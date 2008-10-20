Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbYJTHMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbYJTHMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 03:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYJTHMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 03:12:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47977 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYJTHMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 03:12:10 -0400
Date: Mon, 20 Oct 2008 09:12:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] x86, ioremap: use %pR in printk
Message-ID: <20081020071203.GB12131@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020040823.871BDDDDEC@ozlabs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> This converts things in drivers/pci to use %pR to printout the
> content of a struct resource instead of hand-casted %llx or
> other variants.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

cool!

 Acked-by: Ingo Molnar <mingo@elte.hu>

there's also two places in arch/x86/mm/ioremap.c that could use this 
straight away - see the (untested) patch below.

	Ingo

--------------------->
>From 3b4f8fd4ff54a2da035e972a610b8d5ac8d8eabb Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 20 Oct 2008 09:08:57 +0200
Subject: [PATCH] x86, ioremap: use %pR in printk

use the new %pR IO resource pointer/address/size printk type conversion
specifier.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/ioremap.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ae71e11..640c653 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -207,8 +207,8 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		return NULL;
 
 	if (!phys_addr_valid(phys_addr)) {
-		printk(KERN_WARNING "ioremap: invalid physical address %llx\n",
-		       (unsigned long long)phys_addr);
+		printk(KERN_WARNING "ioremap: invalid physical address %pR\n",
+		       phys_addr);
 		WARN_ON_ONCE(1);
 		return NULL;
 	}
@@ -267,9 +267,9 @@ static void __iomem *__ioremap_caller(resource_size_t phys_addr,
 		    (prot_val == _PAGE_CACHE_WC &&
 		     new_prot_val == _PAGE_CACHE_WB)) {
 			pr_debug(
-		"ioremap error for 0x%llx-0x%llx, requested 0x%lx, got 0x%lx\n",
-				(unsigned long long)phys_addr,
-				(unsigned long long)(phys_addr + size),
+		"ioremap error for %pR-%pR, requested 0x%lx, got 0x%lx\n",
+				phys_addr,
+				phys_addr + size,
 				prot_val, new_prot_val);
 			free_memtype(phys_addr, phys_addr + size);
 			return NULL;
