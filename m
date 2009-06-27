Return-Path: <linux-kernel-owner+w=401wt.eu-S1757145AbZF0RG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145AbZF0RG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 13:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755856AbZF0RGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 13:06:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:53419 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbZF0RGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 13:06:19 -0400
Subject: [PATCH] SCSI: userspace cannot use scsi_command_size_tbl,
 COMMAND_SIZE and scsi_device_type
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 22:35:59 +0530
Message-Id: <1246122359.32198.7.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


userspace cannot use scsi_command_size_tbl, COMMAND_SIZE
and scsi_device_type defined in kernel

fix the following 'make headers_check' warnings:

  usr/include/scsi/scsi.h:159: userspace cannot call function or variable defined in the kernel
  usr/include/scsi/scsi.h:285: userspace cannot call function or variable defined in the kernel

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/scsi/scsi.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 084478e..7ba5acf 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -156,9 +156,6 @@ scsi_varlen_cdb_length(const void *hdr)
 	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
 }
 
-extern const unsigned char scsi_command_size_tbl[8];
-#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
-
 static inline unsigned
 scsi_command_size(const unsigned char *cmnd)
 {
@@ -166,6 +163,13 @@ scsi_command_size(const unsigned char *cmnd)
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
 
+#ifdef __KERNEL__
+extern const unsigned char scsi_command_size_tbl[8];
+#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
+
+/* Returns a human-readable name for the device */
+extern const char * scsi_device_type(unsigned type);
+#endif
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
@@ -281,9 +285,6 @@ enum scsi_protocol {
 	SCSI_PROTOCOL_UNSPEC = 0xf, /* No specific protocol */
 };
 
-/* Returns a human-readable name for the device */
-extern const char * scsi_device_type(unsigned type);
-
 /*
  * standard mode-select header prepended to all mode-select commands
  */
-- 
1.6.0.6



