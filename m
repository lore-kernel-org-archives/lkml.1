Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbYKNG4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbYKNG4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 01:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYKNG4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 01:56:00 -0500
Received: from adelie.canonical.com ([91.189.90.139]:55174 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYKNGz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 01:55:59 -0500
Date: Fri, 14 Nov 2008 00:55:51 -0600 (CST)
From: Steve Conklin <sconklin@canonical.com>
X-X-Sender: sconklin@T41
To: linux-kernel@vger.kernel.org
cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] Quirk for reboot stalls on a Dell Optiplex 330
Message-ID: <alpine.DEB.2.00.0811140051000.13353@T41>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6269c416487b41576107ef6f535639d3177daa43 Mon Sep 17 00:00:00 2001
From: Leann Ogasawara <leann.ogasawara@canonical.com>
Date: Wed, 12 Nov 2008 17:01:54 -0600
Subject: [PATCH] Quirk for reboot stalls on a Dell Optiplex 330

Dell Optiplex 330 appears to hang on reboot. This is resolved by adding
a quirk to set bios reboot.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Steve Conklin <steve.conklin@canonical.com>
---
 arch/x86/kernel/reboot.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 904a8ea..0d897f8 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -169,6 +169,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
 		},
 	},
+	{   /* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 330",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 330"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
-- 
1.5.6.3

