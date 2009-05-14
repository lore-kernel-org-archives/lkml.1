Return-Path: <linux-kernel-owner+w=401wt.eu-S1761508AbZENNQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761508AbZENNQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761009AbZENNPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:15:49 -0400
Received: from 216-237-3-220.orange.nextweb.net ([216.237.3.220]:19147 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbZENNPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:15:48 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2009 09:15:47 EDT
Message-ID: <4A0C15F3.1090601@solarflare.com>
Date: Thu, 14 May 2009 14:00:35 +0100
From: Neil Turton <nturton@solarflare.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Subject: [PATCH] Fixed an off-by-one error in the AMD IOMMU driver.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2009 13:00:39.0199 (UTC) FILETIME=[FAEE92F0:01C9D493]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable amd_iommu_last_bdf holds the maximum bdf of any device
controlled by an IOMMU, so the number of device entries needed is
amd_iommu_last_bdf+1.  The function tbl_size used amd_iommu_last_bdf
instead.  This would be a problem if the last device were a large
enough power of 2.

Signed-off-by: Neil Turton <nturton@solarflare.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 42c33ce..61479ba 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -175,7 +175,7 @@ static inline void update_last_devid(u16 devid)
 static inline unsigned long tbl_size(int entry_size)
 {
 	unsigned shift = PAGE_SHIFT +
-			 get_order(amd_iommu_last_bdf * entry_size);
+			 get_order(((int)amd_iommu_last_bdf+1) * entry_size);

 	return 1UL << shift;
 }
-- 
1.5.5
