Return-Path: <linux-kernel-owner+w=401wt.eu-S1763630AbXGWQHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763630AbXGWQHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 12:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760749AbXGWQEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 12:04:52 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:48722 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760739AbXGWQEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 12:04:50 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jul 2007 21:36:08 +0530
Message-Id: <20070723160608.22137.14790.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
Subject: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit() definitions
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

[8/8] i386: bitops: smp_mb__{before, after}_clear_bit() definitions

>From Documentation/atomic_ops.txt, those archs that require explicit
memory barriers around clear_bit() must also implement these two interfaces.
However, for i386, clear_bit() is a strict, locked, atomic and
un-reorderable operation and includes an implicit memory barrier already.

But these two functions have been wrongly defined as "barrier()" which is
a pointless _compiler optimization_ barrier, and only serves to make gcc
not do legitimate optimizations that it could have otherwise done.

So let's make these proper no-ops, because that's exactly what we require
these to be on the i386 platform.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---

[ A similar optimization needs to be done in the atomic.h also.
  Will submit that patch shortly. ]

 include/asm-i386/bitops.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index 4f1fda5..42999eb 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -106,8 +106,8 @@ static inline void __clear_bit(int nr, unsigned long *addr)
  * Bit operations are already serializing on x86.
  * These must still be defined here for API completeness.
  */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
+#define smp_mb__before_clear_bit()	do {} while (0)
+#define smp_mb__after_clear_bit()	do {} while (0)
 
 /**
  * __change_bit - Toggle a bit in memory
