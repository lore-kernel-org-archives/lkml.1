Return-Path: <linux-kernel-owner+w=401wt.eu-S933937AbZHGUnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937AbZHGUnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933925AbZHGUnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:43:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33082 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933872AbZHGUm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:42:58 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH 4/6] [ARM] ixp2000: fix type of ixp2000_timer_interrupt
Date: Fri,  7 Aug 2009 22:42:39 +0200
Message-Id: <1249677761-19470-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090807203939.GA19374@pengutronix.de>
References: <20090807203939.GA19374@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build warning for 2.6.31-rc5 (ARCH=arm, ixp2000_defconfig):

	  CC      arch/arm/mach-ixp2000/core.o
	arch/arm/mach-ixp2000/core.c:217: warning: initialization from incompatible pointer type

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
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
1.6.3.3

