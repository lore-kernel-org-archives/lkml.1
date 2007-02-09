Return-Path: <linux-kernel-owner+w=401wt.eu-S1946663AbXBIQoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946663AbXBIQoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946639AbXBIQjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:39:20 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51704 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946651AbXBIQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:39:16 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] hpet: trivial __iomem annotations
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HFYmJ-0006ol-N3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 16:39:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/i386/kernel/hpet.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/i386/kernel/hpet.c b/arch/i386/kernel/hpet.c
index 45a8685..0b29d41 100644
--- a/arch/i386/kernel/hpet.c
+++ b/arch/i386/kernel/hpet.c
@@ -12,7 +12,7 @@
 /* FSEC = 10^-15 NSEC = 10^-9 */
 #define FSEC_PER_NSEC	1000000
 
-static void *hpet_ptr;
+static void __iomem *hpet_ptr;
 
 static cycle_t read_hpet(void)
 {
@@ -40,8 +40,7 @@ static int __init init_hpet_clocksource(void)
 		return -ENODEV;
 
 	/* calculate the hpet address: */
-	hpet_base =
-		(void __iomem*)ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+	hpet_base = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
 	hpet_ptr = hpet_base + HPET_COUNTER;
 
 	/* calculate the frequency: */
-- 
1.5.0-rc2.GIT


