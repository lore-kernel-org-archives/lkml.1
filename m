Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbYJIEca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbYJIEca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbYJIE3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:29:44 -0400
Received: from ms1.nttdata.co.jp ([163.135.193.232]:52285 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbYJIE3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:29:31 -0400
Message-Id: <20081009042927.636755827@nttdata.co.jp>
References: <20081009042814.398846861@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 09 Oct 2008 13:28:22 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toshiharu Harada <haradats@nttdata.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [TOMOYO #10 (linux-next) 8/8] Kconfig and Makefile
X-OriginalArrivalTime: 09 Oct 2008 04:29:29.0351 (UTC) FILETIME=[9EA36970:01C929C7]
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

--- linux-next.orig/security/Kconfig
+++ linux-next/security/Kconfig
@@ -134,6 +134,7 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
+source security/tomoyo/Kconfig
 
 endmenu
 
--- linux-next.orig/security/Makefile
+++ linux-next/security/Makefile
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
+++ linux-next/security/tomoyo/Kconfig
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
+++ linux-next/security/tomoyo/Makefile
@@ -0,0 +1 @@
+obj-y = common.o realpath.o tomoyo.o domain.o file.o

--

