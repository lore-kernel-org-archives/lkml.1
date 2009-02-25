Return-Path: <linux-kernel-owner+w=401wt.eu-S1760127AbZBYErc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127AbZBYErc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759925AbZBYErT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:47:19 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:8528 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759912AbZBYErR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:47:17 -0500
Date: Tue, 24 Feb 2009 20:49:21 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250449.UAA12785@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 06/15] bitops: Change the bitmap index from int to unsigned long [h8300]
Cc: bjorn.helgaas@hp.com, justin.chen@hp.com, linux-kernel@vger.kernel.org,
       ysato@users.sourceforge.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [h8300]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/h8300/include/asm/bitops.h |    8 ++++----
 1 file changed, 1 insertion(+), 1 deletion(-)
diff -Nru a/arch/h8300/include/asm/bitops.h b/arch/h8300/include/asm/bitops.h
--- a/arch/h8300/include/asm/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/h8300/include/asm/bitops.h	2009-02-15 18:19:39.771556647 -0800
@@ -43,7 +43,7 @@
 	break;
 
 #define H8300_GEN_BITOP(FNAME,OP)				      \
-static __inline__ void FNAME(int nr, volatile unsigned long* addr)    \
+static __inline__ void FNAME(unsigned long nr, volatile unsigned long* addr) \
 {								      \
 	volatile unsigned char *b_addr;				      \
 	b_addr = (volatile unsigned char *)addr + ((nr >> 3) ^ 3);    \
@@ -79,7 +79,7 @@
 #undef H8300_GEN_BITOP
 #undef H8300_GEN_BITOP_CONST
 
-static __inline__ int test_bit(int nr, const unsigned long* addr)
+static __inline__ int test_bit(unsigned long nr, const unsigned long* addr)
 {
 	return (*((volatile unsigned char *)addr + 
                ((nr >> 3) ^ 3)) & (1UL << (nr & 7))) != 0;
@@ -111,7 +111,7 @@
         break;
 
 #define H8300_GEN_TEST_BITOP(FNNAME,OP)				     \
-static __inline__ int FNNAME(int nr, volatile void * addr)	     \
+static __inline__ int FNNAME(unsigned long nr, volatile void * addr) \
 {								     \
 	int retval = 0;						     \
 	char ccrsave;						     \
@@ -144,7 +144,7 @@
 	return retval;						     \
 }								     \
 								     \
-static __inline__ int __ ## FNNAME(int nr, volatile void * addr)     \
+static __inline__ int __ ## FNNAME(unsigned long nr, volatile void * addr) \
 {								     \
 	int retval = 0;						     \
 	volatile unsigned char *b_addr;				     \
