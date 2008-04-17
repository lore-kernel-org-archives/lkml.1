Return-Path: <linux-kernel-owner+w=401wt.eu-S1761902AbYDUNZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761902AbYDUNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760148AbYDUNTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:9129 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033AbYDUNTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=p/UOgWhCcM5WIEDUa/m0dgBfbKPxgykYT4Y6VISuC/CGWhxB8RFJel6fLPz0Uv8PKqIs45hhFzpPOyGrsCW4/GntxlwebVlnGI22t4rtLanTzrm+usnuxljPtRzq0Ty5PUaFdmxjtQgVq8WNPPZZniZ/mN0BELOguIqyWbmsKlM=
Message-Id: <db7c10e708b9bdd1618c034591d27c33cb341222.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 17 Apr 2008 09:24:48 -0400
Subject: [PATCH 31/37] Input: wm97xx-core - use IRQF_SAMPLE_RANDOM
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Mark Brown <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The touchscreen interrupt is driven by human input which can reasonably
be used to provide entropy.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/touchscreen/wm97xx-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index e27b1e0..fec07c2 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -355,7 +355,8 @@ static int wm97xx_init_pen_irq(struct wm97xx *wm)
 	 * provided. */
 	BUG_ON(!wm->mach_ops->irq_enable);
 
-	if (request_irq(wm->pen_irq, wm97xx_pen_interrupt, IRQF_SHARED,
+	if (request_irq(wm->pen_irq, wm97xx_pen_interrupt,
+			IRQF_SHARED | IRQF_SAMPLE_RANDOM,
 			"wm97xx-pen", wm)) {
 		dev_err(wm->dev,
 			"Failed to register pen down interrupt, polling");
-- 
1.5.5.rc2.6.gf58d


