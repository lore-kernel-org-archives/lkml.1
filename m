Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbZJIVO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbZJIVO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbZJIVO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:14:58 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:56981 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbZJIVOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:14:54 -0400
Date: Fri, 09 Oct 2009 17:14:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5/7] x86/PCI: print resources consistently with %pRt
In-reply-to: <200910071315.16250.bjorn.helgaas@hp.com>
Message-id: <alpine.LFD.2.00.0910091707380.3912@localhost.localdomain>
References: <20091006213259.4272.68068.stgit@bob.kio>
 <20091006213349.4272.65914.stgit@bob.kio>
 <86802c440910071143y7ba8b0f8y9efff738eba9d30b@mail.gmail.com>
 <200910071315.16250.bjorn.helgaas@hp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The message changes like this:
> 
>   -PCI: Failed to allocate to allocate 0x0-0x3fff from PCI IO for PCI Bus 0000:00
>   +pci_root PNP0A03:01: can't allocate [io  0x0000-0x3fff]
> 
> I don't think changing "PCI IO" to "io" is really a problem.  In fact,
> strictly speaking, "PCI IO" is the wrong name for ioport_resource --
> we're talking about a host bridge, and the upstream side is not PCI
> at all.
> 
> However, I do think it would be more useful to mention the fact that
> we failed to allocate a *window*, e.g., 
> 
>   pci_root PNP0A03:00: can't allocate host bridge window [io  0x0000-0x3fff]
> 
> I did consider keeping the PCI bus ("0000:00"), but I decided we
> already have that information here:
> 
>   ACPI: PCI Root Bridge [PCI0] (0000:00)
> 
> and it doesn't seem worthwhile to me to repeat the bus number in all
> the host bridge-related messages.  Right now, there's nothing to tie
> the PCI0 to the PNP0A03:00 (and "PCI0" shouldn't be exposed to users
> anyway), but someday when I finally convince Len to use dev_printk
> in ACPI, it could look something like this:
> 
>   pci_root PNP0A03:00: PCI host bridge to pci_bus 0000:00

The last time we looked at using dev_printk() in ACPI,
it looked like the leading ACPI: would go away, and the
concern was that would hinder, rather than help, people
in reporting issues to the right place.

I have no problem with using dev_printk() where it makes sense,
but only if it makes the message more useful rather than
less useful.

BTW. I like the consistency provided by the series at hand.
I assume that it will go through Jesse's, and for that,
consider the relevant bits...

Acked-by: Len Brown <len.brown@intel.com>

cheers,
-Len
