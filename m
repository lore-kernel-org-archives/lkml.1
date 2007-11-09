Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbXKIGF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbXKIGF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932068AbXKIGDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:03:55 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52883 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932065AbXKIGDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:03:54 -0500
Date: Fri, 9 Nov 2007 07:03:30 +0100
From: Adrian Bunk <bunk@kernel.org>
To: muli@il.ibm.com, jdmason@kudzu.us, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86 pci-calgary_64.c: make a variable static
Message-ID: <20071109060330.GX26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"debugging" is a horrible name for a global variable - thankfully it can 
become static.

Also put it out of __read_mostly so that gcc no longer has to emit it
at all.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/kernel/pci-calgary_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

22f49393bbb5d8e73f94338be5d1ad52f459779c 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 6bf1f71..a262f94 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -183,7 +183,7 @@ static struct calgary_bus_info bus_info[MAX_PHB_BUS_NUM] = { { NULL, 0, 0 }, };
 
 /* enable this to stress test the chip's TCE cache */
 #ifdef CONFIG_IOMMU_DEBUG
-int debugging __read_mostly = 1;
+static int debugging = 1;
 
 static inline unsigned long verify_bit_range(unsigned long* bitmap,
 	int expected, unsigned long start, unsigned long end)
@@ -202,7 +202,7 @@ static inline unsigned long verify_bit_range(unsigned long* bitmap,
 	return ~0UL;
 }
 #else /* debugging is disabled */
-int debugging __read_mostly = 0;
+static int debugging = 0;
 
 static inline unsigned long verify_bit_range(unsigned long* bitmap,
 	int expected, unsigned long start, unsigned long end)

