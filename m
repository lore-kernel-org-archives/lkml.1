Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367AbYBQISs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbYBQISs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbYBQIRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:17:38 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33968 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961AbYBQIRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:17:33 -0500
Date: Sun, 17 Feb 2008 10:17:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [2.6 patch] let LOG_BUF_SHIFT default to 17
Message-ID: <20080217081707.GE3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16 kB is often no longer enough for a normal boot of an UP system.

And even less when people e.g. use suspend.

17 seems to be a more reasonable default for current kernels on current 
hardware (it's just the default, anyone who is memory limited can 
still lower it).

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---

This patch has been sent on:
- 29 Jan 2008

f02213e3c1cb90ec1c66227f037110d489f30bfd 
diff --git a/init/Kconfig b/init/Kconfig
index 0eda68f..81a1255 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -272,17 +272,14 @@ config IKCONFIG_PROC
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
 	range 12 21
-	default 17 if S390 || LOCKDEP
-	default 16 if X86_NUMAQ || IA64
-	default 15 if SMP
-	default 14
+	default 17
 	help
 	  Select kernel log buffer size as a power of 2.
-	  Defaults and Examples:
-	  	     17 => 128 KB for S/390
-		     16 => 64 KB for x86 NUMAQ or IA-64
-	             15 => 32 KB for SMP
-	             14 => 16 KB for uniprocessor
+	  Examples:
+	  	     17 => 128 KB
+		     16 => 64 KB
+	             15 => 32 KB
+	             14 => 16 KB
 		     13 =>  8 KB
 		     12 =>  4 KB
 

