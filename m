Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZJQA7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZJQA7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbZJQA7C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:59:02 -0400
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:48999 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750838AbZJQA7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:59:01 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] block/scsi_ioctl.c: quiet sparse noise
Date: Fri, 16 Oct 2009 20:59:04 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901E24571@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] block/scsi_ioctl.c: quiet sparse noise
Thread-Index: AcpOxQX9wa/ZzU1qTUuqhmX9c3bHeA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Oct 2009 00:59:04.0960 (UTC) FILETIME=[05FEF800:01CA4EC5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet sparse noise about symbol's not being declared.

Symbol blk_default_cmd_filter is only used locally and should be static.

The function blk_scsi_ioctl_init() is a fs_initcall and should also be
static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e5b1001..a8b5a10 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -35,7 +35,9 @@
 struct blk_cmd_filter {
 	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
 	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-} blk_default_cmd_filter;
+};
+
+static struct blk_cmd_filter blk_default_cmd_filter;
 
 /* Command group 3 is reserved and should never be used.  */
 const unsigned char scsi_command_size_tbl[8] =
@@ -675,7 +677,7 @@ int scsi_cmd_ioctl(struct request_queue *q, struct gendisk *bd_disk, fmode_t mod
 }
 EXPORT_SYMBOL(scsi_cmd_ioctl);
 
-int __init blk_scsi_ioctl_init(void)
+static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
 	return 0; 
