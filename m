Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbXGQPAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbXGQPAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXGQPAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:00:48 -0400
Received: from www.osadl.org ([213.239.205.134]:60980 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752393AbXGQPAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:00:47 -0400
Subject: Re: [patch-mm 14/33] x86_64: Consolidate tsc calibration
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <200707171451.23668.ak@suse.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
	 <20070715155541.282543247@inhelltoy.tec.linutronix.de>
	 <200707171451.23668.ak@suse.de>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 17:00:43 +0200
Message-Id: <1184684443.12353.435.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 14:51 +0200, Andi Kleen wrote:
> On Sunday 15 July 2007 18:10:55 Thomas Gleixner wrote:
> > Move the TSC calibration code to tsc.c. Reimplement it so the
> > pm timer can be used as a reference as well.
> 
> Why is the pm timer better than the PIT for this? 
> 
> I've had mixed success with the pmtimer too.

I had more consistent results on i386 with pmtimer than with the PIT

> >
> > Index: linux-2.6.22-rc6-mm/include/asm-i386/tsc.h
> > ===================================================================
> > --- linux-2.6.22-rc6-mm.orig/include/asm-i386/tsc.h	2007-07-15 17:26:45.000000000 +0200
> > +++ linux-2.6.22-rc6-mm/include/asm-i386/tsc.h	2007-07-15 17:34:42.000000000 +0200
> > @@ -71,4 +71,8 @@ extern void init_tsc_clocksource(void);
> >  extern void check_tsc_sync_source(int cpu);
> >  extern void check_tsc_sync_target(void);
> >  
> > +#ifdef CONFIG_X86_64
> > +extern void tsc_calibrate(void);
> > +#endif
> 
> The ifdef shouldn't be needed?

Yep. It can go.

	tglx


