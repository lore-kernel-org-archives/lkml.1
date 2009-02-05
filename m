Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbZBEJGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbZBEJGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbZBEJEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:04:45 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:53381 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531AbZBEJEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:04:43 -0500
Message-Id: <20090205082234.211966947@nttdata.co.jp>
References: <20090205081810.331987920@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 05 Feb 2009 17:18:17 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #15 7/8] Kconfig and Makefile
X-OriginalArrivalTime: 05 Feb 2009 08:22:35.0589 (UTC) FILETIME=[E63E3750:01C9876A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO uses LSM hooks for pathname based access control and securityfs support.

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/Kconfig         |    1 +
 security/Makefile        |    2 ++
 security/tomoyo/Kconfig  |   11 +++++++++++
 security/tomoyo/Makefile |    1 +
 4 files changed, 15 insertions(+)

--- security-testing-2.6.git.orig/security/Kconfig
+++ security-testing-2.6.git/security/Kconfig
@@ -134,6 +134,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- security-testing-2.6.git.orig/security/Makefile
+++ security-testing-2.6.git/security/Makefile
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
+++ security-testing-2.6.git/security/tomoyo/Kconfig
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
+	  found at <http://tomoyo.sourceforge.jp/>.
+	  If you are unsure how to answer this question, answer N.
--- /dev/null
+++ security-testing-2.6.git/security/tomoyo/Makefile
@@ -0,0 +1 @@
+obj-y = common.o realpath.o tomoyo.o domain.o file.o

--

