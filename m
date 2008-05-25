Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYEYRBE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYEYRBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 13:01:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYEYRAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 13:00:51 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55868 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbYEYRAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 13:00:50 -0400
Date: Sun, 25 May 2008 19:58:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sparc64: global_reg_snapshot is not for userspace
Message-ID: <20080525165813.GC1791@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

global_reg_snapshot shouldn't be visible in our userspace headers.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-sparc64/ptrace.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

bcd3ca7553a2f3e416db385fd976ef5b862b1370 diff --git a/include/asm-sparc64/ptrace.h b/include/asm-sparc64/ptrace.h
index d8a56cd..b163da7 100644
--- a/include/asm-sparc64/ptrace.h
+++ b/include/asm-sparc64/ptrace.h
@@ -126,6 +126,8 @@ struct sparc_trapf {
 #define TRACEREG32_SZ	sizeof(struct pt_regs32)
 #define STACKFRAME32_SZ	sizeof(struct sparc_stackf32)
 
+#ifdef __KERNEL__
+
 struct global_reg_snapshot {
 	unsigned long		tstate;
 	unsigned long		tpc;
@@ -137,8 +139,6 @@ struct global_reg_snapshot {
 	unsigned long		pad2;
 };
 
-#ifdef __KERNEL__
-
 #define __ARCH_WANT_COMPAT_SYS_PTRACE
 
 #define force_successful_syscall_return()	    \
@@ -306,6 +306,8 @@ extern void __show_regs(struct pt_regs *);
 #define SF_XARG5  0x58
 #define SF_XXARG  0x5c
 
+#ifdef __KERNEL__
+
 /* global_reg_snapshot offsets */
 #define GR_SNAP_TSTATE	0x00
 #define GR_SNAP_TPC	0x08
@@ -316,6 +318,8 @@ extern void __show_regs(struct pt_regs *);
 #define GR_SNAP_PAD1	0x30
 #define GR_SNAP_PAD2	0x38
 
+#endif  /*  __KERNEL__  */
+
 /* Stuff for the ptrace system call */
 #define PTRACE_SPARC_DETACH       11
 #define PTRACE_GETREGS            12

