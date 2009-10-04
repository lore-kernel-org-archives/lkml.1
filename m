Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbZJDNBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbZJDNBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 09:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757222AbZJDNBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 09:01:05 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:52859 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025AbZJDNBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 09:01:03 -0400
Message-Id: <20091004125335.562367068@I-love.SAKURA.ne.jp>
References: <20091004124946.788396453@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sun, 04 Oct 2009 21:50:11 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #16 25/25] TOMOYO: Update Kconfig and Makefile.
Content-Disposition: inline; filename=tomoyo-update-Makefile-and-Kconfig.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch switches from TOMOYO 2.2.0 to TOMOYO 2.3.0 .

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/Kconfig  |   67 +++++++++++++++++++++++++++++++++++++++++++++++
 security/tomoyo/Makefile |    2 -
 2 files changed, 68 insertions(+), 1 deletion(-)

--- security-testing-2.6.orig/security/tomoyo/Kconfig
+++ security-testing-2.6/security/tomoyo/Kconfig
@@ -3,9 +3,76 @@ config SECURITY_TOMOYO
 	depends on SECURITY
 	select SECURITYFS
 	select SECURITY_PATH
+	select SECURITY_NETWORK
 	default n
 	help
 	  This selects TOMOYO Linux, pathname-based access control.
 	  Required userspace tools and further information may be
 	  found at <http://tomoyo.sourceforge.jp/>.
 	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_TOMOYO_MAX_ACCEPT_ENTRY
+	int "Default maximal count for learning mode"
+	default 2048
+	range 0 2147483647
+	depends on SECURITY_TOMOYO
+	help
+	  This is the default value for maximal ACL entries
+	  that are automatically appended into policy at "learning mode".
+	  Some programs access thousands of objects, so running
+	  such programs in "learning mode" dulls the system response
+	  and consumes much memory.
+	  This is the safeguard for such programs.
+
+config SECURITY_TOMOYO_BUILTIN_INITIALIZERS
+	string "Built-in domain initializer programs"
+	default "/sbin/modprobe /sbin/hotplug"
+	depends on SECURITY_TOMOYO
+	---help---
+	  Some programs are executed from initrd/initramfs before /sbin/init
+	  starts.
+
+	  Since policy is loaded when /sbin/init starts, it is impossible to
+	  run such programs outside the <kernel> domain. Usually it is fine.
+
+	  But if such programs continue running when /sbin/init starts, such
+	  programs will reside in the <kernel> domain.
+	  If such programs executes /bin/sh , you will give the <kernel> domain
+	  permission to execute /bin/sh ; I think you don't want to do so.
+
+	  This option allows you to chase such programs away from the <kernel>
+	  domain so that you won't give the <kernel> domain permission to
+	  execute /bin/sh .
+
+config SECURITY_TOMOYO_AUDIT
+	bool "Auditing interface support"
+	default y
+	depends on SECURITY_TOMOYO
+	help
+	  This option enables /sys/kernel/security/tomoyo/grant_log and /sys/kernel/security/tomoyo/reject_log
+	  interfaces. You may disable these interfaces if you want to apply for
+	  HDD-less systems (e.g. embedded systems).
+
+config SECURITY_TOMOYO_MAX_GRANT_LOG
+	int "Default maximal count for grant log"
+	default 1024
+	range 0 2147483647
+	depends on SECURITY_TOMOYO_AUDIT
+	help
+	  This is the default value for maximal entries for
+	  access grant logs that the kernel can hold on memory.
+	  You can read the log via /sys/kernel/security/tomoyo/grant_log.
+	  If you don't need access grant logs,
+	  you may set this value to 0.
+
+config SECURITY_TOMOYO_MAX_REJECT_LOG
+	int "Default maximal count for reject log"
+	default 1024
+	range 0 2147483647
+	depends on SECURITY_TOMOYO_AUDIT
+	help
+	  This is the default value for maximal entries for
+	  access reject logs that the kernel can hold on memory.
+	  You can read the log via /sys/kernel/security/tomoyo/reject_log.
+	  If you don't need access reject logs,
+	  you may set this value to 0.
--- security-testing-2.6.orig/security/tomoyo/Makefile
+++ security-testing-2.6/security/tomoyo/Makefile
@@ -1 +1 @@
-obj-y = common.o realpath.o tomoyo.o domain.o file.o
+obj-y = address_group.o gc.o mount.o new-file.o path_group.o audit.o environ.o load_policy.o network.o new-realpath.o securityfs_if.o util.o capability.o condition.o memory.o new-domain.o number_group.o policy_io.o lsm.o

-- 
