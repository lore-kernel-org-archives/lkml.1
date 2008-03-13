Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYCMKOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYCMKOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYCMKLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:11:46 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35280 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbYCMKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:11:44 -0400
Date: Thu, 13 Mar 2008 11:03:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: ak@suse.de, kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: clean up aperture_64.c
Message-ID: <20080313100358.GA3327@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Initializing to zero is generally bad idea, I hope it is right for
__init data, too.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 608152a..88747f3 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -26,11 +27,11 @@ #include <asm/dma.h>
 #include <asm/k8.h>
 
 int gart_iommu_aperture;
-int gart_iommu_aperture_disabled __initdata = 0;
-int gart_iommu_aperture_allowed __initdata = 0;
+int gart_iommu_aperture_disabled __initdata;
+int gart_iommu_aperture_allowed __initdata;
 
 int fallback_aper_order __initdata = 1; /* 64MB */
-int fallback_aper_force __initdata = 0;
+int fallback_aper_force __initdata;
 
 int fix_aperture __initdata = 1;
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
