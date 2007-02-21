Return-Path: <linux-kernel-owner+w=401wt.eu-S1161208AbXBUKCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161208AbXBUKCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:02:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161200AbXBUKBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:01:37 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:25024 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161189AbXBUKBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:01:24 -0500
Date: Wed, 21 Feb 2007 11:01:22 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Optional ZONE_DMA for s390.
Message-ID: <20070221100122.GE13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Optional ZONE_DMA for s390.
    
Disable ZONE_DMA on 31-bit. All memory is addressable by all
devices and we do not need any special memory pool.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig   |    4 ++--
 arch/s390/mm/init.c |    2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/arch/s390/Kconfig linux-2.6-patched/arch/s390/Kconfig
--- linux-2.6/arch/s390/Kconfig	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/Kconfig	2007-02-21 10:47:27.000000000 +0100
@@ -8,8 +8,8 @@ config MMU
 	default y
 
 config ZONE_DMA
-	bool
-	default y
+	def_bool y
+	depends on 64BIT
 
 config LOCKDEP_SUPPORT
 	bool
diff -urpN linux-2.6/arch/s390/mm/init.c linux-2.6-patched/arch/s390/mm/init.c
--- linux-2.6/arch/s390/mm/init.c	2007-02-21 10:47:06.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/init.c	2007-02-21 10:47:27.000000000 +0100
@@ -141,7 +141,9 @@ void __init paging_init(void)
 	__raw_local_irq_ssm(ssm_mask);
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(MAX_DMA_ADDRESS);
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 	free_area_init_nodes(max_zone_pfns);
 }
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

