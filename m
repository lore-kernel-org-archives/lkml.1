Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbZF3VZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbZF3VZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbZF3VZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:25:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47089 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589AbZF3VZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:25:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Wire up new syscalls
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 30 Jun 2009 22:24:54 +0100
Message-ID: <20090630212454.19294.75622.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up new syscalls rt_tgsigqueueinfo and perf_counter_open.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/unistd.h |    4 +++-
 arch/frv/kernel/entry.S       |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index 96d78d5..4a8fb42 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -341,10 +341,12 @@
 #define __NR_inotify_init1	332
 #define __NR_preadv		333
 #define __NR_pwritev		334
+#define __NR_rt_tgsigqueueinfo	335
+#define __NR_perf_counter_open	336
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 335
+#define NR_syscalls 337
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 356e0e3..fde1e44 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1524,5 +1524,7 @@ sys_call_table:
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev
+	.long sys_rt_tgsigqueueinfo	/* 335 */
+	.long sys_perf_counter_open
 
 syscall_table_size = (. - sys_call_table)

