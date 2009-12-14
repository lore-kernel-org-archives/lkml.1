Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbZLNRSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbZLNRSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 12:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbZLNRSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 12:18:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42579 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036AbZLNRSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 12:18:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=q7OMp8WeEzbc3duo40ZH9LsGRFL12KEtJEwARGcdw3WA4vIJPll7Is1h6wIkO6uEgV
         j7dHKS1cqkGWyY7MzygC4Z0f5Oa94vsOoimJx6LDTpqBw89gp6khoHaTyKPLWJV7Yb9d
         ifdOgC78jZOyTqUJazK6R2EPAeKh7TrG/41eE=
Subject: [PATCH 2/4] mfd: mc13783: When probing, unlock the mc13783 before
 subsystems initialisation.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Sascha linux-arm <s.hauer@pengutronix.de>
In-Reply-To: <1260810776.2022.130.camel@climbing-alby>
References: <1260808880.2022.98.camel@climbing-alby>
	 <1260810776.2022.130.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 18:18:05 +0100
Message-ID: <1260811085.2022.135.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this, mc13783 subsystems drivers can configure the mc13783 chip
reading and writing registers.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13783-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index 3953297..185139e 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -629,6 +629,8 @@ err_revision:
 	}
 	/* This should go away (END) */
 
+	mc13783_unlock(mc13783);
+
 	if (pdata->flags & MC13783_USE_ADC)
 		mc13783_add_subdevice(mc13783, "mc13783-adc");
 
@@ -651,8 +653,6 @@ err_revision:
 	if (pdata->flags & MC13783_USE_TOUCHSCREEN)
 		mc13783_add_subdevice(mc13783, "mc13783-ts");
 
-	mc13783_unlock(mc13783);
-
 	return 0;
 }
 
-- 
1.6.3.3



