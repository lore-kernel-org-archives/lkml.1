Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZEIUV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZEIUV7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 16:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbZEIUVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 16:21:50 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:9753 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346AbZEIUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 16:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=KQtpvefVSjTT2B/+nty95RA83IHYnFtSQFzoQbIcxVy/bbdWCkbLR/5Dla3qW/pbvj
         mIOmUsMGopT5hZD4ZeqYF6AAINdOJAZ3IpNnCuZX5aWEhw24E+Y6sTGh+R/MrpFUHlsz
         ghEwAkCohA4j5GXqZaR9RSJwaiKr7UhicxNVY=
From: Nelson Castillo <arhuaco@freaks-unidos.net>
Subject: [PATCH] pcf50633: Fix unsafe disable_irq
To: sameo@linux.intel.com
Cc: balajirrao@openmoko.org, linux-kernel@vger.kernel.org
Date: Sat, 09 May 2009 15:21:43 -0500
Message-ID: <20090509202143.8431.81717.stgit@localhost>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this change Openmoko Freerunner (GTA02) bootstrap
will deadlock. As pointed out in other patches this issue is
in the wild since the merge of:

commit 3aa551c9b4c40018f0e261a178e3d25478dc04a9
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Mon Mar 23 18:28:15 2009 +0100

   genirq: add threaded interrupt handler support

   Add support for threaded interrupt handlers

Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
---

 drivers/mfd/pcf50633-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 7793932..11a6248 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -443,7 +443,7 @@ static irqreturn_t pcf50633_irq(int irq, void *data)
 	dev_dbg(pcf->dev, "pcf50633_irq\n");
 
 	get_device(pcf->dev);
-	disable_irq(pcf->irq);
+	disable_irq_nosync(pcf->irq);
 	schedule_work(&pcf->irq_work);
 
 	return IRQ_HANDLED;

