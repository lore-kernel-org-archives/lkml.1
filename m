Return-Path: <linux-kernel-owner+w=401wt.eu-S1763515AbZANPsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763515AbZANPsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbZANPsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:48:13 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:34891 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbZANPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:48:12 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Stefan Assmann <sassmann@suse.de>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot interrupt equivalent
Date: Wed, 14 Jan 2009 08:48:07 -0700
User-Agent: KMail/1.9.10
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Sven Dietrich <sdietrich@novell.com>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <20090113082513.GA18449@sli10-desk.sh.intel.com> <496DB702.40302@suse.de>
In-Reply-To: <496DB702.40302@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901140848.08531.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 January 2009 02:57:22 am Stefan Assmann wrote:
> Shaohua Li wrote:
> > So a device can generate interrupt from two irqs. And we can get the irq
> > number for the routing table. Can we extend the irq mechanism and
> > automatically register the interrupt handler for the two irqs?
> 
> This would not solve the problem of asserting 2 different interrupt
> lines, in the masked interrupt handling case, for 1 interrupt request.
> The result would be that the ISR is called twice and at the second call
> you can't be sure that the device hasn't already been serviced.

Calling the ISR twice isn't a problem, is it?  We're talking about
PCI interrupts, which are shareable, so ISRs have to handle being
called extra times.

There's still the problem that the core will disable an IRQ if we
take it too many times without any ISR that cares about it.  But that's
a core issue, not an ISR issue.

Bjorn
