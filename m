Return-Path: <linux-kernel-owner+w=401wt.eu-S965113AbYD1QYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965113AbYD1QYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933806AbYD1QYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:24:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40308 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765754AbYD1QYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:24:36 -0400
Date: Mon, 28 Apr 2008 18:24:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] dvb: build failure fix
Message-ID: <20080428162421.GA16566@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix build failure found via x86.git randconfig testing:

 drivers/built-in.o: In function `tda829x_attach':
 : undefined reference to `tda827x_attach'
 drivers/built-in.o: In function `tda829x_attach':
 : undefined reference to `tda18271_attach'

build failure is due to this nasty dependency:

  CONFIG_DVB_CORE=m but CONFIG_TUNER_TDA8290=y.

the solution is to follow the DVB_CORE constraint in the Kconfig. It's 
not pretty but works.

Kconfig should be enhanced instead with a new keyword: "depends on 
instructure ..." that makes it clear that the dependent module can only 
be of equal or lesser link mode - but not =y while the infrastructure 
module is =m. But i digress.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/media/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux/drivers/media/Kconfig
===================================================================
--- linux.orig/drivers/media/Kconfig
+++ linux/drivers/media/Kconfig
@@ -106,21 +106,21 @@ if VIDEO_TUNER_CUSTOMIZE
 
 config TUNER_XC2028
 	tristate "XCeive xc2028/xc3028 tuners"
-	depends on I2C && FW_LOADER
+	depends on I2C && FW_LOADER && ((DVB_CORE = m && m) || (DVB_CORE = y))
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the xc2028/xc3028 tuners.
 
 config TUNER_MT20XX
 	tristate "Microtune 2032 / 2050 tuners"
-	depends on I2C
+	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the MT2032 / MT2050 tuner.
 
 config TUNER_TDA8290
 	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
-	depends on I2C
+	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
 	select DVB_TDA827X
 	select DVB_TDA18271
 	default m if VIDEO_TUNER_CUSTOMIZE
@@ -129,21 +129,21 @@ config TUNER_TDA8290
 
 config TUNER_TEA5761
 	tristate "TEA 5761 radio tuner (EXPERIMENTAL)"
-	depends on I2C && EXPERIMENTAL
+	depends on I2C && EXPERIMENTAL && ((DVB_CORE = m && m) || (DVB_CORE = y))
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the Philips TEA5761 radio tuner.
 
 config TUNER_TEA5767
 	tristate "TEA 5767 radio tuner"
-	depends on I2C
+	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for the Philips TEA5767 radio tuner.
 
 config TUNER_SIMPLE
 	tristate "Simple tuner support"
-	depends on I2C
+	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
 	select TUNER_TDA9887
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
@@ -151,7 +151,7 @@ config TUNER_SIMPLE
 
 config TUNER_TDA9887
 	tristate "TDA 9885/6/7 analog IF demodulator"
-	depends on I2C
+	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
 	default m if VIDEO_TUNER_CUSTOMIZE
 	help
 	  Say Y here to include support for Philips TDA9885/6/7
