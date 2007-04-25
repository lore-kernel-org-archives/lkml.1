Return-Path: <linux-kernel-owner+w=401wt.eu-S2992728AbXDYLio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992728AbXDYLio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 07:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXDYLio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 07:38:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40038 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992728AbXDYLim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 07:38:42 -0400
Date: Wed, 25 Apr 2007 17:13:18 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5
Message-ID: <20070425114318.GA7328@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu> <20070423051659.GA3929@gentoox2.trippelsdorf.de> <20070423052728.GB3929@gentoox2.trippelsdorf.de> <20070423062116.GB4518@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070423062116.GB4518@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2007 at 08:21:16AM +0200, Ingo Molnar wrote:
> > Changing sys_yield_to to sys_sched_yield_to in 
> > include/asm-x86_64/unistd.h fixes the problem.
> 
> thanks. I edited the -v5 patch so new downloads should have the fix. (i 
> also test-booted x86_64 with this patch)

I downloaded -v5 and noticed this:

--- linux.orig/include/asm-x86_64/unistd.h
+++ linux/include/asm-x86_64/unistd.h
@@ -619,8 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages                279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_yield_to          280
+__SYSCALL(__NR_move_pages, sys_sched_yield_to)

s/__NR_move_pages/__NR_yield_to in the above line?

-- 
Regards,
vatsa
