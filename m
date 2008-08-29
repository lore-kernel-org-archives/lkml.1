Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbYH2Lzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbYH2Lzx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbYH2Lzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:55:44 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14094 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbYH2Lzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:55:44 -0400
Message-Id: <48B80029.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:56:57 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use LOCK_PREFIX consistently in tick spin lock
	 code
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 include/asm-x86/spinlock.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.27-rc5/include/asm-x86/spinlock.h	2008-08-21 14:37:34.000000000 +0200
+++ 2.6.27-rc5-x86-spinlock-prefix/include/asm-x86/spinlock.h	2008-08-19 12:43:22.000000000 +0200
@@ -97,8 +97,8 @@ static __always_inline int __ticket_spin
 		     "jne 1f\n\t"
 		     "movw %w0,%w1\n\t"
 		     "incb %h1\n\t"
-		     "lock ; cmpxchgw %w1,%2\n\t"
-		     "1:"
+		     LOCK_PREFIX "cmpxchgw %w1, %2\n"
+		     "1:\t"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
 		     : "=&a" (tmp), "=Q" (new), "+m" (lock->slock)
@@ -135,9 +135,9 @@ static __always_inline void __ticket_spi
 	int inc = 0x00010000;
 	int tmp;
 
-	asm volatile("lock ; xaddl %0, %1\n"
+	asm volatile(LOCK_PREFIX "xaddl %0, %1\n\t"
 		     "movzwl %w0, %2\n\t"
-		     "shrl $16, %0\n\t"
+		     "shrl $16, %0\n"
 		     "1:\t"
 		     "cmpl %0, %2\n\t"
 		     "je 2f\n\t"
@@ -162,8 +162,8 @@ static __always_inline int __ticket_spin
 		     "cmpl %0,%1\n\t"
 		     "jne 1f\n\t"
 		     "addl $0x00010000, %1\n\t"
-		     "lock ; cmpxchgl %1,%2\n\t"
-		     "1:"
+		     LOCK_PREFIX "cmpxchgl %1, %2\n"
+		     "1:\t"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
 		     : "=&a" (tmp), "=r" (new), "+m" (lock->slock)



