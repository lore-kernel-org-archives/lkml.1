Return-Path: <linux-kernel-owner+w=401wt.eu-S2992645AbXDDEK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992645AbXDDEK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992640AbXDDEKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:10:07 -0400
Received: from ozlabs.org ([203.10.76.45]:49618 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934058AbXDDEBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:43 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:32 +1000
Subject: [PATCH 11/14] get_unmapped_area handles MAP_FIXED on ramfs (nommu) 
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040143.1EDE6DDEA0@ozlabs.org>
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
