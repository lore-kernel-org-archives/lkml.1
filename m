Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbXE1Imf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbXE1Imf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761529AbXE1Ig4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:56 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:49098 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837AbXE1Igh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:37 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069468:sNHT28572348"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 14/20] Blackfin arch: add proper ENDPROC()
Date: Mon, 28 May 2007 16:37:49 +0800
Message-Id: <11803414794055-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

add proper ENDPROC() to close out assembly functions
so size/type is set properly in the final ELF image

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/entry.S          |    5 +++++
 arch/blackfin/lib/divsi3.S            |    3 +++
 arch/blackfin/lib/ins.S               |    4 +++-
 arch/blackfin/lib/memchr.S            |    2 +-
 arch/blackfin/lib/memcmp.S            |    2 +-
 arch/blackfin/lib/memcpy.S            |    2 ++
 arch/blackfin/lib/memmove.S           |    2 +-
 arch/blackfin/lib/memset.S            |    2 +-
 arch/blackfin/lib/modsi3.S            |    2 ++
 arch/blackfin/lib/outs.S              |    3 +++
 arch/blackfin/lib/smulsi3_highpart.S  |    2 ++
 arch/blackfin/lib/udivsi3.S           |    2 ++
 arch/blackfin/lib/umodsi3.S           |    4 ++++
 arch/blackfin/lib/umulsi3_highpart.S  |    2 ++
 arch/blackfin/mach-common/cache.S     |   10 ++++++++++
 arch/blackfin/mach-common/cacheinit.S |    4 ++++
 arch/blackfin/mach-common/cplbhdlr.S  |    4 ++--
 arch/blackfin/mach-common/cplbmgr.S   |    1 +
 arch/blackfin/mach-common/entry.S     |   18 ++++++++++++++++++
 arch/blackfin/mach-common/interrupt.S |    2 ++
 arch/blackfin/mach-common/lock.S      |    4 +++-
 21 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/arch/blackfin/kernel/entry.S b/arch/blackfin/kernel/entry.S
index 5880b27..65c5ba4 100644
--- a/arch/blackfin/kernel/entry.S
+++ b/arch/blackfin/kernel/entry.S
@@ -58,10 +58,12 @@ ENTRY(_ret_from_fork)
 	RESTORE_ALL_SYS
 	p0 = reti;
 	jump (p0);
+ENDPROC(_ret_from_fork)
 
 ENTRY(_sys_fork)
 	r0 = -EINVAL;
 	rts;
+ENDPROC(_sys_fork)
 
 ENTRY(_sys_vfork)
 	r0 = sp;
@@ -72,6 +74,7 @@ ENTRY(_sys_vfork)
 	SP += 12;
 	rets = [sp++];
 	rts;
+ENDPROC(_sys_vfork)
 
 ENTRY(_sys_clone)
 	r0 = sp;
@@ -82,6 +85,7 @@ ENTRY(_sys_clone)
 	SP += 12;
 	rets = [sp++];
 	rts;
+ENDPROC(_sys_clone)
 
 ENTRY(_sys_rt_sigreturn)
 	r0 = sp;
@@ -92,3 +96,4 @@ ENTRY(_sys_rt_sigreturn)
 	SP += 12;
 	rets = [sp++];
 	rts;
+ENDPROC(_sys_rt_sigreturn)
diff --git a/arch/blackfin/lib/divsi3.S b/arch/blackfin/lib/divsi3.S
index 3e29861..2ac59c7 100644
--- a/arch/blackfin/lib/divsi3.S
+++ b/arch/blackfin/lib/divsi3.S
@@ -44,6 +44,7 @@
  */
 
 .global   ___divsi3;
+.type ___divsi3, STT_FUNC;
 
 #ifdef CONFIG_ARITHMETIC_OPS_L1
 .section .l1.text
@@ -214,3 +215,5 @@ ___divsi3 :
 .Lret_zero:
   R0 = 0;
   RTS;
+
+.size ___divsi3, .-___divsi3
diff --git a/arch/blackfin/lib/ins.S b/arch/blackfin/lib/ins.S
index 7d5e984..a17cc77 100644
--- a/arch/blackfin/lib/ins.S
+++ b/arch/blackfin/lib/ins.S
@@ -46,7 +46,7 @@ ENTRY(_insl)
 .Llong_loop_e: 	NOP;
 	sti R3;
 	RTS;
-
+ENDPROC(_insl)
 
 ENTRY(_insw)
 	P0 = R0;	/* P0 = port */
@@ -61,6 +61,7 @@ ENTRY(_insw)
 .Lword_loop_e: 	NOP;
 	sti R3;
 	RTS;
