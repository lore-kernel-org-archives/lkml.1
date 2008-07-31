Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYGaMCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYGaMCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYGaMCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:02:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYGaMCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:02:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Wire up new system calls
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Date: Thu, 31 Jul 2008 13:01:30 +0100
Message-ID: <20080731120130.14303.5790.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up system calls added in the last merge window for the MN10300 arch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/entry.S  |    6 ++++++
 include/asm-mn10300/unistd.h |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index beb4017..62fba8a 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -717,6 +717,12 @@ ENTRY(sys_call_table)
 	.long sys_fallocate		/* 325 */
 	.long sys_timerfd_settime
 	.long sys_timerfd_gettime
+	.long sys_signalfd4
+	.long sys_eventfd2
+	.long sys_epoll_create1		/* 330 */
+	.long sys_dup3
+	.long sys_pipe2
+	.long sys_inotify_init1
 
 
 nr_syscalls=(.-sys_call_table)/4
diff --git a/include/asm-mn10300/unistd.h b/include/asm-mn10300/unistd.h
index 3721aa9..543a4f9 100644
--- a/include/asm-mn10300/unistd.h
+++ b/include/asm-mn10300/unistd.h
@@ -338,6 +338,12 @@
 #define __NR_fallocate		325
 #define __NR_timerfd_settime	326
 #define __NR_timerfd_gettime	327
+#define __NR_signalfd4		328
+#define __NR_eventfd2		329
+#define __NR_epoll_create1	330
+#define __NR_dup3		331
+#define __NR_pipe2		332
+#define __NR_inotify_init1	333
 
 #ifdef __KERNEL__
 

