Return-Path: <linux-kernel-owner+w=401wt.eu-S1762462AbXGaUTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762462AbXGaUTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbXGaUT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:19:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33576
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758598AbXGaUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:19:27 -0400
Date: Tue, 31 Jul 2007 13:19:23 -0700 (PDT)
Message-Id: <20070731.131923.104035780.davem@davemloft.net>
To: borntraeger@de.ibm.com
Cc: jack@hawkeye.stone.uk.eu.org, linux-kernel@vger.kernel.org,
       trivial@kernel.org, gregkh@suse.de
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci
 subsystem.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200707311553.29090.borntraeger@de.ibm.com>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
	<20070731125443.880871000@hawkeye.stone.uk.eu.org>
	<200707311553.29090.borntraeger@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Tue, 31 Jul 2007 15:53:28 +0200

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
> This looks wrong. void * doesnt need a cast to a pointer, but res->start is an 
> integer u32 type, and therefore we need a cast, no?

Similar issue with the arch/sparc/kernel/ebus.c change.

If the cast is being done to an integer type you can't
remove it.