+ENDPROC(_insw)
 
 ENTRY(_insb)
 	P0 = R0;	/* P0 = port */
@@ -75,3 +76,4 @@ ENTRY(_insb)
 .Lbyte_loop_e:  NOP;
 	sti R3;
 	RTS;
+ENDPROC(_insb)
diff --git a/arch/blackfin/lib/memchr.S b/arch/blackfin/lib/memchr.S
index 4981222..5da4281 100644
--- a/arch/blackfin/lib/memchr.S
+++ b/arch/blackfin/lib/memchr.S
@@ -67,4 +67,4 @@ ENTRY(_memchr)
 	R0 += -1;
 	RTS;
 
-.size _memchr,.-_memchr
+ENDPROC(_memchr)
diff --git a/arch/blackfin/lib/memcmp.S b/arch/blackfin/lib/memcmp.S
index 5b95023..a6b8ee6 100644
--- a/arch/blackfin/lib/memcmp.S
+++ b/arch/blackfin/lib/memcmp.S
@@ -107,4 +107,4 @@ ENTRY(_memcmp)
 	P3 = I1;
 	RTS;
 
-.size _memcmp,.-_memcmp
+ENDPROC(_memcmp)
diff --git a/arch/blackfin/lib/memcpy.S b/arch/blackfin/lib/memcpy.S
index c1e00ef..34b5a91 100644
--- a/arch/blackfin/lib/memcpy.S
+++ b/arch/blackfin/lib/memcpy.S
@@ -140,3 +140,5 @@ ENTRY(_memcpy)
 	B[P0--] = R1;
 
 	RTS;
+
+ENDPROC(_memcpy)
diff --git a/arch/blackfin/lib/memmove.S b/arch/blackfin/lib/memmove.S
index 2e5fb7f..c371585 100644
--- a/arch/blackfin/lib/memmove.S
+++ b/arch/blackfin/lib/memmove.S
@@ -100,4 +100,4 @@ ENTRY(_memmove)
 	P3 = I1;
 	RTS;
 
-.size _memmove,.-_memmove
+ENDPROC(_memmove)
diff --git a/arch/blackfin/lib/memset.S b/arch/blackfin/lib/memset.S
index ba6d047..8159136 100644
--- a/arch/blackfin/lib/memset.S
+++ b/arch/blackfin/lib/memset.S
@@ -106,4 +106,4 @@ ENTRY(_memset)
 	B[P0++] = R1;
 	JUMP .Laligned;
 
-.size _memset,.-_memset
+ENDPROC(_memset)
diff --git a/arch/blackfin/lib/modsi3.S b/arch/blackfin/lib/modsi3.S
index 528b8b1..ca1dd39 100644
--- a/arch/blackfin/lib/modsi3.S
+++ b/arch/blackfin/lib/modsi3.S
@@ -77,3 +77,5 @@ ___modsi3:
 	R0 = 0;
 .LRETURN_R0:
 	RTS;
+
+.size ___modsi3, .-___modsi3
diff --git a/arch/blackfin/lib/outs.S b/arch/blackfin/lib/outs.S
index f8c876f..4c3da8a 100644
--- a/arch/blackfin/lib/outs.S
+++ b/arch/blackfin/lib/outs.S
@@ -40,6 +40,7 @@ ENTRY(_outsl)
 .Llong_loop_s: R0 = [P1++];
 .Llong_loop_e: [P0] = R0;
 	RTS;
+ENDPROC(_outsl)
 
 ENTRY(_outsw)
 	P0 = R0;	/* P0 = port */
@@ -50,6 +51,7 @@ ENTRY(_outsw)
 .Lword_loop_s: R0 = W[P1++];
 .Lword_loop_e: W[P0] = R0;
 	RTS;
+ENDPROC(_outsw)
 
 ENTRY(_outsb)
 	P0 = R0;	/* P0 = port */
@@ -60,3 +62,4 @@ ENTRY(_outsb)
 .Lbyte_loop_s: R0 = B[P1++];
 .Lbyte_loop_e: B[P0] = R0;
 	RTS;
+ENDPROC(_outsb)
diff --git a/arch/blackfin/lib/smulsi3_highpart.S b/arch/blackfin/lib/smulsi3_highpart.S
index 10b8f8d..e383cd3 100644
--- a/arch/blackfin/lib/smulsi3_highpart.S
+++ b/arch/blackfin/lib/smulsi3_highpart.S
@@ -28,3 +28,5 @@ ___smulsi3_highpart:
 
 	R0 = R0 + R1;
 	RTS;
