Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbZL1J7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbZL1J7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 04:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbZL1J7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 04:59:47 -0500
Received: from mail.gmx.net ([213.165.64.20]:46351 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752100AbZL1J7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 04:59:46 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19yU88FRQlylwdMT8d355eBaoZaIHI6det11C3j1a
	LQFUXL5qEZ3ApX
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Hans-Christian Egtvedt" <hans-christian.egtvedt@atmel.com>
Subject: Re: [PATCH] arch/avr32: Fix build failure for avr32 caused by typo
Date: Mon, 28 Dec 2009 10:59:30 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Ma <pma@mediamatech.com>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org
References: <200912252008.45602.PeterHuewe@gmx.de> <20091228091318.454c4713@hcegtvedt.norway.atmel.com>
In-Reply-To: <20091228091318.454c4713@hcegtvedt.norway.atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912281059.30450.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 28 Dezember 2009 09:13:18 schrieb Hans-Christian Egtvedt:
> On Fri, 25 Dec 2009 20:08:45 +0100
> 
> Peter Huewe <PeterHuewe@gmx.de> wrote:
> > This patch fixes a build failure introduced by the patch
> >   atmel-mci: change use of dma slave interface by Nicolas Ferre
> > by changing mci_dma_slave to the correct name of mci_dma_data
> >
> > This should make the avr32 tree build again.
> 
> Ah, great, I have not gotten around to test this yet. Thanks for the
> patch. I've done some minor changes and also fixed the kzalloc/kfree
> error handling. Please see the inlined patch below.
> 

> @@ -1344,7 +1344,7 @@ at32_add_device_mci(unsigned int id, struct
>  mci_platform_data *data) ARRAY_SIZE(atmel_mci0_resource)))
>  		goto fail;
> 
> -	slave = kzalloc(sizeof(struct mci_dma_slave), GFP_KERNEL);
> +	slave = kzalloc(sizeof(struct mci_dma_data), GFP_KERNEL);
> 
>  	slave->sdata.dma_dev = &dw_dmac0_device.dev;
>  	slave->sdata.reg_width = DW_DMA_SLAVE_WIDTH_32BIT;


Great, thanks for the update.
The only thing that still catches my eye is that the kzalloc line can fail, so 
you should perhaps add something like
if (!slave) {
	printk(KERN_ERR "No memory left for at32ap700x: at32_add_device_mc");
	goto fail;
}

(not tested :)


Apart from that:
Acked-By: Peter Huewe <peterhuewe@gmx.de>


Thanks and best regards,
Peter
