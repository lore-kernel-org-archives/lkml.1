Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbYDRXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbYDRXXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYDRXWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:22:48 -0400
Received: from havoc.gtf.org ([69.61.125.42]:51491 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYDRXWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:22:47 -0400
Message-Id: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: rmk@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk,
       kernel@wantstofly.org
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/15] ARM minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:22:45 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid confusion by /not/ passing an unused pointer to
arm_rtc_interrupt()

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/arm/mach-integrator/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-integrator/time.c b/arch/arm/mach-integrator/time.c
index 5278f58..5235f64 100644
--- a/arch/arm/mach-integrator/time.c
+++ b/arch/arm/mach-integrator/time.c
@@ -125,7 +125,7 @@ static int rtc_probe(struct amba_device *dev, void *id)
 	xtime.tv_sec = __raw_readl(rtc_base + RTC_DR);
 
 	ret = request_irq(dev->irq[0], arm_rtc_interrupt, IRQF_DISABLED,
-			  "rtc-pl030", dev);
+			  "rtc-pl030", NULL);
 	if (ret)
 		goto map_out;
 
-- 
1.5.4.1

