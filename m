Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZGXNuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZGXNuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 09:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZGXNuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 09:50:15 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:54689 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbZGXNuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 09:50:14 -0400
X-Greylist: delayed 1252 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 09:50:14 EDT
Date: Fri, 24 Jul 2009 22:29:19 +0900 (JST)
Message-Id: <20090724.222919.240484146.anemo@mba.ocn.ne.jp>
To: nicolas.ferre@atmel.com
Cc: dan.j.williams@intel.com, maciej.sosnowski@intel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com
Subject: Re: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4A696449.7050303@atmel.com>
References: <1248285885-1189-1-git-send-email-nicolas.ferre@atmel.com>
	<e9c3a7c20907231013k3d5e8c89w1069e8509539438f@mail.gmail.com>
	<4A696449.7050303@atmel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 09:35:37 +0200, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > Seems straightforward and self contained, applied.  Just curious which
> > drivers will take advantage of this slave capability?  As it stands I
> > do not see any in-tree users of at_hdmac beyond dmatest?
> 
> Well, in fact the same as dw_dmac: atmel-mci. Adaptation of other
> drivers are coming: probably ac97 and spi interfaces.
> 
> The patches for adaptation of atmel-mci to at_hdmac are coming...

Your atc_chain_complete() calls dma_unmap_xxx unless
DMA_COMPL_SKIP_XXX_UNMAP specified.  But atmel-mci driver does not set
the flag on dma_async_tx_descriptor.  I suppose one of them should be
fixed.

It is not clear for me how dma driver should handle unmapping on
completion of slave DMA.  Are there any consensus on it?

I enclosed unmapping code of txx9dmac driver by "if (!slave)" and did
not use DMA_COMPL_SKIP_XXX_UNMAP flag in its client driver (txx9aclc
ASoC driver).  If consensus made on how to handle unmapping on slave
DMA, I will follow it.

---
Atsushi Nemoto
