Return-Path: <linux-kernel-owner+w=401wt.eu-S1422828AbXBUT1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422828AbXBUT1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422829AbXBUT1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:27:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:37719 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422828AbXBUT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:27:07 -0500
Subject: Re: Linux 2.6.21-rc1
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
In-Reply-To: <1172085792.25076.119.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <1172075053.8577.38.camel@imap.mvista.com>
	 <1172077664.25076.75.camel@localhost.localdomain>
	 <1172078340.8577.43.camel@imap.mvista.com>
	 <1172079671.25076.80.camel@localhost.localdomain>
	 <1172079523.8577.48.camel@imap.mvista.com>
	 <1172081931.25076.95.camel@localhost.localdomain>
	 <1172082200.8577.56.camel@imap.mvista.com>
	 <1172085792.25076.119.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 11:24:56 -0800
Message-Id: <1172085896.8577.67.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 20:23 +0100, Thomas Gleixner wrote:
> On Wed, 2007-02-21 at 10:23 -0800, Daniel Walker wrote:
> > Right, but eventually there isn't a regular timer interrupt through the
> > io-apic. I don't think in the past IRQ0 stops without the system
> > crashing, so check_timer() could assume the timer (IRQ0) is _always_
> > regular.
> > 
> > do you know what the requirement are for routing the NMI through the
> > io-apic? 
> 
> Sorry. I checked. switching PIT off really breaks nmi_watchdog=1, as
> this just mirrors IRQ#0 to the NMI. No IRQ#0 from PIT, no NMI

That's what I suspected ..

> We could keep PIT running with an empty interrupt handler when
> nmi_watchdog=1 is set, but this interferes nicely with broadcasting.
> 
> Does nmi_watchdog=2 work ? We might switch to that, when a local APIC is
> available. 

Oddly, nmi_watchdog=2 doesn't work in 2.6.21-rc1, but it works in
2.6.20-rt8 however I'm not sure of the config could have been PREEMPT_RT
was on.

Daniel

