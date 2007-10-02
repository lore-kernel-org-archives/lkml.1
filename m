Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbXJBHlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbXJBHlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXJBHkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:40:51 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:55694 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbXJBHku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:40:50 -0400
Message-ID: <4701F5F7.7030905@nttdata.co.jp>
Date: Tue, 02 Oct 2007 16:40:39 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.6) Gecko/20070728 Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
CC: chrisw@sous-sol.org
Subject: [TOMOYO 15/15](repost) Kconfig and Makefile for TOMOYO Linux.
References: <4701F285.5000206@nttdata.co.jp>
In-Reply-To: <4701F285.5000206@nttdata.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2007 07:40:40.0610 (UTC) FILETIME=[87F5E020:01C804C7]
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

--- linux-2.6.orig/security/Kconfig	2007-10-02 11:11:53.000000000 +0900
+++ linux-2.6/security/Kconfig	2007-10-02 11:26:21.000000000 +0900
@@ -94,6 +94,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-2.6.orig/security/Makefile	2007-10-02 11:11:53.000000000 +0900
+++ linux-2.6/security/Makefile	2007-10-02 11:26:21.000000000 +0900
@@ -16,3 +16,4 @@ obj-$(CONFIG_SECURITY)			+= security.o d
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
+obj-$(CONFIG_SECURITY_TOMOYO)       += tomoyo/
\ No newline at end of file
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/security/tomoyo/Kconfig	2007-10-02 11:26:21.000000000 +0900
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
+	  You can get them from
+	  <http://tomoyo.sourceforge.jp/en/2.1.x/>
+
+	  TOMOYO Linux is also applicable to figuring out the behavior
+	  of your system, for TOMOYO uses the canonicalized absolute
+	  pathnames and TreeView style domain transitions.
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/security/tomoyo/Makefile	2007-10-02 11:26:21.000000000 +0900
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_TOMOYO) += tomoyo.o tomoyo_func.o
+tomoyo_func-objs := domain.o common.o realpath.o audit.o file.o exec.o net.o mount.o signal.o condition.o
+EXTRA_CFLAGS += -Isecurity/tomoyo/include


