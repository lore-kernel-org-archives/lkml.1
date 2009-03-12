Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbZCLUsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbZCLUsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZCLUsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:48:12 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:60954 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZCLUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bepH8z++gdn5VH4nRpTGwUbj+LjMOO/lUaWUhDe03B1Z8kl1acuoTD6qlJNHcN19dD
         t3kuKHzqV3yadrGJDYJvszr+bsfGaw+x27LsN7qKREv9GNbbLeF0DbtDBvdes452HK/2
         2UCMunk6lj/xpatrIzO3QC2NYHmTsbgidoSqY=
From: Yegor Yefremov <yegorslists@googlemail.com>
To: linux-kernel@vger.kernel.org
Cc: Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] Add support for the SST 39VF3201 flash chip.
Date: Thu, 12 Mar 2009 21:48:01 +0100
Message-Id: <49b97507.190c660a.7b95.ffffccb8@mx.google.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

---
 drivers/mtd/chips/jedec_probe.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index 2f3f2f7..e824b9b 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -159,6 +159,7 @@
 #define SST39LF800	0x2781
 #define SST39LF160	0x2782
 #define SST39VF1601	0x234b
+#define SST39VF3201	0x235b
 #define SST39LF512	0x00D4
 #define SST39LF010	0x00D5
 #define SST39LF020	0x00D6
@@ -1490,6 +1491,21 @@ static const struct amd_flash_info jedec_table[] = {
 			ERASEINFO(0x1000,256)
 		}
 	}, {
+		.mfr_id		= MANUFACTURER_SST,     /* should be CFI */
+		.dev_id		= SST39VF3201,
+		.name		= "SST 39VF3201",
+		.devtypes	= CFI_DEVICETYPE_X16,
+		.uaddr		= MTD_UADDR_0xAAAA_0x5555,
+		.dev_size	= SIZE_4MiB,
+		.cmd_set	= P_ID_AMD_STD,
+		.nr_regions	= 4,
+		.regions	= {
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256),
+			ERASEINFO(0x1000,256)
+		}
+	}, {
 		.mfr_id		= MANUFACTURER_SST,
 		.dev_id		= SST36VF3203,
 		.name		= "SST 36VF3203",
-- 
1.5.2.4

