Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbXDCFyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbXDCFyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 01:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbXDCFyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 01:54:44 -0400
Received: from www.osadl.org ([213.239.205.134]:42278 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753116AbXDCFyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 01:54:44 -0400
Subject: Re: [linux-pm] [PATCH v2] Add suspend/resume for HPET
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
In-Reply-To: <Pine.LNX.4.44L0.0704021557270.29713-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0704021557270.29713-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 07:54:45 +0200
Message-Id: <1175579686.28263.204.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 16:04 -0400, Alan Stern wrote:
> > It's not that simple though, especially with HPET.  The BIOS may expect
> > the PIT to work, but Linux currently (and problematically!) uses HPET in
> > "legacy replacement mode".  And ISTR the problems are coming up when the
> > system is already in a low-functionality state:  IRQs off everywhere,
> > even timer ticks have stopped.
> 
> I know nothing about the workings of the HPET and other clock code.  My 
> point was this: Suspend passes through various intermediate stages in 
> which some devices are available and others aren't.  So long as those 
> stages are exact duplicates (in reverse order) of the stages that occurred 
> during startup, it should be possible to make them all work.

Unfortunately it is not a fully linear problem. Devices are initialized
late and put the system into a more complex state (i.e. dynticks,
highres) which needs to be suspended and resumed. If we want to do this
completely linear we need to do a full reverse rollback of the system
states, which moves even more complexity into such systems.

Also the linear approach is not working with other devices, as one can
see with the still unresolved "IRQ#X nobody cared" issues at resume,
which break my laptop. It works nice on startup of the system, but
breaks on resume.

	tglx


