Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZBFQ6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZBFQ6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZBFQ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:58:29 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:54412 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbZBFQ62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:58:28 -0500
Date: Sat, 07 Feb 2009 01:58:25 +0900 (JST)
Message-Id: <20090207.015825.95063161.anemo@mba.ocn.ne.jp>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       maciej.sosnowski@intel.com, hskinnemoen@atmel.com,
       g.liakhovetski@gmx.de, nicolas.ferre@atmel.com
Subject: Re: [PATCH 07/13] dmaengine: introduce dma_request_channel and
 private channels
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20081114213453.32354.53002.stgit@dwillia2-linux.ch.intel.com>
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
	<20081114213453.32354.53002.stgit@dwillia2-linux.ch.intel.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008 14:34:53 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> To ensure that all channels are not consumed by the general-purpose
> allocator the DMA_PRIVATE capability is provided to exclude a dma_device
> from general-purpose (memory-to-memory) consideration.
...
> +			/* Found a suitable channel, try to grab, prep, and
> +			 * return it.  We first set DMA_PRIVATE to disable
> +			 * balance_ref_count as this channel will not be
> +			 * published in the general-purpose allocator
> +			 */
> +			dma_cap_set(DMA_PRIVATE, device->cap_mask);
> +			err = dma_chan_get(chan);

The dma_request_channel() set DMA_PRIVATE but dma_release_channel()
does not clear it.

If a client (such as dmatest) grabbed a public channel by
dma_request_channel(), the channel will stay private forever.

While a dma driver might set DMA_PRIVATE initially for private-only
channels, dma_release_channel() cannot clear it unconditionally.

How can this solved?  DMA_ALWAYS_PRIVATE or device->is_private or
something will needed?

---
Atsushi Nemoto
