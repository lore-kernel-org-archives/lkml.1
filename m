Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYIXJHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYIXJHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYIXJFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:05:48 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:61495 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYIXJFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:05:35 -0400
Message-Id: <20080924090354.348298594@nttdata.co.jp>
References: <20080924090317.359685535@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Wed, 24 Sep 2008 18:03:23 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #9 (2.6.27-rc7-mm1) 6/6] Kconfig and Makefile
X-OriginalArrivalTime: 24 Sep 2008 09:05:33.0048 (UTC) FILETIME=[B32CBF80:01C91E24]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/Kconfig         |    1 +
 security/Makefile        |    2 ++
 security/tomoyo/Kconfig  |   11 +++++++++++
 security/tomoyo/Makefile |    1 +
 4 files changed, 15 insertions(+)

--- linux-2.6.27-rc7-mm1.orig/security/Kconfig
+++ linux-2.6.27-rc7-mm1/security/Kconfig
@@ -125,6 +125,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-2.6.27-rc7-mm1.orig/security/Makefile
+++ linux-2.6.27-rc7-mm1/security/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
+subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 
 # always enable default capabilities
 obj-y		+= commoncap.o
@@ -17,3 +18,4 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selin
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
+obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
--- /dev/null
+++ linux-2.6.27-rc7-mm1/security/tomoyo/Kconfig
@@ -0,0 +1,11 @@
+config SECURITY_TOMOYO
+	bool "TOMOYO Linux Support"
+	depends on SECURITY
+	select SECURITYFS
+	select SECURITY_PATH
+	default n
+	help
+	  This selects TOMOYO Linux, pathname-based access control.
+	  Required userspace tools and further information may be
+          found at <http://tomoyo.sourceforge.jp/>.
+	  If you are unsure how to answer this question, answer N.
--- /dev/null
+++ linux-2.6.27-rc7-mm1/security/tomoyo/Makefile
@@ -0,0 +1 @@
+obj-y = common.o realpath.o tomoyo.o domain.o file.o

--

