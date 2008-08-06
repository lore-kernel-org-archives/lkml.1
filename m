Return-Path: <linux-kernel-owner+w=401wt.eu-S1763555AbYHFIsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763555AbYHFIsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763504AbYHFIo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:44:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:13145 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763449AbYHFIoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LieiknxP5JRf0s+1FMAoiDHcxOYa68eTUoecersYKUEfkozTK4eHkiVv1F7EGCsVcn
         8iHoUO6tALG814NYSQfgpCUzXghdJHHFmgToVgUfeJRyW+pBGUP5zq9YPQDfc3nWpoyK
         bLLCgISQh+fGYVVj/qlod2biW/U3FZ41WiljM=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 09/33] drivers/char to use nr_irqs
Date: Wed,  6 Aug 2008 01:42:51 -0700
Message-Id: <1218012195-10429-10-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
References: <1218012195-10429-1-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-2-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-3-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-4-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-5-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-6-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-7-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-8-git-send-email-yhlu.kernel@gmail.com>
 <1218012195-10429-9-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 drivers/char/hpet.c       |    2 +-
 drivers/char/random.c     |    4 ++--
 drivers/char/vr41xx_giu.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 2908a0e..8d562ae 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -219,7 +219,7 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)
 	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
 		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
 
-		if (irq >= NR_IRQS) {
+		if (irq >= nr_irqs) {
 			irq = HPET_MAX_IRQ;
 			break;
 		}
diff --git a/drivers/char/random.c b/drivers/char/random.c
index e0d0e37..fdbdcfc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -647,7 +647,7 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 void add_interrupt_randomness(int irq)
 {
-	if (irq >= NR_IRQS || irq_timer_state[irq] == NULL)
+	if (irq >= nr_irqs || irq_timer_state[irq] == NULL)
 		return;
 
 	DEBUG_ENT("irq event %d\n", irq);
@@ -911,7 +911,7 @@ void rand_initialize_irq(int irq)
 {
 	struct timer_rand_state *state;
 
-	if (irq >= NR_IRQS || irq_timer_state[irq])
+	if (irq >= nr_irqs || irq_timer_state[irq])
 		return;
 
 	/*
diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
index ffe9b4e..54c8372 100644
--- a/drivers/char/vr41xx_giu.c
+++ b/drivers/char/vr41xx_giu.c
@@ -641,7 +641,7 @@ static int __devinit giu_probe(struct platform_device *dev)
 	}
 
 	irq = platform_get_irq(dev, 0);
-	if (irq < 0 || irq >= NR_IRQS)
+	if (irq < 0 || irq >= nr_irqs)
 		return -EBUSY;
 
 	return cascade_irq(irq, giu_get_irq);
-- 
1.5.4.5

