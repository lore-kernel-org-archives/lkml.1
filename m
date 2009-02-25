Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbZBYEti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbZBYEti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760367AbZBYEtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:49:21 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:43267 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760353AbZBYEtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:49:19 -0500
Date: Tue, 24 Feb 2009 20:51:23 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250451.UAA12861@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 10/15] bitops: Change the bitmap index from int to unsigned long [parisc]
Cc: bjorn.helgaas@hp.com, grundler@parisc-linux.org, justin.chen@hp.com,
       kyle@mcmartin.ca, linux-kernel@vger.kernel.org, matthew@wil.cx
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [parisc]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/parisc/include/asm/bitops.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)
diff -Nru a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
--- a/arch/parisc/include/asm/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/parisc/include/asm/bitops.h	2009-02-15 18:19:39.783275397 -0800
@@ -28,7 +28,7 @@
  *	__*_bit() are "relaxed" and don't use spinlock or volatile.
  */
 
-static __inline__ void set_bit(int nr, volatile unsigned long * addr)
+static __inline__ void set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = 1UL << CHOP_SHIFTCOUNT(nr);
 	unsigned long flags;
@@ -39,7 +39,7 @@ static __inline__ void set_bit(int nr, v
 	_atomic_spin_unlock_irqrestore(addr, flags);
 }
 
-static __inline__ void clear_bit(int nr, volatile unsigned long * addr)
+static __inline__ void clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = ~(1UL << CHOP_SHIFTCOUNT(nr));
 	unsigned long flags;
@@ -50,7 +50,8 @@ static __inline__ void clear_bit(int nr,
 	_atomic_spin_unlock_irqrestore(addr, flags);
 }
 
-static __inline__ void change_bit(int nr, volatile unsigned long * addr)
+static __inline__ void
+change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = 1UL << CHOP_SHIFTCOUNT(nr);
 	unsigned long flags;
@@ -61,7 +62,8 @@ static __inline__ void change_bit(int nr
 	_atomic_spin_unlock_irqrestore(addr, flags);
 }
 
-static __inline__ int test_and_set_bit(int nr, volatile unsigned long * addr)
+static __inline__ int
+test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = 1UL << CHOP_SHIFTCOUNT(nr);
 	unsigned long old;
@@ -79,7 +81,8 @@ static __inline__ int test_and_set_bit(i
 	return set;
 }
 
-static __inline__ int test_and_clear_bit(int nr, volatile unsigned long * addr)
+static __inline__ int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = 1UL << CHOP_SHIFTCOUNT(nr);
 	unsigned long old;
@@ -97,7 +100,8 @@ static __inline__ int test_and_clear_bit
 	return set;
 }
 
-static __inline__ int test_and_change_bit(int nr, volatile unsigned long * addr)
+static __inline__ int
+test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long mask = 1UL << CHOP_SHIFTCOUNT(nr);
 	unsigned long oldbit;
