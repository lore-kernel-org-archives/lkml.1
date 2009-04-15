Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbZDOShU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbZDOShU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZDOSgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:36:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60229 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbZDOSgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:36:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/5] MN10300: Wire up missing system calls
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 15 Apr 2009 19:34:46 +0100
Message-ID: <20090415183446.11029.97069.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
References: <20090415183441.11029.30619.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wire up missing system calls preadv() and pwritev().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/unistd.h |    2 ++
 arch/mn10300/kernel/entry.S       |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/include/asm/unistd.h b/arch/mn10300/include/asm/unistd.h
index 543a4f9..fef5b43 100644
--- a/arch/mn10300/include/asm/unistd.h
+++ b/arch/mn10300/include/asm/unistd.h
@@ -344,6 +344,8 @@
 #define __NR_dup3		331
 #define __NR_pipe2		332
 #define __NR_inotify_init1	333
+#define __NR_preadv		334
+#define __NR_pwritev		335
 
 #ifdef __KERNEL__
 
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 34ab5a2..3dc3e46 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -723,6 +723,8 @@ ENTRY(sys_call_table)
 	.long sys_dup3
 	.long sys_pipe2
 	.long sys_inotify_init1
+	.long sys_preadv
+	.long sys_pwritev		/* 335 */
 
 
 nr_syscalls=(.-sys_call_table)/4

