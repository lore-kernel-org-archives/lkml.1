Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbYAXQx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbYAXQx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYAXQxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:08 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64198 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbYAXQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:03 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/17] [MIPS] Malta: set up the screen info in a separate function
Date: Thu, 24 Jan 2008 19:52:44 +0300
Message-Id: <1201193577-4261-5-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a separate short and sweet function to initialize
the screen_info global variable.

This improves readability of the Malta board setup code.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_setup.c |   39 ++++++++++++++++------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 79d74ea..8b391ee 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -132,6 +132,26 @@ static void __init pci_clock_check(void)
 }
 #endif
 
+#if defined(CONFIG_VT) && defined(CONFIG_VGA_CONSOLE)
+static void __init screen_info_setup(void)
+{
+	screen_info = (struct screen_info) {
+		.orig_x = 0,
+		.orig_y = 25,
+		.ext_mem_k = 0,
+		.orig_video_page = 0,
+		.orig_video_mode = 0,
+		.orig_video_cols = 80,
+		.unused2 = 0,
+		.orig_video_ega_bx = 0,
+		.unused3 = 0,
+		.orig_video_lines = 25,
+		.orig_video_isVGA = VIDEO_TYPE_VGAC,
+		.orig_video_points = 16
+	};
+}
+#endif
+
 void __init plat_mem_setup(void)
 {
 	unsigned int i;
@@ -200,23 +220,8 @@ void __init plat_mem_setup(void)
 #ifdef CONFIG_BLK_DEV_FD
 	fd_activate();
 #endif
-#ifdef CONFIG_VT
-#if defined(CONFIG_VGA_CONSOLE)
-	screen_info = (struct screen_info) {
-		.orig_x = 0,
-		.orig_y = 25,
-		.ext_mem_k = 0,
-		.orig_video_page = 0,
-		.orig_video_mode = 0,
-		.orig_video_cols = 80,
-		.unused2 = 0,
-		.orig_video_ega_bx = 0,
-		.unused3 = 0,
-		.orig_video_lines = 25,
-		.orig_video_isVGA = VIDEO_TYPE_VGAC,
-		.orig_video_points = 16
-	};
-#endif
+#if defined(CONFIG_VT) && defined(CONFIG_VGA_CONSOLE)
+	screen_info_setup();
 #endif
 	mips_reboot_setup();
 }
-- 
1.5.3

