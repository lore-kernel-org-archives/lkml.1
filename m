Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYDVQ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYDVQ3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbYDVQ3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:29:31 -0400
Received: from h155.mvista.com ([63.81.120.155]:31787 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752133AbYDVQ3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:29:30 -0400
Message-ID: <480E1245.4000300@ru.mvista.com>
Date: Tue, 22 Apr 2008 20:28:53 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] scc_pata: add ->dma_host_set and ->dma_start methods
References: <200804122104.26846.bzolnier@gmail.com>
In-Reply-To: <200804122104.26846.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Add ->dma_host_set and ->dma_start methods (+ __scc_dma_end() helper)
> so scc_ide_{in,out}b() can be used directly.

    In fact, you could have used in/out_be32() instead like the rest of the 
code in this driver...

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> Index: b/drivers/ide/pci/scc_pata.c
> ===================================================================
> --- a/drivers/ide/pci/scc_pata.c
> +++ b/drivers/ide/pci/scc_pata.c
> @@ -260,6 +260,20 @@ static void scc_set_dma_mode(ide_drive_t
>  	out_be32((void __iomem *)udenvt_port, reg);
>  }
>  
> +static void scc_dma_host_set(ide_drive_t *drive, int on)
> +{
> +	ide_hwif_t *hwif = drive->hwif;
> +	u8 unit = (drive->select.b.unit & 0x01);

    Needless parens.

> +	u8 dma_stat = scc_ide_inb(hwif->dma_status);
> +
> +	if (on)
> +		dma_stat |= (1 << (5 + unit));

   Again...

MBR, Sergei
