Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbXDYV72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbXDYV72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbXDYV72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:59:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:10297 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbXDYV71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:59:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lS0Lq2JIwNpRQWAqLXGOmLAUpSCUlmjuG0M5p3LVKr5KkEoJYKHrHjPPXMs8OQwta/yTiS3x5NfufGIf7vEflzJKlkeryjWUNdoTw4+Cr6crsmisFv/8wjnqDXnykV32aGYqSL+/H7SvbAeY/3AkF2JwdkxyHnMw9zQWzYbNEY4=
From: Sergey Yanovich <ynvich@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx,
       Sergey Yanovich <ynvich@gmail.com>
Subject: [PATCH] [mmc] [tifm] Reduces delay in card insert/removal
Date: Thu, 26 Apr 2007 00:59:25 +0300
Message-Id: <11775383661213-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11775383653672-git-send-email-ynvich@gmail.com>
References: 200704200056.33866.arnd@arndb.de
 <11775383653672-git-send-email-ynvich@gmail.com>
Message-Id: <033d5e9dede8853d54e81bc9c1435a2b7915518b.1177536863.git.ynvich@gmail.com>
In-Reply-To: <5e03dd4e0b14c8155162a5b5b1cea4ed7e04cea3.1177536862.git.ynvich@gmail.com>
References: <5e03dd4e0b14c8155162a5b5b1cea4ed7e04cea3.1177536862.git.ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First, I tried to replace 'mdelay' with 'msleep' and put it after
'unlock'. It gives a certain oops.

With the delay of 50 msec driver remains stable. It has something
to do with hardware initialization, so this value should not be
affected by CPU speed. I hope so.

Signed-off-by: Sergey Yanovich <ynvich@gmail.com>
---
 drivers/mmc/tifm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/tifm.c b/drivers/mmc/tifm.c
index 30cab30..310f07c 100644
--- a/drivers/mmc/tifm.c
+++ b/drivers/mmc/tifm.c
@@ -361,7 +361,7 @@ mmc_tifm_irq_chip(unsigned long param)
 		socket->state = READY;
 		tasklet_schedule(&socket->cmd_end);
 	}
-	mdelay(100);
+	mdelay(50);
 	spin_unlock_irqrestore(&socket->lock, flags);
 	mmc_detect_change(mmc, 0);
 }
-- 
1.5.1.2

