Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYDWJ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYDWJ6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbYDWJw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:52:29 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59474 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbYDWJw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:52:27 -0400
Date: Wed, 23 Apr 2008 12:51:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: wli@holomorphy.com, "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sparc: cleanup after SunOS binary emulation removal
Message-ID: <20080423095148.GC28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following cleanups are now possible:
- arch/sparc/kernel/entry.S:ret_sys_call no longer has to be global
- arch/sparc/kernel/signal.c:sys_sigpause() can be removed

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sparc/kernel/entry.S  |    1 -
 arch/sparc/kernel/signal.c |    5 -----
 2 files changed, 6 deletions(-)

7548ea102f0db3c04f47a3c60242327b02916a5a diff --git a/arch/sparc/kernel/entry.S b/arch/sparc/kernel/entry.S
index 135644f..484c83d 100644
--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -1409,7 +1409,6 @@ syscall_is_too_hard:
 
 	st	%o0, [%sp + STACKFRAME_SZ + PT_I0]
 
-	.globl	ret_sys_call
 ret_sys_call:
 	ld	[%curptr + TI_FLAGS], %l6
 	cmp	%o0, -ERESTART_RESTARTBLOCK
diff --git a/arch/sparc/kernel/signal.c b/arch/sparc/kernel/signal.c
index 1f73061..3e849e8 100644
--- a/arch/sparc/kernel/signal.c
+++ b/arch/sparc/kernel/signal.c
@@ -105,11 +105,6 @@ static int _sigpause_common(old_sigset_t set)
 	return -ERESTARTNOHAND;
 }
 
-asmlinkage int sys_sigpause(unsigned int set)
-{
-	return _sigpause_common(set);
-}
-
 asmlinkage int sys_sigsuspend(old_sigset_t set)
 {
 	return _sigpause_common(set);

