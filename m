Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbZGOFzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbZGOFzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 01:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZGOFzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 01:55:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:55558 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751650AbZGOFzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 01:55:24 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19tXDIL5uttsA2TZmPGRVsc1y6y2up3ozSTAT9OI2
	ByviwzGqeQGnpi
From: Alexey Fisher <bug-track@fisher-privat.net>
To: ykzhao <yakui.zhao@intel.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: Alexey Fisher <bug-track@fisher-privat.net>
Subject: [PATCH] Solve the issue with memory corruption on Intel BIOS.
Date: Wed, 15 Jul 2009 07:55:14 +0200
Message-Id: <1247637314-5609-1-git-send-email-bug-track@fisher-privat.net>
X-Mailer: git-send-email 1.6.3.3
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Bug 13710 was reported "corrupted low memory after resume on Intel
DG45ID board". It use AMI BIOS with Intel vendor string. We need to add this
vendor to CONFIG_X86_RESERVE_LOW_64K workaround.

Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
---
 arch/x86/kernel/setup.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index de2cab1..89d00e2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -672,6 +672,13 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
 		},
 	},
+	 {
+		 .callback = dmi_low_memory_corruption,
+		 .ident = "Intel BIOS",
+		 .matches = {
+			 DMI_MATCH(DMI_BIOS_VENDOR, "Intel Corp."),
+		 },
+	 },
 #endif
 	{}
 };
-- 
1.6.3.3

