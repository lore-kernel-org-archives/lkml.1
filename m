Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZLBSy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZLBSy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 13:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZLBSy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 13:54:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33356 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbZLBSy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 13:54:26 -0500
Date: Wed, 2 Dec 2009 19:54:31 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Luotao Fu <l.fu@pengutronix.de>
Subject: Re: [PATCH] mfd/mc13783: near complete rewrite
Message-ID: <20091202185431.GA22051@pengutronix.de>
References: <20091105235349.GA22519@pengutronix.de> <1257465368-24012-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091106002847.GC22366@sortiz.org> <20091124214452.GC21466@pengutronix.de> <20091124232602.GH8290@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091124232602.GH8290@sortiz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

> > If it looks OK for you, can you please squash the patch below into the
> > original commit?  
> That's fine with me, I'll do it.
In the hope not to annoy you, below is another modification that greatly
improves the touch function.  Feel free to to squash into the original
commit again.

Best regards and thanks
Uwe

----------------->8--------------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

mfd/mc13783: don't set ADREFMODE for touch conversions

Setting ADREFMODE is utter nonsense, but that's hard to read out of the
spec.  Strange enough it's possible to read x and y values even when
it's set.  When unset you can get values not only for the axes, but also
for contact resistance which allows the touch driver to report pressure
values.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/mc13783-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index dc1add0..a1ade23 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -462,8 +462,8 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 
 	switch (mode) {
 	case MC13783_ADC_MODE_TS:
-		adc0 |= MC13783_ADC0_ADREFEN | MC13783_ADC0_ADREFMODE
-			| MC13783_ADC0_TSMOD0 | MC13783_ADC0_TSMOD1;
+		adc0 |= MC13783_ADC0_ADREFEN | MC13783_ADC0_TSMOD0 |
+			MC13783_ADC0_TSMOD1;
 		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
 		break;
 
-- 
1.6.5.2

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
