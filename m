Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZG2PVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZG2PVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbZG2PVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:21:35 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:59869 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484AbZG2PVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:21:35 -0400
Date: Thu, 30 Jul 2009 00:16:32 +0900 (JST)
Message-Id: <20090730.001632.39159752.anemo@mba.ocn.ne.jp>
To: maciej.sosnowski@intel.com
Cc: haavard.skinnemoen@atmel.com, nicolas.ferre@atmel.com,
       dan.j.williams@intel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: at_hdmac: add DMA slave transfers
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7B2980817@irsmsx504.ger.corp.intel.com>
References: <129600E5E5FB004392DDC3FB599660D7B271F468@irsmsx504.ger.corp.intel.com>
	<20090729.001330.172537373.anemo@mba.ocn.ne.jp>
	<129600E5E5FB004392DDC3FB599660D7B2980817@irsmsx504.ger.corp.intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 14:05:17 +0100, "Sosnowski, Maciej" <maciej.sosnowski@intel.com> wrote:
> Atsushi Nemoto wrote:
> > On Mon, 27 Jul 2009 14:24:26 +0100, "Sosnowski, Maciej" <maciej.sosnowski@intel.com> wrote:
> >>>> Your atc_chain_complete() calls dma_unmap_xxx unless
> >>>> DMA_COMPL_SKIP_XXX_UNMAP specified.  But atmel-mci driver does not set
> >>>> the flag on dma_async_tx_descriptor.  I suppose one of them should be
> >>>> fixed.
> >>> 
> >>> atmel-mci should definitely set that flag.
> >>> 
> >>> Haavard
> >> 
> >> I agree with Haavard.
> > 
> > Then, what should dma driver do when client driver did not set these
> > flags?  If it should call dma_unmap_sg(), the dma driver should keep
> > sg and direction somewhere...
> 
> Well, what about BUG_ON?

Or prep_slave_sg can preset both DMA_COMPL_SKIP_XXX_UNMAP flags, or do
not unmap in dma driver for slave channel.  I suppose latter is safe
and simple.

> > Also, calling dma_map_sg() in its prep_slave_sg function will not fit
> > for sound drivers, which use DMA buffers prepared in its framework.
> 
> It looks like a need for one more flag: DMA_SKIP_MAP_SG.
> What do you think?

I do not think it is worth to introduce new flag.

As Dan said, pushing dma mapping responsibility to the client looks
simple and clean way for me.

---
Atsushi Nemoto
