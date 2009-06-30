Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbZF3VeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbZF3VeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755319AbZF3VeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:34:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZF3VeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:34:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] MN10300: Wire up new syscalls
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Date: Tue, 30 Jun 2009 22:33:15 +0100
Message-ID: <20090630213315.20951.36489.stgit@warthog.procyon.org.uk>
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

 arch/mn10300/include/asm/unistd.h |    4 +++-
 arch/mn10300/kernel/entry.S       |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/arch/mn10300/include/asm/unistd.h b/arch/mn10300/include/asm/unistd.h
index fef5b43..fad6861 100644
--- a/arch/mn10300/include/asm/unistd.h
+++ b/arch/mn10300/include/asm/unistd.h
@@ -346,10 +346,12 @@
 #define __NR_inotify_init1	333
 #define __NR_preadv		334
 #define __NR_pwritev		335
+#define __NR_rt_tgsigqueueinfo	336
+#define __NR_perf_counter_open	337
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 326
+#define NR_syscalls 338
 
 /*
  * specify the deprecated syscalls we want to support on this arch
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 7408a27..e0d2563 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -722,6 +722,8 @@ ENTRY(sys_call_table)
 	.long sys_inotify_init1
 	.long sys_preadv
 	.long sys_pwritev		/* 335 */
+	.long sys_rt_tgsigqueueinfo
+	.long sys_perf_counter_open
 
 
 nr_syscalls=(.-sys_call_table)/4

