Return-Path: <linux-kernel-owner+w=401wt.eu-S965233AbXBYXTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbXBYXTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 18:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965232AbXBYXTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 18:19:16 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44223 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965236AbXBYXTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 18:19:12 -0500
Date: Mon, 26 Feb 2007 00:19:12 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] init/do_mounts.c: proper prepare_namespace() prototype
Message-ID: <20070225231912.GF29575@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper protype for prepare_namespace() in 
include/linux/init.h.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/init.h |    3 ++-
 init/do_mounts.c     |    1 +
 init/main.c          |    1 -
 3 files changed, 3 insertions(+), 2 deletions(-)

--- linux-2.6.20-mm2/include/linux/init.h.old	2007-02-25 19:54:02.000000000 +0100
+++ linux-2.6.20-mm2/include/linux/init.h	2007-02-25 19:57:56.000000000 +0100
@@ -72,7 +72,8 @@
 extern unsigned int reset_devices;
 
 /* used by init/main.c */
-extern void setup_arch(char **);
+void setup_arch(char **);
+void prepare_namespace(void);
 
 #endif
   
--- linux-2.6.20-mm2/init/do_mounts.c.old	2007-02-25 19:54:59.000000000 +0100
+++ linux-2.6.20-mm2/init/do_mounts.c	2007-02-25 19:55:12.000000000 +0100
@@ -9,6 +9,7 @@
 #include <linux/delay.h>
 #include <linux/mount.h>
 #include <linux/device.h>
+#include <linux/init.h>
 
 #include <linux/nfs_fs.h>
 #include <linux/nfs_fs_sb.h>
--- linux-2.6.20-mm2/init/main.c.old	2007-02-25 19:55:21.000000000 +0100
+++ linux-2.6.20-mm2/init/main.c	2007-02-25 19:55:35.000000000 +0100
@@ -94,7 +94,6 @@
 extern void prio_tree_init(void);
 extern void radix_tree_init(void);
 extern void free_initmem(void);
-extern void prepare_namespace(void);
 #ifdef	CONFIG_ACPI
 extern void acpi_early_init(void);
 #else

