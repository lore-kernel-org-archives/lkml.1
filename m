Return-Path: <linux-kernel-owner+w=401wt.eu-S1760701AbZBYEty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701AbZBYEty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbZBYEth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:49:37 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:45168 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760558AbZBYEtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:49:36 -0500
Date: Tue, 24 Feb 2009 20:51:40 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250451.UAA12871@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 11/15] bitops: Change the bitmap index from int to unsigned long [powerpc]
Cc: benh@kernel.crashing.org, bjorn.helgaas@hp.com, justin.chen@hp.com,
       linux-kernel@vger.kernel.org, paulus@samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [powerpc]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/powerpc/include/asm/bitops.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)
diff -Nru a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
--- a/arch/powerpc/include/asm/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/powerpc/include/asm/bitops.h	2009-02-15 18:19:39.784251959 -0800
@@ -56,7 +56,7 @@
 #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
 #define BITOP_LE_SWIZZLE	((BITS_PER_LONG-1) & ~0x7)
 
-static __inline__ void set_bit(int nr, volatile unsigned long *addr)
+static __inline__ void set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long old;
 	unsigned long mask = BITOP_MASK(nr);
@@ -73,7 +73,8 @@
 	: "cc" );
 }
 
-static __inline__ void clear_bit(int nr, volatile unsigned long *addr)
+static __inline__ void
+clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long old;
 	unsigned long mask = BITOP_MASK(nr);
@@ -90,7 +91,8 @@
 	: "cc" );
 }
 
-static __inline__ void clear_bit_unlock(int nr, volatile unsigned long *addr)
+static __inline__ void
+clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long old;
 	unsigned long mask = BITOP_MASK(nr);
@@ -108,7 +110,8 @@
 	: "cc", "memory");
 }
 
-static __inline__ void change_bit(int nr, volatile unsigned long *addr)
+static __inline__ void
+change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned long old;
 	unsigned long mask = BITOP_MASK(nr);
@@ -228,7 +231,8 @@
 
 #include <asm-generic/bitops/non-atomic.h>
 
-static __inline__ void __clear_bit_unlock(int nr, volatile unsigned long *addr)
+static __inline__ void
+__clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
 {
 	__asm__ __volatile__(LWSYNC_ON_SMP "" ::: "memory");
 	__clear_bit(nr, addr);
