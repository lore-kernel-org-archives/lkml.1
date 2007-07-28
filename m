Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbXG1R36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbXG1R36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 13:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXG1R3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 13:29:51 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44665 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbXG1R3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 13:29:51 -0400
Date: Sat, 28 Jul 2007 20:29:50 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix alpha objstrip.c compilation warnings
Message-ID: <Pine.SOC.4.64.0707282025430.20474@math.ut.ee>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In current 2.6.23-rc1+git, make bootimage gives the following warnings 
while compiling objstrip.c. The patch below fixes these warnings by 
casting strncmp argument to char * - it does not seem feasible to change 
its type in struct elfhdr.

  HOSTCC  arch/alpha/boot/tools/objstrip
arch/alpha/boot/tools/objstrip.c: In function 'main':
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of 'strlen' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of '__builtin_strcmp' differ in signedness
arch/alpha/boot/tools/objstrip.c:147: warning: pointer targets in passing argument 1 of 'strncmp' differ in signedness

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/arch/alpha/boot/tools/objstrip.c b/arch/alpha/boot/tools/objstrip.c
index 96154e7..ef18382 100644
--- a/arch/alpha/boot/tools/objstrip.c
+++ b/arch/alpha/boot/tools/objstrip.c
@@ -144,7 +144,7 @@ main (int argc, char *argv[])
 #ifdef __ELF__
     elf = (struct elfhdr *) buf;
 
-    if (elf->e_ident[0] == 0x7f && strncmp(elf->e_ident + 1, "ELF", 3) == 0) {
+    if (elf->e_ident[0] == 0x7f && strncmp((char *)elf->e_ident + 1, "ELF", 3) == 0) {
 	if (elf->e_type != ET_EXEC) {
 	    fprintf(stderr, "%s: %s is not an ELF executable\n",
 		    prog_name, inname);

-- 
Meelis Roos (mroos@linux.ee)
