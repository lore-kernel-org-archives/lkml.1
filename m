Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbZGaED4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbZGaED4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 00:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZGaEDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 00:03:54 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:62283 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbZGaEDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 00:03:54 -0400
Date: Fri, 31 Jul 2009 12:58:52 +0900 (JST)
Message-Id: <20090731.125852.229722391.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: maciej.sosnowski@intel.com, haavard.skinnemoen@atmel.com,
       nicolas.ferre@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4A705C6F.1000203@intel.com>
References: <129600E5E5FB004392DDC3FB599660D7B271F468@irsmsx504.ger.corp.intel.com>
	<20090729.001330.172537373.anemo@mba.ocn.ne.jp>
	<4A705C6F.1000203@intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 07:27:59 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> > Then, what should dma driver do when client driver did not set these
> > flags?  If it should call dma_unmap_sg(), the dma driver should keep
> > sg and direction somewhere...
> > 
> > Also, calling dma_map_sg() in its prep_slave_sg function will not fit
> > for sound drivers, which use DMA buffers prepared in its framework.
> > 
> > For slave DMA, doing all mapping/unmapping in DMA client is better,
> > isn't it?
> 
> Yes it is.  The whole point of the dma driver doing its own unmapping is 
> specifically for clients that use the async_tx api, i.e. where they do 
> not know if the transaction is carried out in hardware and have no way 
> of tracking the details necessary to perform the unmap.  DMA-slave 
> clients request specific channels and know the hardware details at a low 
> level, so it should not be too high an expectation to push dma mapping 
> responsibility to the client.

OK, I will send a patch to move all map_sg/unmap_sg for slave channel
to its client.  Affected drivers are at_hdmac, dw_dmac and atmel-mci.

I do not have any of them, I hope someone who have them can test it.
Thank you.

---
Atsushi Nemoto
