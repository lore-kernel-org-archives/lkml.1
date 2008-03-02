Return-Path: <linux-kernel-owner+w=401wt.eu-S1760295AbYCBWyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295AbYCBWyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYCBWyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:54:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:46106 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbYCBWym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:54:42 -0500
Subject: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: linuxppc-dev@ozlabs.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, airlied@linux.ie
In-Reply-To: <20080302223012.90210@gmx.net>
References: <20071125234254.B4405DDE49@ozlabs.org>
	 <20080302110505.175270@gmx.net> <1204490829.15052.482.camel@pasglop>
	 <20080302223012.90210@gmx.net>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 09:54:07 +1100
Message-Id: <1204498447.15052.485.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Okay, I changed the code to this:
> 
> >DRM_DEBUG("dev = 0x%x, bus_address = 0x%x, bus_to_virt = 0x%lx, max_pages = 0x%x\n",
> >	(unsigned int)&dev->pdev->dev, bus_address,
> >	(unsigned long)virt_to_bus(bus_address), max_pages);
> >
> >if (gart_info->gart_table_location == DRM_ATI_GART_MAIN) {
> >	DRM_DEBUG("calling dma_sync_single_for_device()\n");
> >	dma_sync_single_for_device(&dev->pdev->dev,
> >		bus_address,
> >		max_pages * sizeof(u32),
> >		PCI_DMA_TODEVICE);
> >}
> 
> It looks like dma_sync_single_for_device() is not called here (the debug
> messages don't show up in kernel log). I also included the Xorg.0.log
> file.

Ok, try adding more debug then, around the calls to pci_map_single() in
that same function and dump the arguments. I'm especially interested
in the result of the various page_address().

Ben.


