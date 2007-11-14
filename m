Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXKNQju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXKNQju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXKNQjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:39:40 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:45592 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbXKNQjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:39:39 -0500
Date: Wed, 14 Nov 2007 17:39:27 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRISv10 usercopy library add lineendings to asm
Message-ID: <20071114163927.GO6347@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removes warning when compiling arch/cris/arch-v10/lib/usercopy.c

No change except adding \n\ on the end of the lines has been done.
Removes warning about multi-line string literals.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 usercopy.c |  314 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 157 insertions(+), 157 deletions(-)

diff --git a/arch/cris/arch-v10/lib/usercopy.c b/arch/cris/arch-v10/lib/usercopy.c
index a12c708..b8e6c04 100644
--- a/arch/cris/arch-v10/lib/usercopy.c
+++ b/arch/cris/arch-v10/lib/usercopy.c
@@ -92,58 +92,58 @@ __copy_user (void __user *pdst, const void *psrc, unsigned long pn)
 	.ifnc %0%1%2%3,$r13$r11$r12$r10					\n\
 	.err								\n\
 	.endif								\n\
-
-	;; Save the registers we'll use in the movem process
-	;; on the stack.
-	subq	11*4,$sp
-	movem	$r10,[$sp]
-
-	;; Now we've got this:
-	;; r11 - src
-	;; r13 - dst
-	;; r12 - n
-
-	;; Update n for the first loop
-	subq	44,$r12
-
-; Since the noted PC of a faulting instruction in a delay-slot of a taken
-; branch, is that of the branch target, we actually point at the from-movem
-; for this case.  There is no ambiguity here; if there was a fault in that
-; instruction (meaning a kernel oops), the faulted PC would be the address
-; after *that* movem.
-
-0:
-	movem	[$r11+],$r10
-	subq   44,$r12
-	bge	0b
-	movem	$r10,[$r13+]
-1:
-	addq   44,$r12  ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-	movem [$sp+],$r10
-2:
-	.section .fixup,\"ax\"
-
-; To provide a correct count in r10 of bytes that failed to be copied,
-; we jump back into the loop if the loop-branch was taken.  There is no
-; performance penalty for sany use; the program will segfault soon enough.
-
-3:
-	move.d [$sp],$r10
-	addq 44,$r10
-	move.d $r10,[$sp]
-	jump 0b
-4:
-	movem [$sp+],$r10
-	addq 44,$r10
-	addq 44,$r12
-	jump 2b
-
-	.previous
-	.section __ex_table,\"a\"
-	.dword 0b,3b
-	.dword 1b,4b
+									\n\
+	;; Save the registers we'll use in the movem process		\n\
+	;; on the stack.						\n\
+	subq	11*4,$sp						\n\
+	movem	$r10,[$sp]						\n\
+									\n\
+	;; Now we've got this:						\n\
+	;; r11 - src							\n\
+	;; r13 - dst							\n\
+	;; r12 - n							\n\
+									\n\
+	;; Update n for the first loop					\n\
+	subq	44,$r12							\n\
+									\n\
+; Since the noted PC of a faulting instruction in a delay-slot of a taken \n\
+; branch, is that of the branch target, we actually point at the from-movem \n\
+; for this case.  There is no ambiguity here; if there was a fault in that \n\
+; instruction (meaning a kernel oops), the faulted PC would be the address \n\
+; after *that* movem.							\n\
+									\n\
+0:									\n\
+	movem	[$r11+],$r10						\n\
+	subq   44,$r12							\n\
+	bge	0b							\n\
+	movem	$r10,[$r13+]						\n\
+1:									\n\
+	addq   44,$r12  ;; compensate for last loop underflowing n	\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem [$sp+],$r10						\n\
+2:									\n\
+	.section .fixup,\"ax\"						\n\
+									\n\
+; To provide a correct count in r10 of bytes that failed to be copied,	\n\
+; we jump back into the loop if the loop-branch was taken.  There is no	\n\
+; performance penalty for sany use; the program will segfault soon enough.\n\
+									\n\
+3:									\n\
+	move.d [$sp],$r10						\n\
+	addq 44,$r10							\n\
+	move.d $r10,[$sp]						\n\
+	jump 0b								\n\
+4:									\n\
+	movem [$sp+],$r10						\n\
+	addq 44,$r10							\n\
+	addq 44,$r12							\n\
+	jump 2b								\n\
+									\n\
+	.previous							\n\
+	.section __ex_table,\"a\"					\n\
+	.dword 0b,3b							\n\
+	.dword 1b,4b							\n\
 	.previous"
 
      /* Outputs */ : "=r" (dst), "=r" (src), "=r" (n), "=r" (retn)
