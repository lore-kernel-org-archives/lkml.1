Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXGYJBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXGYJBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 05:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXGYJA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 05:00:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939AbXGYJAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 05:00:55 -0400
Date: Wed, 25 Jul 2007 02:00:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch] fix the softlockup watchdog to actually work
Message-Id: <20070725020003.63144fd6.akpm@linux-foundation.org>
In-Reply-To: <20070725085204.GA22067@elte.hu>
References: <20070717114453.GA8212@elte.hu>
	<469CCF8F.4010107@goop.org>
	<20070717154934.GA24231@elte.hu>
	<20070725014912.35c7e325.akpm@linux-foundation.org>
	<20070725085204.GA22067@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 10:52:04 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > apparently the functionality of the soft lockup watchdog was never 
> > > actually tested with that patch applied ...
> > > 
> > > [this is -stable material too.]
> > 
> > Still isn't working.  I'm getting random meaningless softlockup 
> > trippings coming out for no apparent reason.
> 
> hm, you still havent applied the other 4 patches i sent:
> 
>  softlockup-fix.patch
> 
>  softlockup-add-irq-regs-h.patch
>  softlockup-better-printout.patch
>  softlockup-cleanups.patch
>  softlockup-use-cpu-clock.patch
> 
> they are all necessary.

I think I have.  Seems that someone hasn't been naming their patches
consistently (which is quite irksome).  I have:

fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch

> softlockup-use-cpu-clock.patch could easily solve the present problem 
> you have: as i pointed it out it is _wrong_ to use sched_clock(), 
> because sched_clock() is not a reliable clocksource. Especially on your 
> VAIO.

It fails with them all applied too:

fix-leak-on-proc-lockdep_stats.patch				OK
fix-the-softlockup-watchdog-to-actually-work.patch		BAD
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch				BAD
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch		BAD

