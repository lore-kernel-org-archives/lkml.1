Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbXKNQpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbXKNQpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbXKNQpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:45:09 -0500
Received: from nic2.axis.se ([193.13.178.10]:48918 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbXKNQpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:45:08 -0500
Date: Wed, 14 Nov 2007 17:44:57 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRISv10 memset library add lineendings to asm
Message-ID: <20071114164457.GQ6347@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add \n\ at end of lines inside asm statement to avoid warning.

No change except adding \n\ to end of line and correcting
whitespace has been done.
Removes warning about multi-line string literals when compiling
arch/cris/arch-v10/lib/memset.c

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 memset.c |   82 +++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/arch/cris/arch-v10/lib/memset.c b/arch/cris/arch-v10/lib/memset.c
index 82bb668..42c1101 100644
--- a/arch/cris/arch-v10/lib/memset.c
+++ b/arch/cris/arch-v10/lib/memset.c
@@ -66,7 +66,7 @@ void *memset(void *pdst,
 
   {
     register char *dst __asm__ ("r13") = pdst;
- 
+
   /* This is NONPORTABLE, but since this whole routine is     */
   /* grossly nonportable that doesn't matter.                 */
 
@@ -110,52 +110,52 @@ void *memset(void *pdst,
       If you want to check that the allocation was right; then
       check the equalities in the first comment.  It should say
       "r13=r13, r12=r12, r11=r11" */
-    __asm__ volatile ("
-        ;; Check that the following is true (same register names on
-        ;; both sides of equal sign, as in r8=r8):
-        ;; %0=r13, %1=r12, %4=r11
-        ;;
-	;; Save the registers we'll clobber in the movem process
-	;; on the stack.  Don't mention them to gcc, it will only be
-	;; upset.
-	subq 	11*4,$sp
-        movem   $r10,[$sp]
-
-        move.d  $r11,$r0
-        move.d  $r11,$r1
-        move.d  $r11,$r2
-        move.d  $r11,$r3
-        move.d  $r11,$r4
-        move.d  $r11,$r5
-        move.d  $r11,$r6
-        move.d  $r11,$r7
-        move.d  $r11,$r8
-        move.d  $r11,$r9
-        move.d  $r11,$r10
-
-        ;; Now we've got this:
-	;; r13 - dst
-	;; r12 - n
-	
-        ;; Update n for the first loop
-        subq    12*4,$r12
-0:
-        subq   12*4,$r12
-        bge     0b
-	movem	$r11,[$r13+]
-
-        addq   12*4,$r12  ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-        movem [$sp+],$r10" 
+    __asm__ volatile ("\n\
+	;; Check that the following is true (same register names on	\n\
+	;; both sides of equal sign, as in r8=r8):			\n\
+	;; %0=r13, %1=r12, %4=r11					\n\
+	;;								\n\
+	;; Save the registers we'll clobber in the movem process	\n\
+	;; on the stack.  Don't mention them to gcc, it will only be	\n\
+	;; upset.							\n\
+	subq	11*4,$sp						\n\
+	movem	$r10,[$sp]						\n\
+									\n\
+	move.d	$r11,$r0						\n\
+	move.d	$r11,$r1						\n\
+	move.d	$r11,$r2						\n\
+	move.d	$r11,$r3						\n\
+	move.d	$r11,$r4						\n\
+	move.d	$r11,$r5						\n\
+	move.d	$r11,$r6						\n\
+	move.d	$r11,$r7						\n\
+	move.d	$r11,$r8						\n\
+	move.d	$r11,$r9						\n\
+	move.d	$r11,$r10						\n\
+									\n\
+	;; Now we've got this:						\n\
+	;; r13 - dst							\n\
+	;; r12 - n							\n\
+									\n\
+	;; Update n for the first loop					\n\
+	subq	12*4,$r12						\n\
+0:									\n\
+	subq	12*4,$r12						\n\
+	bge	0b							\n\
+	movem	$r11,[$r13+]						\n\
+									\n\
+	addq	12*4,$r12 ;; compensate for last loop underflowing n	\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem	[$sp+],$r10"
 
      /* Outputs */ : "=r" (dst), "=r" (n)
      /* Inputs */ : "0" (dst), "1" (n), "r" (lc));
-    
+
   }
 
     /* Either we directly starts copying, using dword copying
-       in a loop, or we copy as much as possible with 'movem' 
+       in a loop, or we copy as much as possible with 'movem'
        and then the last block (<44 bytes) is copied here.
        This will work since 'movem' will have updated src,dst,n. */
 

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
