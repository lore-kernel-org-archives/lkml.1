Return-Path: <linux-kernel-owner+w=401wt.eu-S1762097AbXEVFGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762097AbXEVFGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 01:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXEVFGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 01:06:41 -0400
Received: from fed1rmmtao106.cox.net ([68.230.241.40]:34962 "EHLO
	fed1rmmtao106.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbXEVFGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 01:06:39 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 01:06:39 EDT
From: Junio C Hamano <junkio@cox.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: [PATCH 2/3] Unify dma blacklist in ide-dma.c and libata-core.c
References: <20070521145042.GA6957@redhat.com>
	<20070521171551.0f81a0be@the-village.bc.nu>
	<7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
Date: Mon, 21 May 2007 22:06:36 -0700
In-Reply-To: <7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net> (Junio C. Hamano's
	message of "Mon, 21 May 2007 22:01:35 -0700")
Message-ID: <7vveela1lv.fsf_-_@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a shared header file that defines the entries
for two dma blacklists in ide-dma.c and libata-core.c to make it
easier to keep them in sync.

Signed-off-by: Junio C Hamano <junkio@cox.net>
---

 * Removes more lines than it adds.  I am not proud of the
   DMA_BLACK_LIST macro in ide-dma.c which relies on the
   compiler doing a sane thing for compile time constant
   expression to initialize the list, but that hopefully can be
   fixed in the next patch.

 drivers/ata/libata-core.c   |   34 ++++------------------------------
 drivers/ide/dma-blacklist.h |   39 +++++++++++++++++++++++++++++++++++++++
 drivers/ide/ide-dma.c       |   33 +++------------------------------
 3 files changed, 46 insertions(+), 60 deletions(-)
 create mode 100644 drivers/ide/dma-blacklist.h

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a6de57e..93b7fa7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3739,36 +3739,10 @@ struct ata_blacklist_entry {
 
 static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	/* Devices with DMA related problems under Linux */
-	{ "WDC AC11000H",	NULL,		ATA_HORKAGE_NODMA },
-	{ "WDC AC22100H",	NULL,		ATA_HORKAGE_NODMA },
-	{ "WDC AC32500H",	NULL,		ATA_HORKAGE_NODMA },
-	{ "WDC AC33100H",	NULL,		ATA_HORKAGE_NODMA },
-	{ "WDC AC31600H",	NULL,		ATA_HORKAGE_NODMA },
-	{ "WDC AC32100H",	"24.09P07",	ATA_HORKAGE_NODMA },
-	{ "WDC AC23200L",	"21.10N21",	ATA_HORKAGE_NODMA },
-	{ "Compaq CRD-8241B", 	NULL,		ATA_HORKAGE_NODMA },
-	{ "CRD-8400B",		NULL, 		ATA_HORKAGE_NODMA },
-	{ "CRD-8480B",		NULL,		ATA_HORKAGE_NODMA },
-	{ "CRD-8482B",		NULL,		ATA_HORKAGE_NODMA },
-	{ "CRD-84",		NULL,		ATA_HORKAGE_NODMA },
-	{ "SanDisk SDP3B",	NULL,		ATA_HORKAGE_NODMA },
-	{ "SanDisk SDP3B-64",	NULL,		ATA_HORKAGE_NODMA },
-	{ "SANYO CD-ROM CRD",	NULL,		ATA_HORKAGE_NODMA },
-	{ "HITACHI CDR-8",	NULL,		ATA_HORKAGE_NODMA },
-	{ "HITACHI CDR-8335",	NULL,		ATA_HORKAGE_NODMA },
-	{ "HITACHI CDR-8435",	NULL,		ATA_HORKAGE_NODMA },
-	{ "Toshiba CD-ROM XM-6202B", NULL,	ATA_HORKAGE_NODMA },
-	{ "TOSHIBA CD-ROM XM-1702BC", NULL,	ATA_HORKAGE_NODMA },
-	{ "CD-532E-A", 		NULL,		ATA_HORKAGE_NODMA },
-	{ "E-IDE CD-ROM CR-840",NULL,		ATA_HORKAGE_NODMA },
-	{ "CD-ROM Drive/F5A",	NULL,		ATA_HORKAGE_NODMA },
-	{ "WPI CDD-820", 	NULL,		ATA_HORKAGE_NODMA },
-	{ "SAMSUNG CD-ROM SC-148C", NULL,	ATA_HORKAGE_NODMA },
-	{ "SAMSUNG CD-ROM SC",	NULL,		ATA_HORKAGE_NODMA },
-	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",NULL,ATA_HORKAGE_NODMA },
-	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
-	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
-	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
+
+#define DMA_BLACK_LIST(model,rev) { (model), (rev), ATA_HORKAGE_NODMA }
+#include "../ide/dma-blacklist.h"
+#undef DMA_BLACK_LIST
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 |
diff --git a/drivers/ide/dma-blacklist.h b/drivers/ide/dma-blacklist.h
new file mode 100644
index 0000000..19b4e0c
--- /dev/null
+++ b/drivers/ide/dma-blacklist.h
@@ -0,0 +1,39 @@
+/*
+ * Shared between ide-dma.c::drive_blacklist[] and
+ * ../ata/libata-core.c::ata_device_blacklist[].
+ *
+ * Each of the above users define DMA_BLACK_LIST() macro
+ * which expands these to structure of their liking.
+ */
+
+	DMA_BLACK_LIST("WDC AC11000H", NULL),
+	DMA_BLACK_LIST("WDC AC22100H", NULL),
+	DMA_BLACK_LIST("WDC AC32500H", NULL),
+	DMA_BLACK_LIST("WDC AC33100H", NULL),
+	DMA_BLACK_LIST("WDC AC31600H", NULL),
+	DMA_BLACK_LIST("WDC AC32100H", "24.09P07"),
+	DMA_BLACK_LIST("WDC AC23200L", "21.10N21"),
+	DMA_BLACK_LIST("Compaq CRD-8241B", NULL),
+	DMA_BLACK_LIST("CRD-8400B", NULL),
+	DMA_BLACK_LIST("CRD-8480B", NULL),
+	DMA_BLACK_LIST("CRD-8482B", NULL),
+	DMA_BLACK_LIST("CRD-84", NULL),
+	DMA_BLACK_LIST("SanDisk SDP3B", NULL),
+	DMA_BLACK_LIST("SanDisk SDP3B-64", NULL),
+	DMA_BLACK_LIST("SANYO CD-ROM CRD", NULL),
+	DMA_BLACK_LIST("HITACHI CDR-8", NULL),
+	DMA_BLACK_LIST("HITACHI CDR-8335", NULL),
+	DMA_BLACK_LIST("HITACHI CDR-8435", NULL),
+	DMA_BLACK_LIST("Toshiba CD-ROM XM-6202B", NULL),
+	DMA_BLACK_LIST("TOSHIBA CD-ROM XM-1702BC", NULL),
+	DMA_BLACK_LIST("CD-532E-A", NULL),
+	DMA_BLACK_LIST("E-IDE CD-ROM CR-840", NULL),
+	DMA_BLACK_LIST("CD-ROM Drive/F5A", NULL),
+	DMA_BLACK_LIST("WPI CDD-820", NULL),
+	DMA_BLACK_LIST("SAMSUNG CD-ROM SC-148C", NULL),
+	DMA_BLACK_LIST("SAMSUNG CD-ROM SC", NULL),
+	DMA_BLACK_LIST("ATAPI CD-ROM DRIVE 40X MAXIMUM", NULL),
+	DMA_BLACK_LIST("_NEC DV5800A", NULL),
+	DMA_BLACK_LIST("SAMSUNG CD-ROM SN-124", "N001"),
+	DMA_BLACK_LIST("Seagate STT20000A", NULL),
+
diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index ead141e..a6a2074 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -100,36 +100,9 @@ static const struct drive_list_entry drive_whitelist [] = {
 
 static const struct drive_list_entry drive_blacklist [] = {
 
-	{ "WDC AC11000H"	,	"ALL"		},
-	{ "WDC AC22100H"	,	"ALL"		},
-	{ "WDC AC32500H"	,	"ALL"		},
-	{ "WDC AC33100H"	,	"ALL"		},
-	{ "WDC AC31600H"	,	"ALL"		},
-	{ "WDC AC32100H"	,	"24.09P07"	},
-	{ "WDC AC23200L"	,	"21.10N21"	},
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
-	{ "SAMSUNG CD-ROM SN-124",	"N001" },
-	{ "Seagate STT20000A",		"ALL" },
+#define DMA_BLACK_LIST(model,rev) { (model), (rev==NULL ? "ALL" : (rev)) }
+#include "dma-blacklist.h"
+#undef DMA_BLACK_LIST
 	{ NULL			,	NULL		}
 
 };
-- 
1.5.2.24.g93d4


