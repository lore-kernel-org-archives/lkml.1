Return-Path: <linux-kernel-owner+w=401wt.eu-S1161347AbXCIAOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161347AbXCIAOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161353AbXCIAOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:14:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57692
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1161347AbXCIAOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:14:08 -0500
Date: Thu, 08 Mar 2007 16:14:07 -0800 (PST)
Message-Id: <20070308.161407.63995586.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       rmk@arm.linux.org.uk, sam@ravnborg.org
Subject: Re: [PATCH] Complain about missing system calls.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1173394873.3461.510.camel@pmac.infradead.org>
References: <1173394873.3461.510.camel@pmac.infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Thu, 08 Mar 2007 23:01:13 +0000

> Most system calls seem to get added to i386 first. This patch
> automatically generates a warning for any new system call which is
> implemented on i386 but not the architecture currently being compiled.
> On PowerPC at the moment, for example, it results in these warnings:
> init/missing_syscalls.h:935:3: warning: #warning syscall sync_file_range not implemented
> init/missing_syscalls.h:947:3: warning: #warning syscall getcpu not implemented
> init/missing_syscalls.h:950:3: warning: #warning syscall epoll_pwait not implemented
> 
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>

David, thanks for this __incredibly__ __useful__ patch.  I kicked it
around on sparc64 and found some more ignores to add, see below.

The vast majority of them vector to sys_ni_syscall in the i386 syscall
table.

sys_ugetrlimit is only necessary if the platform started out
using the non-SuS compliant sys_old_getrlimit()

The rest, like ioperm, iopl, modify_ldt, et al. are i386
specific.

Signed-off-by: David S. Miller <davem@davemloft.net>

--- a/init/missing_syscalls.c.ORIG	2007-03-08 16:11:00.000000000 -0800
+++ b/init/missing_syscalls.c	2007-03-08 16:02:30.000000000 -0800
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
