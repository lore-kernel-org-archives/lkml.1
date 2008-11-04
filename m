Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYKDGMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYKDGMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYKDGKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:10:16 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:46089 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbYKDGKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:10:01 -0500
Message-Id: <20081104060958.273022071@nttdata.co.jp>
References: <20081104060847.086543472@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Tue, 04 Nov 2008 15:08:57 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Toshiharu Harada <haradats@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #12 (2.6.28-rc2-mm1) 10/11] Kconfig and Makefile
X-OriginalArrivalTime: 04 Nov 2008 06:09:59.0301 (UTC) FILETIME=[F7824350:01C93E43]
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

--- linux-2.6.28-rc2-mm1.orig/security/Kconfig
+++ linux-2.6.28-rc2-mm1/security/Kconfig
@@ -134,6 +134,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-2.6.28-rc2-mm1.orig/security/Makefile
+++ linux-2.6.28-rc2-mm1/security/Makefile
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
+++ linux-2.6.28-rc2-mm1/security/tomoyo/Kconfig
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
+++ linux-2.6.28-rc2-mm1/security/tomoyo/Makefile
@@ -0,0 +1 @@
+obj-y = common.o realpath.o tomoyo.o domain.o file.o

--

