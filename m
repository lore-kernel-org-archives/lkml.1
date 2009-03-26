Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbZCZOVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbZCZOVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZCZOU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:20:58 -0400
Received: from smtp.nokia.com ([192.100.122.233]:21047 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbZCZOU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:20:57 -0400
Message-ID: <49CB8F5A.4030400@nokia.com>
Date: Thu, 26 Mar 2009 16:21:14 +0200
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@sirena.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] regulator: twl4030 VAUX3 supports 3.0V
References: <49B11EB0.30809@nokia.com> <1237290190.6781.313.camel@vega.slimlogic.co.uk> <49C9EB17.2020408@nokia.com> <200903251003.29340.david-b@pacbell.net>
In-Reply-To: <200903251003.29340.david-b@pacbell.net>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Mar 2009 14:20:24.0978 (UTC) FILETIME=[013CBF20:01C9AE1E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 51f946af56a5de9c25b2eb6e6a33660283f84195 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@nokia.com>
Date: Fri, 6 Mar 2009 14:51:30 +0200
Subject: [PATCH] regulator: twl4030 VAUX3 supports 3.0V

TWL4030 and TWL5030 support 3.0V on VAUX3.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index f3ec98c..e2032fb 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -193,6 +193,9 @@ static int twl4030reg_set_mode(struct regulator_dev *rdev, unsigned mode)
  *
  * VSEL values documented as "TI cannot support these values" are flagged
  * in these tables as UNSUP() values; we normally won't assign them.
+ *
+ * VAUX3 at 3V is incorrectly listed in some TI manuals as unsupported.
+ * TI are revising the twl5030/tps659x0 specs to support that 3.0V setting.
  */
 #ifdef CONFIG_TWL4030_ALLOW_UNSUPPORTED
 #define UNSUP_MASK	0x0000
@@ -223,7 +226,7 @@ static const u16 VAUX2_VSEL_table[] = {
 };
 static const u16 VAUX3_VSEL_table[] = {
 	1500, 1800, 2500, 2800,
-	UNSUP(3000), UNSUP(3000), UNSUP(3000), UNSUP(3000),
+	3000, 3000, 3000, 3000,
 };
 static const u16 VAUX4_VSEL_table[] = {
 	700, 1000, 1200, UNSUP(1300),
-- 
1.5.6.3
