Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbXEVFBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbXEVFBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 01:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbXEVFBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 01:01:37 -0400
Received: from fed1rmmtao103.cox.net ([68.230.241.43]:65492 "EHLO
	fed1rmmtao103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXEVFBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 01:01:37 -0400
From: Junio C Hamano <junkio@cox.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org
Subject: [PATCH] Match DMA blacklist entries between ide-dma.c and libata-core.c
References: <20070521145042.GA6957@redhat.com>
	<20070521171551.0f81a0be@the-village.bc.nu>
cc: Dave Jones <davej@redhat.com>
Date: Mon, 21 May 2007 22:01:35 -0700
In-Reply-To: <20070521171551.0f81a0be@the-village.bc.nu> (Alan Cox's message
	of "Mon, 21 May 2007 17:15:51 +0100")
Message-ID: <7v3b1pbgeo.fsf_-_@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few entries in ata_device_blacklist[] in libata-core.c
marked with HORKAGE_NODMA but are missing from drive_blacklist[]
in ide-dma.c.  This patch makes the lists in sync.

Also remove a duplicated entry for "SanDisk SDP3B-64".

Signed-off-by: Junio C Hamano <junkio@cox.net>
---

 * Recently Alan Cox responded that libata blacklist needs to be
   kept in sync when Dave Jones added STT20000A to DMA blacklist
   in ide-dma.c
---
 drivers/ide/ide-dma.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-dma.c b/drivers/ide/ide-dma.c
index b77b7d1..ead141e 100644
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -119,15 +119,17 @@ static const struct drive_list_entry drive_blacklist [] = {
 	{ "HITACHI CDR-8335"	,	"ALL"		},
 	{ "HITACHI CDR-8435"	,	"ALL"		},
 	{ "Toshiba CD-ROM XM-6202B"	,	"ALL"		},
+	{ "TOSHIBA CD-ROM XM-1702BC",	"ALL"		},
 	{ "CD-532E-A"		,	"ALL"		},
 	{ "E-IDE CD-ROM CR-840",	"ALL"		},
 	{ "CD-ROM Drive/F5A",	"ALL"		},
 	{ "WPI CDD-820",		"ALL"		},
 	{ "SAMSUNG CD-ROM SC-148C",	"ALL"		},
 	{ "SAMSUNG CD-ROM SC",	"ALL"		},
-	{ "SanDisk SDP3B-64"	,	"ALL"		},
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",	"ALL"		},
 	{ "_NEC DV5800A",               "ALL"           },  
+	{ "SAMSUNG CD-ROM SN-124",	"N001" },
+	{ "Seagate STT20000A",		"ALL" },
 	{ NULL			,	NULL		}
 
 };
-- 
1.5.2.24.g93d4


