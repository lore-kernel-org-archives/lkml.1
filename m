Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXA3WZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXA3WZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXA3WZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:25:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35338 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbXA3WZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:25:14 -0500
Date: Tue, 30 Jan 2007 22:37:23 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: conke.hu@amd.com
Subject: Re: atiixp.c: add cable detection support for ATI IDE
Message-ID: <20070130223723.10d35b87@localhost.localdomain>
In-Reply-To: <200701301859.l0UIxaqX025758@hera.kernel.org>
References: <200701301859.l0UIxaqX025758@hera.kernel.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>     IDE HDD does not work if it uses a 40-pin PATA cable on ATI chipset.
>     This patch fixes the bug.
>     
>     Signed-off-by: Conke Hu <conke.hu@amd.com>

Doe this actually work if the driver is loaded after a suspend to ram and
resume ?

> -	hwif->udma_four = 1;
> +	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ch, &udma_mode);
> +	if ((udma_mode & 0x07) >= 0x04 || (udma_mode & 0x70) >= 0x40)
> +		hwif->udma_four = 1;
> +	else
> +		hwif->udma_four = 0;
> +

How does the actual cable detection work rather than relying on the BIOS
modes to guess the cable ?

Alan
