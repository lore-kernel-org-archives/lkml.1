Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZEMDGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZEMDGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbZEMDF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:05:58 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36201
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754920AbZEMDF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:05:56 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 13/16] x86: make /dev/mem mappings _PAGE_IOMAP
Date: Tue, 12 May 2009 14:28:35 -0700
Message-Id: <1242163718-2934-14-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242163718-2934-1-git-send-email-jeremy@goop.org>
References: <1242163718-2934-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Use _PAGE_IOMAP on /dev/mem mappings.

[ Impact: allow hardware to be mapped via /dev/mem in Xen ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/pat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 5ba8d88..3f7886f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -494,7 +494,7 @@ int free_memtype(u64 start, u64 end)
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
-	return vma_prot;
+	return __pgprot(pgprot_val(vma_prot) | _PAGE_IOMAP);
 }
 
 #ifdef CONFIG_STRICT_DEVMEM
-- 
1.6.0.6

