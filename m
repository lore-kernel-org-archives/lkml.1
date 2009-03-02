Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZCBWNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZCBWNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZCBWNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:13:21 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:42792 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbZCBWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:13:20 -0500
Date: Mon, 2 Mar 2009 14:14:06 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH mainline] menu: fix embedded menu snafu
Message-Id: <20090302141406.13d5ef1f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.49AC59D6.0304:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The COMPAT_BRK kconfig symbol does not depend on EMBEDDED,
but it is in the midst of the EMBEDDED menu symbols, so it mucks
up the EMBEDDED menu.  Fix by moving it to just after all of
the EMBEDDED menu symbols.  Also, surround all of the
EMBEDDED symbols with "if EMBEDDED"/"endif" so that this
EMBEDDED block is clearer.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 init/Kconfig |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- linux-2.6.29-rc6-git5.orig/init/Kconfig
+++ linux-2.6.29-rc6-git5/init/Kconfig
@@ -683,6 +683,8 @@ menuconfig EMBEDDED
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+if EMBEDDED
+
 config UID16
 	bool "Enable 16-bit UID system calls" if EMBEDDED
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION)
@@ -780,18 +782,6 @@ config PCSPKR_PLATFORM
           This option allows to disable the internal PC-Speaker
           support, saving some memory.
 
-config COMPAT_BRK
-	bool "Disable heap randomization"
-	default y
-	help
-	  Randomizing heap placement makes heap exploits harder, but it
-	  also breaks ancient binaries (including anything libc5 based).
-	  This option changes the bootup default to heap randomization
-	  disabled, and can be overriden runtime by setting
-	  /proc/sys/kernel/randomize_va_space to 2.
-
-	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
-
 config BASE_FULL
 	default y
 	bool "Enable full-sized data structures for core" if EMBEDDED
@@ -897,6 +887,20 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+endif # EMBEDDED
+
+config COMPAT_BRK
+	bool "Disable heap randomization"
+	default y
+	help
+	  Randomizing heap placement makes heap exploits harder, but it
+	  also breaks ancient binaries (including anything libc5 based).
+	  This option changes the bootup default to heap randomization
+	  disabled, and can be overriden runtime by setting
+	  /proc/sys/kernel/randomize_va_space to 2.
+
+	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
+
 choice
 	prompt "Choose SLAB allocator"
 	default SLUB
