Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121Ab0AVUUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0AVUUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 15:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060Ab0AVUUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 15:20:06 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:41502 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab0AVUUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 15:20:04 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jan 2010 15:20:04 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=P8LMW31Iyh+0su0rgMcGye4qYn/1qVrW1ISnxR/+aDDAtS92msvTM/NKKR5kqSJahD
         OCHyXrSvsx5oC94jZFzviHKmuWBeq6kBDSV+GY/E9iA+/vjMK7+BuYTFE3fk9j1d47NH
         PB03BuCXE7WPeLetad4sfbqwDv2iOieTK5vDY=
From: mturquette@gmail.com
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Mike Turquette <mturquette@ti.com>
Subject: [PATCH] MFD: TWL4030: program remap_sleep correctly
Date: Fri, 22 Jan 2010 14:12:58 -0600
Message-Id: <1264191178-12877-1-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Turquette <mturquette@ti.com>

Variable remap was incorrectly referencing remap_off for the remap_sleep
case when configuring TWL4030 power scripts.

Signed-off-by: Mike Turquette <mturquette@ti.com>
---
 drivers/mfd/twl4030-power.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Applies to MFD master branch, for .33 fixes

diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
index 0815292..5b045ff 100644
--- a/drivers/mfd/twl4030-power.c
+++ b/drivers/mfd/twl4030-power.c
@@ -405,7 +405,7 @@ static int __init twl4030_configure_resource(struct twl4030_resconfig *rconfig)
 
 	if (rconfig->remap_sleep != TWL4030_RESCONFIG_UNDEF) {
 		remap &= ~SLEEP_STATE_MASK;
-		remap |= rconfig->remap_off << SLEEP_STATE_SHIFT;
+		remap |= rconfig->remap_sleep << SLEEP_STATE_SHIFT;
 	}
 
 	err = twl_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
-- 
1.6.3.2

