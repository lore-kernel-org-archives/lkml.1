Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbXJKNcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbXJKNcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 09:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbXJKNcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 09:32:25 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61531 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759626AbXJKNcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:32:23 -0400
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: chrisw@sous-sol.org
Subject: [TOMOYO #4 13/13] Kconfig and Makefile for TOMOYO Linux.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710112225.HGI87594.FVLFOFMJtHSOQO@I-love.SAKURA.ne.jp>
In-Reply-To: <200710112225.HGI87594.FVLFOFMJtHSOQO@I-love.SAKURA.ne.jp>
Message-Id: <200710112232.CFC82337.OJFOOHMFVFtLQS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 11 Oct 2007 22:32:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig and Makefile for TOMOYO Linux.
TOMOYO Linux is placed in security/tomoyo .

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/Kconfig         |    1 +
 security/Makefile        |    1 +
 security/tomoyo/Kconfig  |   18 ++++++++++++++++++
 security/tomoyo/Makefile |    3 +++
 4 files changed, 23 insertions(+)

--- linux-2.6.orig/security/Kconfig	2007-10-11 15:52:19.000000000 +0900
+++ linux-2.6/security/Kconfig	2007-10-11 15:53:12.000000000 +0900
@@ -94,6 +94,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-2.6.orig/security/Makefile	2007-10-11 15:52:19.000000000 +0900
+++ linux-2.6/security/Makefile	2007-10-11 15:53:12.000000000 +0900
@@ -16,3 +16,4 @@ obj-$(CONFIG_SECURITY)			+= security.o d
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
+obj-$(CONFIG_SECURITY_TOMOYO)       += tomoyo/
\ No newline at end of file
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/security/tomoyo/Kconfig	2007-10-11 15:53:12.000000000 +0900
@@ -0,0 +1,18 @@
+config SECURITY_TOMOYO
+	bool "TOMOYO Linux support"
+	depends on SECURITY
+	select SECURITY_NETWORK
+	select AUDIT
+	default n
+	help
+	  This selects TOMOYO Linux.
+
+	  TOMOYO Linux is a domain-based access control method using LSM.
+	  If you answer Y, you will need a policy loader program
+	  (/sbin/tomoyo-init) and some configuration files.
+	  Project page is
+	  <http://tomoyo.sourceforge.jp/>
+
+	  TOMOYO Linux is also applicable to figuring out the behavior
+	  of your system, for TOMOYO uses the canonicalized absolute
+	  pathnames and TreeView style domain transitions.
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/security/tomoyo/Makefile	2007-10-11 15:59:29.000000000 +0900
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_TOMOYO) += tomoyo.o tomoyo_func.o
+tomoyo_func-objs := domain.o common.o realpath.o audit.o file.o exec.o net.o mount.o condition.o
+EXTRA_CFLAGS += -Isecurity/tomoyo/include

