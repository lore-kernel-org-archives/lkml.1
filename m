Return-Path: <linux-kernel-owner+w=401wt.eu-S1759082AbXFZS2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082AbXFZS2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbXFZS2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:28:44 -0400
Received: from h155.mvista.com ([63.81.120.155]:41287 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757286AbXFZS2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:28:43 -0400
Message-ID: <46815B44.1040609@ru.mvista.com>
Date: Tue, 26 Jun 2007 22:30:28 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] piix: backport short cables support from ata_piix.c
References: <200706101558.14511.bzolnier@gmail.com>
In-Reply-To: <200706101558.14511.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Backport short cables support from ata_piix.c.

> This patch should allow UDMA > 2 modes on:
> - Acer 5602WLMi
> - Acer 3682WLMi
> - Asus W5F
> - Acer Aspire 2023WLMi

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

    Minor nit here:

> Index: b/drivers/ide/pci/piix.c
> ===================================================================
> --- a/drivers/ide/pci/piix.c
> +++ b/drivers/ide/pci/piix.c
> @@ -394,12 +394,43 @@ static void piix_dma_clear_irq(ide_drive
[...]
>  static u8 __devinit piix_cable_detect(ide_hwif_t *hwif)
>  {
> -	struct pci_dev *dev = hwif->pci_dev;
> +	struct pci_dev *pdev = hwif->pci_dev;

    Unnecessary rename.

> +	const struct ich_laptop *lap = &ich_laptop[0];

    ... and & and [0] are superfluous with arrays -- they behave like pointers 
in expression.

MBR, Sergei
