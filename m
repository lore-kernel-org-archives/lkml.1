Return-Path: <linux-kernel-owner+w=401wt.eu-S1761453AbZEAQhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761453AbZEAQhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 12:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZEAQhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 12:37:18 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:63360 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZEAQhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 12:37:16 -0400
Message-ID: <49FB2529.2080102@oracle.com>
Date: Fri, 01 May 2009 09:36:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] menu: fix embedded menu order
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49FB24D1.015E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix Embedded menu order/structure.

The "EMBEDDED" menu display is broken, i.e., it is split apart,
not displayed entirely in one place, due to some symbols not being
listed as "if EMBEDDED".  Make them be displayed all together.

Tested with menuconfig, xconfig, & gconfig.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 init/Kconfig |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- lnx-2630-rc4.orig/init/Kconfig
+++ lnx-2630-rc4/init/Kconfig
@@ -786,7 +786,7 @@ config KALLSYMS
 	   somewhat, as all symbols have to be loaded into the kernel image.
 
 config KALLSYMS_ALL
-	bool "Include all symbols in kallsyms"
+	bool "Include all symbols in kallsyms" if EMBEDDED
 	depends on DEBUG_KERNEL && KALLSYMS
 	help
 	   Normally kallsyms only contains the symbols of functions, for nicer
@@ -797,7 +797,7 @@ config KALLSYMS_ALL
 	   Say N.
 
 config KALLSYMS_EXTRA_PASS
-	bool "Do an extra kallsyms pass"
+	bool "Do an extra kallsyms pass" if EMBEDDED
 	depends on KALLSYMS
 	help
 	   If kallsyms is not working correctly, the build will fail with
@@ -807,9 +807,8 @@ config KALLSYMS_EXTRA_PASS
 	   reported.  KALLSYMS_EXTRA_PASS is only a temporary workaround while
 	   you wait for kallsyms to be fixed.
 
-
 config STRIP_ASM_SYMS
-	bool "Strip assembler-generated symbols during link"
+	bool "Strip assembler-generated symbols during link" if EMBEDDED
 	default n
 	help
 	  Strip internal assembler-generated symbols during a link (symbols
@@ -961,6 +960,9 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+# end EMBEDDED menu -- don't put non-EMBEDDED items between
+# "menuconfig EMBEDDED" and here.
+
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
