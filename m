Return-Path: <linux-kernel-owner+w=401wt.eu-S1763189AbXFBTIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763189AbXFBTIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758490AbXFBTIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:08:42 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:51892 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756896AbXFBTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:08:42 -0400
Date: Sat, 2 Jun 2007 21:08:44 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make arch/i386/mm/pgtable.c:pgd_{c,d}tor() static
Message-ID: <20070602190844.GJ5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pgd_{c,d}tor() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 arch/i386/mm/pgtable.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.22-rc3-mm1/arch/i386/mm/pgtable.c.old	2007-06-02 19:16:38.000000000 +0200
+++ linux-2.6.22-rc3-mm1/arch/i386/mm/pgtable.c	2007-06-02 19:18:26.000000000 +0200
@@ -235,7 +235,7 @@
 
 #if (PTRS_PER_PMD == 1)
 /* Non-PAE pgd constructor */
-void pgd_ctor(void *pgd)
+static void pgd_ctor(void *pgd)
 {
 	unsigned long flags;
 
@@ -257,7 +257,7 @@
 }
 #else  /* PTRS_PER_PMD > 1 */
 /* PAE pgd constructor */
-void pgd_ctor(void *pgd)
+static void pgd_ctor(void *pgd)
 {
 	/* PAE, kernel PMD may be shared */
 
@@ -276,7 +276,7 @@
 }
 #endif	/* PTRS_PER_PMD */
 
-void pgd_dtor(void *pgd)
+static void pgd_dtor(void *pgd)
 {
 	unsigned long flags; /* can be called from interrupt context */
 

