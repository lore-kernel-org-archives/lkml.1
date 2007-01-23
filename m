Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbXAWWAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbXAWWAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932498AbXAWWAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:00:41 -0500
Received: from www.osadl.org ([213.239.205.134]:35781 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932091AbXAWWAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:41 -0500
Message-Id: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:00:55 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 00/46] High resolution timer / dynamic tick update
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a full replacement queue for the high resolution timer / dynamic 
ticks implemementation in -mm.

This version includes the following improvements:

 - Seperate clockevents management of devices and users

 - Provide a generic tick managament infrastructure, which makes use
   of the clock events management layer. This provides:

   - periodic tick management
   - broadcast management (e.g. to solve the APIC stops in C3 power
     state problem)
   - dynamic tick core functionality
   - high resolution timer core infrastructure

   This allows to provide dynamic ticks with low and high resolution
   timers by sharing the infrastructure. [read: CONFIG_NO_HZ=y is now
   available without CONFIG_HIGH_RES_TIMERS as well.]

   ( The dynamic tick implementation also contains a fix for the
     generic next_timer_interrupt() function, which did not do the
     cascade lookups correctly. )

 - Provide a generic way to verify clocksources. TSC needs
   verification due to broken hardware and BIOS implementations. The
   previous attempt to allow TSC usage for high resolution and/or
   dynamic ticks only in combination with the PM-Timer made hardwired
   assumptions, which are ugly to maintain. The new verification code
   solves this by chosing the best available clocksource for
   verification and handles the usability check for highres / dynamic
   ticks. This makes TSC code agnostic of other hardware available in
   the system.

 - Removed the dynamic tick specific parts from the high resolution
   timer code.

 - Dynamic ticks and high resolution timers can be disabled separately
   at compile time or at run time from the kernel command line.

      Thomas, Ingo

P.S:
Sorry for the resend. Did not notice my list typo. :(

--

