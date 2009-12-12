Return-Path: <linux-kernel-owner+w=401wt.eu-S934185AbZLMBtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185AbZLMBtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934270AbZLMBtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:49:00 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57466 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934275AbZLMBs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:48:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=S/+EGVlJu4EWDlkz0G+u6l/NtzmbgCjauaj6ZOPgq6HvDcmTfJhEwMWzPKLapGQ0nn
         1C9M5v3pvUElliwtoq57D0Pay+rQ7zMduPM1BXDe/UT6K69XNNb6s+0LaK+dA0N46uFU
         SlytF6FENo+HVav4bDYw8JrqMPEEl7yt0DW2M=
Subject: [PATCH 2/4] mfd: mc13783: When probing, unlock the mc13783 before
 subsystems initialisation.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1260636523.2054.28.camel@climbing-alby>
References: <1260635829.2054.16.camel@climbing-alby>
	 <1260636523.2054.28.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 17:53:39 +0100
Message-ID: <1260636819.2054.33.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this, mc13783 subsystems drivers can configure the mc13783 chip
reading and writing registers.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/mfd/mc13783-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
index aa1f79a..35dcc2a 100644
--- a/drivers/mfd/mc13783-core.c
+++ b/drivers/mfd/mc13783-core.c
@@ -631,6 +631,8 @@ err_revision:
 	}
 	/* This should go away (END) */
 
+	mc13783_unlock(mc13783);
+
 	if (pdata->flags & MC13783_USE_ADC)
 		mc13783_add_subdevice(mc13783, "mc13783-adc");
 
@@ -653,8 +655,6 @@ err_revision:
 	if (pdata->flags & MC13783_USE_TOUCHSCREEN)
 		mc13783_add_subdevice(mc13783, "mc13783-ts");
 
-	mc13783_unlock(mc13783);
-
 	return 0;
 }
 
-- 
1.6.3.3



