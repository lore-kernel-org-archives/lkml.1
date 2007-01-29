Return-Path: <linux-kernel-owner+w=401wt.eu-S932333AbXA2UmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333AbXA2UmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932518AbXA2UmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:42:14 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:46919 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932333AbXA2UmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:42:10 -0500
Date: Mon, 29 Jan 2007 12:41:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Jeff Dike <jdike@addtoit.com>
cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab.c ifdef reduction breaks build
In-Reply-To: <Pine.LNX.4.64.0701291214060.32740@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0701291240020.401@schroedinger.engr.sgi.com>
References: <20070129200517.GA6229@ccure.user-mode-linux.org>
 <Pine.LNX.4.64.0701291214060.32740@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I also hit the same issue. Here is the patch:


Fix slab build failure if !CONFIG_ZONE_DMA

I also needed this to get 2.6.20-rc6-mm2 to build. Fixes the fix by the
complainer about the fixes. #ifdef cannot be avoided since cs_dmacachep
is no longer defined.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.20-rc6-mm2/mm/slab.c
===================================================================
--- linux-2.6.20-rc6-mm2.orig/mm/slab.c	2007-01-29 14:27:58.000000000 -0600
+++ linux-2.6.20-rc6-mm2/mm/slab.c	2007-01-29 14:33:04.270329009 -0600
@@ -1503,6 +1503,7 @@ void __init kmem_cache_init(void)
 					ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 					NULL, NULL);
 		}
+#ifdef CONFIG_ZONE_DMA
 		if (CONFIG_ZONE_DMA_FLAG)
 			sizes->cs_dmacachep = kmem_cache_create(
 					names->name_dma,
@@ -1511,6 +1512,7 @@ void __init kmem_cache_init(void)
 					ARCH_KMALLOC_FLAGS|SLAB_CACHE_DMA|
 						SLAB_PANIC,
 					NULL, NULL);
+#endif
 		sizes++;
 		names++;
 	}
