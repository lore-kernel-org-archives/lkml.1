Return-Path: <linux-kernel-owner+w=401wt.eu-S1764483AbZANQwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764483AbZANQwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763043AbZANQwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:52:32 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:26820 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762911AbZANQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:52:31 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Olaf Dabrunz <od@suse.de>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot interrupt equivalent
Date: Wed, 14 Jan 2009 09:52:24 -0700
User-Agent: KMail/1.9.10
Cc: Stefan Assmann <sassmann@suse.de>, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Sven Dietrich <sdietrich@novell.com>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <200901140848.08531.bjorn.helgaas@hp.com> <20090114155529.GP25512@suse.de>
In-Reply-To: <20090114155529.GP25512@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901140952.24757.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 08:55:29 am Olaf Dabrunz wrote:
> On 14-Jan-09, Bjorn Helgaas wrote:
> > On Wednesday 14 January 2009 02:57:22 am Stefan Assmann wrote:
> > > Shaohua Li wrote:
> > > > So a device can generate interrupt from two irqs. And we can get the irq
> > > > number for the routing table. Can we extend the irq mechanism and
> > > > automatically register the interrupt handler for the two irqs?
> > > 
> > > This would not solve the problem of asserting 2 different interrupt
> > > lines, in the masked interrupt handling case, for 1 interrupt request.
> > > The result would be that the ISR is called twice and at the second call
> > > you can't be sure that the device hasn't already been serviced.
> > 
> > Calling the ISR twice isn't a problem, is it?  We're talking about
> > PCI interrupts, which are shareable, so ISRs have to handle being
> > called extra times.
> > 
> > There's still the problem that the core will disable an IRQ if we
> > take it too many times without any ISR that cares about it.  But that's
> > a core issue, not an ISR issue.
> 
> It is not solvable in the core. How do you find out that the "nobody
> cared" spurious IRQ is benign?

Sorry, I'm not suggesting that you can.  I was just trying to clarify
that the problem is not with calling an ISR twice, but I think I only
managed to muddy the discussion to no benefit.

Bjorn
