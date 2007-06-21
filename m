Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbXFUROc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbXFUROc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXFUROW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:14:22 -0400
Received: from h155.mvista.com ([63.81.120.155]:64327 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754737AbXFUROW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:14:22 -0400
Message-ID: <467AB253.8010902@ru.mvista.com>
Date: Thu, 21 Jun 2007 21:16:03 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/19] ide: use PIO/MMIO operations directly where possible
References: <20070112042621.28794.6937.sendpatchset@localhost.localdomain> <20070112042807.28794.8251.sendpatchset@localhost.localdomain>
In-Reply-To: <20070112042807.28794.8251.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> [PATCH] ide: use PIO/MMIO operations directly where possible

> This results in smaller/faster/simpler code and allows future optimizations.
> Also remove no longer needed ide[_mm]_{inl,outl}() and ide_hwif_t.{INL,OUTL}.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: a/drivers/ide/pci/hpt366.c
> ===================================================================
> --- a.orig/drivers/ide/pci/hpt366.c
> +++ a/drivers/ide/pci/hpt366.c
> @@ -836,7 +836,7 @@ static int hpt374_ide_dma_test_irq(ide_d
>  		return 0;
>  	}
>  
> -	dma_stat = hwif->INB(hwif->dma_status);
> +	dma_stat = inb(hwif->dma_status);
>  	/* return 1 if INTR asserted */
>  	if (dma_stat & 4)
>  		return 1;

    Hmm... this driver *still* has a lot more indirect I/O accessors -- I 
wonder why only this one had been converted then?

MBR, Sergei

