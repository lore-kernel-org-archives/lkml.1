Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZD0K4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZD0K4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756036AbZD0K4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:56:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59544 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbZD0K4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:56:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FRV: Wire up new syscalls
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Mon, 27 Apr 2009 11:55:17 +0100
Message-ID: <20090427105517.26247.30840.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up new system calls for the FRV arch (preadv and pwritev).

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/unistd.h |    4 +++-
 arch/frv/kernel/entry.S       |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)


diff --git a/arch/frv/include/asm/unistd.h b/arch/frv/include/asm/unistd.h
index edcfaf5..96d78d5 100644
--- a/arch/frv/include/asm/unistd.h
+++ b/arch/frv/include/asm/unistd.h
@@ -339,10 +339,12 @@
 #define __NR_dup3		330
 #define __NR_pipe2		331
 #define __NR_inotify_init1	332
+#define __NR_preadv		333
+#define __NR_pwritev		334
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 333
+#define NR_syscalls 335
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
diff --git a/arch/frv/kernel/entry.S b/arch/frv/kernel/entry.S
index 99060ab..1da523b 100644
--- a/arch/frv/kernel/entry.S
+++ b/arch/frv/kernel/entry.S
@@ -1525,5 +1525,7 @@ sys_call_table:
 	.long sys_dup3			/* 330 */
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_preadv
+	.long sys_pwritev
 
 syscall_table_size = (. - sys_call_table)

