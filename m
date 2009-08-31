Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbZHaRI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbZHaRI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZHaRIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:08:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:32907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZHaRIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:08:19 -0400
Date: Mon, 31 Aug 2009 17:07:28 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, ehrhardt@linux.vnet.ibm.com, arnd@arndb.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       zippel@linux-m68k.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com, paulus@samba.org, horsth@linux.vnet.ibm.com,
       davem@davemloft.net, benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       ehrhardt@linux.vnet.ibm.com, arnd@arndb.de, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       horsth@linux.vnet.ibm.com, davem@davemloft.net,
       benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, nickpiggin@yahoo.com.au, mingo@elte.hu
In-Reply-To: <20090831124416.666403991@de.ibm.com>
References: <20090831124416.666403991@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking, m68k/asm-offsets: Rename pt_regs offset defines
Message-ID: <tip-f159ee782990aacb5494738c98f13a2aa61dbb4a@git.kernel.org>
Git-Commit-ID: f159ee782990aacb5494738c98f13a2aa61dbb4a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 17:07:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f159ee782990aacb5494738c98f13a2aa61dbb4a
Gitweb:     http://git.kernel.org/tip/f159ee782990aacb5494738c98f13a2aa61dbb4a
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 31 Aug 2009 14:43:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 18:08:49 +0200

locking, m68k/asm-offsets: Rename pt_regs offset defines

In order to be able to use asm-offsets.h in C files the
existing namespace conflicts must be solved first. In
asm-offsets.h e.g. PT_D0 gets defined which is the offset of
the d0 member of the pt_regs structure. However a same define
(with a different meaning) exists in asm/ptregs.h.

So rename the defines created with the asm-offset mechanism to
PT_OFF_D0 etc. There also already exist a few defines with
these names that have the same meaning. So remove the existing
defines and use the asm-offset generated ones.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: <linux-arch@vger.kernel.org>
LKML-Reference: <20090831124416.666403991@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/m68k/include/asm/entry_mm.h |    3 ---
 arch/m68k/include/asm/entry_no.h |    8 ++++----
 arch/m68k/include/asm/math-emu.h |   20 ++++++++++----------
 arch/m68k/kernel/asm-offsets.c   |   26 +++++++++++++-------------
 arch/m68k/kernel/entry.S         |   22 +++++++++++-----------
 arch/m68k/math-emu/fp_entry.S    |   30 +++++++++++++++---------------
 6 files changed, 53 insertions(+), 56 deletions(-)

diff --git a/arch/m68k/include/asm/entry_mm.h b/arch/m68k/include/asm/entry_mm.h
index 5202f5a..4fcfc28 100644
--- a/arch/m68k/include/asm/entry_mm.h
+++ b/arch/m68k/include/asm/entry_mm.h
@@ -118,9 +118,6 @@ PT_DTRACE_BIT = 2
 #define STR(X) STR1(X)
 #define STR1(X) #X
 
-#define PT_OFF_ORIG_D0	 0x24
-#define PT_OFF_FORMATVEC 0x32
-#define PT_OFF_SR	 0x2C
 #define SAVE_ALL_INT				\
 	"clrl	%%sp@-;"    /* stk_adj */	\
 	"pea	-1:w;"	    /* orig d0 = -1 */	\
diff --git a/arch/m68k/include/asm/entry_no.h b/arch/m68k/include/asm/entry_no.h
index c2553d2..907ed03 100644
--- a/arch/m68k/include/asm/entry_no.h
+++ b/arch/m68k/include/asm/entry_no.h
@@ -72,8 +72,8 @@ LENOSYS = 38
 	lea	%sp@(-32),%sp		/* space for 8 regs */
 	moveml	%d1-%d5/%a0-%a2,%sp@
 	movel	sw_usp,%a0		/* get usp */
-	movel	%a0@-,%sp@(PT_PC)	/* copy exception program counter */
-	movel	%a0@-,%sp@(PT_FORMATVEC)/* copy exception format/vector/sr */
+	movel	%a0@-,%sp@(PT_OFF_PC)	/* copy exception program counter */
+	movel	%a0@-,%sp@(PT_OFF_FORMATVEC)/*copy exception format/vector/sr */
 	bra	7f
 	6:
 	clrl	%sp@-			/* stkadj */
@@ -89,8 +89,8 @@ LENOSYS = 38
 	bnes	8f			/* no, skip */
 	move	#0x2700,%sr		/* disable intrs */
 	movel	sw_usp,%a0		/* get usp */
