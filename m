Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZA0WJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZA0WJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZA0WJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:09:18 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:20061 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752639AbZA0WJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:09:17 -0500
X-YMail-OSG: 2FHGtbIVM1kNbuDX5lH58N1sYbWaxEhRDmEj5bGStPU1Z6YhXnCrhBdC4JuZdubUYk3GY_9qsRl7URqn0XAWcOTDcfD1uRXME6OtBzz.U3WQzKGWNhcW5IAC63pRvYpm.cuh8uD3nnzb4v1GpEFmjCCpdBdp3xcmEr9NKzvYW964zHGr81u4CFxdb_FspFiyc11x3ezIAVS_Old8LJX10fkhgAP6f4toUDfQcyiyPOyI1eDB8Lk-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 3/4] [Target_Core_Mod]: Remove LOAD_UNLOAD_MEDIUM usage
	from IBLOCK/FILEIO/RAMDISK
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 14:08:08 -0800
Message-Id: <1233094088.6442.105.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 26063b8d3f7a72a7529a0bef643ca2770023d487 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 27 Jan 2009 13:54:43 -0800
Subject: [PATCH 3/4] [Target_Core_Mod]: Remove LOAD_UNLOAD_MEDIUM usage from IBLOCK/FILEIO/RAMDISK

This patch removes the usage of LOAD_UNLOAD_MEDIUM (which has been droped in
favor of using include/linux/cdrom.h GP_* opcode defines) in the various virtual
(eg: above the SCSI layer) Target_Core_Mod subsystem plugin.  This opcode is only
defined for TYPE_ROM, and these subsystem plugins emulate TYPE_DISK.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c   |    1 -
 drivers/lio-core/target_core_iblock.c |    1 -
 drivers/lio-core/target_core_rd.c     |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 5cf95f2..156090a 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -490,7 +490,6 @@ static int fd_emulate_scsi_cdb (se_task_t *task)
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
-	case LOAD_UNLOAD_MEDIUM:
 	case REZERO_UNIT:
 	case SEEK_10:
 	case SPACE:
diff --git a/drivers/lio-core/target_core_iblock.c b/drivers/lio-core/target_core_iblock.c
index 29dc87b..a94526c 100644
--- a/drivers/lio-core/target_core_iblock.c
+++ b/drivers/lio-core/target_core_iblock.c
@@ -420,7 +420,6 @@ static int iblock_emulate_scsi_cdb (se_task_t *task)
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
-	case LOAD_UNLOAD_MEDIUM:
 	case REZERO_UNIT:
 	case SEEK_10:
 	case SPACE:
diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index e991bb6..d6e4596 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -495,7 +495,6 @@ static int rd_emulate_scsi_cdb (se_task_t *task)
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 	case ERASE:
-	case LOAD_UNLOAD_MEDIUM:
 	case REZERO_UNIT:
 	case SEEK_10:
 	case SPACE:
-- 
1.5.4.1



