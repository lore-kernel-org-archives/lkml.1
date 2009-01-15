Return-Path: <linux-kernel-owner+w=401wt.eu-S1761572AbZAOAKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761572AbZAOAKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 19:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbZAOAKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 19:10:40 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:24485 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116AbZAOAKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 19:10:39 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Olaf Dabrunz <od@suse.de>
Subject: Re: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot interrupt equivalent
Date: Wed, 14 Jan 2009 17:10:33 -0700
User-Agent: KMail/1.9.10
Cc: Stefan Assmann <sassmann@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Sven Dietrich <sdietrich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Jon Masters <jcm@redhat.com>
References: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain> <496C788C.9050305@suse.de> <20090113155717.GM25512@suse.de>
In-Reply-To: <20090113155717.GM25512@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141710.33859.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2009 08:57:17 am Olaf Dabrunz wrote:
> On 13-Jan-09, Stefan Assmann wrote:
> > Bjorn Helgaas wrote:
> > > (I added Eric, Maciej, and Jon because they participated in
> > > previous discussion here: http://lkml.org/lkml/2008/6/2/269)
> > > 
> > > On Monday 12 January 2009 04:09:25 am Stefan Assmann wrote:
> > >> Len Brown wrote:
> > >>> Stefan,
> > >>> I had to exclude your changes to drivers/acpi/pci_irq.c from
> > >>> e1d3a90846b40ad3160bf4b648d36c6badad39ac
> > >>> in order to get some other changes to that file upstream in the
> > >>> 2.6.29 merge window. ...
> > >> Let me try to give you a short overview of what's happening there.
> > >>
> > >> If an IRQ arrives at line X of a non-primary IO-APIC and that line is
> > >> masked a new IRQ will be generated on the primary IO-APIC/PIC. This is
> > >> called a "Boot Interrupt" by Intel. It's purpose is, as the name
> > >> suggests, to ensure that the IRQ is handled at boot time (when the
> > >> non-primary) IO-APIC is still disabled.
> > >>
> > >> Condition to be met for "Boot Interrupts":
> > >> - line X on non-primary IO-APIC interrupt line is masked
> > >> - line X is asserted
> > > 
> > > Thanks.  Let me replay this to see whether I understand.  Please
> > > correct any of my misapprehensions :-)
> > > 
> > > Since your patch doesn't look at the IOxAPIC RDL register to see
> > > whether the pin is masked, you must be assuming that Linux is
> > > *always* using boot interrupts, and never unmasking the non-primary
> > > IOxAPIC entry.
> > 
> > Yes, for this special case that is correct.
> 
> Right. The current reroute code assumes that all interrupts use masking.

I'm not an expert in the "classic x86 ioapic behaviour" or in RT
interrupt handling.  My main objections are that the patch as proposed
is a gross hack in the ACPI _PRT lookup path, and that it didn't touch
the non-ACPI lookup path, which should have the same problem.  Now that
Eric pointed out this is just classic behavior, I also wonder why the
quirk doesn't list more devices.

The effect of the patch sounds sort of similar to using "noapic" --
you're basically ignoring the IOAPIC and using only the "boot interrupt"
or legacy PIC interrupt or whatever it is.  Can you contrast it with
that?

Bjorn


