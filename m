Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXFNJp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXFNJp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXFNJoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:44:55 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:41638 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbXFNJoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:44:54 -0400
Message-ID: <4670EF35.7030100@nttdata.co.jp>
Date: Thu, 14 Jun 2007 16:33:09 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [TOMOYO 2/9] Kconfig and Makefile for TOMOYO Linux.
References: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
In-Reply-To: <5fb14edc0706140030x4a906178ofd35df06dfa5c192@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jun 2007 07:33:09.0496 (UTC) FILETIME=[41A2D780:01C7AE56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux 2.0 is implemented using LSM and auditing subsystem.
When you use TOMOYO, you need to enable auditing support and disable all features
(other than TOMOYO Linux) that use LSM because TOMOYO Linux 2.0 has to be built-in.
If you don't want to disable any features that use LSM, please use TOMOYO Linux 1.4.1 instead.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

---------------
 security/Kconfig         |    1 +
 security/Makefile        |    1 +
 security/tomoyo/Kconfig  |   22 ++++++++++++++++++++++
 security/tomoyo/Makefile |    3 +++
 4 files changed, 27 insertions(+)

diff -ubBpErN linux-2.6.21.5/security/Kconfig linux-2.6.21.5-tomoyo/security/Kconfig
--- linux-2.6.21.5/security/Kconfig	2007-06-12 03:37:06.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/Kconfig	2007-06-14 15:02:38.000000000 +0900
@@ -94,6 +94,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
diff -ubBpErN linux-2.6.21.5/security/Makefile linux-2.6.21.5-tomoyo/security/Makefile
--- linux-2.6.21.5/security/Makefile	2007-06-12 03:37:06.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/Makefile	2007-06-14 15:02:38.000000000 +0900
@@ -16,3 +16,4 @@ obj-$(CONFIG_SECURITY)			+= security.o d
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
+obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
diff -ubBpErN linux-2.6.21.5/security/tomoyo/Kconfig linux-2.6.21.5-tomoyo/security/tomoyo/Kconfig
--- linux-2.6.21.5/security/tomoyo/Kconfig	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/Kconfig	2007-06-05 00:00:00.000000000 +0900
@@ -0,0 +1,22 @@
+config SECURITY_TOMOYO
+	bool "TOMOYO Linux support"
+	depends on SECURITY && AUDIT
+	help
+	  Say Y here to support TOMOYO Linux.
+
+	  TOMOYO Linux is applicable to figuring out the system's behavior,
+	  for TOMOYO uses the canonicalized absolute pathnames and
+	  TreeView style domain transitions.
+
+config TOMOYO_MAX_ACCEPT_ENTRY
+	int "Default maximal count for accept mode"
+	default 2048
+	range 0 2147483647
+	depends on SECURITY_TOMOYO
+	help
+	  This is the default value for maximal ACL entries
+	  that are automatically appended into policy at "accept mode".
+	  Some programs access thousands of objects, so running
+	  such programs in "accept mode" dulls the system response
+	  and consumes much memory.
+	  This is the safeguard for such programs.
diff -ubBpErN linux-2.6.21.5/security/tomoyo/Makefile linux-2.6.21.5-tomoyo/security/tomoyo/Makefile
--- linux-2.6.21.5/security/tomoyo/Makefile	1970-01-01 09:00:00.000000000 +0900
+++ linux-2.6.21.5-tomoyo/security/tomoyo/Makefile	2007-06-05 00:00:00.000000000 +0900
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SECURITY_TOMOYO) += tomoyo.o tomoyo_func.o
+tomoyo_func-objs := domain.o common.o realpath.o file.o audit.o
+EXTRA_CFLAGS += -Isecurity/tomoyo/include
---------------

