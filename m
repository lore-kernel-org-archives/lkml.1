Return-Path: <linux-kernel-owner+w=401wt.eu-S1030574AbXBFXgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030574AbXBFXgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030578AbXBFXgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:36:20 -0500
Received: from www.osadl.org ([213.239.205.134]:42685 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030574AbXBFXgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:36:19 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: dwalker@mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170804177.3455.109.camel@dwalker1>
References: <20070206205231.GA25430@elte.hu>
	 <1170795378.3455.31.camel@dwalker1> <20070206210959.GC25430@elte.hu>
	 <1170796999.3455.43.camel@dwalker1> <20070206214131.GA1176@elte.hu>
	 <1170798879.3455.58.camel@dwalker1> <20070206220855.GB5109@elte.hu>
	 <1170801742.3455.87.camel@dwalker1> <20070206225650.GA14853@elte.hu>
	 <1170803070.3455.93.camel@dwalker1>  <20070206231421.GA18654@elte.hu>
	 <1170804177.3455.109.camel@dwalker1>
Content-Type: text/plain
Date: Wed, 07 Feb 2007 00:36:29 +0100
Message-Id: <1170804989.3785.58.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 15:22 -0800, Daniel  Walker wrote:
> > > What about the statistics for the other interrupts in the system ? It 
> > > clearly doesn't list all interrupts in the system .
> > 
> > what is your point?
> 
> Isn't the listing inconsistent ? /proc/interrupts only showing some
> special interrupts, and not others .. 

It shows _ALL_ used interrupts in the system. There is no point to let
it show NR_IRQ interrupts with a event count = 0.

> For example it shows NMI which is
> not related to request_irq() .. It shows some clock driver devices
> (timer, NMI, LOC) and not others (clock event devices) ..

PIT is a clock event device and uses IRQ0, where the interrupt count is
displayed:

0:    3022812          0   IO-APIC-edge      timer

Local APIC timer is a clock event device too and the interrupt count is
displayed as well:

LOC:     177795    1755941 

There are no other clock event devices in a PC system at the moment
and /proc/interrupt does not care, whether the interrupt was setup for a
clock event device or something else. It displays the name which is
given in the irqaction struct and does not care what it means. I did not
change the name in the IRQ#0 setup, so it still displays "timer" (which
can either be PIT or HPET), but this is something the interrupt layer
does not know and does not care about.

The special interrupts, which are not handled by the generic IRQ layer
(LOC, NMI) are displayed to have the complete statistics available.

We did not change anything on that. The changed behavior you are
observing (IRQ#0 is not incrementing) is reflecting the reality of the
system. IRQ#0 is not firing, so it does not increment.

	tglx


