Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZLSX0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZLSX0c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 18:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753944AbZLSX0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 18:26:30 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:39909 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZLSX03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 18:26:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bDrfEDm+c+oEK8SPNwW1usn32EOG45HpCD5Cay4sfVkaXeJvUP+/yPf7+969SHLcsx
         9QCPq4Fb+0pWHd/nwssjLc/s8xR27UrMt4NxA7OzGUMY+LPcIVElhOJN4Kk8g2pVW33l
         Mq8p5oyHgF4RItCI/gqaHrCYMsTdpYg3ril/M=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: James.Bottomley@suse.de, robert.w.love@intel.com, vasu.dev@intel.com,
       jeykholt@cisco.com, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi/libfc: Clean up hard coded array size calculation.
Date: Sat, 19 Dec 2009 18:26:16 -0500
Message-Id: <1261265176-5241-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.rc0.61.g41d5b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ARRAY_SIZE macro from kernel.h api instead.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/scsi/libfc/fc_exch.c  |    9 ++++-----
 drivers/scsi/libfc/fc_lport.c |    3 ++-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index c1c1574..b65652a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -23,9 +23,10 @@
  * Fibre Channel exchange and sequence handling.
  */
 
-#include <linux/timer.h>
-#include <linux/gfp.h>
 #include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/timer.h>
 
 #include <scsi/fc/fc_fc2.h>
 
@@ -194,8 +195,6 @@ static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp);
  */
 static char *fc_exch_rctl_names[] = FC_RCTL_NAMES_INIT;
 
-#define FC_TABLE_SIZE(x)   (sizeof(x) / sizeof(x[0]))
-
 static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
 					      unsigned int max_index)
 {
@@ -211,7 +210,7 @@ static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
 static const char *fc_exch_rctl_name(unsigned int op)
 {
 	return fc_exch_name_lookup(op, fc_exch_rctl_names,
-				   FC_TABLE_SIZE(fc_exch_rctl_names));
+				   ARRAY_SIZE(fc_exch_rctl_names));
 }
 
 /*
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index bd2f771..98b4eaf 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -87,6 +87,7 @@
  * (i.e. _enter_* function).
  */
 
+#include <linux/kernel.h>
 #include <linux/timer.h>
 #include <asm/unaligned.h>
 
@@ -1137,7 +1138,7 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 	fc_lport_state_enter(lport, LPORT_ST_RFT_ID);
 
 	lps = &lport->fcts;
-	i = sizeof(lps->ff_type_map) / sizeof(lps->ff_type_map[0]);
+	i = ARRAY_SIZE(lps->ff_type_map);
 	while (--i >= 0)
 		if (ntohl(lps->ff_type_map[i]) != 0)
 			break;
-- 
1.6.6.rc0.61.g41d5b

