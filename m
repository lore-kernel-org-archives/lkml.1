Return-Path: <linux-kernel-owner+w=401wt.eu-S1763023AbXGaVlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763023AbXGaVlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759900AbXGaVlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:41:03 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4647 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068AbXGaVlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:41:00 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 62] include/asm-avr32/pgalloc.h: kmalloc + memset conversion to kcalloc
Date: Tue, 31 Jul 2007 23:41:00 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       hskinnemoen@atmel.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312341.01133.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/asm-avr32/pgalloc.h |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- linux-2.6.23-rc1-mm1-a/include/asm-avr32/pgalloc.h	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/include/asm-avr32/pgalloc.h	2007-07-31 15:05:25.000000000 +0200
@@ -27,13 +27,7 @@ static __inline__ void pmd_populate(stru
  */
 static __inline__ pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	unsigned int pgd_size = (USER_PTRS_PER_PGD * sizeof(pgd_t));
-	pgd_t *pgd = kmalloc(pgd_size, GFP_KERNEL);
-
-	if (pgd)
-		memset(pgd, 0, pgd_size);
-
-	return pgd;
+	return kcalloc(USER_PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL);
 }

 static inline void pgd_free(pgd_t *pgd)
