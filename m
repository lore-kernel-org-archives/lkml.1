Return-Path: <linux-kernel-owner+w=401wt.eu-S1761977AbZENNP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761977AbZENNP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbZENNPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:15:48 -0400
Received: from 216-237-3-220.orange.nextweb.net ([216.237.3.220]:19147 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbZENNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:15:48 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2009 09:15:47 EDT
Message-ID: <4A0C17BB.4010300@solarflare.com>
Date: Thu, 14 May 2009 14:08:11 +0100
From: Neil Turton <nturton@solarflare.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Subject: [PATCH] Fixed the handling of device aliases in the AMD IOMMU driver.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2009 13:08:13.0989 (UTC) FILETIME=[0A020550:01C9D495]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devid parameter to set_dev_entry_from_acpi is the requester ID
rather than the device ID since it is used to index the IOMMU device
table.  The handling of IVHD_DEV_ALIAS used to pass the device ID.
This patch fixes it to pass the requester ID.

Signed-off-by: Neil Turton <nturton@solarflare.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 61479ba..c013906 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -618,7 +618,7 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 		case IVHD_DEV_ALIAS:
 			devid = e->devid;
 			devid_to = e->ext >> 8;
-			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
+			set_dev_entry_from_acpi(iommu, devid_to, e->flags, 0);
 			amd_iommu_alias_table[devid] = devid_to;
 			break;
 		case IVHD_DEV_ALIAS_RANGE:
-- 
1.5.5
