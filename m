Return-Path: <linux-kernel-owner+w=401wt.eu-S1751167AbXA3T7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbXA3T7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbXA3T7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:59:25 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:41533 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751167AbXA3T7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:59:24 -0500
Date: Tue, 30 Jan 2007 11:59:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab.c ifdef reduction breaks build
In-Reply-To: <Pine.LNX.4.64.0701291343180.548@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0701301158320.12100@schroedinger.engr.sgi.com>
References: <20070129200517.GA6229@ccure.user-mode-linux.org>
 <Pine.LNX.4.64.0701291214060.32740@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0701291240020.401@schroedinger.engr.sgi.com>
 <20070129125630.dfba64a4.akpm@osdl.org> <Pine.LNX.4.64.0701291343180.548@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Christoph Lameter wrote:

> On Mon, 29 Jan 2007, Andrew Morton wrote:
> 
> > On Mon, 29 Jan 2007 12:41:33 -0800 (PST)
> > Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > +#ifdef CONFIG_ZONE_DMA
> > >  		if (CONFIG_ZONE_DMA_FLAG)
> > 
> > We don't need the `if (CONFIG_ZONE_DMA_FLAG)' any more, do we?
> 
> Correct.
> 

Here is the modified patch:


Fix slab build failure if !CONFIG_ZONE_DMA

I also needed this to get 2.6.20-rc6-mm2 to build. Fixes the fix of the
complainer about the fixes.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

Index: linux-2.6.20-rc6-mm2/mm/slab.c
===================================================================
--- linux-2.6.20-rc6-mm2.orig/mm/slab.c	2007-01-30 13:56:10.683074081 -0600
+++ linux-2.6.20-rc6-mm2/mm/slab.c	2007-01-30 13:57:13.152420752 -0600
@@ -1504,14 +1504,15 @@ void __init kmem_cache_init(void)
 					ARCH_KMALLOC_FLAGS|SLAB_PANIC,
 					NULL, NULL);
 		}
-		if (CONFIG_ZONE_DMA_FLAG)
-			sizes->cs_dmacachep = kmem_cache_create(
+#ifdef CONFIG_ZONE_DMA
+		sizes->cs_dmacachep = kmem_cache_create(
 					names->name_dma,
 					sizes->cs_size,
 					ARCH_KMALLOC_MINALIGN,
 					ARCH_KMALLOC_FLAGS|SLAB_CACHE_DMA|
 						SLAB_PANIC,
 					NULL, NULL);
+#endif
 		sizes++;
 		names++;
 	}
