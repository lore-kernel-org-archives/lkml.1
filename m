Return-Path: <linux-kernel-owner+w=401wt.eu-S1765311AbYAaHfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765311AbYAaHfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:35:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbYAaHfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:35:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:63648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYAaHfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:35:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,283,1199692800"; 
   d="scan'208";a="294571493"
Subject: [PATCH 3/5] x86: early_ioremap_reset fix 2
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Jan 2008 15:36:04 +0800
Message-Id: <1201764964.12950.24.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Jan 2008 07:35:02.0790 (UTC) FILETIME=[CA966260:01C863DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug of early_ioremap_reset(), which had been fixed
before by "convert the boot time page table to the kernels native
format" patch. But that patch has been reverted now.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/ioremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -350,7 +350,7 @@ void __init early_ioremap_reset(void)
 	for (idx = FIX_BTMAP_BEGIN; idx >= FIX_BTMAP_END; idx--) {
 		addr = fix_to_virt(idx);
 		pte = early_ioremap_pte(addr);
-		if (!*pte & _PAGE_PRESENT) {
+		if (*pte & _PAGE_PRESENT) {
 			phys = *pte & PAGE_MASK;
 			set_fixmap(idx, phys);
 		}

