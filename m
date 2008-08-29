Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbYH2Lxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbYH2Lxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbYH2Lxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:53:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:14011 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615AbYH2Lxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:53:45 -0400
Message-Id: <48B7FFB3.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 29 Aug 2008 12:54:59 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Nick Piggin" <npiggin@suse.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix ticket spin lock asm constraints
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

--- linux-2.6.27-rc5/include/asm-x86/spinlock.h	2008-08-21 14:37:34.000000000 +0200
+++ 2.6.27-rc5-x86-spinlock-constraints/include/asm-x86/spinlock.h	2008-08-19 12:43:22.000000000 +0200
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
 



