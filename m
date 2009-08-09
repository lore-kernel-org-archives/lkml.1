Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbZHIPnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbZHIPnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 11:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbZHIPnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 11:43:12 -0400
Received: from ns.ariel-networks.com ([122.216.114.210]:38619 "EHLO
	ns.ariel-networks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZHIPnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 11:43:12 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86 : omit duplicate processing at pte_pgprot()
Message-Id: <20090809154312.62D1A378124@ns.ariel-networks.com>
Date: Mon, 10 Aug 2009 00:43:12 +0900 (JST)
From: ohyama_sec@ariel-networks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suggest following PATCH that omit duplicate processing of mask.

pte_pgprot() macro [arch/x86/include/asm/pgtable.h] call pte_flags() [arch/x86/include/asm/pgtable_types.h] that return value is masked by PTE_FLAGS_MASK in pte_flags() function, and this macro also masks the returned value by PTE_FLAGS_MASK.

I guess that we don't have to do the mask processing at pte_pgprot() macro because it has already been masked at pte_flags().
So, how about the following PATCH ?

	<Hiroyasu OHYAMA>

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3cc06e3..a0b454c 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -265,7 +265,7 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
        return __pgprot(preservebits | addbits);
         }

         -#define pte_pgprot(x) __pgprot(pte_flags(x) & PTE_FLAGS_MASK)
         +#define pte_pgprot(x) __pgprot(pte_flags(x))

          #define canon_pgprot(p) __pgprot(massage_pgprot(p))
