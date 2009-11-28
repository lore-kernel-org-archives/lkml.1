Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZK1Ps0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZK1Ps0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 10:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZK1PsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 10:48:25 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:47053 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZK1PsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 10:48:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QW1EZ979M6s/rnsDR2VF7jdnJ/I4vXs6mpztErVKoIkmMzWJ2C2mjAXiKW4l/+tmI4
         ClUrdQ0GvmJnfIJSY9DeDZ+qZadsaVARTDjwuUgm36NGv+4ZKlp+YvWIR1Sgn81CcoSy
         TfnbwQxkbVJ7gfaqFf/0fRdepYTYTf0x2kmeI=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: rpurdie@rpsys.net, dave@sr71.net, martinez.javier@gmail.com,
       Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] leds: fix the return value of ich7_lpc_probe.
Date: Sat, 28 Nov 2009 10:48:10 -0500
Message-Id: <1259423290-6864-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.rc0.61.g41d5b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function ich7_lpc_probe there is a 'return' that is not returning any
value, but it should because the return type is int not void.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/leds/leds-ss4200.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index c7f6347..a0c4092 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -350,7 +350,7 @@ static int __devinit ich7_lpc_probe(struct pci_dev *dev,
 	status = pci_enable_device(dev);
 	if (status) {
 		dev_err(&dev->dev, "pci_enable_device failed\n");
-		return;
+		return status;
 	}
 
 	nas_gpio_pci_dev = dev;
-- 
1.6.6.rc0.61.g41d5b

