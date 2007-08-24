Return-Path: <linux-kernel-owner+w=401wt.eu-S1762928AbXHXMqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762928AbXHXMqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758616AbXHXMp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:45:56 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:60944 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825AbXHXMpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:45:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=A1lXoYk5bOv8fL6bA/PqHoQoZWPRgg/q9VgPjmrKgnUqUesS3ANL2T/zDuv9gq/k8wGMGlbje8krdCvI3eEkgrQj0+Aw8dcGaynGzuuqnAS8Dw2FU+HnqGeJgryT3RdW2SP6sGYcJIm75pzGJ2ItmqZEgQdh060cwmwRW6GCNkg=
Message-ID: <46CED2FC.9030700@gmail.com>
Date: Fri, 24 Aug 2007 21:45:48 +0900
From: Kentaro Takeda <k.takeda26@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: [TOMOYO 02/15] Kconfig and Makefile for TOMOYO Linux.
References: <46CED214.6050505@gmail.com>
In-Reply-To: <46CED214.6050505@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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

--- linux-2.6.orig/security/Kconfig	2007-08-23 21:25:12.000000000 +0900
+++ linux-2.6/security/Kconfig	2007-08-24 15:51:34.000000000 +0900
@@ -94,6 +94,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-2.6.orig/security/Makefile	2007-08-23 21:25:12.000000000 +0900
+++ linux-2.6/security/Makefile	2007-08-24 15:51:34.000000000 +0900
@@ -16,3 +16,4 @@ obj-$(CONFIG_SECURITY)			+= security.o d
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
+obj-$(CONFIG_SECURITY_TOMOYO)       += tomoyo/
\ No newline at end of file
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/security/tomoyo/Kconfig	2007-08-24 15:51:34.000000000 +0900
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
+++ linux-2.6/security/tomoyo/Makefile	2007-08-24 15:51:34.000000000 +0900
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_TOMOYO) += tomoyo.o tomoyo_func.o
+tomoyo_func-objs := domain.o common.o realpath.o audit.o file.o exec.o net.o mount.o signal.o condition.o
+EXTRA_CFLAGS += -Isecurity/tomoyo/include

