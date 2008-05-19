Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbYESMjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbYESMjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYESMjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:39:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56179 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbYESMjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:39:00 -0400
Date: Mon, 19 May 2008 14:39:52 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: aperture_64: use symbolic constants
Message-ID: <20080519123952.GA23118@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use symbolic constants in aperture_64.c where possible (and make a
comment slightly more helpful).

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit 4cc4fa2a3ff78277430201c74580e99bbaf7a1d0
tree 6ceafd1f7c4d020f084e9b96d30619680d393274
parent 033a68acc1817ba2bd9f25c2384e4b0c22ff4288
author Pavel <pavel@amd.ucw.cz> Mon, 19 May 2008 14:38:59 +0200
committer Pavel <pavel@amd.ucw.cz> Mon, 19 May 2008 14:38:59 +0200

 arch/x86/kernel/aperture_64.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 479926d..6b3757e 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -263,11 +263,11 @@ void __init early_gart_iommu_check(void)
 		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
 			continue;
 
-		ctl = read_pci_config(0, num, 3, 0x90);
+		ctl = read_pci_config(0, num, 3, AMD64_GARTAPERTURECTL);
 		aper_enabled = ctl & 1;
 		aper_order = (ctl >> 1) & 7;
 		aper_size = (32 * 1024 * 1024) << aper_order;
-		aper_base = read_pci_config(0, num, 3, 0x94) & 0x7fff;
+		aper_base = read_pci_config(0, num, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
 		aper_base <<= 25;
 
 		if ((last_aper_order && aper_order != last_aper_order) ||
@@ -303,9 +303,9 @@ void __init early_gart_iommu_check(void)
 		if (!early_is_k8_nb(read_pci_config(0, num, 3, 0x00)))
 			continue;
 
-		ctl = read_pci_config(0, num, 3, 0x90);
+		ctl = read_pci_config(0, num, 3, AMD64_GARTAPERTURECTL);
 		ctl &= ~1;
-		write_pci_config(0, num, 3, 0x90, ctl);
+		write_pci_config(0, num, 3, AMD64_GARTAPERTURECTL, ctl);
 	}
 
 }
@@ -332,9 +332,9 @@ void __init gart_iommu_hole_init(void)
 		iommu_detected = 1;
 		gart_iommu_aperture = 1;
 
-		aper_order = (read_pci_config(0, num, 3, 0x90) >> 1) & 7;
+		aper_order = (read_pci_config(0, num, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
 		aper_size = (32 * 1024 * 1024) << aper_order;
-		aper_base = read_pci_config(0, num, 3, 0x94) & 0x7fff;
+		aper_base = read_pci_config(0, num, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
 		aper_base <<= 25;
 
 		printk(KERN_INFO "Node %d: aperture @ %Lx size %u MB\n",
@@ -406,11 +406,13 @@ void __init gart_iommu_hole_init(void)
 			continue;
 
 		/*
-		 * Don't enable translation yet. That is done later.
+		 * Don't enable translation yet. That is done later
+		 * by enable_gart_translation.
+		 *
 		 * Assume this BIOS didn't initialise the GART so
 		 * just overwrite all previous bits
 		 */
-		write_pci_config(0, num, 3, 0x90, aper_order<<1);
-		write_pci_config(0, num, 3, 0x94, aper_alloc>>25);
+		write_pci_config(0, num, 3, AMD64_GARTAPERTURECTL, aper_order<<1);
+		write_pci_config(0, num, 3, AMD64_GARTAPERTUREBASE, aper_alloc>>25);
 	}
 }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
