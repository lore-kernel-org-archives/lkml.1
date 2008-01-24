Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbYAZO7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbYAZO7p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 09:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYAZO7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 09:59:38 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1080 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750727AbYAZO7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 09:59:37 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 20/52] [microblaze] heartbeat file
Date: Thu, 24 Jan 2008 16:02:55 +0100
Message-Id: <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/heartbeat.c |   40 ++++++++++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/heartbeat.c

diff --git a/arch/microblaze/kernel/heartbeat.c b/arch/microblaze/kernel/heartbeat.c
new file mode 100644
index 0000000..e29aa1f
--- /dev/null
+++ b/arch/microblaze/kernel/heartbeat.c
@@ -0,0 +1,40 @@
+/*
+ * arch/microblaze/kernel/heartbeat.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/sched.h>
+#include <asm/page.h>
+#include <asm/io.h>
+#include <asm/setup.h>
+
+void heartbeat(void)
+{
+#if 0
+	static unsigned int cnt, period, dist;
+
+	if (cnt == 0 || cnt == dist) {
+		iowrite32(1, CONFIG_XILINX_LEDS_4BIT_BASEADDR);
+	} else if (cnt == 7 || cnt == dist + 7) {
+		iowrite32(0, CONFIG_XILINX_LEDS_4BIT_BASEADDR);
+	}
+
+	if (++cnt > period) {
+		cnt = 0;
+
+		/*
+		 * The hyperbolic function below modifies the heartbeat period
+		 * length in dependency of the current (5min) load. It goes
+		 * through the points f(0)=126, f(1)=86, f(5)=51, f(inf)->30.
+		 */
+		period = ((672 << FSHIFT) / (5 * avenrun[0] +
+					(7 << FSHIFT))) + 30;
+		dist = period / 4;
+	}
+#endif
+}
-- 
1.5.4.rc4.14.g6fc74

