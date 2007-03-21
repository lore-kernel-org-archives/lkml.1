Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXCUWW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXCUWW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965373AbXCUWW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:22:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:40767 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965356AbXCUWW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:22:56 -0400
Date: Wed, 21 Mar 2007 23:23:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 2/3] kbuild: ignore more i386 legacy syscalls
Message-ID: <20070321222317.GC22623@uranus.ravnborg.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <20070320103151.f65c81b6.randy.dunlap@oracle.com> <20070320192016.GC22797@outflux.net> <20070320214714.0e584cd4.akpm@linux-foundation.org> <20070321221905.GA22623@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321221905.GA22623@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9ca09c1ca8e5f65ea9f7f0bb3de71cc70a0f6511 Mon Sep 17 00:00:00 2001
From: David Miller <davem@davemloft.net>
Date: Thu, 8 Mar 2007 16:14:07 -0800
Subject: [PATCH] kbuild: ignore more i386 legacy syscalls

The vast majority of them vector to sys_ni_syscall in the i386 syscall
table.

sys_ugetrlimit is only necessary if the platform started out
using the non-SuS compliant sys_old_getrlimit()

The rest, like ioperm, iopl, modify_ldt, et al. are i386
specific.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 init/missing_syscalls.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/init/missing_syscalls.c b/init/missing_syscalls.c
index e802b06..dc6b97d 100644
--- a/init/missing_syscalls.c
+++ b/init/missing_syscalls.c
@@ -18,6 +18,22 @@
 #endif
 
 /* i386-specific or historical system calls */
+#define __IGNORE_break
+#define __IGNORE_stty
+#define __IGNORE_gtty
+#define __IGNORE_ftime
+#define __IGNORE_prof
+#define __IGNORE_lock
+#define __IGNORE_mpx
+#define __IGNORE_ulimit
+#define __IGNORE_profil
+#define __IGNORE_ioperm
+#define __IGNORE_iopl
+#define __IGNORE_idle
+#define __IGNORE_modify_ldt
+#define __IGNORE_getpmsg
+#define __IGNORE_putpmsg
+#define __IGNORE_ugetrlimit
 #define __IGNORE_mmap2
 #define __IGNORE_vm86
 #define __IGNORE_vm86old
-- 
1.4.4.2

