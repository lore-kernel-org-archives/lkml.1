Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbZANPz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbZANPz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbZANPze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:55:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZANPzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:55:32 -0500
Date: Wed, 14 Jan 2009 16:55:29 +0100
From: Olaf Dabrunz <od@suse.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Stefan Assmann <sassmann@suse.de>, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Sven Dietrich <sdietrich@novell.com>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot
	interrupt equivalent
Message-ID: <20090114155529.GP25512@suse.de>
Mail-Followup-To: Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Stefan Assmann <sassmann@suse.de>, Shaohua Li <shaohua.li@intel.com>,
	Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	Sven Dietrich <sdietrich@novell.com>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <20090113082513.GA18449@sli10-desk.sh.intel.com> <496DB702.40302@suse.de> <200901140848.08531.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901140848.08531.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-Jan-09, Bjorn Helgaas wrote:
> On Wednesday 14 January 2009 02:57:22 am Stefan Assmann wrote:
> > Shaohua Li wrote:
> > > So a device can generate interrupt from two irqs. And we can get the irq
> > > number for the routing table. Can we extend the irq mechanism and
> > > automatically register the interrupt handler for the two irqs?
> > 
> > This would not solve the problem of asserting 2 different interrupt
> > lines, in the masked interrupt handling case, for 1 interrupt request.
> > The result would be that the ISR is called twice and at the second call
> > you can't be sure that the device hasn't already been serviced.
> 
> Calling the ISR twice isn't a problem, is it?  We're talking about
> PCI interrupts, which are shareable, so ISRs have to handle being
> called extra times.
> 
> There's still the problem that the core will disable an IRQ if we
> take it too many times without any ISR that cares about it.  But that's
> a core issue, not an ISR issue.

It is not solvable in the core. How do you find out that the "nobody
cared" spurious IRQ is benign?

Regards,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

