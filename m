Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZD2MgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZD2MgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZD2MgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:36:06 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:55480 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZD2MgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:36:05 -0400
Date: Wed, 29 Apr 2009 14:36:01 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] atomic: fix atomic_long_cmpxchg/xchg for 64 bit
 architectures
Message-ID: <20090429143601.1a79ab8f@osiris.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

On a linux-next allyesconfig build:

kernel/trace/ring_buffer.c:1726:
	warning: passing argument 1 of 'atomic_cmpxchg' from incompatible pointer type
linux-next/arch/s390/include/asm/atomic.h:112:
	note: expected 'struct atomic_t *' but argument is of type 'struct atomic64_t *'

atomic_long_cmpxchg and atomic_long_xchg are incorrectly defined for
64 bit architectures. They should be mapped to the atomic64_* variants.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/asm-generic/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-next/include/asm-generic/atomic.h
===================================================================
--- linux-next.orig/include/asm-generic/atomic.h
+++ linux-next/include/asm-generic/atomic.h
@@ -132,9 +132,9 @@ static inline long atomic_long_add_unles
 #define atomic_long_inc_not_zero(l) atomic64_inc_not_zero((atomic64_t *)(l))
 
 #define atomic_long_cmpxchg(l, old, new) \
-	(atomic_cmpxchg((atomic64_t *)(l), (old), (new)))
+	(atomic64_cmpxchg((atomic64_t *)(l), (old), (new)))
 #define atomic_long_xchg(v, new) \
-	(atomic_xchg((atomic64_t *)(l), (new)))
+	(atomic64_xchg((atomic64_t *)(l), (new)))
 
 #else  /*  BITS_PER_LONG == 64  */
 
