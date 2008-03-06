Return-Path: <linux-kernel-owner+w=401wt.eu-S934392AbYCFC24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392AbYCFC24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 21:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763627AbYCFCZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 21:25:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:61432 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762270AbYCFCZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 21:25:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hvr+Tr2ZMWkYRs/pI8c3R0NKqTEjyOFjfApxs1RHguFjxndrkj4emFe73wItOFCErHEXh8DTBdXE3OiCepHKf5RtmCWPh0wua3hKzsfi8dzrNT8SXuXkECyNOm2XgCr6udWKrqDQDDRWUVH+Z+upmNfQxUi/SgI0olvT6moRoX0=
Subject: [PATCH 07/16] ieee1394: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 18:24:54 -0800
Message-Id: <1204770294.14154.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/ieee1394/highlevel.c     |    6 +++---
 drivers/ieee1394/ieee1394_core.c |    2 +-
 drivers/ieee1394/ohci1394.c      |    2 +-
 drivers/ieee1394/pcilynx.c       |   12 ++++++------
 drivers/ieee1394/sbp2.c          |    4 ++--
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/ieee1394/highlevel.c b/drivers/ieee1394/highlevel.c
index b642546..fa2bfec 100644
--- a/drivers/ieee1394/highlevel.c
+++ b/drivers/ieee1394/highlevel.c
@@ -339,7 +339,7 @@ u64 hpsb_allocate_and_register_addrspace(struct hpsb_highlevel *hl,
 	if ((alignment & 3) || (alignment > 0x800000000000ULL) ||
 	    (hweight64(alignment) != 1)) {
 		HPSB_ERR("%s called with invalid alignment: 0x%048llx",
-			 __FUNCTION__, (unsigned long long)alignment);
+			 __func__, (unsigned long long)alignment);
 		return retval;
 	}
 
@@ -354,7 +354,7 @@ u64 hpsb_allocate_and_register_addrspace(struct hpsb_highlevel *hl,
 	if (((start|end) & ~align_mask) || (start >= end) ||
 	    (end > CSR1212_ALL_SPACE_END)) {
 		HPSB_ERR("%s called with invalid addresses "
-			 "(start = %012Lx  end = %012Lx)", __FUNCTION__,
+			 "(start = %012Lx  end = %012Lx)", __func__,
 			 (unsigned long long)start,(unsigned long long)end);
 		return retval;
 	}
@@ -422,7 +422,7 @@ int hpsb_register_addrspace(struct hpsb_highlevel *hl, struct hpsb_host *host,
 
 	if (((start|end) & 3) || (start >= end) ||
 	    (end > CSR1212_ALL_SPACE_END)) {
-		HPSB_ERR("%s called with invalid addresses", __FUNCTION__);
+		HPSB_ERR("%s called with invalid addresses", __func__);
 		return 0;
 	}
 
diff --git a/drivers/ieee1394/ieee1394_core.c b/drivers/ieee1394/ieee1394_core.c
index 36c747b..942bf1f 100644
--- a/drivers/ieee1394/ieee1394_core.c
+++ b/drivers/ieee1394/ieee1394_core.c
@@ -242,7 +242,7 @@ int hpsb_bus_reset(struct hpsb_host *host)
 {
 	if (host->in_bus_reset) {
 		HPSB_NOTICE("%s called while bus reset already in progress",
-			    __FUNCTION__);
+			    __func__);
 		return 1;
 	}
 
diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
index 969de2a..b14e6ea 100644
--- a/drivers/ieee1394/ohci1394.c
+++ b/drivers/ieee1394/ohci1394.c
@@ -708,7 +708,7 @@ static void insert_packet(struct ti_ohci *ohci,
                                 /* FIXME: do something about it */
                                 PRINT(KERN_ERR,
                                       "%s: packet data addr: %p size %Zd bytes "
-                                      "cross page boundary", __FUNCTION__,
+				      "cross page boundary", __func__,
                                       packet->data, packet->data_size);
                         }
 #endif
diff --git a/drivers/ieee1394/pcilynx.c b/drivers/ieee1394/pcilynx.c
index 8af01ab..eb065a4 100644
--- a/drivers/ieee1394/pcilynx.c
+++ b/drivers/ieee1394/pcilynx.c
@@ -226,7 +226,7 @@ static int get_phy_reg(struct ti_lynx *lynx, int addr)
         if (addr > 15) {
                 PRINT(KERN_ERR, lynx->id,
                       "%s: PHY register address %d out of range",
-		      __FUNCTION__, addr);
+		      __func__, addr);
                 return -1;
         }
 
@@ -238,7 +238,7 @@ static int get_phy_reg(struct ti_lynx *lynx, int addr)
 
                 if (i > 10000) {
                         PRINT(KERN_ERR, lynx->id, "%s: runaway loop, aborting",
-			      __FUNCTION__);
+			      __func__);
                         retval = -1;
                         break;
                 }
@@ -261,13 +261,13 @@ static int set_phy_reg(struct ti_lynx *lynx, int addr, int val)
 
         if (addr > 15) {
                 PRINT(KERN_ERR, lynx->id,
-                      "%s: PHY register address %d out of range", __FUNCTION__, addr);
+		      "%s: PHY register address %d out of range", __func__, addr);
                 return -1;
         }
 
         if (val > 0xff) {
                 PRINT(KERN_ERR, lynx->id,
-                      "%s: PHY register value %d out of range", __FUNCTION__, val);
+		      "%s: PHY register value %d out of range", __func__, val);
                 return -1;
         }
 
@@ -287,7 +287,7 @@ static int sel_phy_reg_page(struct ti_lynx *lynx, int page)
 
         if (page > 7) {
                 PRINT(KERN_ERR, lynx->id,
-                      "%s: PHY page %d out of range", __FUNCTION__, page);
+		      "%s: PHY page %d out of range", __func__, page);
                 return -1;
         }
 
@@ -309,7 +309,7 @@ static int sel_phy_reg_port(struct ti_lynx *lynx, int port)
 
         if (port > 15) {
                 PRINT(KERN_ERR, lynx->id,
-                      "%s: PHY port %d out of range", __FUNCTION__, port);
+		      "%s: PHY port %d out of range", __func__, port);
                 return -1;
         }
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 9e2b196..3d2e17d 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -610,7 +610,7 @@ static struct sbp2_command_info *sbp2util_allocate_command_orb(
 		cmd->Current_SCpnt = Current_SCpnt;
 		list_add_tail(&cmd->list, &lu->cmd_orb_inuse);
 	} else
-		SBP2_ERR("%s: no orbs available", __FUNCTION__);
+		SBP2_ERR("%s: no orbs available", __func__);
 	spin_unlock_irqrestore(&lu->cmd_orb_lock, flags);
 	return cmd;
 }
@@ -1289,7 +1289,7 @@ static int sbp2_set_busy_timeout(struct sbp2_lu *lu)
 
 	data = cpu_to_be32(SBP2_BUSY_TIMEOUT_VALUE);
 	if (hpsb_node_write(lu->ne, SBP2_BUSY_TIMEOUT_ADDRESS, &data, 4))
-		SBP2_ERR("%s error", __FUNCTION__);
+		SBP2_ERR("%s error", __func__);
 	return 0;
 }
 
-- 
1.5.4.GIT


