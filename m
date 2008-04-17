Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbYDQNWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbYDQNWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 09:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYDQNWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 09:22:41 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:47809 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbYDQNWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 09:22:40 -0400
Message-ID: <48074F18.7050802@tiscali.nl>
Date: Thu, 17 Apr 2008 15:22:32 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: phil.el@wanadoo.fr
CC: oprofile-list@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] oprofile: vma_map: fix test on overlay_tbl_offset
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Offset is unsigned and when an address isn't found in the vma map
vma_map_lookup() returns the vma physical address + 0x10000000.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
index 9a93217..1c28e2e 100644
--- a/arch/powerpc/oprofile/cell/vma_map.c
+++ b/arch/powerpc/oprofile/cell/vma_map.c
@@ -229,7 +229,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
 	 */
 	overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym,
 					    aSpu, &grd_val);
-	if (overlay_tbl_offset < 0) {
+	if (overlay_tbl_offset >= 0x10000000) {
 		printk(KERN_ERR "SPU_PROF: "
 		       "%s, line %d: Error finding SPU overlay table\n",
 		       __FUNCTION__, __LINE__);

