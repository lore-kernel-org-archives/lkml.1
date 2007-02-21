Return-Path: <linux-kernel-owner+w=401wt.eu-S1161359AbXBUUvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161359AbXBUUvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161358AbXBUUvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:51:45 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:63529 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161359AbXBUUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:51:44 -0500
Subject: Re: Linux 2.6.21-rc1
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172090603.25076.127.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
	 <1172081931.25076.95.camel@localhost.localdomain>
	 <1172082200.8577.56.camel@imap.mvista.com>
	 <1172085792.25076.119.camel@localhost.localdomain>
	 <1172088050.8577.71.camel@imap.mvista.com>
	 <1172090603.25076.127.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 12:49:33 -0800
Message-Id: <1172090973.8577.77.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 21:43 +0100, Thomas Gleixner wrote:
> On Wed, 2007-02-21 at 12:00 -0800, Daniel Walker wrote:
> > There's a compile failure during my bisect.
> > 
> > distcc[3863] ERROR: compile /tmp//hrtimer.tmp.dwalker1.3795.i on dwalker3/120 failed
> > kernel/hrtimer.c: In function 'hrtimer_cpu_notify':
> > kernel/hrtimer.c:884: warning: implicit declaration of function 'clockevents_notify'
> > kernel/hrtimer.c:884: error: 'CLOCK_EVT_NOTIFY_CPU_DEAD' undeclared (first use in this function)
> > kernel/hrtimer.c:884: error: (Each undeclared identifier is reported only once 
> > kernel/hrtimer.c:884: error: for each function it appears in.)
> > drivers/ide/setup-pci.c: In function 'ide_scan_pcibus':
> > drivers/ide/setup-pci.c:866: warning: ignoring return value of '__pci_register_driver', declared with attribute warn_unused_result
> > make[1]: *** [kernel/hrtimer.o] Error 1
> 
> hrmpf. we made it bisectable at some point.

It was related some code under a hot plug ifdef ..

Here's the final commit from the bisect which caused it . It says "No
changes to existing functionality" ?

e9e2cdb412412326c4827fc78ba27f410d837e6e is first bad commit
commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Feb 16 01:28:04 2007 -0800

    [PATCH] clockevents: i386 drivers

    Add clockevent drivers for i386: lapic (local) and PIT/HPET (global).  Update
    the timer IRQ to call into the PIT/HPET driver's event handler and the
    lapic-timer IRQ to call into the lapic clockevent driver.  The assignement of
    timer functionality is delegated to the core framework code and replaces the
    compile and runtime evalution in do_timer_interrupt_hook()

    Use the clockevents broadcast support and implement the lapic_broadcast
    function for ACPI.

    No changes to existing functionality.



