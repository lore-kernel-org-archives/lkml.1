Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZJULta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZJULta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 07:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbZJULta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 07:49:30 -0400
Received: from smtp.nokia.com ([192.100.122.233]:35539 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbZJULt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 07:49:29 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] mfd: fix more undefined twl4030-power resconfig value checks
Date: Wed, 21 Oct 2009 14:49:22 +0300
Message-Id: <1256125762-10069-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 21 Oct 2009 11:49:26.0847 (UTC) FILETIME=[8A8164F0:01CA5244]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Aaro's previous fix, this needs to be fixed for the newly added
remap_off and remap_sleep resources as well.

The code tries to skip values initialized with -1, but since the values
are unsigned the comparison is always true.

The patch eliminates the following compiler warnings:

drivers/mfd/twl4030-power.c: In function 'twl4030_configure_resource':
drivers/mfd/twl4030-power.c:338: warning: comparison is always true due to
limited range of data type

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/twl4030-power.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 9f98c36..3048f18 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -398,12 +398,12 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 		return err;
 	}
 
-	if (rconfig->remap_off >= 0) {
+	if (rconfig->remap_off != TWL4030_RESCONFIG_UNDEF) {
 		remap &= ~OFF_STATE_MASK;
 		remap |= rconfig->remap_off << OFF_STATE_SHIFT;
 	}
 
-	if (rconfig->remap_sleep >= 0) {
+	if (rconfig->remap_sleep != TWL4030_RESCONFIG_UNDEF) {
 		remap &= ~SLEEP_STATE_MASK;
 		remap |= rconfig->remap_off << SLEEP_STATE_SHIFT;
 	}
-- 
1.6.3.3

