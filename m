Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbXGPIiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbXGPIiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754744AbXGPIiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:38:07 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:47326 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754634AbXGPIh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:37:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=AP03/GnLS0DrEU6mREN9LyRdNDskl2E6KbNp+FfI/Yanlfrpx8AzOyQAmBPZXI1ijhQO4J24DVsoH4sEcpFUgJM5nROfXsnb8M04ZROeSpLYa+6qggwMSxGgKou261uhMWr7meoM5Gdsz7tm1N6vZXtD5+HRQNXCFnKg438fA3E=  ;
X-YMail-OSG: 8wx8VTcVM1m4Xt2fnMhoVlvDeinWmlIAN34u87I0_Sx_HhIKglav0ZMo9tOV.eiNGYkPt8H0UQ--
Message-ID: <469B2E4D.6050404@yahoo.com.au>
Date: Mon, 16 Jul 2007 18:37:33 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Matt Mackall <mpm@selenic.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] slob: reduce list scanning
References: <20070714055434.GQ11115@waste.org> <469B09AB.5010309@yahoo.com.au> <84144f020707160022p37a2d712g21c3d5c89ed6345d@mail.gmail.com>
In-Reply-To: <84144f020707160022p37a2d712g21c3d5c89ed6345d@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 7/16/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
>> Actually SLOB potentially has some fundamental CPU cache hotness
>> advantages over the other allocators, for the same reasons as
>> its space advantages.
> 
> 
> Because consecutive allocations hit the same cache-hot page regardless
> of requested size where as SLUB by definition distributes allocations
> to different pages (some of which may not be hot)?

Yeah, that, and also a newly freed slab object is quite likely to be
hot, and that memory can be used by another subsequent allocation --
not always, because the allocation heuristics may not place it there,
but there is potential that is impossible with slab allocators.

-- 
SUSE Labs, Novell Inc.
