Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbYAHTc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbYAHTc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYAHTcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:32:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbYAHTcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:32:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=L96sL0CkyhRhNZES4gZ7ji84vqc/R/xO99tWnaA7HIq8RlxCS2DBEfcmMncc66OYgiYNkdRs2K9xUEJTK4UfCPqzW+JZ6g5MibJNiiQUv+KUeVuEsAP3S58EKQQzAt+RdQ5wMxR5h3Ij04SnAoN0Boe0PvktXtIPRjq53aws3n0=
Date: Tue, 8 Jan 2008 20:32:23 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: [PATCH 2/5] x86: coding style fixes in arch/x86/ia32/fpu32.c
Message-ID: <20080108203223.5671cd54@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few coding style violations (37 errors).

Checkpatch now reports:
total: 2 errors, 1 warnings, 183 lines checked


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/ia32/fpu32.c |   68 ++++++++++++++++++++++++------------------------
 1 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/x86/ia32/fpu32.c b/arch/x86/ia32/fpu32.c
index 2c8209a..2efc306 100644
--- a/arch/x86/ia32/fpu32.c
+++ b/arch/x86/ia32/fpu32.c
@@ -1,8 +1,8 @@
-/* 
+/*
  * Copyright 2002 Andi Kleen, SuSE Labs.
  * FXSAVE<->i387 conversion support. Based on code by Gareth Hughes.
  * This is used for ptrace, signals and coredumps in 32bit emulation.
- */ 
+ */
 
 #include <linux/sched.h>
 #include <asm/sigcontext32.h>
@@ -13,15 +13,15 @@
 static inline unsigned short twd_i387_to_fxsr(unsigned short twd)
 {
 	unsigned int tmp; /* to avoid 16 bit prefixes in the code */
- 
+
 	/* Transform each pair of bits into 01 (valid) or 00 (empty) */
-        tmp = ~twd;
-        tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
-        /* and move the valid bits to the lower byte. */
-        tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
-        tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
-        tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
-        return tmp;
+	tmp = ~twd;
+	tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
+	/* and move the valid bits to the lower byte. */
+	tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
+	tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
+	tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
+	return tmp;
 }
 
 static inline unsigned long twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
@@ -37,17 +37,17 @@ static inline unsigned long twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
 
 	for (i = 0 ; i < 8 ; i++) {
 		if (twd & 0x1) {
-			st = FPREG_ADDR( fxsave, (i - tos) & 7 );
+			st = FPREG_ADDR(fxsave, (i - tos) & 7);
 
 			switch (st->exponent & 0x7fff) {
 			case 0x7fff:
 				tag = 2;		/* Special */
 				break;
 			case 0x0000:
-				if ( !st->significand[0] &&
+				if (!st->significand[0] &&
 				     !st->significand[1] &&
 				     !st->significand[2] &&
-				     !st->significand[3] ) {
+				     !st->significand[3]) {
 					tag = 1;	/* Zero */
 				} else {
 					tag = 2;	/* Special */
@@ -91,8 +91,8 @@ static inline int convert_fxsr_from_user(struct i387_fxsave_struct *fxsave,
 	G(5, fxsave->rdp);
 	/* 6: ds ignored */
 #undef G
-	if (err) 
-		return -1; 
+	if (err)
+		return -1;
 
 	to = (struct _fpxreg *)&fxsave->st_space[0];
 	from = &buf->_st[0];
@@ -112,57 +112,57 @@ static inline int convert_fxsr_to_user(struct _fpstate_ia32 __user *buf,
 	struct _fpreg __user *to;
 	struct _fpxreg *from;
 	int i;
-	u16 cs,ds; 
-	int err = 0; 
+	u16 cs, ds;
+	int err = 0;
 
 	if (tsk == current) {
 		/* should be actually ds/cs at fpu exception time,
 		   but that information is not available in 64bit mode. */
-		asm("movw %%ds,%0 " : "=r" (ds)); 
-		asm("movw %%cs,%0 " : "=r" (cs)); 		
+		asm("movw %%ds,%0 " : "=r" (ds));
+		asm("movw %%cs,%0 " : "=r" (cs));
 	} else { /* ptrace. task has stopped. */
 		ds = tsk->thread.ds;
 		cs = regs->cs;
-	} 
+	}
 
 #define P(num,val) err |= __put_user(val, num + (u32 __user *)buf)
 	P(0, (u32)fxsave->cwd | 0xffff0000);
 	P(1, (u32)fxsave->swd | 0xffff0000);
 	P(2, twd_fxsr_to_i387(fxsave));
 	P(3, (u32)fxsave->rip);
-	P(4,  cs | ((u32)fxsave->fop) << 16); 
+	P(4,  cs | ((u32)fxsave->fop) << 16);
 	P(5, fxsave->rdp);
 	P(6, 0xffff0000 | ds);
 #undef P
 
-	if (err) 
-		return -1; 
+	if (err)
+		return -1;
 
 	to = &buf->_st[0];
 	from = (struct _fpxreg *) &fxsave->st_space[0];
-	for ( i = 0 ; i < 8 ; i++, to++, from++ ) {
+	for (i = 0 ; i < 8 ; i++, to++, from++) {
 		if (__copy_to_user(to, from, sizeof(*to)))
 			return -1;
 	}
 	return 0;
 }
 
-int restore_i387_ia32(struct task_struct *tsk, struct _fpstate_ia32 __user *buf, int fsave) 
-{ 
+int restore_i387_ia32(struct task_struct *tsk, struct _fpstate_ia32 __user *buf, int fsave)
+{
 	clear_fpu(tsk);
-	if (!fsave) { 
-		if (__copy_from_user(&tsk->thread.i387.fxsave, 
+	if (!fsave) {
+		if (__copy_from_user(&tsk->thread.i387.fxsave,
 				     &buf->_fxsr_env[0],
 				     sizeof(struct i387_fxsave_struct)))
 			return -1;
 		tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
 		set_stopped_child_used_math(tsk);
-	} 
+	}
 	return convert_fxsr_from_user(&tsk->thread.i387.fxsave, buf);
-}  
+}
 
-int save_i387_ia32(struct task_struct *tsk, 
-		   struct _fpstate_ia32 __user *buf, 
+int save_i387_ia32(struct task_struct *tsk,
+		   struct _fpstate_ia32 __user *buf,
 		   struct pt_regs *regs,
 		   int fsave)
 {
@@ -174,8 +174,8 @@ int save_i387_ia32(struct task_struct *tsk,
 	if (fsave)
 		return 0;
 	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
-	if (fsave) 
-		return err ? -1 : 1; 	
+	if (fsave)
+		return err ? -1 : 1;
 	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
 	err |= __copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
 			      sizeof(struct i387_fxsave_struct));
-- 
1.5.4.rc2.17.g257f

