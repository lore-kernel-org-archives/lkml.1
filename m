Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbYAIBCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbYAIBCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 20:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbYAIAzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:55:33 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:51981 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbYAIAyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:54:31 -0500
Message-Id: <20080109005427.810812597@nttdata.co.jp>
References: <20080109005320.323184643@nttdata.co.jp>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 09:53:40 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #6 retry 20/21] Kconfig and Makefile
X-OriginalArrivalTime: 09 Jan 2008 00:54:28.0396 (UTC) FILETIME=[2FE266C0:01C8525A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux is placed in security/tomoyo .

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/Kconfig         |    1 +
 security/Makefile        |    1 +
 security/tomoyo/Kconfig  |   26 ++++++++++++++++++++++++++
 security/tomoyo/Makefile |    2 ++
 4 files changed, 30 insertions(+)

--- linux-2.6-mm.orig/security/Kconfig
+++ linux-2.6-mm/security/Kconfig
@@ -105,6 +105,7 @@ config SECURITY_ROOTPLUG
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-2.6-mm.orig/security/Makefile
+++ linux-2.6-mm/security/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selin
 obj-$(CONFIG_SECURITY_SMACK)		+= commoncap.o smack/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
+obj-$(CONFIG_SECURITY_TOMOYO)           += tomoyo/
--- /dev/null
+++ linux-2.6-mm/security/tomoyo/Kconfig
@@ -0,0 +1,26 @@
+config SECURITY_TOMOYO
+	bool "TOMOYO Linux support"
+	depends on SECURITY
+	select SECURITY_NETWORK
+	default n
+	help
+	  This selects TOMOYO Linux.
+
+	  TOMOYO Linux is a domain-based access control method using LSM.
+	  If you answer Y, you will need a policy loader program
+	  (/sbin/tomoyo-init) and some configuration files.
+	  You can get them from
+	  <http://tomoyo.sourceforge.jp/en/2.1.x/>
+
+	  TOMOYO Linux is also applicable to figuring out the behavior
+	  of your system, for TOMOYO uses the canonicalized absolute
+	  pathnames and TreeView style domain transitions.
+
+config SECURITY_TOMOYO_USE_AUDITD
+	bool "Use standard auditing subsystem"
+	depends on SECURITY_TOMOYO && AUDIT
+	default y
+	help
+	  This makes messages sent to auditing subsystem.
+
+	  If you say 'N' here, messages will be sent to printk().
--- /dev/null
+++ linux-2.6-mm/security/tomoyo/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_SECURITY_TOMOYO) += tomoyo.o domain.o common.o realpath.o audit.o file.o exec.o environ.o net.o mount.o signal.o capability.o condition.o
+EXTRA_CFLAGS += -Isecurity/tomoyo/include

-- 
