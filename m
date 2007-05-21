Return-Path: <linux-kernel-owner+w=401wt.eu-S1762463AbXEUKMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762463AbXEUKMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761640AbXEUKJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:23 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5145 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796AbXEUKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:13 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505449:sNHT24156587"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 29/32] Blackfin arch: update pm.c according to power management API change.
Date: Mon, 21 May 2007 18:09:37 +0800
Message-Id: <11797421881875-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-common/pm.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index deb2727..afed524 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -102,10 +102,8 @@ static int bfin_pm_prepare(suspend_state_t state)
 	switch (state) {
 	case PM_SUSPEND_STANDBY:
 		break;
-	case PM_SUSPEND_MEM:
-		return -ENOTSUPP;
 
-	case PM_SUSPEND_DISK:
+	case PM_SUSPEND_MEM:
 		return -ENOTSUPP;
 
 	default:
@@ -126,10 +124,8 @@ static int bfin_pm_enter(suspend_state_t state)
 	case PM_SUSPEND_STANDBY:
 		bfin_pm_suspend_standby_enter();
 		break;
-	case PM_SUSPEND_MEM:
-		return -ENOTSUPP;
 
-	case PM_SUSPEND_DISK:
+	case PM_SUSPEND_MEM:
 		return -ENOTSUPP;
 
 	default:
@@ -155,9 +151,6 @@ static int bfin_pm_finish(suspend_state_t state)
 	case PM_SUSPEND_MEM:
 		return -ENOTSUPP;
 
-	case PM_SUSPEND_DISK:
-		return -ENOTSUPP;
-
 	default:
 		return -EINVAL;
 	}
@@ -166,7 +159,6 @@ static int bfin_pm_finish(suspend_state_t state)
 }
 
 struct pm_ops bfin_pm_ops = {
-	.pm_disk_mode = PM_DISK_PLATFORM,
 	.prepare = bfin_pm_prepare,
 	.enter = bfin_pm_enter,
 	.finish = bfin_pm_finish,
-- 
1.5.1.2
