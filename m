Return-Path: <linux-kernel-owner+w=401wt.eu-S1030966AbXDWCnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030966AbXDWCnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 22:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030967AbXDWCnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 22:43:53 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:43488 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030966AbXDWCnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 22:43:52 -0400
Date: Sun, 22 Apr 2007 22:39:40 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, -v5
In-reply-to: <20070423012509.GA25162@wotan.suse.de>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Mark Lord <lkml@rtr.ca>,
       Ulrich Drepper <drepper@redhat.com>
Message-id: <200704222239.40818.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu>
 <20070423012509.GA25162@wotan.suse.de>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 April 2007, Nick Piggin wrote:
>On Mon, Apr 23, 2007 at 03:12:29AM +0200, Ingo Molnar wrote:
>> i'm pleased to announce release -v5 of the CFS scheduler patchset. The
>> patch against v2.6.21-rc7 and v2.6.20.7 can be downloaded from:
>>
>>     http://redhat.com/~mingo/cfs-scheduler/
>>
>> this CFS release mainly fixes regressions and improves interactivity:
>>
>>     13 files changed, 211 insertions(+), 199 deletions(-)
>>
>> the biggest user-visible change in -v5 are various interactivity
>> improvements (especially under higher load) to fix reported regressions,
>> and an improved way of handling nice levels. There's also a new
>> sys_sched_yield_to() syscall implementation for i686 and x86_64.
>>
>> All known regressions have been fixed. (knock on wood)
>
>I think the granularity is still much too low. Why not increase it to
>something more reasonable as a default?

I haven't approached that yet, but I just noticed, having been booted to this 
for all of 5 minutes, that although I told it not to renice x when my script 
ran 'make oldconfig', and I answered n, but there it is, sitting at -19 
according to htop.

The .config says otherwise:
[root@coyote linux-2.6.21-rc7-CFS-v5]# grep RENICE .config
# CONFIG_RENICE_X is not set

So v5 reniced X in spite of the 'no' setting.

Although I hadn't noticed it, one way or the other, I just set it (X) back to 
the default -1 so that I'm comparing the same apples when I do compare.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Fortune finishes the great quotations, #2

	If at first you don't succeed, think how many people
	you've made happy.

