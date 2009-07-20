Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbZGTPsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbZGTPsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZGTPsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:48:20 -0400
Received: from compulab.site5.com ([67.18.134.219]:60199 "EHLO compulab.co.il"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbZGTPsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:48:20 -0400
Message-ID: <4A6491C1.5060909@compulab.co.il>
Date: Mon, 20 Jul 2009 18:48:17 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.21 (X11/20090712)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Denis Turischev <denis@compulab.co.il>,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] Add reboot fixup for SBC-fitPC2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Denis Turischev <denis@compulab.co.il>

This patch adds reboot fixup for CompuLab SBC-fitPC2 board.

Singned-off-by: Denis Turischev <denis@compulab.co.il>
Signedd-off-by: Mike Rapoport <mike@compulab.co.il

diff -Nru linux-2.6.31-rc3.orig/arch/x86/kernel/reboot.c
linux-2.6.31-rc3/arch/x86/kernel/reboot.c
--- linux-2.6.31-rc3.orig/arch/x86/kernel/reboot.c	2009-07-14 04:18:52.000000000
+0300
+++ linux-2.6.31-rc3/arch/x86/kernel/reboot.c	2009-07-16 14:39:48.000000000 +0300
@@ -249,6 +249,15 @@
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
 		},
 	},
+	{	/* Handle problems with rebooting on
+				CompuLab SBC-FITPC2 board */
+		.callback = set_bios_reboot,
+		.ident = "CompuLab SBC-FITPC2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
+		},
+	},
 	{ }
 };


-- 
Sincerely yours,
Mike.

