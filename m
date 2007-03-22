Return-Path: <linux-kernel-owner+w=401wt.eu-S965793AbXCVGEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793AbXCVGEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965819AbXCVGEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:04:09 -0400
Received: from ozlabs.org ([203.10.76.45]:57911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965826AbXCVGEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:04:05 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:01:27 +1100
Subject: [RFC/PATCH 11/15] get_unmapped_area handles MAP_FIXED on ramfs (nommu) 
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060301.DD1A6DE411@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 fs/ramfs/file-nommu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-cell/fs/ramfs/file-nommu.c
===================================================================
--- linux-cell.orig/fs/ramfs/file-nommu.c	2007-03-22 16:18:27.000000000 +1100
+++ linux-cell/fs/ramfs/file-nommu.c	2007-03-22 16:20:14.000000000 +1100
@@ -238,7 +238,10 @@ unsigned long ramfs_nommu_get_unmapped_a
 	struct page **pages = NULL, **ptr, *page;
 	loff_t isize;
 
-	if (!(flags & MAP_SHARED))
+	/* Deal with MAP_FIXED differently ? Forbid it ? Need help from some nommu
+	 * folks there... --BenH.
+	 */
+	if ((flags & MAP_FIXED) || !(flags & MAP_SHARED))
 		return addr;
 
 	/* the mapping mustn't extend beyond the EOF */