-	movel	%sp@(PT_PC),%a0@-	/* copy exception program counter */
-	movel	%sp@(PT_FORMATVEC),%a0@-/* copy exception format/vector/sr */
+	movel	%sp@(PT_OFF_PC),%a0@-	/* copy exception program counter */
+	movel	%sp@(PT_OFF_FORMATVEC),%a0@-/*copy exception format/vector/sr */
 	moveml	%sp@,%d1-%d5/%a0-%a2
 	lea	%sp@(32),%sp		/* space for 8 regs */
 	movel	%sp@+,%d0
diff --git a/arch/m68k/include/asm/math-emu.h b/arch/m68k/include/asm/math-emu.h
index ddfab96..5e9249b 100644
--- a/arch/m68k/include/asm/math-emu.h
+++ b/arch/m68k/include/asm/math-emu.h
@@ -145,16 +145,16 @@ extern unsigned int fp_debugprint;
  * these are only used during instruction decoding
  * where we always know how deep we're on the stack.
  */
-#define FPS_DO		(PT_D0)
-#define FPS_D1		(PT_D1)
-#define FPS_D2		(PT_D2)
-#define FPS_A0		(PT_A0)
-#define FPS_A1		(PT_A1)
-#define FPS_A2		(PT_A2)
-#define FPS_SR		(PT_SR)
-#define FPS_PC		(PT_PC)
-#define FPS_EA		(PT_PC+6)
-#define FPS_PC2		(PT_PC+10)
+#define FPS_DO		(PT_OFF_D0)
+#define FPS_D1		(PT_OFF_D1)
+#define FPS_D2		(PT_OFF_D2)
+#define FPS_A0		(PT_OFF_A0)
+#define FPS_A1		(PT_OFF_A1)
+#define FPS_A2		(PT_OFF_A2)
+#define FPS_SR		(PT_OFF_SR)
+#define FPS_PC		(PT_OFF_PC)
+#define FPS_EA		(PT_OFF_PC+6)
+#define FPS_PC2		(PT_OFF_PC+10)
 
 .macro	fp_get_fp_reg
 	lea	(FPD_FPREG,FPDATA,%d0.w*4),%a0
diff --git a/arch/m68k/kernel/asm-offsets.c b/arch/m68k/kernel/asm-offsets.c
index b1f012f..0cffab8 100644
--- a/arch/m68k/kernel/asm-offsets.c
+++ b/arch/m68k/kernel/asm-offsets.c
@@ -44,20 +44,20 @@ int main(void)
 	DEFINE(TINFO_FLAGS, offsetof(struct thread_info, flags));
 
 	/* offsets into the pt_regs */
-	DEFINE(PT_D0, offsetof(struct pt_regs, d0));
-	DEFINE(PT_ORIG_D0, offsetof(struct pt_regs, orig_d0));
-	DEFINE(PT_D1, offsetof(struct pt_regs, d1));
-	DEFINE(PT_D2, offsetof(struct pt_regs, d2));
-	DEFINE(PT_D3, offsetof(struct pt_regs, d3));
-	DEFINE(PT_D4, offsetof(struct pt_regs, d4));
-	DEFINE(PT_D5, offsetof(struct pt_regs, d5));
-	DEFINE(PT_A0, offsetof(struct pt_regs, a0));
-	DEFINE(PT_A1, offsetof(struct pt_regs, a1));
-	DEFINE(PT_A2, offsetof(struct pt_regs, a2));
-	DEFINE(PT_PC, offsetof(struct pt_regs, pc));
-	DEFINE(PT_SR, offsetof(struct pt_regs, sr));
+	DEFINE(PT_OFF_D0, offsetof(struct pt_regs, d0));
+	DEFINE(PT_OFF_ORIG_D0, offsetof(struct pt_regs, orig_d0));
+	DEFINE(PT_OFF_D1, offsetof(struct pt_regs, d1));
+	DEFINE(PT_OFF_D2, offsetof(struct pt_regs, d2));
+	DEFINE(PT_OFF_D3, offsetof(struct pt_regs, d3));
+	DEFINE(PT_OFF_D4, offsetof(struct pt_regs, d4));
+	DEFINE(PT_OFF_D5, offsetof(struct pt_regs, d5));
+	DEFINE(PT_OFF_A0, offsetof(struct pt_regs, a0));
+	DEFINE(PT_OFF_A1, offsetof(struct pt_regs, a1));
+	DEFINE(PT_OFF_A2, offsetof(struct pt_regs, a2));
+	DEFINE(PT_OFF_PC, offsetof(struct pt_regs, pc));
+	DEFINE(PT_OFF_SR, offsetof(struct pt_regs, sr));
 	/* bitfields are a bit difficult */
