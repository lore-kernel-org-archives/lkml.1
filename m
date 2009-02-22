Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbZBVJX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbZBVJX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbZBVJXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:23:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47784 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbZBVJXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:23:14 -0500
Date: Sun, 22 Feb 2009 10:22:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Ed Swierk <eswierk@aristanetworks.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
Subject: Re: [RFC] [PATCH] PCI mmconfig without ACPI
Message-ID: <20090222092256.GC6964@elte.hu>
References: <1233766786.16414.26.camel@localhost.localdomain> <20090204181738.GA16174@elte.hu> <alpine.LFD.2.00.0902210046030.19156@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902210046030.19156@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> 
> > > +#ifdef CONFIG_PCI_MMCONFIG
> > > +
> > > +struct acpi_mcfg_allocation {
> > > +	u64 address;		/* Base address, processor-relative */
> > > +	u16 pci_segment;	/* PCI segment group number */
> > > +	u8 start_bus_number;	/* Starting PCI Bus number */
> > > +	u8 end_bus_number;	/* Final PCI Bus number */
> > > +	u32 reserved;
> > > +};
> > 
> > Please rename this to "struct pci_mcfg_allocation" - there's nothing ACPI 
> > about it anymore - mmcfg is a PCI feature and ACPI is an enumeration method.
> > 
> > Also, while touching it, please also use the opportunity to align structure 
> > fields vertically:
> > 
> >  struct pci_mcfg_allocation {
> > 	u64	address;		/* Base address, processor-relative */
> > 	u16	pci_segment;		/* PCI segment group number */
> > 	u8	start_bus_number;	/* Starting PCI Bus number */
> > 	u8	end_bus_number;		/* Final PCI Bus number */
> > 	u32	__reserved;
> >  };
> > 
> > The whole layout of this structure becomes easier to read and nicer to look 
> > at as well.
> > 
> > Another small detail: note how i renamed reserved to __reserved - that is a 
> > standard way to de-emphasise the signficance of a structure field.
> > 
> > The reserved field there is for future expansion and to pad the structure to 
> > 16 bytes - it doesnt really mean much and the underscores move it a bit out 
> > of the default line of sight.
> > 
> > With a 'reserved' field people end up wondering whether it's perhaps some 
> > _semantic_ 'reserved area' kind of thing (like for e820 maps, etc.) - so 
> > it's never bad to make that distinction explicit via the double underscores.
> 
> struct acpi_mcfg_allocation is the structure that maps onto the MCFG
> ACPI table as defined in the PCI firmware spec and provided by the ACPI 
> BIOS.
> 
> I'd like it to stay in actbl1.h -- as that is part of ACPICA, which
> tracks the standard tables.  (and I see you did this with your updated 
> patch, thanks.)
> 
> FWIW, "reserved" here really does have a specific definition. 
> On read-only tables, such as this one, reserved fields are 
> defined to return 0 on reads for this version of the table, 
> but may return non-zero on future revisions.

of course - i did not want to suggest anything else.

Anything that the hardware accesses/provides is special and 
reserved in that sense.

My suggestion to rename to __reserved was to document this fact 
better and to make sure there's no higher-level 'reserved' 
concept controlled here.

	Ingo
