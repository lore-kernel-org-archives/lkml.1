Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYBIRAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYBIRAS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 12:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbYBIRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 12:00:06 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:35076 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYBIRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:00:04 -0500
Date: Sat, 9 Feb 2008 11:59:52 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Remove manual definition and subsequent testing of
 BUILD_CRAMDISK.
Message-ID: <alpine.LFD.1.00.0802091157160.6048@localhost.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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


Remove the explicit definition, and subsequent superfluous testing, of
BUILD CRAMDISK.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  is there any point to this brute-force setting anymore?  just
curious.

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
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

Home page:                                         http://crashcourse.ca
Fedora Cookbook:    http://crashcourse.ca/wiki/index.php/Fedora_Cookbook
========================================================================
