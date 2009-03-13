Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbZCMRBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbZCMRBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbZCMRAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:00:54 -0400
Received: from gw.goop.org ([64.81.55.164]:57400 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758808AbZCMRAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:00:53 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       David Airlie <airlied@linux.ie>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/27] x86/pci: make sure _PAGE_IOMAP it set on pci mappings
Date: Fri, 13 Mar 2009 09:59:53 -0700
Message-Id: <1236963612-14287-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1236963612-14287-1-git-send-email-jeremy@goop.org>
References: <1236963612-14287-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

When mapping pci space via /sys or /proc, make sure we're really
doing a hardware mapping by setting _PAGE_IOMAP.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/pci/i386.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5ead808..e233e58 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -296,6 +296,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
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

