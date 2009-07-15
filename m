Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbZGOMQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbZGOMQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 08:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbZGOMQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 08:16:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:54955 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754148AbZGOMQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 08:16:22 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1/jkjI4g6jjCvaF0nFPruNM5lXTc5ASYM0fw+Q+HP
	O6NXv/D1reozFJ
From: Alexey Fisher <bug-track@fisher-privat.net>
To: ykzhao <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, alan@lxorguk.ukuu.org.uk
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH] Lowmemory corruption. Quirk for Intel DG45ID board.
Date: Wed, 15 Jul 2009 14:16:09 +0200
Message-Id: <1247660169-4503-1-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.6.3.3
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMI BIOS with lowmemory corruption was found on Intel DG45ID board
(Bug 13710). It hase differnt DMI_BIOS_VENDOR = "Intel Corp.", for
now we will match only DMI_BOARD_NAME.

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
---
 arch/x86/kernel/setup.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index de2cab1..4bacb68 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -672,6 +672,19 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
 		},
 	},
+	{
+	/*
+	 * AMI BIOS with lowmemory corruption was found on Intel DG45ID board.
+	 * It hase differnt DMI_BIOS_VENDOR = "Intel Corp.", for now we will
+	 * match only DMI_BOARD_NAME and see if there is more bad products
+	 * with this vendor.
+	 */
+		.callback = dmi_low_memory_corruption,
+		.ident = "AMI BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "DG45ID"),
+		},
+	},
 #endif
 	{}
 };
-- 
1.6.3.3