+
+.size ___smulsi3_highpart, .-___smulsi3_highpart
diff --git a/arch/blackfin/lib/udivsi3.S b/arch/blackfin/lib/udivsi3.S
index d39a129..58fd96d 100644
--- a/arch/blackfin/lib/udivsi3.S
+++ b/arch/blackfin/lib/udivsi3.S
@@ -296,3 +296,5 @@ ENTRY(___udivsi3)
   R1 = R0 - R3;
   IF CC R0 = R1;
   RTS;
+
+ENDPROC(___udivsi3)
diff --git a/arch/blackfin/lib/umodsi3.S b/arch/blackfin/lib/umodsi3.S
index b55ce96..4f2b76e 100644
--- a/arch/blackfin/lib/umodsi3.S
+++ b/arch/blackfin/lib/umodsi3.S
@@ -34,7 +34,9 @@
 #endif
 
 .extern ___udivsi3;
+.type ___udivsi3, STT_FUNC;
 .globl	___umodsi3
+.type ___umodsi3, STT_FUNC;
 ___umodsi3:
 
 	CC=R0==0;
@@ -64,3 +66,5 @@ ___umodsi3:
 	R0 = 0;
 .LRETURN_R0:
 	RTS;
+
+.size ___umodsi3, .-___umodsi3
diff --git a/arch/blackfin/lib/umulsi3_highpart.S b/arch/blackfin/lib/umulsi3_highpart.S
index aac8218..67b7993 100644
--- a/arch/blackfin/lib/umulsi3_highpart.S
+++ b/arch/blackfin/lib/umulsi3_highpart.S
@@ -21,3 +21,5 @@ ___umulsi3_highpart:
 	R1 = PACK(R1.l,R0.h);
 	R0 = R1 + R2;
 	RTS;
+
+.size ___umulsi3_highpart, .-___umulsi3_highpart
diff --git a/arch/blackfin/mach-common/cache.S b/arch/blackfin/mach-common/cache.S
index bb9446e..8bd2af1 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -70,6 +70,7 @@ ENTRY(_cache_invalidate)
 .Lno_dcache_b:
 	R7 = [SP++];
 	RTS;
+ENDPROC(_cache_invalidate)
 
 /* Invalidate the Entire Instruction cache by
  * disabling IMC bit
@@ -106,6 +107,8 @@ ENTRY(_invalidate_entire_icache)
 
 	( R7:5) = [SP++];
 	RTS;
+ENDPROC(_invalidate_entire_icache)
+ENDPROC(_icache_invalidate)
 
 /*
  * blackfin_cache_flush_range(start, end)
@@ -129,6 +132,7 @@ ENTRY(_blackfin_icache_flush_range)
 	IFLUSH [P0];
 	SSYNC;
 	RTS;
+ENDPROC(_blackfin_icache_flush_range)
 
 /*
  * blackfin_icache_dcache_flush_range(start, end)
@@ -155,6 +159,7 @@ ENTRY(_blackfin_icache_dcache_flush_range)
 	FLUSH [P0];
 	SSYNC;
 	RTS;
+ENDPROC(_blackfin_icache_dcache_flush_range)
 
 /* Throw away all D-cached data in specified region without any obligation to
  * write them back. However, we must clean the D-cached entries around the
@@ -183,6 +188,7 @@ ENTRY(_blackfin_dcache_invalidate_range)
 	FLUSHINV[P0];
 	SSYNC;
 	RTS;
+ENDPROC(_blackfin_dcache_invalidate_range)
 
 /* Invalidate the Entire Data cache by
  * clearing DMC[1:0] bits
@@ -221,6 +227,8 @@ ENTRY(_dcache_invalidate)
 
 	( R7:6) = [SP++];
 	RTS;
+ENDPROC(_dcache_invalidate)
+ENDPROC(_invalidate_entire_dcache)
 
 ENTRY(_blackfin_dcache_flush_range)
 	R2 = -L1_CACHE_BYTES;
@@ -241,6 +249,7 @@ ENTRY(_blackfin_dcache_flush_range)
 	FLUSH[P0];
 	SSYNC;
 	RTS;
+ENDPROC(_blackfin_dcache_flush_range)
 
 ENTRY(_blackfin_dflush_page)
 	P1 = 1 << (PAGE_SHIFT - L1_CACHE_SHIFT);
@@ -251,3 +260,4 @@ ENTRY(_blackfin_dflush_page)
 .Lfl1:	FLUSH [P0++];
 	SSYNC;
 	RTS;
+ENDPROC(_blackfin_dflush_page)
diff --git a/arch/blackfin/mach-common/cacheinit.S b/arch/blackfin/mach-common/cacheinit.S
index 8c17f09..7924a90 100644
--- a/arch/blackfin/mach-common/cacheinit.S
+++ b/arch/blackfin/mach-common/cacheinit.S
@@ -86,6 +86,8 @@ ENTRY(_bfin_icache_init)
 	SSYNC;
 	STI R2;
 	RTS;
+
+ENDPROC(_bfin_icache_init)
 #endif
 
 #if defined(CONFIG_BLKFIN_DCACHE)
@@ -134,4 +136,6 @@ ENTRY(_bfin_dcache_init)
 	SSYNC;
 	STI R2;
 	RTS;
+
+ENDPROC(_bfin_dcache_init)
 #endif
diff --git a/arch/blackfin/mach-common/cplbhdlr.S b/arch/blackfin/mach-common/cplbhdlr.S
index b979067..2f3c72c 100644
--- a/arch/blackfin/mach-common/cplbhdlr.S
+++ b/arch/blackfin/mach-common/cplbhdlr.S
@@ -42,8 +42,6 @@
 
 .align 2
 
-.global __cplb_hdr;
-.type __cplb_hdr, STT_FUNC;
 ENTRY(__cplb_hdr)
 	R2 = SEQSTAT;
 
@@ -128,3 +126,5 @@ ENTRY(__cplb_hdr)
 	call _panic_cplb_error;
 	SP += 12;
 	JUMP _handle_bad_cplb;
+
+ENDPROC(__cplb_hdr)
diff --git a/arch/blackfin/mach-common/cplbmgr.S b/arch/blackfin/mach-common/cplbmgr.S
index f5efc4b..e4b47e0 100644
--- a/arch/blackfin/mach-common/cplbmgr.S
+++ b/arch/blackfin/mach-common/cplbmgr.S
@@ -592,6 +592,7 @@ ENTRY(_cplb_mgr)
 	( R7:4,P5:3 ) = [SP++];
 	R0 = CPLB_RELOADED;
 	RTS;
+ENDPROC(_cplb_mgr)
 
 .data
 .align 4;
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 7d03687..40045b1 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -103,6 +103,7 @@ ENTRY(_ex_dcplb)
 	if !cc jump _return_from_exception;
 	/* fall through */
 #endif
