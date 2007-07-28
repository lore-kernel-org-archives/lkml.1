Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbXG1RZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbXG1RZs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbXG1RZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:25:40 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44641 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbXG1RZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:25:40 -0400
Date: Sat, 28 Jul 2007 20:25:39 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: [PATCH] fix alpha mkbb compilation warnings
Message-ID: <Pine.SOC.4.64.0707282021150.20474@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In current 2.6.23-rc1+git, make bootimage gives the following warnings 
while compiling mkbb.c. The patch below fixes these warnings by using 
the proper include for exit() and using appropriate printf format.

  HOSTCC  arch/alpha/boot/tools/mkbb
arch/alpha/boot/tools/mkbb.c: In function 'main':
arch/alpha/boot/tools/mkbb.c:95: warning: implicit declaration of function 'exit'
arch/alpha/boot/tools/mkbb.c:95: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:102: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:110: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:117: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
arch/alpha/boot/tools/mkbb.c:118: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:125: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
arch/alpha/boot/tools/mkbb.c:126: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:143: warning: incompatible implicit declaration of built-in function 'exit'
arch/alpha/boot/tools/mkbb.c:148: warning: incompatible implicit declaration of built-in function 'exit'

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/arch/alpha/boot/tools/mkbb.c b/arch/alpha/boot/tools/mkbb.c
index 632a7fd..1185778 100644
--- a/arch/alpha/boot/tools/mkbb.c
+++ b/arch/alpha/boot/tools/mkbb.c
@@ -11,6 +11,7 @@
 
 #include <fcntl.h>
 #include <unistd.h>
+#include <stdlib.h>
 #include <stdio.h>
 
 /* Minimal definition of disklabel, so we don't have to include
@@ -114,7 +115,7 @@ int main(int argc, char ** argv)
     nread = read(fd, &bootloader_image, sizeof(bootblock));
     if(nread != sizeof(bootblock)) {
 	perror("lxboot read");
-	fprintf(stderr, "expected %d, got %d\n", sizeof(bootblock), nread);
+	fprintf(stderr, "expected %zd, got %d\n", sizeof(bootblock), nread);
 	exit(0);
     }
 
@@ -122,7 +123,7 @@ int main(int argc, char ** argv)
     nread = read(dev, &bootblock_from_disk, sizeof(bootblock));
     if(nread != sizeof(bootblock)) {
 	perror("bootblock read");
-	fprintf(stderr, "expected %d, got %d\n", sizeof(bootblock), nread);
+	fprintf(stderr, "expected %zd, got %d\n", sizeof(bootblock), nread);
 	exit(0);
     }
 

-- 
Meelis Roos (mroos@linux.ee)
