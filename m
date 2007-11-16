Return-Path: <linux-kernel-owner+w=401wt.eu-S1763658AbXKPRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763658AbXKPRzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbXKPRzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:55:35 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53451 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085AbXKPRzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:55:33 -0500
Message-Id: <20071116173529.501540030@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Sat, 17 Nov 2007 02:34:56 +0900
From: penguin-kernel@I-love.SAKURA.ne.jp
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #5 17/18] Kconfig and Makefile
Content-Disposition: inline; filename=tomoyo-kconfig.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux is placed in security/tomoyo .

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
 security/Kconfig         |    1 +
 security/Makefile        |    1 +
 security/tomoyo/Kconfig  |   26 ++++++++++++++++++++++++++
 security/tomoyo/Makefile |    2 ++
 4 files changed, 30 insertions(+)

--- linux-2.6-mm.orig/security/Kconfig	2007-11-14 15:12:08.000000000 +0900
+++ linux-2.6-mm/security/Kconfig	2007-11-14 15:15:44.000000000 +0900
@@ -104,6 +104,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-2.6-mm.orig/security/Makefile	2007-10-10 05:31:38.000000000 +0900
+++ linux-2.6-mm/security/Makefile	2007-11-14 15:15:44.000000000 +0900
@@ -16,3 +16,4 @@ obj-$(CONFIG_SECURITY)			+= security.o d
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
+obj-$(CONFIG_SECURITY_TOMOYO)           += tomoyo/
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-mm/security/tomoyo/Kconfig	2007-11-14 15:15:44.000000000 +0900
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
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-mm/security/tomoyo/Makefile	2007-11-14 15:15:44.000000000 +0900
@@ -0,0 +1,2 @@
+obj-$(CONFIG_SECURITY_TOMOYO) += tomoyo.o domain.o common.o realpath.o audit.o file.o exec.o net.o mount.o signal.o capability.o condition.o
+EXTRA_CFLAGS += -Isecurity/tomoyo/include

-- 
