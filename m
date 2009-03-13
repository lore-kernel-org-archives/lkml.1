Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZCMQei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZCMQei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 12:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759215AbZCMQay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 12:30:54 -0400
Received: from gw.goop.org ([64.81.55.164]:56778 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759048AbZCMQav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 12:30:51 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/15] x86: make /dev/mem mappings _PAGE_IOMAP
Date: Fri, 13 Mar 2009 09:29:54 -0700
Message-Id: <1236961796-13407-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236961796-13407-1-git-send-email-jeremy@goop.org>
References: <1236961796-13407-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use _PAGE_IOMAP on /dev/mem mappings.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ea1d6bb..6d1ff36 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -504,7 +504,7 @@ int free_memtype(u64 start, u64 end)
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
-	return vma_prot;
+	return __pgprot(pgprot_val(vma_prot) | _PAGE_IOMAP);
 }
 
 #ifdef CONFIG_STRICT_DEVMEM
-- 
1.6.0.6

