Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbZGUPJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbZGUPJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZGUPJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:09:37 -0400
Received: from cmpxchg.org ([85.214.51.133]:33282 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbZGUPJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:09:36 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [patch] arm: boolean bit testing
Date: Tue, 21 Jul 2009 17:08:28 +0200
Message-Id: <1248188908-10083-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bit testing (test, testset, testclear, testchange) for bit numbers
known at compile time returns a word with the tested-for bit set.

Change it to return a true boolean value so to make it consistent with
the out-of-line path and all the other bitops implementations.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/arm/include/asm/bitops.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

My limited ARM asm-foo says that the testop macro functions properly
already.  Please double check.

diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index 63a481f..338ff19 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -84,7 +84,7 @@ ____atomic_test_and_set_bit(unsigned int bit, volatile unsigned long *p)
 	*p = res | mask;
 	raw_local_irq_restore(flags);
 
-	return res & mask;
+	return (res & mask) != 0;
 }
 
 static inline int
@@ -101,7 +101,7 @@ ____atomic_test_and_clear_bit(unsigned int bit, volatile unsigned long *p)
 	*p = res & ~mask;
 	raw_local_irq_restore(flags);
 
-	return res & mask;
+	return (res & mask) != 0;
 }
 
 static inline int
@@ -118,7 +118,7 @@ ____atomic_test_and_change_bit(unsigned int bit, volatile unsigned long *p)
 	*p = res ^ mask;
 	raw_local_irq_restore(flags);
 
-	return res & mask;
+	return (res & mask) != 0;
 }
 
 #include <asm-generic/bitops/non-atomic.h>
-- 
1.6.3

