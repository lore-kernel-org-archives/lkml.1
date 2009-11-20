Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZKTRQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZKTRQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZKTRQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:16:31 -0500
Received: from smtp.nokia.com ([192.100.122.233]:49835 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbZKTRQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:16:31 -0500
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       De-Schrijver Peter <Peter.De-Schrijver@nokia.com>,
       Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 1/1] twl4030-regulator: Remove regulator from all groups when disabling
Date: Fri, 20 Nov 2009 19:15:54 +0200
Message-Id: <1258737354-16409-1-git-send-email-eduardo.valentin@nokia.com>
X-Mailer: git-send-email 1.6.5.7.g9ecb2
X-OriginalArrivalTime: 20 Nov 2009 17:16:10.0161 (UTC) FILETIME=[27623A10:01CA6A05]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Valentin <eduardo.valentin@nokia.com>

Just remove regulator from all groups when disabling. This way we
avoid problems if boot loader touches twl4030 registers.

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index e2032fb..9365140 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -126,7 +126,7 @@ static int twl4030reg_disable(struct regulator_dev *rdev)
 	if (grp < 0)
 		return grp;
 
-	grp &= ~P1_GRP;
+	grp &= ~(P1_GRP | P2_GRP | P3_GRP);
 	return twl4030reg_write(info, VREG_GRP, grp);
 }
 
-- 
1.6.5.7.g9ecb2

