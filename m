Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbYKTLmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbYKTLmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYKTLm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:42:27 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:61927 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbYKTLm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:42:26 -0500
Message-Id: <20081120112735.714537916@I-love.SAKURA.ne.jp>
References: <20081120112543.799450455@I-love.SAKURA.ne.jp>
User-Agent: quilt/0.46-1
Date: Thu, 20 Nov 2008 20:25:53 +0900
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #13 (mmotm 2008-11-19-02-19) 10/11] Kconfig and Makefile
Content-Disposition: inline; filename=tomoyo-makefile.patch
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

--- linux-2.6.28-rc5-mm1.orig/security/Kconfig
+++ linux-2.6.28-rc5-mm1/security/Kconfig
@@ -134,6 +134,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-2.6.28-rc5-mm1.orig/security/Makefile
+++ linux-2.6.28-rc5-mm1/security/Makefile
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
+++ linux-2.6.28-rc5-mm1/security/tomoyo/Kconfig
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
+++ linux-2.6.28-rc5-mm1/security/tomoyo/Makefile
@@ -0,0 +1 @@
+obj-y = common.o realpath.o tomoyo.o domain.o file.o

-- 
