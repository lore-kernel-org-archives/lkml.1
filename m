Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbXGaNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbXGaNyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbXGaNyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:54:06 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:34452 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbXGaNyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:54:05 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: jack@hawkeye.stone.uk.eu.org
Subject: Re: [Patch 09/16] Remove unnecessary kmalloc casts in the pci subsystem.
Date: Tue, 31 Jul 2007 15:53:28 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125443.880871000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125443.880871000@hawkeye.stone.uk.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707311553.29090.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 31. Juli 2007 schrieb jack@hawkeye.stone.uk.eu.org:
> --- a/drivers/pci/rom.c
> +++ b/drivers/pci/rom.c
> @@ -185,7 +185,7 @@ void __iomem *pci_map_rom_copy(struct pc
>  			  IORESOURCE_ROM_BIOS_COPY))
>  		return rom;
> 
> -	res->start = (unsigned long)kmalloc(*size, GFP_KERNEL);
> +	res->start = kmalloc(*size, GFP_KERNEL);

This looks wrong. void * doesnt need a cast to a pointer, but res->start is an 
integer u32 type, and therefore we need a cast, no?



-- 
IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschäftsführung: Herbert Kircher 
Sitz der Gesellschaft: Böblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

