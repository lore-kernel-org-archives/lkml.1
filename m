Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZE1HVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZE1HVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 03:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZE1HUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 03:20:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbZE1HUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 03:20:48 -0400
Date: Thu, 28 May 2009 00:20:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, arnd@arndb.de, joerg.roedel@amd.com
Subject: Re: [PATCH -tip 2/5] x86: use asm-generic/dma-mapping-common.h
Message-Id: <20090528002032.737f3e67.akpm@linux-foundation.org>
In-Reply-To: <1242359705-2117-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1242359705-2117-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1242359705-2117-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 12:55:02 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Acked-by: Joerg Roedel <joerg.roedel@amd.com>
>
> ...
>
>  /* Make sure we keep the same behaviour */
>  static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
>  {
> @@ -53,178 +55,6 @@ extern int dma_set_mask(struct device *dev, u64 mask);
>  extern void *dma_generic_alloc_coherent(struct device *dev, size_t size,
>  					dma_addr_t *dma_addr, gfp_t flag);
>  
> -static inline dma_addr_t
> -dma_map_single(struct device *hwdev, void *ptr, size_t size,
> -	       enum dma_data_direction dir)
> -{
> -	struct dma_map_ops *ops = get_dma_ops(hwdev);
> -	dma_addr_t addr;
> -
> -	kmemcheck_mark_initialized(ptr, size);

This patch attempts to delete kmemcheck stuff which isn't presently in
linux-next.

So I went ahead and ported the patch, but it'll break if/when kmemcheck
returns.

