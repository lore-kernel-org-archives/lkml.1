Return-Path: <linux-kernel-owner+w=401wt.eu-S1755749AbZAEPgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749AbZAEPgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZAEPgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:36:03 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:64169 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbZAEPgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:36:01 -0500
Date: Tue, 06 Jan 2009 00:35:58 +0900 (JST)
Message-Id: <20090106.003558.115932572.anemo@mba.ocn.ne.jp>
To: haavard.skinnemoen@atmel.com
Cc: linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com
Subject: Re: dw_dmac driver questions
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090105153024.179c9f29@hskinnemoen-d830>
References: <20081229.233932.25909762.anemo@mba.ocn.ne.jp>
	<20090105153024.179c9f29@hskinnemoen-d830>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 15:30:24 +0100, Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> > 1. map/unmap DMA buffers for slave transfer
> > 
> > For slave-DMA, it seems dmac driver is responsible for mapping DMA
> > buffers, and client is responsible for unmapping them.  Is it right?
> 
> No, it's the other way around, unless DMA_COMPL_SKIP_*_UNMAP is set.
> But I think the dw_dmac driver wrongly maps the buffers before queuing
> them.

Well, I'm confused...  I reference atmel-mci for client and dw_dmac
for dma engine.  Currently, dw_dmac calls dma_map_sg() and atmel-mci
calls dma_unmap_sg().  Do you mean atmel-mci will be changed to call
dma_map_sg()?

> > 4. This is a comment on head of dwc_handle_error().
> > 
> > 	/*
> > 	 * The descriptor currently at the head of the active list is
> > 	 * borked. Since we don't have any way to report errors, we'll
> > 	 * just have to scream loudly and try to carry on.
> > 	 */
> > 
> > But, the bad descriptor can be at any place of the active list, no ?
> > For example, if the active list contained two descriptor and latter
> > was broken and tasklet was delayed by some reason, the head of the
> > list should be good.
> 
> Since dwc_scan_descriptors() was just called, all descriptors that were
> completed successfully have been removed from the active list. So the
> first entry must be the broken one.

But the removal from the active list is done in tasklet too.  If the
CPU was slow and DMA engine was fast enough, DMA engine will process
multiple descriptors before the tasklet called, no ?

---
Atsushi Nemoto
