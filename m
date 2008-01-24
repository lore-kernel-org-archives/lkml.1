Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbYAXQxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbYAXQxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYAXQxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:05 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64186 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752881AbYAXQxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:03 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 01/17] [MIPS] Malta: use Linux kernel style for structure initialization
Date: Thu, 24 Jan 2008 19:52:41 +0300
Message-Id: <1201193577-4261-2-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reformats the structure initialization code thus
making the latter look idiomatic.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_setup.c |   56 +++++++++++++++++++++-------
 1 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index bc43a5c..d051405 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -43,11 +43,36 @@ extern void kgdb_config(void);
 #endif
 
 struct resource standard_io_resources[] = {
-	{ .name = "dma1", .start = 0x00, .end = 0x1f, .flags = IORESOURCE_BUSY },
-	{ .name = "timer", .start = 0x40, .end = 0x5f, .flags = IORESOURCE_BUSY },
-	{ .name = "keyboard", .start = 0x60, .end = 0x6f, .flags = IORESOURCE_BUSY },
-	{ .name = "dma page reg", .start = 0x80, .end = 0x8f, .flags = IORESOURCE_BUSY },
-	{ .name = "dma2", .start = 0xc0, .end = 0xdf, .flags = IORESOURCE_BUSY },
+	{
+		.name = "dma1",
+		.start = 0x00,
+		.end = 0x1f,
+		.flags = IORESOURCE_BUSY
+	},
+	{
+		.name = "timer",
+		.start = 0x40,
+		.end = 0x5f,
+		.flags = IORESOURCE_BUSY
+	},
+	{
+		.name = "keyboard",
+		.start = 0x60,
+		.end = 0x6f,
+		.flags = IORESOURCE_BUSY
+	},
+	{
+		.name = "dma page reg",
+		.start = 0x80,
+		.end = 0x8f,
+		.flags = IORESOURCE_BUSY
+	},
+	{
+		.name = "dma2",
+		.start = 0xc0,
+		.end = 0xdf,
+		.flags = IORESOURCE_BUSY
+	},
 };
 
 const char *get_system_type(void)
@@ -171,15 +196,18 @@ void __init plat_mem_setup(void)
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
 	screen_info = (struct screen_info) {
-		0, 25,			/* orig-x, orig-y */
-		0,			/* unused */
-		0,			/* orig-video-page */
-		0,			/* orig-video-mode */
-		80,			/* orig-video-cols */
-		0, 0, 0,		/* ega_ax, ega_bx, ega_cx */
-		25,			/* orig-video-lines */
-		VIDEO_TYPE_VGAC,	/* orig-video-isVGA */
-		16			/* orig-video-points */
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
 	};
 #endif
 #endif
-- 
1.5.3

