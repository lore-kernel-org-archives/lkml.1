Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbXD0Tx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbXD0Tx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbXD0Tx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:53:57 -0400
Received: from smtp.bulldogdsl.com ([212.158.248.7]:2574 "EHLO
	mcr-smtp-001.bulldogdsl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756031AbXD0Txz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:53:55 -0400
X-Spam-Abuse: Please report all spam/abuse matters to abuse@bulldogdsl.com
From: Alistair John Strachan <s0348365@sms.ed.ac.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] Move LOG_BUF_SHIFT to a more sensible place
Date: Fri, 27 Apr 2007 20:53:32 +0100
User-Agent: KMail/1.9.6
Cc: "Sunil Naidu" <akula2.shark@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Frederik Deweerdt" <deweerdt@free.fr>,
       "Andrew Morton" <akpm@linux-foundation.org>, trivial@kernel.org
References: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com> <8355959a0704270731k97da30anf1c010f7ae3dc18c@mail.gmail.com> <20070427085500.1c4b267c.randy.dunlap@oracle.com>
In-Reply-To: <20070427085500.1c4b267c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704272053.32502.s0348365@sms.ed.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Several people have observed that perhaps LOG_BUF_SHIFT should be in a more 
obvious place than under DEBUG_KERNEL. Under some circumstances (such as the 
PARISC architecture), DEBUG_KERNEL can increase kernel size, which is an 
undesirable trade off for something as trivial as increasing the kernel log 
buffer size.

Instead, move LOG_BUF_SHIFT into "General Setup", so that people are more 
likely to be able to change it such a circumstance that the default buffer 
size is insufficient.

Signed-off-by: Alistair John Strachan <s0348365@sms.ed.ac.uk>
---

diff --git a/init/Kconfig b/init/Kconfig
index b170aa1..cc9eb35 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -262,6 +262,23 @@ config IKCONFIG_PROC
 	  This option enables access to the kernel configuration file
 	  through /proc/config.gz.
 
+config LOG_BUF_SHIFT
+	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
+	range 12 21
+	default 17 if S390 || LOCKDEP
+	default 16 if X86_NUMAQ || IA64
+	default 15 if SMP
+	default 14
+	help
+	  Select kernel log buffer size as a power of 2.
+	  Defaults and Examples:
+	  	     17 => 128 KB for S/390
+		     16 => 64 KB for x86 NUMAQ or IA-64
+	             15 => 32 KB for SMP
+	             14 => 16 KB for uniprocessor
+		     13 =>  8 KB
+		     12 =>  4 KB
+
 config CPUSETS
 	bool "Cpuset support"
 	depends on SMP
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3f3e740..de82401 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -86,23 +86,6 @@ config DEBUG_SHIRQ
 	  Drivers ought to be able to handle interrupts coming in at those
 	  points; some don't and need to be caught.
 
-config LOG_BUF_SHIFT
-	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)" if DEBUG_KERNEL
-	range 12 21
-	default 17 if S390 || LOCKDEP
-	default 16 if X86_NUMAQ || IA64
-	default 15 if SMP
-	default 14
-	help
-	  Select kernel log buffer size as a power of 2.
-	  Defaults and Examples:
-	  	     17 => 128 KB for S/390
-		     16 => 64 KB for x86 NUMAQ or IA-64
-	             15 => 32 KB for SMP
-	             14 => 16 KB for uniprocessor
-		     13 =>  8 KB
-		     12 =>  4 KB
-
 config DETECT_SOFTLOCKUP
 	bool "Detect Soft Lockups"
 	depends on DEBUG_KERNEL && !S390

-- 
Cheers,
Alistair.

Final year Computer Science undergraduate.
1F2 55 South Clerk Street, Edinburgh, UK.
