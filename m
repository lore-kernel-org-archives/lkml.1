Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYKDRSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYKDRSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbYKDRSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:18:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:46713 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753560AbYKDRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:18:39 -0500
Message-ID: <491083E9.60305@ru.mvista.com>
Date: Tue, 04 Nov 2008 20:18:33 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] rz1000: apply chipset quirks early
References: <20081103200244.5098.29817.sendpatchset@localhost.localdomain> <20081103200306.5098.41565.sendpatchset@localhost.localdomain>
In-Reply-To: <20081103200306.5098.41565.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rz1000: apply chipset quirks early

> * Use pci_name(dev) instead of hwif->name in init_hwif_rz1000().

> * init_hwif_rz1000() -> rz1000_init_chipset().  Update rz1000_init_one()
>   to use rz1000_init_chipset() and add now required rz1000_remove().

> * Remove superfluous ide_rz1000 chipset type.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

> Index: b/drivers/ide/rz1000.c
> ===================================================================
> --- a/drivers/ide/rz1000.c
> +++ b/drivers/ide/rz1000.c
> @@ -22,34 +22,48 @@
>  
>  #define DRV_NAME "rz1000"
>  
> -static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
> +static unsigned int __devinit rz1000_init_chipset(struct pci_dev *dev)

    Hm, this is not a real init_chipset() method and it does just one thing -- 
disables readahead, so rz1000_disable_readahead() or something of that sort 
seems like a better name...

MBR, Sergei
