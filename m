Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbXKNQoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbXKNQoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbXKNQn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:43:58 -0500
Received: from nic2.axis.se ([193.13.178.10]:48879 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbXKNQn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:43:58 -0500
Date: Wed, 14 Nov 2007 17:43:47 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRISv10 string library add lineendings to asm
Message-ID: <20071114164347.GP6347@axis.com>
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
arch/cris/arch-v10/lib/string.c

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 string.c |   54 +++++++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/cris/arch-v10/lib/string.c b/arch/cris/arch-v10/lib/string.c
index 15d6662..7161a2b 100644
--- a/arch/cris/arch-v10/lib/string.c
+++ b/arch/cris/arch-v10/lib/string.c
@@ -95,33 +95,33 @@ void *memcpy(void *pdst,
       If you want to check that the allocation was right; then
       check the equalities in the first comment.  It should say
       "r13=r13, r11=r11, r12=r12" */
-    __asm__ volatile ("
-        ;; Check that the following is true (same register names on
-        ;; both sides of equal sign, as in r8=r8):
-        ;; %0=r13, %1=r11, %2=r12
-        ;;
-	;; Save the registers we'll use in the movem process
-	;; on the stack.
-	subq 	11*4,$sp
-	movem	$r10,[$sp]
-
-        ;; Now we've got this:
-	;; r11 - src
-	;; r13 - dst
-	;; r12 - n
-	
-        ;; Update n for the first loop
-        subq    44,$r12
-0:
-	movem	[$r11+],$r10
-        subq   44,$r12
-        bge     0b
-	movem	$r10,[$r13+]
-
-        addq   44,$r12  ;; compensate for last loop underflowing n
-
-	;; Restore registers from stack
-        movem [$sp+],$r10" 
+    __asm__ volatile ("\n\
+	;; Check that the following is true (same register names on	\n\
+	;; both sides of equal sign, as in r8=r8):			\n\
+	;; %0=r13, %1=r11, %2=r12					\n\
+	;;								\n\
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
+	subq	44,$r12							\n\
+	bge	0b							\n\
+	movem	$r10,[$r13+]						\n\
+									\n\
+	addq	44,$r12 ;; compensate for last loop underflowing n	\n\
+									\n\
+	;; Restore registers from stack					\n\
+	movem	[$sp+],$r10"
 
      /* Outputs */ : "=r" (dst), "=r" (src), "=r" (n) 
      /* Inputs */ : "0" (dst), "1" (src), "2" (n));

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
