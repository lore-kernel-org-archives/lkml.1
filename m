Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbZL1KDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbZL1KDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbZL1KD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:03:29 -0500
Received: from relay.atmel.no ([80.232.32.139]:57101 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZL1KD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:03:29 -0500
Date: Mon, 28 Dec 2009 11:02:44 +0100
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Peter =?UTF-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Ma <pma@mediamatech.com>, linux-kernel@vger.kernel.org,
       linux-mmc@vger.kernel.org
Subject: Re: [PATCH] arch/avr32: Fix build failure for avr32 caused by typo
Message-ID: <20091228110244.3957a358@hcegtvedt.norway.atmel.com>
In-Reply-To: <200912281059.30450.PeterHuewe@gmx.de>
References: <200912252008.45602.PeterHuewe@gmx.de>
	<20091228091318.454c4713@hcegtvedt.norway.atmel.com>
	<200912281059.30450.PeterHuewe@gmx.de>
Organization: Atmel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 10:59:30 +0100
Peter Hüwe <PeterHuewe@gmx.de> wrote:

> Am Montag 28 Dezember 2009 09:13:18 schrieb Hans-Christian Egtvedt:
> > On Fri, 25 Dec 2009 20:08:45 +0100
> > 
> > Peter Huewe <PeterHuewe@gmx.de> wrote:
> > > This patch fixes a build failure introduced by the patch
> > >   atmel-mci: change use of dma slave interface by Nicolas Ferre
> > > by changing mci_dma_slave to the correct name of mci_dma_data
> > >
> > > This should make the avr32 tree build again.
> > 
> > Ah, great, I have not gotten around to test this yet. Thanks for the
> > patch. I've done some minor changes and also fixed the kzalloc/kfree
> > error handling. Please see the inlined patch below.
> > 
> 
> > @@ -1344,7 +1344,7 @@ at32_add_device_mci(unsigned int id, struct
> >  mci_platform_data *data) ARRAY_SIZE(atmel_mci0_resource)))
> >  		goto fail;
> > 
> > -	slave = kzalloc(sizeof(struct mci_dma_slave), GFP_KERNEL);
> > +	slave = kzalloc(sizeof(struct mci_dma_data), GFP_KERNEL);
> > 
> >  	slave->sdata.dma_dev = &dw_dmac0_device.dev;
> >  	slave->sdata.reg_width = DW_DMA_SLAVE_WIDTH_32BIT;
> 
> 
> Great, thanks for the update.
> The only thing that still catches my eye is that the kzalloc line can fail, so 
> you should perhaps add something like
> if (!slave) {
> 	printk(KERN_ERR "No memory left for at32ap700x: at32_add_device_mc");
> 	goto fail;
> }
> 

Sounds like the patch should be split in two, one addressing the proper
naming of the struct mci_dma_data and one fixing the allocation of
memory and proper cleanup.

-- 
Best regards,
Hans-Christian Egtvedt
