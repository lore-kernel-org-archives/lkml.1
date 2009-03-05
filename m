Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbZCELWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbZCELWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbZCELW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:22:29 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:30884
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751405AbZCELW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:22:28 -0500
X-BigFish: VPS-14(z21eWzzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KG1693-01-78I-01
Date: Thu, 5 Mar 2009 12:22:15 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] iommu fixes for 2.6.29-rc7
Message-ID: <20090305112215.GB8751@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Mar 2009 11:22:15.0634 (UTC) FILETIME=[A3378B20:01C99D84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 559595a985e106d2fa9f0c79b7f5805453fed593:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../benh/powerpc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git iommu/fixes-2.6.29

FUJITA Tomonori (1):
      AMD IOMMU: remove unnecessary ifdef

Hannes Eder (1):
      IOMMU-API: use ANSI style function declaration for 'iommu_found'

 arch/x86/kernel/amd_iommu.c |    2 --
 drivers/base/iommu.c        |    2 +-
 2 files changed, 1 insertions(+), 3 deletions(-)

One fix is for AMD IOMMU and the other one for the IOMMU-API. Please
pull.

Joerg

Here is the full diff:

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 5113c08..d7a7c4c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -23,9 +23,7 @@
 #include <linux/debugfs.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
-#ifdef CONFIG_IOMMU_API
 #include <linux/iommu.h>
-#endif
 #include <asm/proto.h>
 #include <asm/iommu.h>
 #include <asm/gart.h>
diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index 5e039d4..c2d1eed 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -31,7 +31,7 @@ void register_iommu(struct iommu_ops *ops)
 	iommu_ops = ops;
 }
 
-bool iommu_found()
+bool iommu_found(void)
 {
 	return iommu_ops != NULL;
 }

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

