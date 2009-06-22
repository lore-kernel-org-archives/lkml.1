Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbZFVVXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbZFVVXA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbZFVVWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:22:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759429AbZFVVWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:22:04 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [RFC][ PATCH -tip v2 3/7] Kbuild: disable gcc crossjumping
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>
Date: Mon, 22 Jun 2009 17:23:13 -0400
Message-ID: <20090622212313.5384.84166.stgit@localhost.localdomain>
In-Reply-To: <20090622212255.5384.53732.stgit@localhost.localdomain>
References: <20090622212255.5384.53732.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_DISABLE_CROSSJUMP option which disables gcc's cross-function
jumping. This option is required by the kprobes jump optimization.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
---

 Makefile          |    4 ++++
 lib/Kconfig.debug |    7 +++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index 2903e13..f73b139 100644
--- a/Makefile
+++ b/Makefile
@@ -524,6 +524,10 @@ else
 KBUILD_CFLAGS	+= -O2
 endif
 
+ifdef CONFIG_DISABLE_CROSSJUMP
+KBUILD_CFLAGS	+= -fno-crossjumping
+endif
+
 include $(srctree)/arch/$(SRCARCH)/Makefile
 
 ifneq ($(CONFIG_FRAME_WARN),0)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8da7467..f88e6b8 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -673,6 +673,13 @@ config FRAME_POINTER
 	  larger and slower, but it gives very useful debugging information
 	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
 
+config DISABLE_CROSSJUMP
+	bool "Disable cross-function jump optimization"
+	help
+	  This build option disables cross-function jump optimization
+	  (crossjumping) of gcc. Disabling crossjumping might increase
+	  kernel binary size a little.
+
 config BOOT_PRINTK_DELAY
 	bool "Delay each boot printk message by N milliseconds"
 	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
