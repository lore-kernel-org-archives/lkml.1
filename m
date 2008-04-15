Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbYDOWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbYDOWQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 18:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760695AbYDOWQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 18:16:33 -0400
Received: from xenotime.net ([66.160.160.81]:58718 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758514AbYDOWQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 18:16:33 -0400
Date: Tue, 15 Apr 2008 15:16:31 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
cc: mingo@redhat.com, tglx@linuxtronix.de, hpa@zytor.com,
       akpm@linux-foundation.org
Subject: [PATCH -next] x86: fix printk format
Message-ID: <Pine.LNX.4.64.0804151514320.15946@shark.he.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix gcc printk format warnings:

next-20080415/arch/x86/mm/mmio-mod.c: In function 'print_pte':
next-20080415/arch/x86/mm/mmio-mod.c:154: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'pteval_t'
next-20080415/arch/x86/mm/mmio-mod.c:154: warning: format '%lx' expects type 'long unsigned int', but argument 4 has type 'pteval_t'
next-20080415/arch/x86/mm/mmio-mod.c: At top level:
next-20080415/arch/x86/mm/mmio-mod.c:403: warning: 'downed_cpus' defined but not used

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/mm/mmio-mod.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- next-20080415.orig/arch/x86/mm/mmio-mod.c
+++ next-20080415/arch/x86/mm/mmio-mod.c
@@ -151,8 +151,9 @@ static void print_pte(unsigned long addr
 							"0x%08lx\n", address);
 		BUG();
 	}
-	pr_info(NAME "pte for 0x%lx: 0x%lx 0x%lx\n", address, pte_val(*pte),
-						pte_val(*pte) & _PAGE_PRESENT);
+	pr_info(NAME "pte for 0x%lx: 0x%llx 0x%llx\n", address,
+		(unsigned long long)pte_val(*pte),
+		(unsigned long long)pte_val(*pte) & _PAGE_PRESENT);
 }
 
 /*
