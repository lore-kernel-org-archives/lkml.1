Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbXBIXlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbXBIXlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXBIXlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:41:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44484 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbXBIXlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:41:46 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 10 Feb 2007 00:40:17 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [stable patch 2.6.20 1/3] Missing critical phys_to_virt in
 lib/swiotlb.c
To: stable@kernel.org
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.3758c666718465a8@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Date: Sun, 04 Feb 2007 13:39:40 -0500
From: David Moore <dcm@acm.org>

Adds missing call to phys_to_virt() in the
lib/swiotlb.c:swiotlb_sync_sg() function.  Without this change, a kernel
panic will always occur whenever a SWIOTLB bounce buffer from a
scatter-gather list gets synced.

Signed-off-by: David Moore <dcm@acm.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This is a fraction of patch "[IA64] swiotlb bug fixes" in 2.6.20-git#,
commit cde14bbfb3aa79b479db35bd29e6c083513d8614.  Unlike its heading
suggests, it is also important for EM64T.

Example crashes caused by swiotlb_sync_sg:
http://lists.opensuse.org/opensuse-bugs/2006-12/msg02943.html
http://qa.mandriva.com/show_bug.cgi?id=28224
http://www.pchdtv.com/forum/viewtopic.php?t=2063&sid=a959a14a4c2db0eebaab7b0df56103ce

--- linux-2.6.20.orig/lib/swiotlb.c	2007-02-04 13:18:41.000000000 -0500
+++ linux-2.6.20/lib/swiotlb.c	2007-02-04 13:19:43.000000000 -0500
@@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
 
 	for (i = 0; i < nelems; i++, sg++)
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, (void *) sg->dma_address,
+			sync_single(hwdev, phys_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 }
 

-- 
Stefan Richter
-=====-=-=== --=- -=-=-
http://arcgraph.de/sr/

