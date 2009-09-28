Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZI1KRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZI1KRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 06:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZI1KRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 06:17:03 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:39827 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZI1KRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 06:17:01 -0400
X-IronPort-AV: E=Sophos;i="4.44,465,1249272000"; 
   d="scan'208";a="6898560"
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, patrick.ohly@intel.com
CC: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Barry Song <21cnbao@gmail.com>
Subject: [PATCH] Fix half-Y2K38 problem in timecompare_update while calculating offset
Date: Mon, 28 Sep 2009 18:16:44 +0800
Message-ID: <1254133004-24877-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.5.6.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ktime will overflow from 03:14:07 UTC on Tuesday, 19 January 2038,
ktime_add() in timecompare_update() will overflow a half earlier.
As a result, wrong offset will be gotten, then cause some strange
problems.
---
 kernel/time/timecompare.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timecompare.c b/kernel/time/timecompare.c
index 71e7f1a..d2d893e 100644
--- a/kernel/time/timecompare.c
+++ b/kernel/time/timecompare.c
@@ -89,7 +89,7 @@ int timecompare_offset(struct timecompare *sync,
 			 * source time
 			 */
 			sample.offset =
-				ktime_to_ns(ktime_add(end, start)) / 2 -
+				(ktime_to_ns(end) + ktime_to_ns(start)) / 2 -
 				ts;
 
 			/* simple insertion sort based on duration */
-- 
1.5.6.3

