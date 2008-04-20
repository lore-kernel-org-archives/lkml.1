Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYDTA1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYDTA1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 20:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYDTA1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 20:27:45 -0400
Received: from ozlabs.org ([203.10.76.45]:34474 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYDTA1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 20:27:44 -0400
To: David Airlie <airlied@linux.ie>
CC: <linux-kernel@vger.kernel.org>, <stevewin@us.ibm.com>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Sun, 20 Apr 2008 10:26:25 +1000
Subject: [PATCH 1/2] drm: Fix mismerge of non-coherent DMA patch
Message-Id: <20080420002743.7071CDE36D@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch for supporting non coherent PCI DMA in the DRM was mismerged
causing the page protection to be updated for the wrong type of
mapping.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

David, if ok, please fwd to stable too.

 drivers/char/drm/drm_vm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-work.orig/drivers/char/drm/drm_vm.c	2008-04-19 16:49:48.000000000 +1000
+++ linux-work/drivers/char/drm/drm_vm.c	2008-04-19 16:49:55.000000000 +1000
@@ -640,12 +640,12 @@ static int drm_mmap_locked(struct file *
 		/* Don't let this area swap.  Change when
 		   DRM_KERNEL advisory is supported. */
 		vma->vm_flags |= VM_RESERVED;
-		vma->vm_page_prot = drm_dma_prot(map->type, vma);
 		break;
 	case _DRM_SCATTER_GATHER:
 		vma->vm_ops = &drm_vm_sg_ops;
 		vma->vm_private_data = (void *)map;
 		vma->vm_flags |= VM_RESERVED;
+		vma->vm_page_prot = drm_dma_prot(map->type, vma);
 		break;
 	default:
 		return -EINVAL;	/* This should never happen. */
