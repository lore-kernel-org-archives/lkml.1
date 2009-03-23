Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbZCWSOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbZCWSOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 14:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760567AbZCWSKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 14:10:21 -0400
Received: from adsl-69-107-72-54.dsl.pltn13.pacbell.net ([69.107.72.54]:60879
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759782AbZCWSKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:10:10 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/15] x86: make /dev/mem mappings _PAGE_IOMAP
Date: Mon, 23 Mar 2009 11:09:57 -0700
Message-Id: <1237831799-6568-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <49C45238.7050007@zytor.com>
References: <49C45238.7050007@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: allow hardware to be mapped via /dev/mem

Use _PAGE_IOMAP on /dev/mem mappings.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 4d2a4df..56899ae 100644
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

