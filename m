Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbZBFIBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbZBFIBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbZBFIAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:00:42 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:27289 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757005AbZBFIAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:00:41 -0500
X-YMail-OSG: Ajg6rtEVM1kgPZUZVMPeGv49BAXikWlea01rEsiookrJPJflrSd50DS8NTpZjp4UO_Qr_RpMQJJDZhgnTQIxwMXza0NCRxDXemzUsxTrCyZ6ymNfcpzrmFJ8IeAFmkWLIR27q7k81yQcBGt4v9o9bzgeEyASLpHS3xkcKnjKS7YlBCMfWfGB8br65EZjuSaAVctFJV_ftK7pR9BigAO.SrIalgVnHwRExXT_SXM5aOX1Pyc2q_k-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 3/6] [Target_Core_Mod]: Update FILEIO and RAMDISK subsystem
	plugins to SPC-3 revision identifer
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
       "Ross S. W. Walker" <rswwalker@gmail.com>,
       Arne Redlich <agr@powerkom-dd.de>, Rafiu Fakunle <rafiu@openfiler.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 23:59:34 -0800
Message-Id: <1233907174.12375.361.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 848969be2f3ea81949fbb2ff33774b1b7f9db981 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 5 Feb 2009 23:15:52 -0800
Subject: [PATCH 3/6] [Target_Core_Mod]: Update FILEIO and RAMDISK subsystem plugins to SPC-3 revision identifer

This patch enables ILEIO and RAMDISK subsystem plugins to use the generic
PERSISTENT_RESERVATION and ALUA logic in Target_Core_Mod/ConfigFS.

At a later date a given $STORAGE_OBJECT will be able to be changed back to
emulated SPC-2 operation via configfs in /sys/kernel/config/target/core/$HBA/$DEV/attrib/
for legacy SPC-2 operation.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c |    2 +-
 drivers/lio-core/target_core_rd.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index 156090a..12faa15 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -1176,7 +1176,7 @@ extern u32 fd_get_blocksize (se_device_t *dev)
  */
 extern u32 fd_get_device_rev (se_device_t *dev)
 {
-	return(SCSI_2); 
+	return(SCSI_SPC_2); // Returns SPC-3 in Initiator Data
 }
 
 /*	fd_get_device_type(): (Part of se_subsystem_api_t template)
diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index d6e4596..1c263cc 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -1346,7 +1346,7 @@ extern u32 rd_get_blocksize (se_device_t *dev)
 
 extern u32 rd_get_device_rev (se_device_t *dev)
 {
-	return(SCSI_2);
+	return(SCSI_SPC_2); // Returns SPC-3 in Initiator Data
 }
 
 extern u32 rd_get_device_type (se_device_t *dev)
-- 
1.5.4.1



