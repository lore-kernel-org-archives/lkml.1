Return-Path: <linux-kernel-owner+w=401wt.eu-S934416AbXJOSpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbXJOSpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764870AbXJOSfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:35:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:48081 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765711AbXJOSfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:35:12 -0400
Message-ID: <4713B29F.2080602@windriver.com>
Date: Mon, 15 Oct 2007 13:34:07 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: paulus@samba.org
Subject: [PATCH 21/21] KGDB: Turn off xmon if kgdb is active on ppc and powerpc
Content-Type: multipart/mixed;
 boundary="------------090209060902030207080508"
X-OriginalArrivalTime: 15 Oct 2007 18:34:50.0470 (UTC) FILETIME=[1211F860:01C80F5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090209060902030207080508
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------090209060902030207080508
Content-Type: text/x-patch;
 name="xmon_or_kgdb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xmon_or_kgdb.patch"

xmon_or_kgdb.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: paulus@samba.org
Subject: [PATCH] Turn off xmon if kgdb is active on ppc and powerpc

Xmon and kgdb are mutually exclusive at the moment so xmon should be
turned off in the kernel config options if kgdb selected.  The case
with "make allmodconfig" was failing and this patch addresses the
problem.

This will be fixed at a later point so as to allow either Xmon or kgdb
to be in the same kernel.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/powerpc/Kconfig.debug |    2 +-
 arch/ppc/Kconfig.debug     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-kgdb/arch/powerpc/Kconfig.debug
===================================================================
--- linux-2.6-kgdb.orig/arch/powerpc/Kconfig.debug
+++ linux-2.6-kgdb/arch/powerpc/Kconfig.debug
@@ -43,7 +43,7 @@ config HCALL_STATS
 
 config XMON
 	bool "Include xmon kernel debugger"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && !KGDB
 	help
 	  Include in-kernel hooks for the xmon kernel monitor/debugger.
 	  Unless you are intending to debug the kernel, say N here.
Index: linux-2.6-kgdb/arch/ppc/Kconfig.debug
===================================================================
--- linux-2.6-kgdb.orig/arch/ppc/Kconfig.debug
+++ linux-2.6-kgdb/arch/ppc/Kconfig.debug
@@ -4,7 +4,7 @@ source "lib/Kconfig.debug"
 
 config XMON
 	bool "Include xmon kernel debugger"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && !KGDB
 	help
 	  Include in-kernel hooks for the xmon kernel monitor/debugger.
 	  Unless you are intending to debug the kernel, say N here.

--------------090209060902030207080508--
