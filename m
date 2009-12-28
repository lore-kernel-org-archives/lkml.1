Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbZL1LFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbZL1LFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZL1LFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:05:48 -0500
Received: from smtp.nokia.com ([192.100.122.233]:61223 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbZL1LFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:05:47 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>, Tony Lindgren <tony@atomide.com>,
       linux-omap@vger.kernel.org
Subject: mfd: twl4030-irq: irq_desc->lock converted to raw_spinlock_t
Date: Mon, 28 Dec 2009 13:02:52 +0200
Message-Id: <1261998172-29760-5-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.6.rc0
In-Reply-To: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
References: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Patchwork-Id: 68408
X-OriginalArrivalTime: 28 Dec 2009 11:04:38.0834 (UTC) FILETIME=[8C6A2920:01CA87AD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 239007b8440abff689632f50cdf0f2b9e895b534 converted
the spinlock_t to raw_spinlock_t. Unfortunately twl4030-irq
was left aside on the conversion.

Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

---

resending because it wasn't applied before


 drivers/mfd/twl4030-irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index 20d29ba..9df9a5a 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -568,12 +568,12 @@ static void twl4030_sih_do_edge(struct work_struct *work)
 
 		bytes[byte] &= ~(0x03 << off);
 
-		spin_lock_irq(&d->lock);
+		raw_spin_lock_irq(&d->lock);
 		if (d->status & IRQ_TYPE_EDGE_RISING)
 			bytes[byte] |= BIT(off + 1);
 		if (d->status & IRQ_TYPE_EDGE_FALLING)
 			bytes[byte] |= BIT(off + 0);
-		spin_unlock_irq(&d->lock);
+		raw_spin_unlock_irq(&d->lock);
 
 		edge_change &= ~BIT(i);
 	}
