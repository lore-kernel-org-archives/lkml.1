Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZDBUhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZDBUhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 16:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932288AbZDBUhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 16:37:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:59528 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765316AbZDBUhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 16:37:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,315,1235980800"; 
   d="scan'208";a="678294010"
Message-Id: <20090402203420.734872000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 13:34:20 -0700
From: fenghua.yu@intel.com
To: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Lutomirski <amluto@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Kyle McMartin <kyle@redhat.com>, Yinghai Lu <yinghai@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       IOMMU <iommu@lists.linux-foundation.org>
Subject: Re: [patch 0/4] Intel IOMMU Supspend/Resume Support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Current Intel IOMMU does not support suspend and resume. In S3 event, kernel
> crashes when DMAR or interrupt remapping is running.
>>
>> The attached patch set implements the suspend and resume feature for Intel
>> IOMMU. It hooks to kernel suspend and resume interface. When suspend happens, itsaves necessary hardware registers. When resume happens, it restores the
>> registers and restarts IOMMU.
>>
>> This patch set can be applied on the tip tree. 
>  
> Looks good to me, apart from the fact that your #4 patch actually needs
>to come before #1. Shall I apply it to my iommu-2.6.git tree or let Ingo
>take it? If the latter, 
>
>Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>
>(if you look carefully, you'll see those are in order 4, 1, 2, 3)
>
>Have we tested this on IA64?

IA64 platforms don't support suspend/resume. The original 4 patches can be
compiled and run on IA64. Only problem is the sysdev interface iommu is
installed but not used.

On the top of the 4 patches, you can apply the following small patch for IA64.
With this small patch, IA64 kernel won't build IOMMU suspend/resume code at all.


Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 intel-iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 5066668..2d9be1d 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2564,7 +2564,7 @@ static void __init init_no_remapping_devices(void)
 	}
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_SUSPEND
 static int init_iommu_hw(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -2702,7 +2702,7 @@ static int __init init_iommu_sysfs(void)
 }
 
 #else
-static init __init init_iommu_sysfs(void)
+static int __init init_iommu_sysfs(void)
 {
 	return 0;
 }
-- 

