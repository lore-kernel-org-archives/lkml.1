Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZAVIXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZAVIXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZAVIX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:23:27 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:26260 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750981AbZAVIX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:23:26 -0500
X-YMail-OSG: plG0IeQVM1ljeBnMFPQi.P748vh2rmt8BvWCLUJ2ivFCr8SZ7g9lxUIgyToTVsIilhodpVLAZciD_wh.iKsaSvnB0Ucduhybdd6tEA3TlonIk0w2z5B0c_jt0u3Tonbe_qjF40wm3YEJFYa61zM3dPXZGrQkh09Z1A9LL9RFnJRc4LdIg3.CZe2_FOY4snrb1.YfBLsiqMU_Byz_qc0EBm9rQOgWqDEimWZ7OxMJ0w2UDUmfJ38-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 1/4] [Linux/SCSI] Add support for SPC-4 CDBs referenced in
	Persisent Reservations Allowed/Confict Table
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <willy@debian.org>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 00:23:02 -0800
Message-Id: <1232612582.1274.529.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c177bb7ba55227d809d85aca3a9d4281e554f718 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Wed, 21 Jan 2009 22:13:00 -0800
Subject: [PATCH 1/4] [Linux/SCSI] Add support for SPC-4 CDBs referenced in Persisent Reservations Allowed/Confict Table

This path adds support for a handful of SPC-4 CDBs, and fills out the MI_* and MO_* prefixed
service action codes for MAINTENANCE_IN and MAINTENANCE_OUT operations.

This information is from spc4r17 and Table D.4 for MI_ and MO_ prefixed defs.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/scsi/scsi.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index a109165..93af6ce 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -104,30 +104,52 @@
 #define PERSISTENT_RESERVE_IN 0x5e
 #define PERSISTENT_RESERVE_OUT 0x5f
 #define VARIABLE_LENGTH_CMD   0x7f
+#define RECEIVE_CREDENTIAL    0x7f // spc4r17 section 6.9 Table 204
 #define REPORT_LUNS           0xa0
+#define SECURITY_PROTOCOL_IN  0xa2
 #define MAINTENANCE_IN        0xa3
 #define MAINTENANCE_OUT       0xa4
 #define MOVE_MEDIUM           0xa5
 #define EXCHANGE_MEDIUM       0xa6
 #define READ_12               0xa8
 #define WRITE_12              0xaa
+#define READ_MEDIA_SERIAL_NUMBER 0xab
 #define WRITE_VERIFY_12       0xae
 #define SEARCH_HIGH_12        0xb0
 #define SEARCH_EQUAL_12       0xb1
 #define SEARCH_LOW_12         0xb2
+#define SECURITY_PROTOCOL_OUT 0xb5
 #define READ_ELEMENT_STATUS   0xb8
 #define SEND_VOLUME_TAG       0xb6
 #define WRITE_LONG_2          0xea
+#define EXTENDED_COPY         0x83
+#define RECEIVE_COPY_RESULTS  0x84
+#define ACCESS_CONTROL_IN     0x86
+#define ACCESS_CONTROL_OUT    0x87
 #define READ_16               0x88
 #define WRITE_16              0x8a
+#define READ_ATTRIBUTE        0x8c
+#define WRITE_ATTRIBUTE	      0x8d
 #define VERIFY_16	      0x8f
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
 /* values for maintenance in */
+#define MI_REPORT_IDENTIFYING_INFORMATION 0x05
 #define MI_REPORT_TARGET_PGS  0x0a
+#define MI_REPORT_ALIASES     0x0b
+#define MI_REPORT_SUPPORTED_OPERATION_CODES 0x0c
+#define MI_REPORT_SUPPORTED_TASK_MANAGEMENT_FUNCTIONS 0x0d
+#define MI_REPORT_PRIORITY   0x0e
+#define MI_REPORT_TIMESTAMP  0x0f
+#define MI_MANAGEMENT_PROTOCOL_IN 0x10
 /* values for maintenance out */
+#define MO_SET_IDENTIFYING_INFORMATION 0x06
 #define MO_SET_TARGET_PGS     0x0a
+#define MO_CHANGE_ALIASES     0x0b
+#define MO_SET_PRIORITY       0x0e
+#define MO_SET_TIMESTAMP      0x0f
+#define MO_MANAGEMENT_PROTOCOL_OUT 0x10
 
 /* Values for T10/04-262r7 */
 #define	ATA_16		      0x85	/* 16-byte pass-thru */
-- 
1.5.4.1



