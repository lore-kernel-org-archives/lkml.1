Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab0CKB44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 20:56:56 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:55405 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab0CKB4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 20:56:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc
         :content-type;
        b=H/bi+2+ZWew2g28C/LDzcw+jvGKLA4YhLKE7XWe5TrxbORxH4F9j60LFPhVeXPXTt8
         c1wJ+JTLoTOMz5BQvgshFCWWfSsZ2QWxqBY9a9YtCcKTWEdutmRLINnKQ1RIgwxEzG3b
         qETqCtAba4O5wFti75hbmMRz04NK6264NvUUo=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
From: axel lin <axel.lin@gmail.com>
Date: Thu, 11 Mar 2010 09:56:34 +0800
Message-ID: <427d64721003101756j2a5bf502na83ab35de4bc247e@mail.gmail.com>
Subject: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 99175ed0f281d54efdaf8eef548077a8f0b4924a Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 11 Mar 2010 09:50:07 +0800
Subject: [PATCH] lp3971: Fix BUCK_VOL_CHANGE_SHIFT logic

Given x=0,1,2, current implementation of BUCK_VOL_CHANGE_SHIFT(x) returns 0,4,8.
The correct return value should be 0,4,6.
This patch fix the logic.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp3971.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index a28ae37..1ba61ab 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -45,7 +45,7 @@ static int lp3971_set_bits(struct lp3971 *lp3971, u8
reg, u16 mask, u16 val);
        LP3971_BUCK2 -> 4
        LP3971_BUCK3 -> 6
 */
-#define BUCK_VOL_CHANGE_SHIFT(x) (((1 << x) & ~0x01) << 1)
+#define BUCK_VOL_CHANGE_SHIFT(x) (((!!x) << 2) | (x & ~0x01))
 #define BUCK_VOL_CHANGE_FLAG_GO 0x01
 #define BUCK_VOL_CHANGE_FLAG_TARGET 0x02
 #define BUCK_VOL_CHANGE_FLAG_MASK 0x03
-- 
1.5.4.3
