Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbXLBNVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbXLBNVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 08:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXLBNVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 08:21:38 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:32422 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbXLBNVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 08:21:37 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 9D002D81-0D89-4A8A-BDDE-D174997CF0D6
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
cc: linux-kernel@vger.kernel.org, "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [PATCH 3/3] x86_64: use __PAGE_KERNEL_EXEC in ioremap_64.c
Date: Sun,  2 Dec 2007 14:21:21 +0100
Message-ID: <11966016811238-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <11966016811565-git-send-email-joerg.roedel@amd.com>
References: <11966016811565-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Dec 2007 13:21:21.0711 (UTC)
 FILETIME=[3B011BF0:01C834E6]
MIME-Version: 1.0
X-WSS-ID: 6B4C6ED30QK3513730-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the manual permission setup for pages in ioremap_64.c with
the pre-defined __PAGE_KERNEL_EXEC value.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/mm/ioremap_64.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/ioremap_64.c b/arch/x86/mm/ioremap_64.c
index 6cac90a..9a67fc6 100644
--- a/arch/x86/mm/ioremap_64.c
+++ b/arch/x86/mm/ioremap_64.c
@@ -103,8 +103,7 @@ void __iomem * __ioremap(unsigned long phys_addr, unsigned long size, unsigned l
 	}
 #endif
 
-	pgprot = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_GLOBAL
-			  | _PAGE_DIRTY | _PAGE_ACCESSED | flags);
+	pgprot = __pgprot(__PAGE_KERNEL_EXEC | _PAGE_GLOBAL | flags);
 	/*
 	 * Mappings have to be page-aligned
 	 */
-- 
1.5.2.5



