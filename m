Return-Path: <linux-kernel-owner+w=401wt.eu-S1757600AbZEMDJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600AbZEMDJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbZEMDGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:06 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36222
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755790AbZEMDGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:02 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/10] x86/pci: make sure _PAGE_IOMAP it set on pci mappings
Date: Tue, 12 May 2009 14:48:09 -0700
Message-Id: <1242164891-3859-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242164891-3859-1-git-send-email-jeremy@goop.org>
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When mapping pci space via /sys or /proc, make sure we're really
doing a hardware mapping by setting _PAGE_IOMAP.

[ Impact: bugfix; make PCI mappings map the right pages ]
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
---
 arch/x86/pci/i386.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index a85bef2..88a1080 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -278,6 +278,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		return -EINVAL;
 
 	prot = pgprot_val(vma->vm_page_prot);
+
+	prot |= _PAGE_IOMAP;	/* creating a mapping for IO */
+
 	if (pat_enabled && write_combine)
 		prot |= _PAGE_CACHE_WC;
 	else if (pat_enabled || boot_cpu_data.x86 > 3)
-- 
1.6.0.6

