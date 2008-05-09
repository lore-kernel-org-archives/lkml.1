Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbYEISgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbYEISgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYEISgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:36:25 -0400
Received: from gw.goop.org ([64.81.55.164]:48015 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbYEISgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:36:25 -0400
Message-ID: <4824999D.1090801@goop.org>
Date: Fri, 09 May 2008 19:36:13 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 5 of 8] x86: use PTE_MASK in pgtable_32.h
References: <a2ab59b40561969b7fea.1210330963@localhost> <alpine.LFD.1.10.0805091733550.3197@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805091733550.3197@apollo.tec.linutronix.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> that's gone from mainline already. Hugh's patch restored the old pmd_bad check.
>   

Here's the rebased patch.

---
 include/asm-x86/pgtable_32.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -94,7 +94,7 @@
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val((x)))
 #define pmd_present(x)	(pmd_val((x)) & _PAGE_PRESENT)
-#define pmd_bad(x) ((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define pmd_bad(x) ((pmd_val(x) & (~PTE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
 
@@ -165,7 +165,7 @@
 #define pmd_page(pmd) (pfn_to_page(pmd_val((pmd)) >> PAGE_SHIFT))
 
 #define pmd_page_vaddr(pmd)					\
-	((unsigned long)__va(pmd_val((pmd)) & PAGE_MASK))
+	((unsigned long)__va(pmd_val((pmd)) & PTE_MASK))
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address)					\


