Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYAWMC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYAWMC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYAWMCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:02:50 -0500
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:22860 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090AbYAWMCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:02:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAC+5lkc7pynT/2dsb2JhbAAIrUWBfw
X-IronPort-AV: E=Sophos;i="4.25,238,1199626200"; 
   d="scan'208";a="38370271"
Message-ID: <47972BAE.70902@niasdigital.com>
Date: Wed, 23 Jan 2008 22:57:34 +1100
From: Ben Nizette <bn@niasdigital.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH -mm] fix variable use in AVR32 pte_alloc_one
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some parts of this function use 'page', some 'pte'.  As such, an AVR32
-mm build fails with an undefined reference to 'page'.

Signed-Off-By: Ben Nizette <bn@niasdigital.com>

---
Index: linux-2.6.24-rc8-mm1/include/asm-avr32/pgalloc.h
===================================================================
--- linux-2.6.24-rc8-mm1.orig/include/asm-avr32/pgalloc.h
+++ linux-2.6.24-rc8-mm1/include/asm-avr32/pgalloc.h
@@ -52,9 +52,9 @@ static inline struct page *pte_alloc_one
 	struct page *pte;
 
 	pte = alloc_page(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO);
-	if (!page)
+	if (!pte)
 		return NULL;
-	pgtable_page_ctor(page);
+	pgtable_page_ctor(pte);
 	return pte;
 }
 
