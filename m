Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbZAIXER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbZAIXER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756362AbZAIXEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:04:00 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:61753 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbZAIXEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:04:00 -0500
Date: Fri, 09 Jan 2009 18:03:44 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: PCI, ACPI, IRQ, IOAPIC: reroute PCI interrupt to legacy boot interrupt
 equivalent
X-X-Sender: lenb@localhost.localdomain
To: Stefan Assmann <sassmann@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Olaf Dabrunz <od@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0901091743310.20020@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,
I had to exclude your changes to drivers/acpi/pci_irq.c from
e1d3a90846b40ad3160bf4b648d36c6badad39ac
in order to get some other changes to that file upstream in the
2.6.29 merge window.

I left the other parts of the quirk intact - so at the moment
on one of the quirked machines, you'll see

PCI quirk: reroute interrupts for...

but will not see

pci irq %d -> rerouted to legacy

as the quirk is effectively disabled.

I had difficulty trying to port this patch to the new pci_irq.c
because fundamentally I don't understand what it is trying
to do, and why.

The quirk is specific to Intel chipsets, so with all the
Linux guys now working at Intel, I'm hopeful that we can
reach a clear understanding of the issue and a consensus
on the proper fix.

BTW. I'm not excited about how the original patch
drops a chipset specific workaround inside the ACPI code
to go behind the mirrors and lie about what ACPI returns.
I'm hopeful that a better place for the workaround
can be found if this is the approach we need to take..

Can you help us understand what the failure is?

thanks,
-Len

