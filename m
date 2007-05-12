Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbXELLtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbXELLtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 07:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbXELLtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 07:49:05 -0400
Received: from www.osadl.org ([213.239.205.134]:40274 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754323AbXELLtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 07:49:02 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <20070512030754.90488f79.akpm@linux-foundation.org>
References: <20070430102837.748238000@linutronix.de>
	 <20070511132846.5ebf4437.akpm@linux-foundation.org>
	 <200705112302.47726.rjw@sisk.pl> <200705112309.15996.rjw@sisk.pl>
	 <20070511235607.83ad0eb5.akpm@linux-foundation.org>
	 <1178959563.22481.126.camel@localhost.localdomain>
	 <20070512020056.a24cf472.akpm@linux-foundation.org>
	 <1178961489.22481.133.camel@localhost.localdomain>
	 <20070512030754.90488f79.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 12 May 2007 13:52:06 +0200
Message-Id: <1178970726.22481.150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 03:07 -0700, Andrew Morton wrote:
> On Sat, 12 May 2007 11:18:09 +0200 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > > It's peculiar that the hang happens when acpi_evaluate_object() hits its
> > > return statement.  Any theories there?
> > 
> > Only stack or memory corruption come into mind, but I have no clue how
> > this is related to the resume logic changes.
> 
> So I had the brilliant idea of turning on some kernel debugging.  It's
> a shame that CONFIG_SOFTWARE_SUSPEND disables CONFIG_DEBUG_PAGEALLOC.

...

> I don't really know what lockdep is complaining about there.  I assume I'm
> not supposed to, given that whoever wrote that couldn't be bothered
> documenting any of it.
> 
> I _think_ it means that lockdep believes that local irqs are enabled
> (according to its state tracking), only it turns out that they're not.

Right. Lockdep checks, whether the tracked interrupt disabled/enabled
state is the same as the state in the hardware. When the check triggers,
then we disabled / enabled interrupts somewhere without going through
lockdeps state tracker. 

/me suspects ASM code missing the TRACE_IFQS_OFF macro in some place,
which was recently modified.

	tglx