-	DEFINE(PT_VECTOR, offsetof(struct pt_regs, pc) + 4);
+	DEFINE(PT_OFF_FORMATVEC, offsetof(struct pt_regs, pc) + 4);
 
 	/* offsets into the irq_handler struct */
 	DEFINE(IRQ_HANDLER, offsetof(struct irq_node, handler));
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index c3735cd..922f52e 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -77,17 +77,17 @@ ENTRY(ret_from_fork)
 	jra	.Lret_from_exception
 
 do_trace_entry:
-	movel	#-ENOSYS,%sp@(PT_D0)	| needed for strace
+	movel	#-ENOSYS,%sp@(PT_OFF_D0)| needed for strace
 	subql	#4,%sp
 	SAVE_SWITCH_STACK
 	jbsr	syscall_trace
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
-	movel	%sp@(PT_ORIG_D0),%d0
+	movel	%sp@(PT_OFF_ORIG_D0),%d0
 	cmpl	#NR_syscalls,%d0
 	jcs	syscall
 badsys:
-	movel	#-ENOSYS,%sp@(PT_D0)
+	movel	#-ENOSYS,%sp@(PT_OFF_D0)
 	jra	ret_from_syscall
 
 do_trace_exit:
@@ -103,7 +103,7 @@ ENTRY(ret_from_signal)
 	addql	#4,%sp
 /* on 68040 complete pending writebacks if any */
 #ifdef CONFIG_M68040
