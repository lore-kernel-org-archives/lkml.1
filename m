Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbYDUNWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbYDUNWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbYDUNS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:18:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:8681 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759793AbYDUNS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=H8mhv4EJ01gToiJWAUCxZoEFp2BnvGbe9Og3YYcplk3sOx5OUpz3PQZAwALA+MLC3sQIF218mYyiT6AEPPZ0xBeqmomS1UZCuMADn1g8IEg1qp75zRJy/TY2InIUP82zAJclQS5TSjSzlGtQOhs1o1RrSRGBYavRk9nbFlYuYmI=
Message-Id: <1164ec1ae43770db6ea5450c6cac0761b11d6d1d.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Tue, 15 Apr 2008 01:31:13 -0400
Subject: [PATCH 23/37] Input: gpio_keys - irq handling cleanup
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: David Brownell <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup IRQ handling in gpio_keys:  bail after handling the IRQ, and
report IRQ_NONE if we never handle it.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/keyboard/gpio_keys.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 6a9ca4b..a54dc15 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -43,10 +43,11 @@ static irqreturn_t gpio_keys_isr(int irq, void *dev_id)
 
 			input_event(input, type, button->code, !!state);
 			input_sync(input);
+			return IRQ_HANDLED;
 		}
 	}
 
-	return IRQ_HANDLED;
+	return IRQ_NONE;
 }
 
 static int __devinit gpio_keys_probe(struct platform_device *pdev)
-- 
1.5.5.rc2.6.gf58d


