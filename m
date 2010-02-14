Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab0BNPcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 10:32:20 -0500
Received: from mail-bw0-f216.google.com ([209.85.218.216]:33461 "EHLO
	mail-bw0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab0BNPcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 10:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YHkcW5bkTqx/8wkbI5jVv/tSe0IQSYPdksEvx08GFCwYpPo3I2YqhqLz0WRxm/lJlW
         Bl2wzw58civItZ+8KrGkpfxcwYRQq9usFIRO/S65H/h3JdwIw8VXKBQeH0QoN5UcAg3R
         ummn8yI4QcWmEFdxXqn/2zTD6a11aL8SwoMmw=
MIME-Version: 1.0
Date: Sun, 14 Feb 2010 17:32:17 +0200
Message-ID: <912ec82a1002140732g946e9b1id8b56d7df7517480@mail.gmail.com>
Subject: understanding DMA cache maint
From: Neshama Parhoti <pneshama@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in the following function,
what's the different between the inner_op (dmac_*) and outer_op (outer_*) ?
why do we need two functions to do the cache operation ?
isn't this an action on the cache hardware itself ? are there 2
hardwares involved ?

void dma_cache_maint(const void *start, size_t size, int direction)
{
   ...
	switch (direction) {
	case DMA_FROM_DEVICE:		/* invalidate only */
		inner_op = dmac_inv_range;
		outer_op = outer_inv_range;
		break;
	case DMA_TO_DEVICE:		/* writeback only */
		inner_op = dmac_clean_range;
		outer_op = outer_clean_range;
		break;
	case DMA_BIDIRECTIONAL:		/* writeback and invalidate */
		inner_op = dmac_flush_range;
		outer_op = outer_flush_range;


thank you!
