Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYJUAET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYJUAET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 20:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYJUAEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 20:04:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:11141 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYJUAEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 20:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rj4a9yRDKKva1tMtHoz+zpYxsjGevTaLF5lTbTTYkXXWaOkEw3NfmOvzovQXnjBZv+
         KzJCarH75z6MOOuWAE2KAS2rfkKC8xDNi7MBEMstu7vKEORI4YvDSswECY/qfhY0QkkX
         P/1cAY13Ct+kWKVUp/08aTAmnty9EowwPJJl4=
Message-ID: <48FD1C77.6070601@gmail.com>
Date: Tue, 21 Oct 2008 02:04:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mips: fix build error on malta
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to build a kernel configured for malta board, one get
these errors and then the build craches:

arch/mips/mti-malta/malta-amon.c:25:32: asm-mips/addrspace.h: No such file or directory
arch/mips/mti-malta/malta-amon.c:26:41: asm-mips/mips-boards/launch.h: No such file or directory
arch/mips/mti-malta/malta-amon.c:27:33: asm-mips/mipsmtregs.h: No such file or directory
arch/mips/mti-malta/malta-amon.c: In function `amon_cpu_avail':
arch/mips/mti-malta/malta-amon.c:31: error: `CPULAUNCH' undeclared (first use in this function)
arch/mips/mti-malta/malta-amon.c:31: error: (Each undeclared identifier is reported only once
arch/mips/mti-malta/malta-amon.c:31: error: for each function it appears in.)
arch/mips/mti-malta/malta-amon.c:33: error: `NCPULAUNCH' undeclared (first use in this function)
arch/mips/mti-malta/malta-amon.c:38: error: invalid use of undefined type `struct cpulaunch'
arch/mips/mti-malta/malta-amon.c:39: error: dereferencing pointer to incomplete type
arch/mips/mti-malta/malta-amon.c:39: error: `LAUNCH_FREADY' undeclared (first use in this function)
arch/mips/mti-malta/malta-amon.c:43: error: dereferencing pointer to incomplete type
arch/mips/mti-malta/malta-amon.c:43: error: `LAUNCH_FGO' undeclared (first use in this function)
arch/mips/mti-malta/malta-amon.c:43: error: `LAUNCH_FGONE' undeclared (first use in this function)
arch/mips/mti-malta/malta-amon.c: In function `amon_cpu_start':
arch/mips/mti-malta/malta-amon.c:56: error: `CPULAUNCH' undeclared (first use in this function)
arch/mips/mti-malta/malta-amon.c:64: error: invalid use of undefined type `struct cpulaunch'
arch/mips/mti-malta/malta-amon.c:68: error: dereferencing pointer to incomplete type
arch/mips/mti-malta/malta-amon.c:69: error: dereferencing pointer to incomplete type
arch/mips/mti-malta/malta-amon.c:70: error: dereferencing pointer to incomplete type
arch/mips/mti-malta/malta-amon.c:71: error: dereferencing pointer to incomplete type
arch/mips/mti-malta/malta-amon.c:76: error: dereferencing pointer to incomplete type
arch/mips/mti-malta/malta-amon.c:76: error: `LAUNCH_FGO' undeclared (first use in this function)
arch/mips/mti-malta/malta-amon.c:77: error: dereferencing pointer to incomplete type
arch/mips/mti-malta/malta-amon.c:77: error: `LAUNCH_FGONE' undeclared (first use in this function)
make[1]: *** [arch/mips/mti-malta/malta-amon.o] Erreur 1

This patch corrects the path for mips headers in 
arch/mips/mti-malta/malta-amon.c

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/arch/mips/mti-malta/malta-amon.c b/arch/mips/mti-malta/malta-amon.c
index 96236bf..df9e526 100644
--- a/arch/mips/mti-malta/malta-amon.c
+++ b/arch/mips/mti-malta/malta-amon.c
@@ -22,9 +22,9 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 
-#include <asm-mips/addrspace.h>
-#include <asm-mips/mips-boards/launch.h>
-#include <asm-mips/mipsmtregs.h>
+#include <asm/addrspace.h>
+#include <asm/mips-boards/launch.h>
+#include <asm/mipsmtregs.h>
 
 int amon_cpu_avail(int cpu)
 {
