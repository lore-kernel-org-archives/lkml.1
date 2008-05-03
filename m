Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYECVYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYECVYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbYECVYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:24:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYECVYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:24:05 -0400
Date: Sat, 3 May 2008 23:23:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Steven Toth <stoth@hauppauge.com>
Subject: [patch] video: build fix for drivers/media/video/au0828
Message-ID: <20080503212351.GA15918@elte.hu>
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


x86.git testing found the following build failure in v2.6.26-rc1:

  MODPOST 424 modules
  ERROR: "tveeprom_hauppauge_analog" [drivers/media/video/au0828/au0828.ko] undefined!
  ERROR: "tveeprom_read" [drivers/media/video/au0828/au0828.ko] undefined!

with this config:

  http://redhat.com/~mingo/misc/config-Sat_May__3_22_28_58_CEST_2008.bad

this patch does what other video drivers do to utilize the 
VIDEO_TVEEPROM functionality (and this resolves the build problem) - but 
i have not checked it on real hardware and i have not checked whether 
the fix is complete.

Observation: other drivers in this space seem to do a wider range of 
selections, so some items might still be missing - just not triggered 
with this specific config.

---
 drivers/media/video/au0828/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/drivers/media/video/au0828/Kconfig
===================================================================
--- linux.orig/drivers/media/video/au0828/Kconfig
+++ linux/drivers/media/video/au0828/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_AU0828
 	tristate "Auvitek AU0828 support"
        depends on VIDEO_DEV && I2C && INPUT && DVB_CORE
 	select I2C_ALGOBIT
+	select VIDEO_TVEEPROM
 	select DVB_AU8522 if !DVB_FE_CUSTOMIZE
 	select MEDIA_TUNER_XC5000 if !DVB_FE_CUSTOMIZE
 	---help---
