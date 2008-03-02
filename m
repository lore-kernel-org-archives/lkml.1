Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbYCBUtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbYCBUtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbYCBUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:48:49 -0500
Received: from gate.crashing.org ([63.228.1.57]:60452 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757297AbYCBUst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:48:49 -0500
Subject: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
In-Reply-To: <20080302110505.175270@gmx.net>
References: <20071125234254.B4405DDE49@ozlabs.org>
	 <20080302110505.175270@gmx.net>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 07:47:09 +1100
Message-Id: <1204490829.15052.482.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Xorg (v7.1.1, Debian Etch) crashes with this patch (applied to 2.6.25-rc3)
> on my AmigaOne with a Radeon 9200 (PCIGART mode enabled). See the attached
> log file for the stack trace.

That doesn't look possible, which is weird... looks like we are passing
0 to clean_dcache_range().

Interestingly enough, I can -see- possible issues with the ppc32 DMA API
when trying to use HIGHMEM but that isn't the case here... 

Can you add printk's to ati_pcigart.c to print the arguments passed to

+               dma_sync_single_for_device(&dev->pdev->dev,
+                                          bus_address,
+                                          max_pages * sizeof(u32),
+                                          PCI_DMA_TODEVICE);
+

And also print the result of bus_to_virt(bus_address) ?

Ben.

