Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbXH3Kkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbXH3Kkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbXH3Kkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:40:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58649 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbXH3Kka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:40:30 -0400
Date: Thu, 30 Aug 2007 12:36:12 +0200
From: andre@finow14.de
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andre Haupt <andre@finow14.de>,
       ecd@atecom.com
Subject: [KJ][patch 1/3] IDT77252: use abs() from kernel.h where appropriate
Message-ID: <20070830103612.GB14925@ahaupt-debian-vm.localdomain>
References: <20070830102551.131398783@finow14.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="idt77252_use_abs_from_kernel_h.patch"
User-Agent: quilt/0.45-1
X-Provags-ID: V01U2FsdGVkX18lAL7+bAbTcO47FlBIsqPYfC1OuTJaZl1Rygi
 RqE3+hyeGykoEM2K8b8EIYYjYkIDiUp+12fb2RvJNqInfv1t8x
 B8Tz+dAxB2wnn1p48N0pqIjf/EpzuSa
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Haupt <andre@finow14.de>
Signed-off-by: Andre Haupt <andre@finow14.de>
---
Index: linus/drivers/atm/idt77252.c
===================================================================
--- linus.orig/drivers/atm/idt77252.c	2007-08-30 11:33:22.000000000 +0200
+++ linus/drivers/atm/idt77252.c	2007-08-30 11:37:00.000000000 +0200
@@ -2092,7 +2092,7 @@ idt77252_rate_logindex(struct idt77252_d
 {
 	u16 afp;
 
-	afp = idt77252_int_to_atmfp(pcr < 0 ? -pcr : pcr);
+	afp = idt77252_int_to_atmfp(abs(pcr));
 	if (pcr < 0)
 		return rate_to_log[(afp >> 5) & 0x1ff];
 	return rate_to_log[((afp >> 5) + 1) & 0x1ff];
@@ -2149,7 +2149,7 @@ idt77252_init_est(struct vc_map *vc, int
 	est = kzalloc(sizeof(struct rate_estimator), GFP_KERNEL);
 	if (!est)
 		return NULL;
-	est->maxcps = pcr < 0 ? -pcr : pcr;
+	est->maxcps = abs(pcr);
 	est->cps = est->maxcps;
 	est->avcps = est->cps << 5;
 

--
