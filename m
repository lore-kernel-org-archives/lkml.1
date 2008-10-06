Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYJFMQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYJFMQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYJFMPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:15:55 -0400
Received: from www.tglx.de ([62.245.132.106]:49012 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099AbYJFMPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:53 -0400
Date: Mon, 6 Oct 2008 14:15:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: use iommu_device_max_index
In-Reply-To: <20081002093405.GC4190@elte.hu>
Message-ID: <alpine.LFD.2.00.0810061411210.3166@apollo>
References: <20080929000525E.fujita.tomonori@lab.ntt.co.jp> <20081001163008.GC30173@amd.com> <20081002093405.GC4190@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, Ingo Molnar wrote:
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Ingo,
> > 
> > can you please apply this patch to your x86/iommu directly? For a 
> > single patch it makes no sense to go through my tree.
> 
> sure - applied to tip/x86/iommu, thanks guys.

breaks sparc64 build due to missing header guards.

Thanks,

	tglx
-------------->
Subject: iommu: add missing header guards
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 06 Oct 2008 14:12:21 +0200

include/linux/iommu-helper.h has no header guards, which breaks
sparc64 build. Add them.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
diff --git a/include/linux/iommu-helper.h b/include/linux/iommu-helper.h
index 786539e..a6d0586 100644
--- a/include/linux/iommu-helper.h
+++ b/include/linux/iommu-helper.h
@@ -1,3 +1,6 @@
+#ifndef _LINUX_IOMMU_HELPER_H
+#define _LINUX_IOMMU_HELPER_H
+
 static inline unsigned long iommu_device_max_index(unsigned long size,
 						   unsigned long offset,
 						   u64 dma_mask)
@@ -19,3 +22,5 @@ extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long align_mask);
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
+
+#endif


