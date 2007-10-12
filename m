Return-Path: <linux-kernel-owner+w=401wt.eu-S934387AbXJLWsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934387AbXJLWsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759997AbXJLWVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:49935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932769AbXJLWVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/75] PTY: add kernel parameter to overwrite legacy pty count
Date: Fri, 12 Oct 2007 15:16:55 -0700
Message-Id: <1192227681926-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276763650-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/kernel-parameters.txt |    4 ++++
 drivers/char/pty.c                  |    9 +++++++--
 include/linux/tty.h                 |    1 -
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a57c1f2..bdddd3c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1430,6 +1430,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	pt.		[PARIDE]
 			See Documentation/paride.txt.
 
+	pty.legacy_count=
+			[KNL] Number of legacy pty's. Overwrites compiled-in
+			default number.
+
 	quiet		[KNL] Disable most log messages
 
 	r128=		[HW,DRM]
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index de14aea..73de771 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -248,14 +248,19 @@ static int pty_bsd_ioctl(struct tty_struct *tty, struct file *file,
 	return -ENOIOCTLCMD;
 }
 
+static int legacy_count = CONFIG_LEGACY_PTY_COUNT;
+module_param(legacy_count, int, 0);
+
 static void __init legacy_pty_init(void)
 {
+	if (legacy_count <= 0)
+		return;
 
-	pty_driver = alloc_tty_driver(NR_PTYS);
+	pty_driver = alloc_tty_driver(legacy_count);
 	if (!pty_driver)
 		panic("Couldn't allocate pty driver");
 
-	pty_slave_driver = alloc_tty_driver(NR_PTYS);
+	pty_slave_driver = alloc_tty_driver(legacy_count);
 	if (!pty_slave_driver)
 		panic("Couldn't allocate pty slave driver");
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 6570719..60478f6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -21,7 +21,6 @@
  * (Note: the *_driver.minor_start values 1, 64, 128, 192 are
  * hardcoded at present.)
  */
-#define NR_PTYS	CONFIG_LEGACY_PTY_COUNT   /* Number of legacy ptys */
 #define NR_UNIX98_PTY_DEFAULT	4096      /* Default maximum for Unix98 ptys */
 #define NR_UNIX98_PTY_MAX	(1 << MINORBITS) /* Absolute limit */
 #define NR_LDISCS		17
-- 
1.5.3.4

