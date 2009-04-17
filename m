Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZDQCNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZDQCNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbZDQCNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:13:07 -0400
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:52077 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753022AbZDQCNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:13:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] include/asm-generic/pgtable.h: fix sparse warnings
Date: Thu, 16 Apr 2009 22:12:18 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F904E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] include/asm-generic/pgtable.h: fix sparse warnings
Thread-Index: Acm/Ae80hheoTkaiR8WyIFdTFska/g==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Apr 2009 02:13:02.0410 (UTC) FILETIME=[0953DAA0:01C9BF02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a number of sparse warnings due to macro expansion.

  warning: symbol '__pte' shadows an earlier one

These sparse warning show up in the following sources:

  mm/fremap.c
  mm/mremap.c
  mm/memory.c
  mm/rmap.c

This trivial patch fixes all the warnings.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/include/asm-generic/pgtable.h
b/include/asm-generic/pgtable.h
index 8e6d0ca..c51b173 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -53,9 +53,9 @@
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define ptep_get_and_clear(__mm, __address, __ptep)
\
 ({
\
-	pte_t __pte = *(__ptep);
\
+	pte_t ___pte = *(__ptep);
\
 	pte_clear((__mm), (__address), (__ptep));
\
-	__pte;
\
+	___pte;
\
 })
 #endif
  
