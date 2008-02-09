Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbYBINhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbYBINhu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbYBINfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:35:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:60467 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757496AbYBINf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:35:27 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/8] kgdb: COPTIMIZE flag
Date: Sat,  9 Feb 2008 07:35:10 -0600
Message-Id: <1202564114-18587-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Feb 2008 13:34:55.0571 (UTC) FILETIME=[8E9B0A30:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

This patch adds in the ability to unoptimize a single kernel module to
make source stepping more linear and not optimize out variables that
the developer might like to inspect.  It used with adding
COPTIMIZE=-O0 to the build line when doing something like a single
kernel module only build.  Or you could use it to override the default
optimization level entirely.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Makefile |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 89f2d8b..65aa7f8 100644
--- a/Makefile
+++ b/Makefile
@@ -502,10 +502,14 @@ endif # $(dot-config)
 all: vmlinux
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
-KBUILD_CFLAGS	+= -Os
+COPTIMIZE	+= -Os
 else
-KBUILD_CFLAGS	+= -O2
+COPTIMIZE	+= -O2
 endif
+# COPTIMIZE may be overridden on the make command line with
+# 	make ... COPTIMIZE=""
+# The resulting object may be easier to debug with KGDB
+KBUILD_CFLAGS	+= $(COPTIMIZE)
 
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
-- 
1.5.4

