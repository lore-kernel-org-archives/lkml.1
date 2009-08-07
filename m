Return-Path: <linux-kernel-owner+w=401wt.eu-S933922AbZHGUm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922AbZHGUm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933872AbZHGUmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:42:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33075 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731AbZHGUmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:42:52 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/6] ucb1x00: include linux/semaphore.h
Date: Fri,  7 Aug 2009 22:42:36 +0200
Message-Id: <1249677761-19470-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

This fixes the following error:

	  CC      drivers/mfd/ucb1x00-core.o
	drivers/mfd/ucb1x00-core.c: In function 'ucb1x00_adc_enable':
	drivers/mfd/ucb1x00-core.c:138: error: implicit declaration of function 'down'
	drivers/mfd/ucb1x00-core.c: In function 'ucb1x00_adc_disable':
	drivers/mfd/ucb1x00-core.c:196: error: implicit declaration of function 'up'
	drivers/mfd/ucb1x00-core.c: In function 'ucb1x00_probe':
	drivers/mfd/ucb1x00-core.c:500: error: implicit declaration of function 'sema_init'

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
---
Hello,

should this better be converted to mutex_lock/mutex_unlock?

Best regards
Uwe
---
 drivers/mfd/ucb1x00-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index fea9085..3c59c26 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/semaphore.h>
 
 #include <mach/dma.h>
 #include <mach/hardware.h>
-- 
1.6.3.3

