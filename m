Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZIPWqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZIPWqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760596AbZIPWqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:46:18 -0400
Received: from kroah.org ([198.145.64.141]:48912 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760069AbZIPWju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:50 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:15 2009
Message-Id: <20090916223715.136276870@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 13/45] x86/amd-iommu: fix broken check in amd_iommu_flush_all_devices
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=x86-amd-iommu-fix-broken-check-in-amd_iommu_flush_all_devices.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joerg Roedel <joerg.roedel@amd.com>

commit e0faf54ee82bf9c07f0307b4391caad4020bd659 upstream.

The amd_iommu_pd_table is indexed by protection domain
number and not by device id. So this check is broken and
must be removed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -485,8 +485,6 @@ void amd_iommu_flush_all_devices(void)
 	int i;
 
 	for (i = 0; i <= amd_iommu_last_bdf; ++i) {
-		if (amd_iommu_pd_table[i] == NULL)
-			continue;
 
 		iommu = amd_iommu_rlookup_table[i];
 		if (!iommu)


