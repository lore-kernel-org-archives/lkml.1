Return-Path: <linux-kernel-owner+w=401wt.eu-S1161205AbXBUKDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205AbXBUKDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161220AbXBUKDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:03:17 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:65523 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161217AbXBUKDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:03:08 -0500
Date: Wed, 21 Feb 2007 11:03:08 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] bss section clearing.
Message-ID: <20070221100308.GJ13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] bss section clearing.

Clear only memory from __bss_start to __bss_stop when clearing the bss
section. Not until _end, which currently happens to be the same.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/early.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/arch/s390/kernel/early.c linux-2.6-patched/arch/s390/kernel/early.c
--- linux-2.6/arch/s390/kernel/early.c	2007-02-21 10:47:32.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/early.c	2007-02-21 10:47:33.000000000 +0100
@@ -110,7 +110,7 @@ static inline void create_kernel_nss(voi
  */
 static noinline __init void clear_bss_section(void)
 {
-	memset(__bss_start, 0, _end - __bss_start);
+	memset(__bss_start, 0, __bss_stop - __bss_start);
 }
 
 /*
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

