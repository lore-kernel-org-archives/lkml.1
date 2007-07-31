Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbXGaOSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbXGaOSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbXGaOR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:17:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57521 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952AbXGaOR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:17:56 -0400
Date: Tue, 31 Jul 2007 20:00:12 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci
 subsystem.
In-Reply-To: <200707311553.29090.borntraeger@de.ibm.com>
Message-ID: <alpine.LFD.0.999.0707311956170.26032@enigma.security.iitk.ac.in>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
 <20070731125443.880871000@hawkeye.stone.uk.eu.org>
 <200707311553.29090.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Jul 2007, Christian Borntraeger wrote:

> Am Dienstag, 31. Juli 2007 schrieb jack@hawkeye.stone.uk.eu.org:
> > --- a/drivers/pci/rom.c
> > +++ b/drivers/pci/rom.c
> > @@ -185,7 +185,7 @@ void __iomem *pci_map_rom_copy(struct pc
> >  			  IORESOURCE_ROM_BIOS_COPY))
> >  		return rom;
> > 
> > -	res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
> > +	res->start = kmalloc(*size, GFP_KERNEL);
> 
> This looks wrong.

Yup, a warning at the very least.

> void * doesnt need a cast to a pointer, but res->start is an 
> integer u32 type,

It better not be, else we have a bug already anyway. Pointers are 64-bit
on 64-bit archs. [ it turns out res->start is resource_size_t which is
set properly as per CONFIG_RESOURCES_64BIT which itself is set properly
as per CONFIG_64BIT, so everything is healthy and fine :-) ]

> and therefore we need a cast, no?

Yes, void * -> unsigned long cast is always ok, and what we need here.


Satyam
