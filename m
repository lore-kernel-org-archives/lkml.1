Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbXLDP1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbXLDP1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXLDP1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:27:17 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:52704 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbXLDP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:27:16 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
cc: linux-kernel@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 2/3] x86_64: use __PAGE_KERNEL* instead of _KERNPG_TABLE
 for 2MB PTEs in memory initialization
Date: Tue,  4 Dec 2007 16:23:50 +0100
Message-ID: <1196781831199-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11967818313616-git-send-email-joerg.roedel@amd.com>
References: <11967818313616-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Dec 2007 15:23:51.0100 (UTC)
 FILETIME=[AC685FC0:01C83689]
MIME-Version: 1.0
X-WSS-ID: 6B4BAE870QK3710675-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This minor cleanup replaces _KERNPG_TABLE with the __PAGE_KERNEL* for 2MB PTEs
in the x86_64 memory initialization code. The __PAGE_KERNEL* defines are more
appropriate for PTEs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/mm/init_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0f9c8c8..8db7348 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -224,7 +224,7 @@ __meminit void *early_ioremap(unsigned long addr, unsigned long size)
 		vaddr += addr & ~PMD_MASK;
 		addr &= PMD_MASK;
 		for (i = 0; i < pmds; i++, addr += PMD_SIZE)
-			set_pmd(pmd + i,__pmd(addr | _KERNPG_TABLE | _PAGE_PSE));
+			set_pmd(pmd+i, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
 		__flush_tlb();
 		return (void *)vaddr;
 	next:
@@ -268,7 +268,7 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 		if (pmd_val(*pmd))
 			continue;
 
-		entry = _PAGE_NX|_PAGE_PSE|_KERNPG_TABLE|_PAGE_GLOBAL|address;
+		entry = __PAGE_KERNEL_LARGE|_PAGE_GLOBAL|address;
 		entry &= __supported_pte_mask;
 		set_pmd(pmd, __pmd(entry));
 	}
-- 
1.5.2.5



