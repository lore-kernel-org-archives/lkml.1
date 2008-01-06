Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYAFTDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYAFTDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 14:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYAFTDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 14:03:42 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39830 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYAFTDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 14:03:41 -0500
Date: Sun, 6 Jan 2008 20:03:35 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: megaraidlinux@lsi.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20080106190335.28212.90140.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH][SCSI] megaraid: Convert from "scsi.h" to <scsi.h> (and friends)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert glue-include "scsi.h" to <scsi.h> (and friends).

(binary sizes)
allyesconfig: before: 260132
              after:  260048

allmodconfig: before: 261740
              after:  261656

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Do not have the hardware, but since it compiles I hope it is alright.


diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 66c6520..9f1e2c5 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -48,8 +48,9 @@
 #include <linux/dma-mapping.h>
 #include <scsi/scsicam.h>
 
-#include "scsi.h"
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
+#include <scsi.h>
 
 #include "megaraid.h"
 
@@ -1955,7 +1956,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	     cmd->device->id, cmd->device->lun);
 
 	if(list_empty(&adapter->pending_list))
-		return FALSE;
+		return false;
 
 	list_for_each_safe(pos, next, &adapter->pending_list) {
 
@@ -1978,7 +1979,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					cmd->serial_number, scb->idx);
 
-				return FALSE;
+				return false;
 			}
 			else {
 
@@ -2003,12 +2004,12 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 				list_add_tail(SCSI_LIST(cmd),
 						&adapter->completed_list);
 
-				return TRUE;
+				return true;
 			}
 		}
 	}
 
-	return FALSE;
+	return false;
 }
 
 static inline int
