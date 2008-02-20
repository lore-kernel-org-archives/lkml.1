Return-Path: <linux-kernel-owner+w=401wt.eu-S1762935AbYBTSKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762935AbYBTSKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 13:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYBTSK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 13:10:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757583AbYBTSK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 13:10:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] FRV: Change the timerfd syscalls to be the same as i386
To: torvalds@osdl.org, apkm@linux-foundation.org, gorcunov@gmail.com
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 18:10:19 +0000
Message-ID: <20080220181019.11052.17220.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220181014.11052.31263.stgit@warthog.procyon.org.uk>
References: <20080220181014.11052.31263.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Change the FRV timerfd syscalls to be the same as i386 timerfd syscalls.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/entry.S  |    4 +++-
 include/asm-frv/unistd.h |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)


diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index ca6a345..f36d7f4 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1494,9 +1494,11 @@ sys_call_table:
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
 	.long sys_signalfd
-	.long sys_ni_syscall
+	.long sys_timerfd_create
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_timerfd_settime	/* 325 */
+	.long sys_timerfd_gettime
 
 
 syscall_table_size = (. - sys_call_table)
diff --git a/include/asm-frv/unistd.h b/include/asm-frv/unistd.h
index e8c9866..f184eb8 100644
--- a/include/asm-frv/unistd.h
+++ b/include/asm-frv/unistd.h
@@ -328,9 +328,11 @@
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
 #define __NR_signalfd		321
-/* #define __NR_timerfd		322 removed */
+#define __NR_timerfd_create	322
 #define __NR_eventfd		323
 #define __NR_fallocate		324
+#define __NR_timerfd_settime	325
+#define __NR_timerfd_gettime	326
 
 #ifdef __KERNEL__
 

