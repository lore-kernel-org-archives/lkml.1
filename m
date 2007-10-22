Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbXJVL5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbXJVL5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXJVL53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:57:29 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46172 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXJVL52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:57:28 -0400
Date: Mon, 22 Oct 2007 15:57:04 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] Bogus KERN_ALERT on oops
Message-ID: <20071022115704.GA6271@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

printing eip: f881b9f3 *pdpt = 0000000000003001 <1>*pde = 000000000480a067 *pte = 0000000000000000
						^^^

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/x86/mm/fault_32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -550,7 +550,7 @@ no_context:
 			page &= PAGE_MASK;
 			page = ((__typeof__(page) *) __va(page))[(address >> PMD_SHIFT)
 			                                         & (PTRS_PER_PMD - 1)];
-			printk(KERN_ALERT "*pde = %016Lx ", page);
+			printk("*pde = %016Lx ", page);
 			page &= ~_PAGE_NX;
 		}
 #else

