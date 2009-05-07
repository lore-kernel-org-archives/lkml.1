Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbZEHAcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbZEHAcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759791AbZEHAKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:54 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52706
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755729AbZEHAKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:00 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 09/11] x86/pci: make sure _PAGE_IOMAP it set on pci mappings
Date: Thu,  7 May 2009 14:45:35 -0700
Message-Id: <1241732737-7669-10-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241732737-7669-1-git-send-email-jeremy@goop.org>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Impact: bugfix

When mapping pci space via /sys or /proc, make sure we're really
doing a hardware mapping by setting _PAGE_IOMAP.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/pci/i386.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index f1817f7..255aece 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -274,6 +274,9 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
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

