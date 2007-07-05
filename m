Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbXGEP22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbXGEP22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 11:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbXGEP2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 11:28:21 -0400
Received: from mail.macqel.be ([194.78.208.39]:7056 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbXGEP2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 11:28:20 -0400
X-Greylist: delayed 1347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2007 11:28:20 EDT
Date: Thu, 5 Jul 2007 17:05:47 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] mtd : add FUJITSU MBM29F800BA and ST M29F800AB descriptions
Message-ID: <20070705150547.GA10281@muff.macqel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Add descriptions for Fujitsu MBM29F800BA and ST M29F800AB flash chips.
Those chips are compatible (except for the ids) with the AMD AM29F800BB.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r d857b8fa1d27 drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c	Sun Jun 24 12:08:53 2007 -0700
+++ b/drivers/mtd/chips/jedec_probe.c	Thu Jul  5 16:46:25 2007 +0200
@@ -70,6 +70,7 @@
 
 /* Fujitsu */
 #define MBM29F040C	0x00A4
+#define MBM29F800BA	0x2258
 #define MBM29LV650UE	0x22D7
 #define MBM29LV320TE	0x22F6
 #define MBM29LV320BE	0x22F9
@@ -129,6 +130,7 @@
 #define LH28F640BF	0x00b0
 
 /* ST - www.st.com */
+#define M29F800AB	0x0058
 #define M29W800DT	0x00D7
 #define M29W800DB	0x005B
 #define M29W160DT	0x22C4
@@ -646,6 +648,23 @@ static const struct amd_flash_info jedec
 		}
 	}, {
 		.mfr_id		= MANUFACTURER_FUJITSU,
+		.dev_id		= MBM29F800BA,
+		.name		= "Fujitsu MBM29F800BA",
+		.uaddr		= {
+			[0] = MTD_UADDR_0x0AAA_0x0555,  /* x8 */
+			[1] = MTD_UADDR_0x0555_0x02AA,  /* x16 */
+		},
+		.DevSize	= SIZE_1MiB,
+		.CmdSet		= P_ID_AMD_STD,
+		.NumEraseRegions= 4,
+		.regions	= {
+			ERASEINFO(0x04000,1),
+			ERASEINFO(0x02000,2),
+			ERASEINFO(0x08000,1),
+			ERASEINFO(0x10000,15),
+		}
+	}, {
+		.mfr_id		= MANUFACTURER_FUJITSU,
 		.dev_id		= MBM29LV650UE,
 		.name		= "Fujitsu MBM29LV650UE",
 		.uaddr		= {
@@ -1510,6 +1529,23 @@ static const struct amd_flash_info jedec
                        ERASEINFO(0x1000,256)
                }
 
+	}, {
+		.mfr_id		= MANUFACTURER_ST,
+		.dev_id		= M29F800AB,
+		.name		= "ST M29F800AB",
+		.uaddr		= {
+			[0] = MTD_UADDR_0x0AAA_0x0555,  /* x8 */
+			[1] = MTD_UADDR_0x0555_0x02AA,  /* x16 */
+		},
+		.DevSize	= SIZE_1MiB,
+		.CmdSet		= P_ID_AMD_STD,
+		.NumEraseRegions= 4,
+		.regions	= {
+			ERASEINFO(0x04000,1),
+			ERASEINFO(0x02000,2),
+			ERASEINFO(0x08000,1),
+			ERASEINFO(0x10000,15),
+		}
        }, {
 		.mfr_id		= MANUFACTURER_ST,	/* FIXME - CFI device? */
 		.dev_id		= M29W800DT,
