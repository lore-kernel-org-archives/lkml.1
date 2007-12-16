Return-Path: <linux-kernel-owner+w=401wt.eu-S932427AbXLPLEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbXLPLEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763161AbXLPLDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:03:52 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53680 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758243AbXLPLDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:03:52 -0500
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071216080441.435456586@I-love.SAKURA.ne.jp>
	<20071216080628.061470932@I-love.SAKURA.ne.jp>
	<200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp>
Message-Id: <200712162003.EGF05255.QVFFHOMOSLOJtF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 16 Dec 2007 20:03:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/Kconfig  |   21 +++++++++++++++++++++
 fs/Makefile |    1 +
 2 files changed, 22 insertions(+)

--- linux-2.6.24-rc5.orig/fs/Kconfig
+++ linux-2.6.24-rc5/fs/Kconfig
@@ -1555,6 +1555,27 @@ config UFS_DEBUG
 	  Y here.  This will result in _many_ additional debugging messages to be
 	  written to the system log.
 
+config SYAORAN_FS
+	tristate "SYAORAN (Tamper-Proof Device Filesystem) support"
+	help
+	  Say Y or M here to support the Tamper-Proof Device Filesystem.
+
+	  SYAORAN stands for
+	  "Simple Yet All-important Object Realizing Abiding Nexus".
+	  SYAORAN is a filesystem for /dev with Mandatory Access Control.
+
+	  The system can't work if /dev is read-only.
+	  Therefore you need to mount a writable filesystem (such as tmpfs)
+	  for /dev if root fs is read-only.
+
+	  But the writable /dev means that files on /dev might be tampered.
+	  For example, if /dev/null is deleted and re-created as a symbolic
+	  link to /dev/hda by an attacker, the contents of the IDE HDD
+	  will be destroyed at a blow.
+
+	  SYAORAN can ensure /dev/null is a character device file
+	  with major=1 minor=3.
+
 endmenu
 
 menuconfig NETWORK_FILESYSTEMS
--- linux-2.6.24-rc5.orig/fs/Makefile
+++ linux-2.6.24-rc5/fs/Makefile
@@ -118,3 +118,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_SYAORAN_FS)        += syaoran/syaoran.o
