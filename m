Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752489AbYLQTwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbYLQTwr (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbYLQTwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:52:37 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:40125 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYLQTwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:52:36 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH] x86 gart: don't complain if no AMD GART found
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Wed, 17 Dec 2008 12:52:34 -0700
Message-ID: <20081217195234.13603.96737.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's perfectly normal for no AMD GART to be present, e.g., if you have
Intel CPUs.  None of the other iommu_init() functions makes noise when
it finds nothing.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/x86/kernel/pci-gart_64.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index ba7ad83..a35eaa3 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -745,10 +745,8 @@ void __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0) {
-		printk(KERN_INFO "PCI-GART: No AMD GART found.\n");
+	if (cache_k8_northbridges() < 0 || num_k8_northbridges == 0)
 		return;
-	}
 
 #ifndef CONFIG_AGP_AMD64
 	no_agp = 1;

