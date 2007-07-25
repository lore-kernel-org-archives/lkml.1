Return-Path: <linux-kernel-owner+w=401wt.eu-S1765477AbXGYMLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765477AbXGYMLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763729AbXGYMI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:57 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33043 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763676AbXGYMIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:55 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7Krb032180@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: fix reset register address casting
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix types used for reset register address setup.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/include/asm-m68knommu/system.h linux-2.6.22-uc0/include/asm-m68knommu/system.h
--- linux-2.6.22/include/asm-m68knommu/system.h	2007-07-12 15:21:55.000000000 +1000
+++ linux-2.6.22-uc0/include/asm-m68knommu/system.h	2007-07-12 15:23:58.000000000 +1000
@@ -296,7 +296,7 @@
 ({						\
 	unsigned char volatile *reset;		\
 	asm("move.w	#0x2700, %sr");		\
-	reset = ((volatile unsigned short *)(MCF_IPSBAR + 0x110000));	\
+	reset = ((volatile unsigned char *)(MCF_IPSBAR + 0x110000));	\
 	while(1)				\
 	*reset |= (0x01 << 7);\
 })
@@ -318,7 +318,7 @@
 ({					\
 	unsigned char volatile *reset;	\
 	asm("move.w     #0x2700, %sr");	\
-	reset = ((volatile unsigned short *)(MCF_IPSBAR + 0xA0000));	\
+	reset = ((volatile unsigned char *)(MCF_IPSBAR + 0xA0000));	\
 	while(1)			\
 		*reset |= 0x80;		\
 })
