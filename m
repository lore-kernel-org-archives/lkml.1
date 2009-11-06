Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbZKFWGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbZKFWGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:06:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760036AbZKFWGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:06:46 -0500
Received: from kroah.org ([198.145.64.141]:39836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759937AbZKFWGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:06:05 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:53 2009
Message-Id: <20091106215953.842686540@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [29/30] x86/amd-iommu: Un__init function required on shutdown
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=x86-amd-iommu-un__init-function-required-on-shutdown.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

commit ca0207114f1708b563f510b7781a360ec5b98359 upstream.

The function iommu_feature_disable is required on system
shutdown to disable the IOMMU but it is marked as __init.
This may result in a panic if the memory is reused. This
patch fixes this bug.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -230,7 +230,7 @@ static void __init iommu_feature_enable(
 	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
 }
 
-static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
+static void iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 {
 	u32 ctrl;
 


