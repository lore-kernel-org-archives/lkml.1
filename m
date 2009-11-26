Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbZKZIAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbZKZIAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 03:00:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759230AbZKZIAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 03:00:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:6372 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759206AbZKZIAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 03:00:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,292,1257148800"; 
   d="scan'208";a="573304070"
From: ling.ma@intel.com
To: mingo@elte.hu
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Ma Ling <ling.ma@intel.com>
Subject: [PATCH RFC] [X86] Compile Option Os versus O2 on latest x86 platform
Date: Thu, 26 Nov 2009 16:05:52 +0800
Message-Id: <1259222752-8161-1-git-send-email-ling.ma@intel.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ma Ling <ling.ma@intel.com>

Hi All

In current kernel compile original option we prefer Os to O2. Os will reduce
compiled kernel code size obviously, and O2 pay more attention to performance
than code size, so in real environment O2 will bring more i-cache miss than Os,
totally performance should slowdown.

In our system test machine kernel code size from Os is 12M, and that from O2 is 14M.
 
But we have two questions about it on latest platform: 
1. 10% * current kernel code size from Os(CPU execution path)
   is far more L1 i-cache size, the difference of i-cache-miss counts from
   both options should become little.
2. our latest platform should has excellent prefetch capability by adjusting
   predication execution path.

Based on above reasons we re-compiled linux kernel with O2 option on below platform.
CPU type: 2P Quad-core Core i7(2 socket*4 core *2 hyper threads)
CPU frequency: 2670MHz
Memory: 6 x 1GBMb

We mainly tested common and stable benchmarks two times,  results show
O2 performance is better than Os (linux kernel version 2.6.32-rc8)  

Benchmarks:                          improvement 
volano                                8%
netperf                               6.7% 
tbench                                6.45%
Kbuild                                5.5% (3 time test, average improvement)
specjbb2000                           2%
fio                                   2%
specjbb2005                           No change
cpu2000                               No change
aim7                                  No change
hackbench                             No Change
oltp                                  No Change

This patch try to enable O2 option and disable Os option.

Appreciate any comments.

Thanks
Ling

---
 arch/x86/configs/x86_64_defconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 6c86acd..d564b90 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -126,7 +126,7 @@ CONFIG_INITRAMFS_SOURCE=""
 CONFIG_RD_GZIP=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
-CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_CC_OPTIMIZE_FOR_SIZE=n
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
 # CONFIG_EMBEDDED is not set
-- 
1.6.2.5

