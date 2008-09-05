Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYIEM0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYIEM0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYIEM0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:26:23 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:29798 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYIEM0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:26:22 -0400
Message-Id: <48C1419F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 05 Sep 2008 13:26:39 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: ticket spin locks: fix asm constraints
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to these changes I doubt the 'volatile' on all the ticket
lock asm()-s are really necessary.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Nick Piggin <npiggin@suse.de>

---
 include/asm-x86/spinlock.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-x86.orig/include/asm-x86/spinlock.h
+++ linux-x86/include/asm-x86/spinlock.h
@@ -101,7 +101,7 @@ static __always_inline int __ticket_spin
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=Q" (new), "+m" (lock->slock)
+		     : "=&a" (tmp), "=&Q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 
@@ -146,7 +146,7 @@ static __always_inline void __ticket_spi
 		     /* don't need lfence here, because loads are in-order */
 		     "jmp 1b\n"
 		     "2:"
-		     : "+Q" (inc), "+m" (lock->slock), "=r" (tmp)
+		     : "+r" (inc), "+m" (lock->slock), "=&r" (tmp)
 		     :
 		     : "memory", "cc");
 }
@@ -166,7 +166,7 @@ static __always_inline int __ticket_spin
 		     "1:"
 		     "sete %b1\n\t"
 		     "movzbl %b1,%0\n\t"
-		     : "=&a" (tmp), "=r" (new), "+m" (lock->slock)
+		     : "=&a" (tmp), "=&q" (new), "+m" (lock->slock)
 		     :
 		     : "memory", "cc");
 



