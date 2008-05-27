Return-Path: <linux-kernel-owner+w=401wt.eu-S1757982AbYE0JFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982AbYE0JFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 05:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbYE0JFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 05:05:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35829 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbYE0JFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 05:05:23 -0400
Date: Tue, 27 May 2008 11:06:10 +0200
From: Pavel Machek <pavel@suse.cz>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: Re: aperture_64.c: corner case wrong
Message-ID: <20080527090610.GC1708@elf.ucw.cz>
References: <20080526191730.GA18425@elf.ucw.cz> <86802c440805261718i616d7740v2e1cbc352d29d58a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440805261718i616d7740v2e1cbc352d29d58a@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try to convert comments in aperture_64.c closer to
english. Unfortunately, I was not able to understand some of the
sentences :-(. Help welcome.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 5373f78..183d907 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -75,21 +75,20 @@ static u32 __init allocate_aperture(void
 	/*
 	 * Aperture has to be naturally aligned. This means a 2GB aperture
 	 * won't have much chance of finding a place in the lower 4GB of
-	 * memory. Unfortunately we cannot move it up because that would
+	 * memory. Unfortunately, we cannot move it up because that would
 	 * make the IOMMU useless.
-	 */
-	/*
-	 * using 512M as goal, in case kexec will load kernel_big
+	 *
+	 * Using 512M as goal, in case kexec will load kernel_big
 	 * that will do the on position decompress, and  could overlap with
 	 * that positon with gart that is used.
-	 * sequende:
+	 * sequence:
 	 * kernel_small
 	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
-	 * ==> kernel_small(gart area become e820_reserved)
+	 * ==> kernel_small (gart area becomes e820_reserved)
 	 * ==> kexec (with kdump trigger path or previous doesn't shutdown gart)
-	 * ==> kerne_big (uncompressed size will be big than 64M or 128M)
+	 * ==> kernel_big (uncompressed size will be bigger than 64M or 128M)
 	 * so don't use 512M below as gart iommu, leave the space for kernel
-	 * code for safe
+	 * code to be safe.
 	 */
 	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
 	if (!p || __pa(p)+aper_size > 0xffffffff) {
@@ -262,14 +261,15 @@ early_param("gart_fix_e820", parse_gart_
 void __init early_gart_iommu_check(void)
 {
 	/*
-	 * in case it is enabled before, esp for kexec/kdump,
-	 * previous kernel already enable that. memset called
-	 * by allocate_aperture/__alloc_bootmem_nopanic cause restart.
-	 * or second kernel have different position for GART hole. and new
+	 * In case it is enabled before, esp for kexec/kdump,
+	 * previous kernel already enabled that. memset called
+	 * by allocate_aperture/__alloc_bootmem_nopanic causes restart.
+	 * Or second kernel could have different position for GART hole, and new
 	 * kernel could use hole as RAM that is still used by GART set by
-	 * first kernel
-	 * or BIOS forget to put that in reserved.
-	 * try to update e820 to make that region as reserved.
+	 * first kernel.
+	 * Or maybe BIOS forgot to put that in reserved.
+	 *
+	 * Try to update e820 to make that region as reserved.
 	 */
 	int fix, slot;
 	u32 ctl;


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
