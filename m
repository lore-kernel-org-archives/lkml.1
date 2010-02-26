Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966286Ab0BZVj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:39:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966257Ab0BZViH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:38:07 -0500
Date: Fri, 26 Feb 2010 16:37:42 -0500
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <f13e52e38e2bccd52f9c5959530b88ddfe73de42.1267214187.git.jbaron@redhat.com>
In-Reply-To: <cover.1267214186.git.jbaron@redhat.com>
References: <cover.1267214186.git.jbaron@redhat.com>
Subject: [PATCH 11/12] tags: recognize syscalls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make tags.sh recognize the new syscall macros:

COMPAT_SYSCALL_DEFINE#N()
ARCH_COMPAT_SYSCALL_DEFINE#N()

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 scripts/tags.sh |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 1a0c44d..d9c703d 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -110,7 +110,9 @@ exuberant()
 	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
 	--extra=+f --c-kinds=-px                                \
 	--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'                  \
-	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'
+	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
+	--regex-c='/^COMPAT_SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/compat_sys_\1/' \
+	--regex-c='/^ARCH_COMPAT_SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/arch_compat_sys_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--langdef=kconfig --language-force=kconfig              \
@@ -130,7 +132,9 @@ emacs()
 {
 	all_sources | xargs $1 -a                               \
 	--regex='/^ENTRY(\([^)]*\)).*/\1/'                      \
-	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'
+	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
+	--regex='/^COMPAT_SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/compat_sys_\1/' \
+	--regex='/^ARCH_COMPAT_SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/arch_compat_sys_\1/'
 
 	all_kconfigs | xargs $1 -a                              \
 	--regex='/^[ \t]*\(\(menu\)*config\)[ \t]+\([a-zA-Z0-9_]+\)/\3/'
-- 
1.6.5.1

