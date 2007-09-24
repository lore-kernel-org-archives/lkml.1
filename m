Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbXIXUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbXIXUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 16:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbXIXUZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 16:25:17 -0400
Received: from www.osadl.org ([213.239.205.134]:60513 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755384AbXIXUZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 16:25:16 -0400
Subject: Re: 2.6.23-rc7-mm1
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
In-Reply-To: <20070924123450.f9e54d3d.akpm@linux-foundation.org>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <64bb37e0709241207q1c188b35ua485a06776ed4bf2@mail.gmail.com>
	 <20070924123450.f9e54d3d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 22:25:12 +0200
Message-Id: <1190665512.4035.247.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 12:34 -0700, Andrew Morton wrote:
> > It prints twice 'System halted' and blinks the keyboard leds, but does
> > not switch off. On all other kernel version I only see one keyboard
> > blink before the power goes out.
> 
> ok...
> 
> > I compared its dmesg to vanilla-rc7 and -rc4-mm1, but expect that rc-4
> > assigns different IRQs I can't see any differences except the normal
> > variation in BogoMips etc.

Can your check whether 2.6.23-rc7 +
http://tglx.de/projects/hrtimers/2.6.23-rc7/patch-2.6.23-rc7-hrt1.patch

works for you ?

> hm, dunno.  The only substantial patch which touches
> arch/x86_64/kernel/process.c (which is where cpu_idle lives) is
> x86_64-prep-idle-loop-for-dynticks.patch.
> 
> The problem is, 2.6.23-rc6-mm1's git-acpi patch had all the new cpuidle
> code in it.  Len dropped all that code over the weekend (which is when I
> picked this copy of his tree), so 2.6.23-rc7-mm1 doesn't have the cpuidle
> code.  Len will be reapplying the cpuidle patches today(ish) so next -mm
> _will_ have the cpuidle code.
> 
> So what we have in rc7-mm1 is this transient no-cpuidle state.  It could be
> that the x86_64 dynticks code (which was developed previously tested in
> conjunction with the cpuidle patches) has some dependency on cpuidle.

It should not. cpuidle makes use of dynticks not the other way round.

	tglx


