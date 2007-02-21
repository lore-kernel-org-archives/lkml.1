Return-Path: <linux-kernel-owner+w=401wt.eu-S1422819AbXBUTSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422819AbXBUTSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422822AbXBUTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:18:09 -0500
Received: from www.osadl.org ([213.239.205.134]:56239 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422820AbXBUTSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:18:08 -0500
Subject: Re: Linux 2.6.21-rc1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Daniel Walker <dwalker@mvista.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172082200.8577.56.camel@imap.mvista.com>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
	 <1172081931.25076.95.camel@localhost.localdomain>
	 <1172082200.8577.56.camel@imap.mvista.com>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 20:23:12 +0100
Message-Id: <1172085792.25076.119.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 10:23 -0800, Daniel Walker wrote:
> Right, but eventually there isn't a regular timer interrupt through the
> io-apic. I don't think in the past IRQ0 stops without the system
> crashing, so check_timer() could assume the timer (IRQ0) is _always_
> regular.
> 
> do you know what the requirement are for routing the NMI through the
> io-apic? 

Sorry. I checked. switching PIT off really breaks nmi_watchdog=1, as
this just mirrors IRQ#0 to the NMI. No IRQ#0 from PIT, no NMI

We could keep PIT running with an empty interrupt handler when
nmi_watchdog=1 is set, but this interferes nicely with broadcasting.

Does nmi_watchdog=2 work ? We might switch to that, when a local APIC is
available. 

	tglx



