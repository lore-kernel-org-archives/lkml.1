Return-Path: <linux-kernel-owner+w=401wt.eu-S1753825AbZESRkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbZESRkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbZESRjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:39:54 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:10768 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752811AbZESRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:39:53 -0400
X-Greylist: delayed 1095 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2009 13:39:53 EDT
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/sparse.c: change printk()s to pr_*() notation
Date: Tue, 19 May 2009 10:21:35 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905191021.35793.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all the printk()s in mm/sparse.c to the pr_*() notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/sparse.c b/mm/sparse.c
index da432d9..895cba9 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -308,9 +308,8 @@ static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
 
 	usemap_nid = sparse_early_nid(__nr_to_section(usemap_snr));
 	if (usemap_nid != nid) {
-		printk(KERN_INFO
-		       "node %d must be removed before remove section %ld\n",
-		       nid, usemap_snr);
+		pr_info("node %d must be removed before remove section %ld\n",
+			nid, usemap_snr);
 		return;
 	}
 	/*
@@ -319,10 +318,9 @@ static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
 	 * gather other removable sections for dynamic partitioning.
 	 * Just notify un-removable section's number here.
 	 */
-	printk(KERN_INFO "Section %ld and %ld (node %d)", usemap_snr,
-	       pgdat_snr, nid);
-	printk(KERN_CONT
-	       " have a circular dependency on usemap and pgdat allocations\n");
+	pr_info("Section %ld and %ld (node %d)", usemap_snr,
+		pgdat_snr, nid);
+	pr_cont(" have a circular dependency on usemap and pgdat allocations\n");
 }
 #else
 static unsigned long * __init
@@ -355,7 +353,7 @@ static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 	/* Stupid: suppress gcc warning for SPARSEMEM && !NUMA */
 	nid = 0;
 
-	printk(KERN_WARNING "%s: allocation failed\n", __func__);
+	pr_warning("%s: allocation failed\n", __func__);
 	return NULL;
 }
 
@@ -384,8 +382,8 @@ static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 	if (map)
 		return map;
 
-	printk(KERN_ERR "%s: sparsemem memory map backing failed "
-			"some memory will not be available.\n", __func__);
+	pr_err("%s: sparsemem memory map backing failed "
+		"some memory will not be available.\n", __func__);
 	ms->section_mem_map = 0;
 	return NULL;
 }
