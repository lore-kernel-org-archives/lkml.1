Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYDZMhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYDZMhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 08:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbYDZMgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 08:36:50 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:39799 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbYDZMgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 08:36:49 -0400
Date: Sat, 26 Apr 2008 08:36:44 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] INIT: Delete hard-coded setting and testing of
 BUILD_CRAMDISK.
Message-ID: <alpine.LFD.1.10.0804260834460.14092@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
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


There seems to be little point in explicitly setting, then testing the
macro BUILD_CRAMDISK within the context of a single source file.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index ed652f4..54156e9 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -10,8 +10,6 @@

 #include "do_mounts.h"

-#define BUILD_CRAMDISK
-
 int __initdata rd_prompt = 1;/* 1 = prompt for RAM disk, 0 = don't prompt */

 static int __init prompt_ramdisk(char *str)
@@ -162,14 +160,8 @@ int __init rd_load_image(char *from)
 		goto done;

 	if (nblocks == 0) {
-#ifdef BUILD_CRAMDISK
 		if (crd_load(in_fd, out_fd) == 0)
 			goto successful_load;
-#else
-		printk(KERN_NOTICE
-		       "RAMDISK: Kernel does not support compressed "
-		       "RAM disk images\n");
-#endif
 		goto done;
 	}

@@ -267,8 +259,6 @@ int __init rd_load_disk(int n)
 	return rd_load_image("/dev/root");
 }

-#ifdef BUILD_CRAMDISK
-
 /*
  * gzip declarations
  */
@@ -425,5 +415,3 @@ static int __init crd_load(int in_fd, int out_fd)
 	kfree(window);
 	return result;
 }
-
-#endif  /* BUILD_CRAMDISK */

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
