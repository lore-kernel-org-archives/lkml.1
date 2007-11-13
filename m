Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbXKMP3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbXKMP3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXKMP3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:29:46 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:37770 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbXKMP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:29:45 -0500
Subject: Re: mm snapshot broken-out-2007-11-13-04-14 Build Fails at memory.c
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       linux-arch@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <4739B81A.3050601@linux.vnet.ibm.com>
References: <200711131215.lADCFfht009739@imap1.linux-foundation.org>
	 <4739B81A.3050601@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: IBM Corporation
Date: Tue, 13 Nov 2007 16:29:41 +0100
Message-Id: <1194967781.3767.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-13 at 20:13 +0530, Kamalesh Babulal wrote:
> Hi Andrew,
> 
> The kernel build fails, with following build error
> 
> mm/memory.c: In function ‘free_pte_range’:
> mm/memory.c:126: error: implicit declaration of function ‘pmd_pgtable’
> mm/memory.c:126: warning: initialization makes pointer from integer without a cast
> mm/memory.c: In function ‘apply_to_pte_range’:
> mm/memory.c:1389: warning: assignment makes pointer from integer without a cast
> make[1]: *** [mm/memory.o] Error 1
> make: *** [mm] Error 2
> 
> The patch causing this issue is config_highpte-vs-sub-page-page-tables.patch.
> Where the marco is defined #ifndef CONFIG_PPC_64K_PAGES.

Forget the request for the .config. Found the problem, fixup patch
below.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.
---
diff -urpN linux-2.6/include/asm-powerpc/pgalloc-64.h linux-2.6-patched/include/asm-powerpc/pgalloc-64.h
--- linux-2.6/include/asm-powerpc/pgalloc-64.h	2007-11-12 17:31:58.000000000 +0100
+++ linux-2.6-patched/include/asm-powerpc/pgalloc-64.h	2007-11-13 16:23:50.000000000 +0100
@@ -68,6 +68,7 @@ static inline void pmd_populate_kernel(s
 
 #define pmd_populate(mm, pmd, pte_page) \
 	pmd_populate_kernel(mm, pmd, page_address(pte_page))
+#define pmd_pgtable(pmd) pmd_page(pmd)
 
 #endif /* CONFIG_PPC_64K_PAGES */
 


