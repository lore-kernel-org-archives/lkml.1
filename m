Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931Ab0AWVBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0AWVBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 16:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548Ab0AWVBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 16:01:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33602 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0AWVBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 16:01:53 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: ixp2000: fix type of ixp2000_timer_interrupt
Date: Sat, 23 Jan 2010 22:01:39 +0100
Message-Id: <1264280500-22878-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build warning for 2.6.33-rc5:

	arch/arm/mach-ixp2000/core.c:217: warning: initialization from incompatible pointer type

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-ixp2000/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-ixp2000/core.c b/arch/arm/mach-ixp2000/core.c
index babb225..e24e3d0 100644
--- a/arch/arm/mach-ixp2000/core.c
+++ b/arch/arm/mach-ixp2000/core.c
@@ -197,7 +197,7 @@ unsigned long ixp2000_gettimeoffset (void)
 	return offset / ticks_per_usec;
 }
 
-static int ixp2000_timer_interrupt(int irq, void *dev_id)
+static irqreturn_t ixp2000_timer_interrupt(int irq, void *dev_id)
 {
 	/* clear timer 1 */
 	ixp2000_reg_wrb(IXP2000_T1_CLR, 1);
-- 
1.6.6