@@ -253,59 +253,59 @@ __copy_user_zeroing (void __user *pdst, const void *psrc, unsigned long pn)
        If you want to check that the allocation was right; then
        check the equalities in the first comment.  It should say
        "r13=r13, r11=r11, r12=r12" */
-    __asm__ volatile ("
+    __asm__ volatile ("\n\
 	.ifnc %0%1%2%3,$r13$r11$r12$r10					\n\
 	.err								\n\
 	.endif								\n\
-
-	;; Save the registers we'll use in the movem process
-	;; on the stack.
-	subq	11*4,$sp
-	movem	$r10,[$sp]
-
-	;; Now we've got this:
-	;; r11 - src
-	;; r13 - dst
-	;; r12 - n
-
-	;; Update n for the first loop
-	subq	44,$r12
-0:
-	movem	[$r11+],$r10
-1:
-	subq   44,$r12
-	bge	0b
-	movem	$r10,[$r13+]
-
-	addq   44,$r12  ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-	movem [$sp+],$r10
-4:
-	.section .fixup,\"ax\"
-
-;; Do not jump back into the loop if we fail.  For some uses, we get a
-;; page fault somewhere on the line.  Without checking for page limits,
-;; we don't know where, but we need to copy accurately and keep an
-;; accurate count; not just clear the whole line.  To do that, we fall
-;; down in the code below, proceeding with smaller amounts.  It should
-;; be kept in mind that we have to cater to code like what at one time
-;; was in fs/super.c:
-;;  i = size - copy_from_user((void *)page, data, size);
-;; which would cause repeated faults while clearing the remainder of
-;; the SIZE bytes at PAGE after the first fault.
-;; A caveat here is that we must not fall through from a failing page
-;; to a valid page.
-
-3:
-	movem  [$sp+],$r10
-	addq	44,$r12 ;; Get back count before faulting point.
-	subq	44,$r11 ;; Get back pointer to faulting movem-line.
-	jump	4b	;; Fall through, pretending the fault didn't happen.
-
-	.previous
-	.section __ex_table,\"a\"
-	.dword 1b,3b
+									\n\
+	;; Save the registers we'll use in the movem process		\n\
+	;; on the stack.						\n\
+	subq	11*4,$sp						\n\
+	movem	$r10,[$sp]						\n\
+									\n\
+	;; Now we've got this:						\n\
+	;; r11 - src							\n\
+	;; r13 - dst							\n\
+	;; r12 - n							\n\
+									\n\
+	;; Update n for the first loop					\n\
+	subq	44,$r12							\n\
+0:									\n\
+	movem	[$r11+],$r10						\n\
+1:									\n\
+	subq   44,$r12							\n\
+	bge	0b							\n\
+	movem	$r10,[$r13+]						\n\
+									\n\
+	addq   44,$r12  ;; compensate for last loop underflowing n	\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem [$sp+],$r10						\n\
+4:									\n\
+	.section .fixup,\"ax\"						\n\
+									\n\
+;; Do not jump back into the loop if we fail.  For some uses, we get a	\n\
+;; page fault somewhere on the line.  Without checking for page limits,	\n\
+;; we don't know where, but we need to copy accurately and keep an	\n\
+;; accurate count; not just clear the whole line.  To do that, we fall	\n\
+;; down in the code below, proceeding with smaller amounts.  It should	\n\
+;; be kept in mind that we have to cater to code like what at one time	\n\
+;; was in fs/super.c:							\n\
+;;  i = size - copy_from_user((void *)page, data, size);		\n\
+;; which would cause repeated faults while clearing the remainder of	\n\
+;; the SIZE bytes at PAGE after the first fault.			\n\
+;; A caveat here is that we must not fall through from a failing page	\n\
+;; to a valid page.							\n\
+									\n\
+3:									\n\
+	movem  [$sp+],$r10						\n\
+	addq	44,$r12 ;; Get back count before faulting point.	\n\
+	subq	44,$r11 ;; Get back pointer to faulting movem-line.	\n\
+	jump	4b	;; Fall through, pretending the fault didn't happen.\n\
+									\n\
+	.previous							\n\
+	.section __ex_table,\"a\"					\n\
+	.dword 1b,3b							\n\
 	.previous"
 
      /* Outputs */ : "=r" (dst), "=r" (src), "=r" (n), "=r" (retn)
@@ -425,64 +425,64 @@ __do_clear_user (void __user *pto, unsigned long pn)
       If you want to check that the allocation was right; then
       check the equalities in the first comment.  It should say
       something like "r13=r13, r11=r11, r12=r12". */
-    __asm__ volatile ("
+    __asm__ volatile ("\n\
 	.ifnc %0%1%2,$r13$r12$r10					\n\
 	.err								\n\
 	.endif								\n\
-
-	;; Save the registers we'll clobber in the movem process
-	;; on the stack.  Don't mention them to gcc, it will only be
-	;; upset.
-	subq	11*4,$sp
-	movem	$r10,[$sp]
-
-	clear.d $r0
-	clear.d $r1
-	clear.d $r2
-	clear.d $r3
-	clear.d $r4
-	clear.d $r5
-	clear.d $r6
-	clear.d $r7
-	clear.d $r8
-	clear.d $r9
-	clear.d $r10
-	clear.d $r11
-
-	;; Now we've got this:
-	;; r13 - dst
-	;; r12 - n
-
-	;; Update n for the first loop
-	subq	12*4,$r12
-0:
-	subq   12*4,$r12
-	bge	0b
-	movem	$r11,[$r13+]
-1:
-	addq   12*4,$r12        ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-	movem [$sp+],$r10
-2:
-	.section .fixup,\"ax\"
-3:
-	move.d [$sp],$r10
-	addq 12*4,$r10
-	move.d $r10,[$sp]
-	clear.d $r10
-	jump 0b
-
-4:
-	movem [$sp+],$r10
-	addq 12*4,$r10
-	addq 12*4,$r12
-	jump 2b
-
-	.previous
-	.section __ex_table,\"a\"
-	.dword 0b,3b
-	.dword 1b,4b
+									\n\
+	;; Save the registers we'll clobber in the movem process	\n\
+	;; on the stack.  Don't mention them to gcc, it will only be	\n\
+	;; upset.							\n\
+	subq	11*4,$sp						\n\
+	movem	$r10,[$sp]						\n\
+									\n\
+	clear.d $r0							\n\
+	clear.d $r1							\n\
+	clear.d $r2							\n\
+	clear.d $r3							\n\
+	clear.d $r4							\n\
+	clear.d $r5							\n\
+	clear.d $r6							\n\
+	clear.d $r7							\n\
+	clear.d $r8							\n\
+	clear.d $r9							\n\
+	clear.d $r10							\n\
+	clear.d $r11							\n\
+									\n\
+	;; Now we've got this:						\n\
+	;; r13 - dst							\n\
+	;; r12 - n							\n\
+									\n\
+	;; Update n for the first loop					\n\
+	subq	12*4,$r12						\n\
+0:									\n\
+	subq   12*4,$r12						\n\
+	bge	0b							\n\
+	movem	$r11,[$r13+]						\n\
+1:									\n\
+	addq   12*4,$r12        ;; compensate for last loop underflowing n\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem [$sp+],$r10						\n\
+2:									\n\
+	.section .fixup,\"ax\"						\n\
+3:									\n\
+	move.d [$sp],$r10						\n\
+	addq 12*4,$r10							\n\
+	move.d $r10,[$sp]						\n\
+	clear.d $r10							\n\
+	jump 0b								\n\
+									\n\
+4:									\n\
+	movem [$sp+],$r10						\n\
+	addq 12*4,$r10							\n\
+	addq 12*4,$r12							\n\
+	jump 2b								\n\
+									\n\
+	.previous							\n\
+	.section __ex_table,\"a\"					\n\
+	.dword 0b,3b							\n\
+	.dword 1b,4b							\n\
 	.previous"
 
      /* Outputs */ : "=r" (dst), "=r" (n), "=r" (retn)

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
