Return-Path: <linux-kernel-owner+w=401wt.eu-S1761116AbYEAF67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761116AbYEAF67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 01:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757689AbYEAF43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 01:56:29 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:43414 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbYEAF4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 01:56:07 -0400
Message-Id: <20080501055559.577648000@nttdata.co.jp>
References: <20080501055405.024390000@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 01 May 2008 14:54:12 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
To: akpm@linux-foundation.org, chrisw@sous-sol.org, viro@ZenIV.linux.org.uk
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #8 (2.6.25-mm1) 7/7] Kconfig and Makefile
X-OriginalArrivalTime: 01 May 2008 05:56:01.0776 (UTC) FILETIME=[090ED700:01C8AB50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/Kconfig         |    1 +
 security/Makefile        |    2 ++
 security/tomoyo/Kconfig  |    9 +++++++++
 security/tomoyo/Makefile |    1 +
 4 files changed, 13 insertions(+)

--- mm.orig/security/Kconfig
+++ mm/security/Kconfig
@@ -124,6 +124,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- mm.orig/security/Makefile
+++ mm/security/Makefile
@@ -5,6 +5,7 @@
 obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
+subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
 
 # if we don't select a security model, use the default capabilities
 ifneq ($(CONFIG_SECURITY),y)
@@ -16,6 +17,7 @@ obj-$(CONFIG_SECURITY)			+= security.o d
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= commoncap.o smack/built-in.o
+obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
--- /dev/null
+++ mm/security/tomoyo/Kconfig
@@ -0,0 +1,9 @@
+config SECURITY_TOMOYO
+	bool "TOMOYO Linux Support"
+	depends on SECURITY
+	default n
+	help
+	  This selects TOMOYO Linux, pathname-based access control.
+	  Required userspace tools and further information may be
+          found at <http://tomoyo.sourceforge.jp/>.
+	  If you are unsure how to answer this question, answer N.
--- /dev/null
+++ mm/security/tomoyo/Makefile
@@ -0,0 +1 @@
+obj-y = common.o realpath.o tomoyo.o domain.o file.o

--

