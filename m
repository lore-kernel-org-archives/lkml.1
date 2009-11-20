Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZKTQav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZKTQav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZKTQau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:30:50 -0500
Received: from smtp.nokia.com ([192.100.122.230]:35818 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbZKTQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:30:50 -0500
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "\\\"De-Schrijver Peter (Nokia-D/Helsinki)\\\"" 
	<Peter.De-Schrijver@nokia.com>,
       Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 1/1] twl4030-regulator: Remove regulator from all groups when disabling
Date: Fri, 20 Nov 2009 18:29:19 +0200
Message-Id: <1258734559-15594-1-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.6.5.7.g9ecb2
X-OriginalArrivalTime: 20 Nov 2009 16:29:29.0496 (UTC) FILETIME=[A20EA980:01CA69FE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just remove regulator from all groups when disabling. This way we
avoid problems if boot loader touches twl4030 registers.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index e2032fb..27b3115 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -126,7 +126,7 @@ static int twl4030reg_disable(struct regulator_dev *rdev)
 	if (grp < 0)
 		return grp;
 
-	grp &= ~P1_GRP;
+	grp &= ~(P1_GRP & P2_GRP | P3_GRP);
 	return twl4030reg_write(info, VREG_GRP, grp);
 }
 
-- 
1.6.5.7.g9ecb2

