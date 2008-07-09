Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYGIL0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYGIL0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 07:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYGIL0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 07:26:34 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:54304 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113AbYGIL0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 07:26:33 -0400
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH 1/1] Setup only one PWM clock when allocating a clock in atmel PWM driver
Date: Wed,  9 Jul 2008 13:26:25 +0200
Message-Id: <1215602785-10881-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: git-send-email 1.5.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will only setup one clock, if free, and return this clock to the
caller. The previous solution would setup both clocks with the same prescaler
and divider and return PWM_CPR_CLKB, thus taking both clocks in the same call
without the caller knowing.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/misc/atmel_pwm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index 0d5ce03..358e02c 100644
--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -211,8 +211,7 @@ int pwm_clk_alloc(unsigned prescale, unsigned div)
 	if ((mr & 0xffff) == 0) {
 		mr |= val;
 		ret = PWM_CPR_CLKA;
-	}
-	if ((mr & (0xffff << 16)) == 0) {
+	} else if ((mr & (0xffff << 16)) == 0) {
 		mr |= val << 16;
 		ret = PWM_CPR_CLKB;
 	}
-- 
1.5.4.3

