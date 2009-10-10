Return-Path: <linux-kernel-owner+w=401wt.eu-S964905AbZJJPky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964905AbZJJPky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934351AbZJJPka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:40:30 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:31122 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034AbZJJPkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:40:25 -0400
Subject: Re: [PATCH 5/7] x86/PCI: print resources consistently with %pRt
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0910091707380.3912@localhost.localdomain>
References: <20091006213259.4272.68068.stgit@bob.kio>
	 <20091006213349.4272.65914.stgit@bob.kio>
	 <86802c440910071143y7ba8b0f8y9efff738eba9d30b@mail.gmail.com>
	 <200910071315.16250.bjorn.helgaas@hp.com>
	 <alpine.LFD.2.00.0910091707380.3912@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 09:36:40 -0600
Message-Id: <1255189000.30901.11.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 17:14 -0400, Len Brown wrote:
> > The message changes like this:
> > 
> >   -PCI: Failed to allocate to allocate 0x0-0x3fff from PCI IO for PCI Bus 0000:00
> >   +pci_root PNP0A03:01: can't allocate [io  0x0000-0x3fff]
> > 
> > I don't think changing "PCI IO" to "io" is really a problem.  In fact,
> > strictly speaking, "PCI IO" is the wrong name for ioport_resource --
> > we're talking about a host bridge, and the upstream side is not PCI
> > at all.
> > 
> > However, I do think it would be more useful to mention the fact that
> > we failed to allocate a *window*, e.g., 
> > 
> >   pci_root PNP0A03:00: can't allocate host bridge window [io  0x0000-0x3fff]
> > 
> > I did consider keeping the PCI bus ("0000:00"), but I decided we
> > already have that information here:
> > 
> >   ACPI: PCI Root Bridge [PCI0] (0000:00)
> > 
> > and it doesn't seem worthwhile to me to repeat the bus number in all
> > the host bridge-related messages.  Right now, there's nothing to tie
> > the PCI0 to the PNP0A03:00 (and "PCI0" shouldn't be exposed to users
> > anyway), but someday when I finally convince Len to use dev_printk
> > in ACPI, it could look something like this:
> > 
> >   pci_root PNP0A03:00: PCI host bridge to pci_bus 0000:00
> 
> The last time we looked at using dev_printk() in ACPI,
> it looked like the leading ACPI: would go away, and the
> concern was that would hinder, rather than help, people
> in reporting issues to the right place.
> 
> I have no problem with using dev_printk() where it makes sense,
> but only if it makes the message more useful rather than
> less useful.

Yes, I'm sorry, that was kind of a low blow that didn't represent your
concerns fairly.

> BTW. I like the consistency provided by the series at hand.
> I assume that it will go through Jesse's, and for that,
> consider the relevant bits...
> 
> Acked-by: Len Brown <len.brown@intel.com>

Thanks.  I'm planning to post an updated series soon.  Joe Perches
suggested reducing the stack usage in vsprintf, so I'm working on that,
and I might add another message or two.

Bjorn


