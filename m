Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZJLMHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZJLMHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 08:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbZJLMHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 08:07:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:42944 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459AbZJLMHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 08:07:10 -0400
Subject: [PATCH 4/4] x86: Move pci_iommu_init to rootfs_initcall()
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J.Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
In-Reply-To: <1255342738.24732.265.camel@macbook.infradead.org>
References: <1255342738.24732.265.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 13:06:21 +0100
Message-Id: <1255349181.10605.11.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want this to happen after the PCI quirks, which are now running at
the very end of the fs_initcalls.

This works around the BIOS problems which were originally addressed by
commit db8be50c4307dac2b37305fc59c8dc0f978d09ea ('USB: Work around BIOS
bugs by quiescing USB controllers earlier'), which was reverted in
commit d93a8f829fe1d2f3002f2c6ddb553d12db420412.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index d20009b..b2a71dc 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -311,7 +311,7 @@ void pci_iommu_shutdown(void)
 	amd_iommu_shutdown();
 }
 /* Must execute after PCI subsystem */
-fs_initcall(pci_iommu_init);
+rootfs_initcall(pci_iommu_init);
 
 #ifdef CONFIG_PCI
 /* Many VIA bridges seem to corrupt data for DAC. Disable it here */
-- 
1.6.5.rc2