-	bfextu	%sp@(PT_VECTOR){#0,#4},%d0
+	bfextu	%sp@(PT_OFF_FORMATVEC){#0,#4},%d0
 	subql	#7,%d0				| bus error frame ?
 	jbne	1f
 	movel	%sp,%sp@-
@@ -127,7 +127,7 @@ ENTRY(system_call)
 	jcc	badsys
 syscall:
 	jbsr	@(sys_call_table,%d0:l:4)@(0)
-	movel	%d0,%sp@(PT_D0)		| save the return value
+	movel	%d0,%sp@(PT_OFF_D0)	| save the return value
 ret_from_syscall:
 	|oriw	#0x0700,%sr
 	movew	%curptr@(TASK_INFO+TINFO_FLAGS+2),%d0
@@ -135,7 +135,7 @@ ret_from_syscall:
 1:	RESTORE_ALL
 
 syscall_exit_work:
-	btst	#5,%sp@(PT_SR)		| check if returning to kernel
+	btst	#5,%sp@(PT_OFF_SR)	| check if returning to kernel
 	bnes	1b			| if so, skip resched, signals
 	lslw	#1,%d0
 	jcs	do_trace_exit
@@ -148,7 +148,7 @@ syscall_exit_work:
 
 ENTRY(ret_from_exception)
 .Lret_from_exception:
-	btst	#5,%sp@(PT_SR)		| check if returning to kernel
+	btst	#5,%sp@(PT_OFF_SR)	| check if returning to kernel
 	bnes	1f			| if so, skip resched, signals
 	| only allow interrupts when we are really the last one on the
 	| kernel stack, otherwise stack overflow can occur during
@@ -182,7 +182,7 @@ do_signal_return:
 	jbra	resume_userspace
 
 do_delayed_trace:
-	bclr	#7,%sp@(PT_SR)		| clear trace bit in SR
+	bclr	#7,%sp@(PT_OFF_SR)	| clear trace bit in SR
 	pea	1			| send SIGTRAP
 	movel	%curptr,%sp@-
 	pea	LSIGTRAP
@@ -199,7 +199,7 @@ ENTRY(auto_inthandler)
 	GET_CURRENT(%d0)
 	addqb	#1,%curptr@(TASK_INFO+TINFO_PREEMPT+1)
 					|  put exception # in d0
-	bfextu	%sp@(PT_VECTOR){#4,#10},%d0
+	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 	subw	#VEC_SPUR,%d0
 
 	movel	%sp,%sp@-
@@ -216,7 +216,7 @@ ret_from_interrupt:
 	ALIGN
 ret_from_last_interrupt:
 	moveq	#(~ALLOWINT>>8)&0xff,%d0
-	andb	%sp@(PT_SR),%d0
+	andb	%sp@(PT_OFF_SR),%d0
 	jne	2b
 
 	/* check if we need to do software interrupts */
@@ -232,7 +232,7 @@ ENTRY(user_inthandler)
 	GET_CURRENT(%d0)
 	addqb	#1,%curptr@(TASK_INFO+TINFO_PREEMPT+1)
 					|  put exception # in d0
-	bfextu	%sp@(PT_VECTOR){#4,#10},%d0
+	bfextu	%sp@(PT_OFF_FORMATVEC){#4,#10},%d0
 user_irqvec_fixup = . + 2
 	subw	#VEC_USER,%d0
 
diff --git a/arch/m68k/math-emu/fp_entry.S b/arch/m68k/math-emu/fp_entry.S
index 954b4f3..916c6f3 100644
--- a/arch/m68k/math-emu/fp_entry.S
+++ b/arch/m68k/math-emu/fp_entry.S
@@ -122,17 +122,17 @@ fp_get_data_reg:
 	.long	fp_get_d6, fp_get_d7
 
 fp_get_d0:
-	move.l	(PT_D0+8,%sp),%d0
+	move.l	(PT_OFF_D0+8,%sp),%d0
 	printf	PREGISTER,"{d0->%08x}",1,%d0
 	rts
 
 fp_get_d1:
-	move.l	(PT_D1+8,%sp),%d0
+	move.l	(PT_OFF_D1+8,%sp),%d0
 	printf	PREGISTER,"{d1->%08x}",1,%d0
 	rts
 
 fp_get_d2:
-	move.l	(PT_D2+8,%sp),%d0
+	move.l	(PT_OFF_D2+8,%sp),%d0
 	printf	PREGISTER,"{d2->%08x}",1,%d0
 	rts
 
@@ -173,35 +173,35 @@ fp_put_data_reg:
 
 fp_put_d0:
 	printf	PREGISTER,"{d0<-%08x}",1,%d0
-	move.l	%d0,(PT_D0+8,%sp)
+	move.l	%d0,(PT_OFF_D0+8,%sp)
 	rts
 
 fp_put_d1:
 	printf	PREGISTER,"{d1<-%08x}",1,%d0
-	move.l	%d0,(PT_D1+8,%sp)
+	move.l	%d0,(PT_OFF_D1+8,%sp)
 	rts
 
 fp_put_d2:
 	printf	PREGISTER,"{d2<-%08x}",1,%d0
-	move.l	%d0,(PT_D2+8,%sp)
+	move.l	%d0,(PT_OFF_D2+8,%sp)
 	rts
 
 fp_put_d3:
 	printf	PREGISTER,"{d3<-%08x}",1,%d0
 |	move.l	%d0,%d3
-	move.l	%d0,(PT_D3+8,%sp)
+	move.l	%d0,(PT_OFF_D3+8,%sp)
 	rts
 
 fp_put_d4:
 	printf	PREGISTER,"{d4<-%08x}",1,%d0
 |	move.l	%d0,%d4
-	move.l	%d0,(PT_D4+8,%sp)
+	move.l	%d0,(PT_OFF_D4+8,%sp)
 	rts
 
 fp_put_d5:
 	printf	PREGISTER,"{d5<-%08x}",1,%d0
 |	move.l	%d0,%d5
-	move.l	%d0,(PT_D5+8,%sp)
+	move.l	%d0,(PT_OFF_D5+8,%sp)
 	rts
 
 fp_put_d6:
@@ -225,17 +225,17 @@ fp_get_addr_reg:
 	.long	fp_get_a6, fp_get_a7
 
 fp_get_a0:
-	move.l	(PT_A0+8,%sp),%a0
+	move.l	(PT_OFF_A0+8,%sp),%a0
 	printf	PREGISTER,"{a0->%08x}",1,%a0
 	rts
 
 fp_get_a1:
-	move.l	(PT_A1+8,%sp),%a0
+	move.l	(PT_OFF_A1+8,%sp),%a0
 	printf	PREGISTER,"{a1->%08x}",1,%a0
 	rts
 
 fp_get_a2:
-	move.l	(PT_A2+8,%sp),%a0
+	move.l	(PT_OFF_A2+8,%sp),%a0
 	printf	PREGISTER,"{a2->%08x}",1,%a0
 	rts
 
@@ -276,17 +276,17 @@ fp_put_addr_reg:
 
 fp_put_a0:
 	printf	PREGISTER,"{a0<-%08x}",1,%a0
-	move.l	%a0,(PT_A0+8,%sp)
+	move.l	%a0,(PT_OFF_A0+8,%sp)
 	rts
 
 fp_put_a1:
 	printf	PREGISTER,"{a1<-%08x}",1,%a0
-	move.l	%a0,(PT_A1+8,%sp)
+	move.l	%a0,(PT_OFF_A1+8,%sp)
 	rts
 
 fp_put_a2:
 	printf	PREGISTER,"{a2<-%08x}",1,%a0
-	move.l	%a0,(PT_A2+8,%sp)
+	move.l	%a0,(PT_OFF_A2+8,%sp)
 	rts
 
 fp_put_a3:
