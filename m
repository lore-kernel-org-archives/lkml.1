Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353Ab0AaL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0AaL5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 06:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990Ab0AaL5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 06:57:30 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:64335 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0AaL51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 06:57:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=AU6EUoAWymO0JD+UOF+ixQybs7QKEu6DG4XmNbHwPxE5EkX2mFxzWS2qGltr5k5u6R
         W3foAmW6N/TvLmWnf30SYHFEbOCkpNdyqNUqAPGBxWbFGPios9rIiUFir6TeONTv/tBG
         gpftR3nkdfkmh3fRVZ0oOhQ0ZSYMJfvl7TB2k=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 7/7] hpet: Use for_each_bit
Date: Sun, 31 Jan 2010 20:53:30 +0900
Message-Id: <1264938810-4173-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/char/hpet.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e481c59..b509185 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -215,9 +215,7 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)
 	else
 		v &= ~0xffff;
 
-	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
-		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
-
+	for_each_bit(irq, &v, HPET_MAX_IRQ) {
 		if (irq >= nr_irqs) {
 			irq = HPET_MAX_IRQ;
 			break;
-- 
1.6.0.6

