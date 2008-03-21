Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYCUHmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYCUHmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 03:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbYCUHmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 03:42:12 -0400
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:39204
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751602AbYCUHmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 03:42:12 -0400
Message-ID: <47E366D0.6090505@cosmosbay.com>
Date: Fri, 21 Mar 2008 08:42:08 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [14/14] vcompound: Avoid vmalloc for ehash_locks
References: <20080321061727.491610308@sgi.com>	<47E35D73.6060703@cosmosbay.com>	<Pine.LNX.4.64.0803210002450.15903@schroedinger.engr.sgi.com> <20080321.003123.180348056.davem@davemloft.net>
In-Reply-To: <20080321.003123.180348056.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Christoph Lameter <clameter@sgi.com>
> Date: Fri, 21 Mar 2008 00:03:51 -0700 (PDT)
> 
>> On Fri, 21 Mar 2008, Eric Dumazet wrote:
>>
>>> But, isnt it defeating the purpose of this *particular* vmalloc() use ?
>> I thought that was controlled by hashdist? I did not see it used here and 
>> so I assumed that the RR was not intended here.
> 
> It's intended for all of the major networking hash tables.

Other networking hash tables uses alloc_large_system_hash(), which handles 
hashdist settings.

But this helper is __init only, so we can not use it for ehash_locks (can be 
allocated by DCCP module)


