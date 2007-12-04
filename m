Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXLDP1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXLDP1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:27:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbXLDP1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:27:22 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:52976 "EHLO
	outbound3-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557AbXLDP1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:27:20 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
cc: linux-kernel@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 1/3] x86_64: define all _PAGE_* in terms of _PAGE_BIT_*
Date: Tue,  4 Dec 2007 16:23:49 +0100
Message-ID: <11967818313780-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11967818313616-git-send-email-joerg.roedel@amd.com>
References: <11967818313616-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Dec 2007 15:23:51.0085 (UTC)
 FILETIME=[AC6615D0:01C83689]
MIME-Version: 1.0
X-WSS-ID: 6B4BAE862IW3685833-06-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines the _PAGE_* paging attributes in pgtable_64.h in terms of
the former defined _PAGE_BIT_* values.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/asm-x86/pgtable_64.h |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 9b0ff47..9d4f11d 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -150,19 +150,23 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm, unsigned long
 #define _PAGE_BIT_ACCESSED	5
 #define _PAGE_BIT_DIRTY		6
 #define _PAGE_BIT_PSE		7	/* 4 MB (or 2MB) page */
+#define _PAGE_BIT_FILE		6
 #define _PAGE_BIT_GLOBAL	8	/* Global TLB entry PPro+ */
 #define _PAGE_BIT_NX           63       /* No execute: only valid after cpuid check */
 
-#define _PAGE_PRESENT	0x001
-#define _PAGE_RW	0x002
-#define _PAGE_USER	0x004
-#define _PAGE_PWT	0x008
-#define _PAGE_PCD	0x010
-#define _PAGE_ACCESSED	0x020
-#define _PAGE_DIRTY	0x040
-#define _PAGE_PSE	0x080	/* 2MB page */
-#define _PAGE_FILE	0x040	/* nonlinear file mapping, saved PTE; unset:swap */
-#define _PAGE_GLOBAL	0x100	/* Global TLB entry */
+#define _PAGE_PRESENT	(_AC(1, UL)<<_PAGE_BIT_PRESENT)
+#define _PAGE_RW	(_AC(1, UL)<<_PAGE_BIT_RW)
+#define _PAGE_USER	(_AC(1, UL)<<_PAGE_BIT_USER)
+#define _PAGE_PWT	(_AC(1, UL)<<_PAGE_BIT_PWT)
+#define _PAGE_PCD	(_AC(1, UL)<<_PAGE_BIT_PCD)
+#define _PAGE_ACCESSED	(_AC(1, UL)<<_PAGE_BIT_ACCESSED)
+#define _PAGE_DIRTY	(_AC(1, UL)<<_PAGE_BIT_DIRTY)
+/* 2MB page */
+#define _PAGE_PSE	(_AC(1, UL)<<_PAGE_BIT_PSE)
+/* nonlinear file mapping, saved PTE; unset:swap */
+#define _PAGE_FILE	(_AC(1, UL)<<_PAGE_BIT_FILE)
+/* Global TLB entry */
+#define _PAGE_GLOBAL	(_AC(1, UL)<<_PAGE_BIT_GLOBAL)
 
 #define _PAGE_PROTNONE	0x080	/* If not present */
 #define _PAGE_NX        (_AC(1,UL)<<_PAGE_BIT_NX)
@@ -248,8 +252,7 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 #define pte_present(x)	(pte_val(x) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 #define pte_clear(mm,addr,xp)	do { set_pte_at(mm, addr, xp, __pte(0)); } while (0)
 
-#define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))	/* FIXME: is this
-						   right? */
+#define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))	/* FIXME: is this right? */
 #define pte_page(x)	pfn_to_page(pte_pfn(x))
 #define pte_pfn(x)  ((pte_val(x) & __PHYSICAL_MASK) >> PAGE_SHIFT)
 
-- 
1.5.2.5



