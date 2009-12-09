Return-Path: <linux-kernel-owner+w=401wt.eu-S967063AbZLIA66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967063AbZLIA66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 19:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967049AbZLIA65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 19:58:57 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60485 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967047AbZLIA64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 19:58:56 -0500
Date: Tue, 8 Dec 2009 16:59:01 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Jon D. Mason" <jdmason@kudzu.us>, discuss@x86-64.org,
       Corinna Schultz <coschult@us.ibm.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] calgary: Increase the maximum PHB bus number
Message-ID: <20091209005901.GX10295@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer systems (x3950M2) can have 48 PHBs per chassis and 8 chassis, so bump the
limits up and provide an explanation of the requirements for each class.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 arch/x86/kernel/pci-calgary_64.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)


diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index e6ec8a2..a693037 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -102,10 +102,15 @@ int use_calgary __read_mostly = 0;
 #define PMR_SOFTSTOPFAULT	0x40000000
 #define PMR_HARDSTOP		0x20000000
 
-#define MAX_NUM_OF_PHBS		8 /* how many PHBs in total? */
-#define MAX_NUM_CHASSIS		8 /* max number of chassis */
-/* MAX_PHB_BUS_NUM is the maximal possible dev->bus->number */
-#define MAX_PHB_BUS_NUM		(MAX_NUM_OF_PHBS * MAX_NUM_CHASSIS * 2)
+/*
+   The maximum PHB bus number.
+   x3950M2 (rare): 8 chassis, 48 PHBs per chassis = 384
+   x3950M2: 4 chassis, 48 PHBs per chassis        = 192
+   x3950 (PCIE): 8 chassis, 32 PHBs per chassis   = 256
+   x3950 (PCIX): 8 chassis, 16 PHBs per chassis   = 128
+*/
+#define MAX_PHB_BUS_NUM		384
+
 #define PHBS_PER_CALGARY	4
 
 /* register offsets in Calgary's internal register space */
