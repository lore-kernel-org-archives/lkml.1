Return-Path: <linux-kernel-owner+w=401wt.eu-S1765673AbZFLQ2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765673AbZFLQ2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763181AbZFLQZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39061 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760273AbZFLQY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:24:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 09/27] Blackfin: fix flag storage for irq funcs
Date: Fri, 12 Jun 2009 12:24:27 -0400
Message-Id: <1244823885-22410-10-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQ functions take an "unsigned long" flags variable, not any other
type, so fix the places where we use "int" or "long".

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/atomic.h |   16 ++++++++--------
 arch/blackfin/include/asm/bitops.h |    3 ++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index 94b2a9b..c7e32ad 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -90,7 +90,7 @@ static inline int atomic_test_mask(int mask, atomic_t *v)
 
 static inline void atomic_add(int i, atomic_t *v)
 {
-	long flags;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 	v->counter += i;
@@ -99,7 +99,7 @@ static inline void atomic_add(int i, atomic_t *v)
 
 static inline void atomic_sub(int i, atomic_t *v)
 {
-	long flags;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 	v->counter -= i;
@@ -110,7 +110,7 @@ static inline void atomic_sub(int i, atomic_t *v)
 static inline int atomic_add_return(int i, atomic_t *v)
 {
 	int __temp = 0;
-	long flags;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 	v->counter += i;
@@ -124,7 +124,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
 static inline int atomic_sub_return(int i, atomic_t *v)
 {
 	int __temp = 0;
-	long flags;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 	v->counter -= i;
@@ -136,7 +136,7 @@ static inline int atomic_sub_return(int i, atomic_t *v)
 
 static inline void atomic_inc(volatile atomic_t *v)
 {
-	long flags;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 	v->counter++;
@@ -145,7 +145,7 @@ static inline void atomic_inc(volatile atomic_t *v)
 
 static inline void atomic_dec(volatile atomic_t *v)
 {
-	long flags;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 	v->counter--;
@@ -154,7 +154,7 @@ static inline void atomic_dec(volatile atomic_t *v)
 
 static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
-	long flags;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 	v->counter &= ~mask;
@@ -163,7 +163,7 @@ static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 
 static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 {
-	long flags;
+	unsigned long flags;
 
 	local_irq_save_hw(flags);
 	v->counter |= mask;
diff --git a/arch/blackfin/include/asm/bitops.h b/arch/blackfin/include/asm/bitops.h
index 21b036e..75fee2f 100644
--- a/arch/blackfin/include/asm/bitops.h
+++ b/arch/blackfin/include/asm/bitops.h
@@ -109,7 +109,8 @@ static inline void clear_bit(int nr, volatile unsigned long *addr)
 
 static inline void change_bit(int nr, volatile unsigned long *addr)
 {
-	int mask, flags;
+	int mask;
+	unsigned long flags;
 	unsigned long *ADDR = (unsigned long *)addr;
 
 	ADDR += nr >> 5;
-- 
1.6.3.1

