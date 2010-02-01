Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab0BAPPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 10:15:24 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:55475 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173Ab0BAPPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 10:15:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u6N78v8BkXowGn1H0qg0HKemElp+DsznEk4ySsyXmmRoFlKaf3HavmlokBat1azg1s
         9L3FIgBcYZQ4/TQkhF2uZNK3VEQG1M5poCpCfFEN8YRAyQh94OsXxxFGnlUkWCXKo4rR
         naFqhK6ifEetF4IuIdFBMR2t4EL82N+pnjves=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 9/9] hpet: Use for_each_set_bit
Date: Tue,  2 Feb 2010 00:10:40 +0900
Message-Id: <1265037040-23413-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
References: <1265037040-23413-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: rename for_each_bit to for_each_set_bit

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/char/hpet.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index e481c59..9c5eea3 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -215,9 +215,7 @@ static void hpet_timer_set_irq(struct hpet_dev *devp)
 	else
 		v &= ~0xffff;
 
-	for (irq = find_first_bit(&v, HPET_MAX_IRQ); irq < HPET_MAX_IRQ;
-		irq = find_next_bit(&v, HPET_MAX_IRQ, 1 + irq)) {
-
+	for_each_set_bit(irq, &v, HPET_MAX_IRQ) {
 		if (irq >= nr_irqs) {
 			irq = HPET_MAX_IRQ;
 			break;
-- 
1.6.0.6

