Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYHAP2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYHAP2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYHAP2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:28:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:56463 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYHAP2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:28:11 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/3] kgdb: remove the requirement for CONFIG_FRAME_POINTER
Date: Fri,  1 Aug 2008 10:27:52 -0500
Message-Id: <1217604474-24239-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1217604474-24239-1-git-send-email-jason.wessel@windriver.com>
References: <1217604474-24239-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 01 Aug 2008 15:27:54.0635 (UTC) FILETIME=[2B1E9DB0:01C8F3EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no technical reason that the kgdb core requires frame
pointers.  It is up to the end user of KGDB to decide if they need
them or not.

[ anemo@mba.ocn.ne.jp: removed frame pointers on mips ]

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl |    8 ++++++++
 lib/Kconfig.kgdb                |   11 +++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index e8acd1f..54d3b15 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -98,6 +98,14 @@
     "Kernel debugging" select "KGDB: kernel debugging with remote gdb".
     </para>
     <para>
+    It is advised, but not required that you turn on the
+    CONFIG_FRAME_POINTER kernel option.  This option inserts code to
+    into the compiled executable which saves the frame information in
+    registers or on the stack at different points which will allow a
+    debugger such as gdb to more accurately construct stack back traces
+    while debugging the kernel.
+    </para>
+    <para>
     Next you should choose one of more I/O drivers to interconnect debugging
     host and debugged target.  Early boot debugging requires a KGDB
     I/O driver that supports early debugging and the driver must be
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 2cfd272..9b5d1d7 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -4,14 +4,17 @@ config HAVE_ARCH_KGDB
 
 menuconfig KGDB
 	bool "KGDB: kernel debugging with remote gdb"
-	select FRAME_POINTER
 	depends on HAVE_ARCH_KGDB
 	depends on DEBUG_KERNEL && EXPERIMENTAL
 	help
 	  If you say Y here, it will be possible to remotely debug the
-	  kernel using gdb.  Documentation of kernel debugger is available
-	  at http://kgdb.sourceforge.net as well as in DocBook form
-	  in Documentation/DocBook/.  If unsure, say N.
+	  kernel using gdb.  It is recommended but not required, that
+	  you also turn on the kernel config option
+	  CONFIG_FRAME_POINTER to aid in producing more reliable stack
+	  backtraces in the external debugger.  Documentation of
+	  kernel debugger is available at http://kgdb.sourceforge.net
+	  as well as in DocBook form in Documentation/DocBook/.  If
+	  unsure, say N.
 
 if KGDB
 
-- 
1.5.5.1

