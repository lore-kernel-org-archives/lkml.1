Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbZLMCNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbZLMCNc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 21:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756807AbZLMCNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 21:13:31 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40759 "HELO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756207AbZLMCNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 21:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wco3sSdx1xkt6sYRlTCH9lOiy4fPOFjEzihvGw/WSwCIvdo4GJ+XM4K4eB/hoF/vCl
         2Tp7aByGm1EBGzJ9W8UhEo3F9aym3kX8uRHkMzHV/Aaw4D05JUVo9eAlPfuwTOpcdoak
         3jr+q1X22AZJgjrZtDd7BeQgSLlN+8lRjwhX8=
Subject: [PATCH 4/4] regulator: mc13783 change to platform_driver_register.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Sascha linux-arm <s.hauer@pengutronix.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1260636976.2054.36.camel@climbing-alby>
References: <1260635829.2054.16.camel@climbing-alby>
	 <1260636523.2054.28.camel@climbing-alby>
	 <1260636819.2054.33.camel@climbing-alby>
	 <1260636976.2054.36.camel@climbing-alby>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 18:06:17 +0100
Message-ID: <1260637577.2054.43.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the instant when regulator driver is probed. 
To have a correct regulators initialisation (enable, disable and voltages 
selection), the driver must have access to mc13783 registers and so 
mc13783-core must be loaded before this.

With this patch mc13783_regulator_probe is called when mc13783-core
register the regulator subsystem.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 drivers/regulator/mc13783-regulator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index ed78137..1ae9017 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -545,12 +545,12 @@ static struct platform_driver mc13783_regulator_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.remove		= __devexit_p(mc13783_regulator_remove),
+	.probe		= mc13783_regulator_probe,
 };
 
 static int __init mc13783_regulator_init(void)
 {
-	return platform_driver_probe(&mc13783_regulator_driver,
-			mc13783_regulator_probe);
+	return platform_driver_register(&mc13783_regulator_driver);
 }
 subsys_initcall(mc13783_regulator_init);
 
-- 
1.6.3.3



