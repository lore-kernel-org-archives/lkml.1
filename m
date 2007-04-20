Return-Path: <linux-kernel-owner+w=401wt.eu-S1422708AbXDTF04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422708AbXDTF04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 01:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422854AbXDTF04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 01:26:56 -0400
Received: from holomorphy.com ([66.93.40.71]:57925 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422708AbXDTF0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 01:26:55 -0400
Date: Thu, 19 Apr 2007 22:26:19 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070420052619.GX2986@holomorphy.com>
References: <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070419031807.GA24512@wotan.suse.de> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <20070419075746.GD31925@holomorphy.com> <4627577B.7050204@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4627577B.7050204@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
>> I'd further recommend making priority levels accessible to kernel threads
>> that are not otherwise accessible to processes, both above and below
>> user-available priority levels. Basically, if you can get SCHED_RR and
>> SCHED_FIFO to coexist as "intimate scheduler classes," then a SCHED_KERN
>> scheduler class can coexist with SCHED_OTHER in like fashion, but with
>> availability of higher and lower priorities than any userspace process
>> is allowed, and potentially some differing scheduling semantics. In such
>> a manner nonessential background processing intended not to ever disturb
>> userspace can be given priorities appropriate to it (perhaps even con's
>> SCHED_IDLEPRIO would make sense), and other, urgent processing can be
>> given priority over userspace altogether.

On Thu, Apr 19, 2007 at 09:50:19PM +1000, Peter Williams wrote:
> This is sounding very much like System V Release 4 (and descendants) 
> except that they call it SCHED_SYS and also give SCHED_NORMAL tasks that 
> are in system mode dynamic priorities in the SCHED_SYS range (to avoid 
> priority inversion, I believe).

Descriptions of that are probably where I got the idea (hurrah for OS
textbooks). It makes a fair amount of sense. Not sure what the take on
the specific precedent is. The only content here is expanding the
priority range with ranges above and below for the exclusive use of
ultra-privileged tasks, so it's really trivial. Actually it might be so
trivial it should just be some permission checks in the SCHED_OTHER
renicing code.


-- wli
