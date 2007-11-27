Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbXK0XrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbXK0XrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 18:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXK0XrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 18:47:10 -0500
Received: from mga07.intel.com ([143.182.124.22]:41803 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753686AbXK0XrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:47:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,221,1194249600"; 
   d="scan'208";a="327501228"
Date: Tue, 27 Nov 2007 15:48:02 -0800
From: mark gross <mgross@linux.intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: ak@linux.intel.com
Subject: [mgross@linux.intel.com: intel-iommu-PMEN-think-oh patch.]
Message-ID: <20071127234802.GB14134@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to cc the list.

--mgross

----- Forwarded message from mark gross <mgross@linux.intel.com> -----

Date: Tue, 27 Nov 2007 15:46:09 -0800
From: mark gross <mgross@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Reply-To: mgross@linux.intel.com
Subject: intel-iommu-PMEN-think-oh patch.

I screwed up with my earlier patch to enable the portected memroy.  The
macro IOMMU_WAIT, exits when the condition goes true.  Without this
patch the code will hang at boot and some ( all?) vtd enabled systems.


--mgross

Signed-off-by: mark gross <mgross@linux.intel.com>


Index: linux-2.6.24-rc2+/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.24-rc2+.orig/drivers/pci/intel-iommu.c	2007-11-27 15:29:38.000000000 -0800
+++ linux-2.6.24-rc2+/drivers/pci/intel-iommu.c	2007-11-27 15:30:06.000000000 -0800
@@ -704,7 +704,7 @@
 
 	/* wait for the protected region status bit to clear */
 	IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
-		readl, (pmen & DMA_PMEN_PRS), pmen);
+		readl, !(pmen & DMA_PMEN_PRS), pmen);
 
 	spin_unlock_irqrestore(&iommu->register_lock, flags);
 }

----- End forwarded message -----
