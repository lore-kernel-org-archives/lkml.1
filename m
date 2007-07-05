Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbXGEL73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbXGEL73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757219AbXGEL7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:59:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143AbXGEL7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:59:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Connect up new syscalls
To: torvalds@osdl.org, akpm@osdl.org, rpjday@mindspring.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Thu, 05 Jul 2007 12:59:13 +0100
Message-ID: <20070705115913.14577.19165.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Connect up new system calls.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/kernel/entry.S  |    4 ++++
 include/asm-frv/unistd.h |    6 +++++-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 43dc08e..275673c 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1492,6 +1492,10 @@ sys_call_table:
 	.long sys_move_pages
 	.long sys_getcpu
 	.long sys_epoll_pwait
+	.long sys_utimensat		/* 320 */
+	.long sys_signalfd
+	.long sys_timerfd
+	.long sys_eventfd
 
 
 syscall_table_size = (. - sys_call_table)
diff --git a/include/asm-frv/unistd.h b/include/asm-frv/unistd.h
index d0ea678..7306c71 100644
--- a/include/asm-frv/unistd.h
+++ b/include/asm-frv/unistd.h
@@ -326,10 +326,14 @@
 #define __NR_move_pages		317
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
+#define __NR_utimensat		320
+#define __NR_signalfd		321
+#define __NR_timerfd		322
+#define __NR_eventfd		323
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 320
+#define NR_syscalls 324
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */

