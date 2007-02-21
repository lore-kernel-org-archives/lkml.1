Return-Path: <linux-kernel-owner+w=401wt.eu-S1422749AbXBUSHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422749AbXBUSHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422751AbXBUSHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:07:44 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:14726 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422749AbXBUSHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:07:43 -0500
Subject: [patch 1/1] MM:  detach_vmas_to_be_unmapped fix
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org
From: akuster@mvista.com
Date: Wed, 21 Feb 2007 10:06:09 -0800
Message-Id: <20070221180742.A05F31C49A@hermes.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~Avoiding-mmap-fragmentation_fixup mm/mmap.c
--- linux-2.6_clean/mm/mmap.c~Avoiding-mmap-fragmentation_fixup	2007-02-21 09:49:32.000000000 -0800
+++ linux-2.6_clean-akuster/mm/mmap.c	2007-02-21 09:51:26.000000000 -0800
@@ -1720,9 +1720,9 @@ detach_vmas_to_be_unmapped(struct mm_str
 	*insertion_point = vma;
 	tail_vma->vm_next = NULL;
 	if (mm->unmap_area == arch_unmap_area)
-		addr = prev ? prev->vm_end : mm->mmap_base;
+		addr = prev ? prev->vm_start : mm->mmap_base;
 	else
-		addr = vma ?  vma->vm_start : mm->mmap_base;
+		addr = vma ?  vma->vm_end : mm->mmap_base;
 	mm->unmap_area(mm, addr);
 	mm->mmap_cache = NULL;		/* Kill the cache. */
 }
_
