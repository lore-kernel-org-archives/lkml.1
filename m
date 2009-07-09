Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbZGIOq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbZGIOq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbZGIOqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:46:48 -0400
Received: from www.tglx.de ([62.245.132.106]:51596 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531AbZGIOqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:46:47 -0400
Date: Thu, 9 Jul 2009 16:46:21 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, nico@cam.org
Subject: [PATCH] trivial: ucb1400_ts: Fix a misleading function name
Message-ID: <20090709144620.GC3646@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver for UCB1400 touchscreen controllers contains a function named
ucb1400_ts_pen_down(), but it returns 0 if the pen is down and 1 if it's up.
This causes confusion, especially since it's used as a boolean truth value
later in the code. This patch renames it.

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

---
 drivers/input/touchscreen/ucb1400_ts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.31-rc/drivers/input/touchscreen/ucb1400_ts.c
===================================================================
--- linux-2.6.31-rc.orig/drivers/input/touchscreen/ucb1400_ts.c	2009-07-09 14:45:45.000000000 +0200
+++ linux-2.6.31-rc/drivers/input/touchscreen/ucb1400_ts.c	2009-07-09 14:46:57.000000000 +0200
@@ -128,7 +128,7 @@
 	return ucb1400_adc_read(ucb->ac97, 0, adcsync);
 }
 
-static inline int ucb1400_ts_pen_down(struct snd_ac97 *ac97)
+static inline int ucb1400_ts_pen_up(struct snd_ac97 *ac97)
 {
 	unsigned short val = ucb1400_reg_read(ac97, UCB_TS_CR);
 	return val & (UCB_TS_CR_TSPX_LOW | UCB_TS_CR_TSMX_LOW);
@@ -209,7 +209,7 @@
 
 		msleep(10);
 
-		if (ucb1400_ts_pen_down(ucb->ac97)) {
+		if (ucb1400_ts_pen_up(ucb->ac97)) {
 			ucb1400_ts_irq_enable(ucb->ac97);
 
 			/*
