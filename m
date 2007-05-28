Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbXE1XLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbXE1XLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 19:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXE1XK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 19:10:59 -0400
Received: from fed1rmmtao106.cox.net ([68.230.241.40]:37698 "EHLO
	fed1rmmtao106.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXE1XK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 19:10:58 -0400
From: Junio C Hamano <junkio@cox.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 1/3] ide_in_drive_list(): accept NULL as the wildcard for firmware revision.
References: <20070521145042.GA6957@redhat.com>
	<7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
	<7vps4ta1iy.fsf_-_@assigned-by-dhcp.cox.net>
	<200705282141.42507.bzolnier@gmail.com>
Date: Mon, 28 May 2007 16:10:43 -0700
Message-ID: <7v4plw8ryk.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier, the matching of (model,rev) in ide-dma black/white list
handling was to consider "ALL" in the table to match any
revision.  This makes NULL to be also an accepted wildcard, and
changes the entries of tables in ide-dma.c to use NULL.

The code still accepts "ALL" as the wildcard, in order to keep
any out-of-tree ide driver that feeds its own table that uses
"ALL" as the wildcard to ide_in_drive_list() function from
breaking.

Signed-off-by: Junio C Hamano <junkio@cox.net>
---
 * This is a respin of earlier "3/3 Make ide dma blacklist handling a bit saner."

 drivers/ide/ide-dma.c |   67 +++++++++++++++++++++++++------------------------
 1 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index ead141e..230ea12 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -91,45 +91,45 @@
 
 static const struct drive_list_entry drive_whitelist [] = {
 
-	{ "Micropolis 2112A"	,       "ALL"		},
-	{ "CONNER CTMA 4000"	,       "ALL"		},
-	{ "CONNER CTT8000-A"	,       "ALL"		},
-	{ "ST34342A"		,	"ALL"		},
+	{ "Micropolis 2112A"	,       NULL		},
+	{ "CONNER CTMA 4000"	,       NULL		},
+	{ "CONNER CTT8000-A"	,       NULL		},
+	{ "ST34342A"		,	NULL		},
 	{ NULL			,	NULL		}
 };
 
 static const struct drive_list_entry drive_blacklist [] = {
 
-	{ "WDC AC11000H"	,	"ALL"		},
-	{ "WDC AC22100H"	,	"ALL"		},
-	{ "WDC AC32500H"	,	"ALL"		},
-	{ "WDC AC33100H"	,	"ALL"		},
-	{ "WDC AC31600H"	,	"ALL"		},
+	{ "WDC AC11000H"	,	NULL 		},
+	{ "WDC AC22100H"	,	NULL 		},
+	{ "WDC AC32500H"	,	NULL 		},
+	{ "WDC AC33100H"	,	NULL 		},
+	{ "WDC AC31600H"	,	NULL 		},
 	{ "WDC AC32100H"	,	"24.09P07"	},
 	{ "WDC AC23200L"	,	"21.10N21"	},
-	{ "Compaq CRD-8241B"	,	"ALL"		},
-	{ "CRD-8400B"		,	"ALL"		},
-	{ "CRD-8480B",			"ALL"		},
-	{ "CRD-8482B",			"ALL"		},
- 	{ "CRD-84"		,	"ALL"		},
-	{ "SanDisk SDP3B"	,	"ALL"		},
-	{ "SanDisk SDP3B-64"	,	"ALL"		},
-	{ "SANYO CD-ROM CRD"	,	"ALL"		},
-	{ "HITACHI CDR-8"	,	"ALL"		},
-	{ "HITACHI CDR-8335"	,	"ALL"		},
-	{ "HITACHI CDR-8435"	,	"ALL"		},
-	{ "Toshiba CD-ROM XM-6202B"	,	"ALL"		},
-	{ "TOSHIBA CD-ROM XM-1702BC",	"ALL"		},
-	{ "CD-532E-A"		,	"ALL"		},
-	{ "E-IDE CD-ROM CR-840",	"ALL"		},
-	{ "CD-ROM Drive/F5A",	"ALL"		},
-	{ "WPI CDD-820",		"ALL"		},
-	{ "SAMSUNG CD-ROM SC-148C",	"ALL"		},
-	{ "SAMSUNG CD-ROM SC",	"ALL"		},
-	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	"ALL"		},
-	{ "_NEC DV5800A",               "ALL"           },  
+	{ "Compaq CRD-8241B"	,	NULL 		},
+	{ "CRD-8400B"		,	NULL 		},
+	{ "CRD-8480B",			NULL 		},
+	{ "CRD-8482B",			NULL 		},
+	{ "CRD-84"		,	NULL 		},
+	{ "SanDisk SDP3B"	,	NULL 		},
+	{ "SanDisk SDP3B-64"	,	NULL 		},
+	{ "SANYO CD-ROM CRD"	,	NULL 		},
+	{ "HITACHI CDR-8"	,	NULL 		},
+	{ "HITACHI CDR-8335"	,	NULL 		},
+	{ "HITACHI CDR-8435"	,	NULL 		},
+	{ "Toshiba CD-ROM XM-6202B"	,	NULL 		},
+	{ "TOSHIBA CD-ROM XM-1702BC",	NULL 		},
+	{ "CD-532E-A"		,	NULL 		},
+	{ "E-IDE CD-ROM CR-840",	NULL 		},
+	{ "CD-ROM Drive/F5A",	NULL 		},
+	{ "WPI CDD-820",		NULL 		},
+	{ "SAMSUNG CD-ROM SC-148C",	NULL 		},
+	{ "SAMSUNG CD-ROM SC",	NULL 		},
+	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	NULL 		},
+	{ "_NEC DV5800A",               NULL            },
 	{ "SAMSUNG CD-ROM SN-124",	"N001" },
-	{ "Seagate STT20000A",		"ALL" },
+	{ "Seagate STT20000A",		NULL  },
 	{ NULL			,	NULL		}
 
 };
@@ -147,8 +147,9 @@ int ide_in_drive_list(struct hd_driveid *id, const struct drive_list_entry *driv
 {
 	for ( ; drive_table->id_model ; drive_table++)
 		if ((!strcmp(drive_table->id_model, id->model)) &&
-		    ((strstr(id->fw_rev, drive_table->id_firmware)) ||
-		     (!strcmp(drive_table->id_firmware, "ALL"))))
+		    (!drive_table->id_firmware ||
+		     !strcmp(drive_table->id_firmware, "ALL") || /* to be removed later */
+		     strstr(id->fw_rev, drive_table->id_firmware)))
 			return 1;
 	return 0;
 }
-- 
1.5.2.86.g99b5-dirty


