Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbXLBERv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbXLBERv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 23:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXLBERo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 23:17:44 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:53021 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbXLBERn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 23:17:43 -0500
Date: Sat, 1 Dec 2007 23:17:33 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH]  Remove superfluous checks for CONFIG_BLK_DEV_INITRD from
 initramfs.c.
Message-ID: <alpine.LFD.0.9999.0712012308370.8111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Given that init/Makefile includes initramfs.c in the build only if
CONFIG_BLK_DEV_INITRD is defined, there seems to be no point checking
for it yet again.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  compile-tested on x86.


diff --git a/init/initramfs.c b/init/initramfs.c
index 1db02a0..d53fee8 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -503,7 +503,6 @@ static int __init retain_initrd_param(char *str)
 __setup("retain_initrd", retain_initrd_param);

 extern char __initramfs_start[], __initramfs_end[];
-#ifdef CONFIG_BLK_DEV_INITRD
 #include <linux/initrd.h>
 #include <linux/kexec.h>

@@ -539,15 +538,12 @@ skip:
 	initrd_end = 0;
 }

-#endif
-
 static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start,
 			 __initramfs_end - __initramfs_start, 0);
 	if (err)
 		panic(err);
-#ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
@@ -579,7 +575,6 @@ static int __init populate_rootfs(void)
 		free_initrd();
 #endif
 	}
-#endif
 	return 0;
 }
 rootfs_initcall(populate_rootfs);
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
