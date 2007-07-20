Return-Path: <linux-kernel-owner+w=401wt.eu-S1765556AbXGUBgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765556AbXGUBgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXGUBf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:35:58 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:39956 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751102AbXGUBf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:35:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=cLrrYfs3y6h7PKRyTK+aWAHynPshyJ6D2Yv44HUxI6+CDkgUqiTUA6qV9xMin3V4/anKVJ6AIQUvvZBqMaGUnI/w/Kc/pipOCI3FIl7gvOfJR/ExZd8mNZ+hNMneOoYY5pvd6Am62fZOdY90ng34d7BBOENg8GqtlBxBe/C6DOQ=  ;
X-YMail-OSG: xPQS_IMVM1lwgJTWPAVG.bQeMTMGh0aCo4MeoDzca8DbMGq9ipN16aLJUm02zp9Rm1tAEv_muA--
Message-ID: <46A05270.5040205@yahoo.com.au>
Date: Fri, 20 Jul 2007 16:13:04 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Badari Pulavarty <pbadari@us.ibm.com>, Bill Irwin <bill.irwin@oracle.com>,
       nacc@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] hugetlbfs read() support
References: <1184376214.15968.9.camel@dyn9047017100.beaverton.ibm.com>	<20070718221950.35bbdb76.akpm@linux-foundation.org>	<1184860309.18188.90.camel@dyn9047017100.beaverton.ibm.com> <20070719095850.6e09b0e8.akpm@linux-foundation.org>
In-Reply-To: <20070719095850.6e09b0e8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry if this is a resend... something bad seems to have happened to me)

Andrew Morton wrote:
> On Thu, 19 Jul 2007 08:51:49 -0700 Badari Pulavarty <pbadari@us.ibm.com> wrote:

>>>This code doesn't have all the ghastly tricks which we deploy to handle
>>>concurrent truncate.
>>
>>Do I need to ? Baaahh!!  I don't want to deal with them. 
> 
> 
> Nick, can you think of any serious consequences of a read/truncate race in
> there?  I can't..

As it doesn't allow writes, then I _think_ it should be OK. If you
ever did want to add write(2) support, then you would have transient
zeroes problems.

But I'm not completely sure.. we've had a lot of (and still have
some known and probably unknown) bugs just in that single
generic_mapping_read function, most of which are due to our rabid
aversion to doing any locking whatsoever there.

So why not just hold i_mutex around the whole thing to be safe?

-- 
SUSE Labs, Novell Inc.
