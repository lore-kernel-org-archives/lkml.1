Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYBHWR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYBHWR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYBHWRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:17:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:41913 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbYBHWRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:17:49 -0500
Message-ID: <47ACD4CB.7090701@windriver.com>
Date: Fri, 08 Feb 2008 16:16:43 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Kiszka <jan.kiszka@web.de>, Andi Kleen <andi@firstfloor.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] KGDB: remove kgdb-own fault handling
References: <20080130011550.GA31853@elte.hu> <200802050436.31070.maximlevitsky@gmail.com> <alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org> <p73ejbn2xk2.fsf@bingen.suse.de> <47AC95FC.5090701@siemens.com> <20080208185719.GA11573@one.firstfloor.org> <47ACC97C.3000806@web.de> <alpine.LFD.1.00.0802081347150.2896@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802081347150.2896@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2008 22:16:22.0215 (UTC) FILETIME=[3C7C4D70:01C86AA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Fri, 8 Feb 2008, Jan Kiszka wrote:
>   
>> Well, let's try it this way: Find below a patch against kgdb.git that
>> removes the special fault handling (this wouldn't be the first feature I
>> recently removed from kgdb :->). Light testing revealed no obvious
>> problems yet.
>>     
>
> That is indeed horrible code. No way will I merge anything that has things 
> like that even in it's *history* (ie somebody needs to re-generate the 
> tree without code like that - some things should not be allowed to exist).
>
>   

I concur.  I will collapse the entire kgdb tree back to the original few
patches which can be bisected.

> That said, while just using "probe_kernel_addr()" is certainly much 
> better, it's still really inefficient. If you actually want to do a "safe 
> memory copy", then the right way to do that is basically to do
>
> 	pagefault_disable();
> 	leftover = __copy_from_user_inatomic(dst, src, count);
> 	pagefault_enable();
>
> 	if (leftover)
> 		handle_the_fact_that_the_copy_didnt_complete();
>
>   

Duly Noted.  Further cleanups are in progress.


Thanks,
Jason.