+ENDPROC(_ex_dcplb)
 
 ENTRY(_ex_icplb)
 	(R7:6,P5:4) = [sp++];
@@ -113,6 +114,7 @@ ENTRY(_ex_icplb)
 	RESTORE_ALL_SYS
 	SP = RETN;
 	rtx;
+ENDPROC(_ex_icplb)
 
 ENTRY(_ex_spinlock)
 	/* Transform this into a syscall - twiddle the syscall vector.  */
@@ -123,6 +125,7 @@ ENTRY(_ex_spinlock)
 	[p5] = r7;
 	csync;
 	/* Fall through.  */
+ENDPROC(_ex_spinlock)
 
 ENTRY(_ex_syscall)
 	DEBUG_START_HWTRACE
@@ -131,6 +134,7 @@ ENTRY(_ex_syscall)
 	raise 15;		/* invoked by TRAP #0, for sys call */
 	sp = retn;
 	rtx
+ENDPROC(_ex_syscall)
 
 ENTRY(_spinlock_bh)
 	SAVE_ALL_SYS
@@ -150,12 +154,14 @@ ENTRY(_spinlock_bh)
 	[SP + PT_R0] = R0;
 	RESTORE_ALL_SYS
 	rti;
+ENDPROC(_spinlock_bh)
 
 ENTRY(_ex_soft_bp)
 	r7 = retx;
 	r7 += -2;
 	retx = r7;
 	jump.s _ex_trap_c;
+ENDPROC(_ex_soft_bp)
 
 ENTRY(_ex_single_step)
 	r7 = retx;
@@ -191,6 +197,7 @@ _return_from_exception:
 	ASTAT = [sp++];
 	sp = retn;
 	rtx;
+ENDPROC(_ex_soft_bp)
 
 ENTRY(_handle_bad_cplb)
 	/* To get here, we just tried and failed to change a CPLB
@@ -250,6 +257,7 @@ ENTRY(_ex_trap_c)
 	SP = RETN;
 	raise 5;
 	rtx;
+ENDPROC(_ex_trap_c)
 
 ENTRY(_exception_to_level5)
 	SAVE_ALL_SYS
@@ -314,6 +322,7 @@ ENTRY(_exception_to_level5)
 	call _ret_from_exception;
 	RESTORE_ALL_SYS
 	rti;
+ENDPROC(_exception_to_level5)
 
 ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 	/* Since the kernel stack can be anywhere, it's not guaranteed to be
@@ -342,6 +351,7 @@ ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 	r7 = -ENOSYS; 		/* signextending enough */
 	[sp + PT_R0] = r7;	/* return value from system call */
 	jump .Lsyscall_really_exit;
