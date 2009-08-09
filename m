Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbZHIJhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbZHIJhI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 05:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZHIJhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 05:37:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52555 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbZHIJhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 05:37:01 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-mm@kvack.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: [PATCH RT 7/6] include linux/interrupt.h in mm/bounce.c
Date: Sun,  9 Aug 2009 11:36:38 +0200
Message-Id: <1249810600-21946-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

This fixes a a build failure for 2.6.31-rc4-rt1 (ARCH=arm,
mv78xx0_defconfig and others):

mm/bounce.c: In function 'bounce_copy_vec':
mm/bounce.c:52: error: implicit declaration of function 'local_irq_save_nort'
mm/bounce.c:56: error: implicit declaration of function 'local_irq_restore_nort'

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk
---
 mm/bounce.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/bounce.c b/mm/bounce.c
index 2fd099c..4a91eed 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/hash.h>
 #include <linux/highmem.h>
+#include <linux/interrupt.h>
 #include <asm/tlbflush.h>
 
 #include <trace/events/block.h>
-- 
1.6.3.3

