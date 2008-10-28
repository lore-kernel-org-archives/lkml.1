Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYJ1VWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYJ1VWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYJ1VW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:22:29 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43169 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481AbYJ1VW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:22:28 -0400
Subject: [PATCH] x86: Fix CONFIG_PCI=n compile failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Glauber Costa <gcosta@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 16:22:23 -0500
Message-Id: <1225228943.3251.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This:

commit fae9a0d8ca68a14da8d2351ad3e0bf42f3b29899
Author: Glauber Costa <gcosta@redhat.com>
Date:   Tue Apr 8 13:20:56 2008 -0300

    x86: merge iommu initialization parameters

Moved the forbid_dac parameter into pci-dma.c but forgot that it's a PCI
only symbol thus causing a compile failure if CONFIG_PCI=N.  Fix by
surrounding the set clause in iommu_setup with #ifdef CONFIG_PCI

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

---

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1972266..47c5a7a 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -202,6 +202,7 @@ static __init int iommu_setup(char *p)
 			iommu_merge = 0;
 		if (!strncmp(p, "forcesac", 8))
 			iommu_sac_force = 1;
+#ifdef CONFIG_PCI
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
@@ -210,6 +211,7 @@ static __init int iommu_setup(char *p)
 			forbid_dac = -1;
 			return 1;
 		}
+#endif
 #ifdef CONFIG_SWIOTLB
 		if (!strncmp(p, "soft", 4))
 			swiotlb = 1;