+ENDPROC(_trap)
 
 ENTRY(_kernel_execve)
 	link SIZEOF_PTREGS;
@@ -396,6 +406,7 @@ ENTRY(_kernel_execve)
 1:
 	unlink;
 	rts;
+ENDPROC(_kernel_execve)
 
 ENTRY(_system_call)
 	/* Store IPEND */
@@ -503,6 +514,7 @@ ENTRY(_system_call)
 	r5 = [sp + PT_RESERVED];
 	rets = r5;
 	rts;
+ENDPROC(_system_call)
 
 _sys_trace:
 	call _syscall_trace;
@@ -531,6 +543,7 @@ _sys_trace:
 
 	call _syscall_trace;
 	jump .Lresume_userspace;
+ENDPROC(_sys_trace)
 
 ENTRY(_resume)
 	/*
@@ -580,6 +593,7 @@ _new_old_task:
 	 * in "new" task.
 	 */
 	rts;
+ENDPROC(_resume)
 
 ENTRY(_ret_from_exception)
 	p2.l = lo(IPEND);
@@ -638,6 +652,7 @@ ENTRY(_ret_from_exception)
 	syscfg = r0;
 5:
 	rts;
+ENDPROC(_ret_from_exception)
 
 ENTRY(_return_from_int)
 	/* If someone else already raised IRQ 15, do nothing.  */
@@ -680,6 +695,7 @@ ENTRY(_return_from_int)
 	rti;
 2:
 	rts;
+ENDPROC(_return_from_int)
 
 ENTRY(_lower_to_irq14)
 #if defined(ANOMALY_05000281)
@@ -745,6 +761,7 @@ _schedule_and_signal:
 1:
 	RESTORE_CONTEXT
 	rti;
+ENDPROC(_lower_to_irq14)
 
 /* Make sure when we start, that the circular buffer is initialized properly
  * R0 and P0 are call clobbered, so we can use them here.
@@ -758,6 +775,7 @@ ENTRY(_init_exception_buff)
 	p0.l = _out_ptr_excause;
 	[p0] = r0;
 	rts;
+ENDPROC(_init_exception_buff)
 
 /*
  * Put these in the kernel data section - that should always be covered by
diff --git a/arch/blackfin/mach-common/interrupt.S b/arch/blackfin/mach-common/interrupt.S
index dd45664..b69f517 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -66,6 +66,7 @@ ENTRY(_evt_emulation)
 	SP += 12;
 	/* - GDB stub fills this in by itself (if defined) */
 	rte;
+ENDPROC(_evt_emulation)
 #endif
 
 /* Common interrupt entry code.	 First we do CLI, then push
@@ -251,3 +252,4 @@ ENTRY(_evt_system_call)
 #endif
 	call _system_call;
 	jump .Lcommon_restore_context;
+ENDPROC(_evt_system_call)
diff --git a/arch/blackfin/mach-common/lock.S b/arch/blackfin/mach-common/lock.S
index 2cbb15b..386ac8d 100644
--- a/arch/blackfin/mach-common/lock.S
+++ b/arch/blackfin/mach-common/lock.S
@@ -155,6 +155,7 @@ ENTRY(_cache_grab_lock)
 	( R7:0,P5:0 ) = [SP++];
 
 	RTS;
+ENDPROC(_cache_grab_lock)
 
 /* After the execution of critical code, the code is now locked into
  * the cache way. Now we need to set ILOC.
@@ -186,6 +187,7 @@ ENTRY(_cache_lock)
 
 	( R7:0,P5:0 ) = [SP++];
 	RTS;
+ENDPROC(_cache_lock)
 
 #endif	/* BLKFIN_CACHE_LOCK */
 
@@ -193,7 +195,6 @@ ENTRY(_cache_lock)
  */
 
 ENTRY(_read_iloc)
-
 	P1.H = (IMEM_CONTROL >> 16);
 	P1.L = (IMEM_CONTROL & 0xFFFF);
 	R1 = 0xF;
@@ -202,3 +203,4 @@ ENTRY(_read_iloc)
 	R0 = R0 & R1;
 
 	RTS;
+ENDPROC(_read_iloc)
-- 
1.5.2
