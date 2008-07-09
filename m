Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYGIItQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYGIItQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYGIItB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:49:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56436 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbYGIItA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:49:00 -0400
Date: Wed, 9 Jul 2008 10:48:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@suse.cz>
Cc: Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       bhavna.sarathy@amd.com, Sebastian.Biemueller@amd.com,
       robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080709084837.GA5358@elte.hu>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-2-git-send-email-joerg.roedel@amd.com> <20080708124504.GA16313@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080708124504.GA16313@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@suse.cz> wrote:

> > +config AMD_IOMMU
> > +	bool "AMD IOMMU support"
> > +	select SWIOTL
> 
> SWIOTLB?

yep, that typo got already fixed via the patch below.

	Ingo

--------------->
commit 07c40e8a1acdb56fca485a6deeb252ebf19509a1
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jun 27 11:31:28 2008 +0200

    x86, AMD IOMMU: build fix #3
    
    fix typo causing:
    
    arch/x86/kernel/built-in.o: In function `__unmap_single':
    amd_iommu.c:(.text+0x17771): undefined reference to `iommu_area_free'
    arch/x86/kernel/built-in.o: In function `__map_single':
    amd_iommu.c:(.text+0x1797a): undefined reference to `iommu_area_alloc'
    amd_iommu.c:(.text+0x179a2): undefined reference to `iommu_area_alloc'
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 62a2820..8aae462 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -551,7 +551,7 @@ config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 
 config AMD_IOMMU
 	bool "AMD IOMMU support"
-	select SWIOTL
+	select SWIOTLB
 	depends on X86_64 && PCI && ACPI
 	help
 	  Select this to get support for AMD IOMMU hardware in your system.

