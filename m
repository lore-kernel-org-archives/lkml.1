Return-Path: <linux-kernel-owner+w=401wt.eu-S934518AbXGaUjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518AbXGaUjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934351AbXGaUgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:36:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:31400 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934336AbXGaUgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=mHd1x42sSDLsCWrutAh2Pj558Z2m6lZVoNXnohzoHAXsa8AGqy/4iqjKeWqzS0njV2ksYoEoBv04yGk448iRtPE2APzz8/pRtZEQxLL5cXg8T5n4nJ7kd+9cLL3qxySBIn9jJyCiYB46FWr3+gfSPGKjcz8k+64HTJ/QQjx9Bvg=
Message-ID: <46AF9D4E.2070900@googlemail.com>
Date: Tue, 31 Jul 2007 22:36:30 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Tomas Kasparek <tomas.kasparek@seznam.cz>, alsa-devel@alsa-project.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH] Get rid of dead code in sound/arm/sa11xx-uda1341.c
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

File /home/devel/linux-rdc/sound/arm/sa11xx-uda1341.c line 82
Unknown CONFIG option! CONFIG_H3600_HAL
File /home/devel/linux-rdc/sound/arm/sa11xx-uda1341.c line 103
Unknown CONFIG option! CONFIG_H3600_HAL
File /home/devel/linux-rdc/sound/arm/sa11xx-uda1341.c line 241
Unknown CONFIG option! CONFIG_H3600_HAL
File /home/devel/linux-rdc/sound/arm/sa11xx-uda1341.c line 310
Unknown CONFIG option! CONFIG_H3600_HAL
File /home/devel/linux-rdc/sound/arm/sa11xx-uda1341.c line 334
Unknown CONFIG option! CONFIG_H3600_HAL
File /home/devel/linux-rdc/sound/arm/sa11xx-uda1341.c line 344
Unknown CONFIG option! CONFIG_H3600_HAL
File /home/devel/linux-rdc/sound/arm/sa11xx-uda1341.c line 357
Unknown CONFIG option! CONFIG_H3600_HAL

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-rdc-clean/sound/arm/sa11xx-uda1341.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-rdc/sound/arm/sa11xx-uda1341.c	2007-07-31 17:43:12.000000000 +0200
@@ -79,12 +79,6 @@
 #include <asm/mach-types.h>
 #include <asm/dma.h>
 
-#ifdef CONFIG_H3600_HAL
-#include <asm/semaphore.h>
-#include <asm/uaccess.h>
-#include <asm/arch/h3600_hal.h>
-#endif
-
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>
@@ -100,9 +94,6 @@
  * We use DMA stuff from 2.4.18-rmk3-hh24 here to be able to compile this
  * module for Familiar 0.6.1
  */
-#ifdef CONFIG_H3600_HAL
-#define HH_VERSION 1
-#endif
 
 /* {{{ Type definitions */
 
@@ -238,11 +229,8 @@ static void sa11xx_uda1341_set_samplerat
 		rate = 8000;
 
 	/* Set the external clock generator */
-#ifdef CONFIG_H3600_HAL
-	h3600_audio_clock(rate);
-#else	
+	
 	sa11xx_uda1341_set_audio_clock(rate);
-#endif
 
 	/* Select the clock divisor */
 	switch (rate) {
@@ -307,13 +295,10 @@ static void sa11xx_uda1341_audio_init(st
 	local_irq_restore(flags);
 
 	/* Enable the audio power */
-#ifdef CONFIG_H3600_HAL
-	h3600_audio_power(AUDIO_RATE_DEFAULT);
-#else
+
 	clr_sa11xx_uda1341_egpio(IPAQ_EGPIO_CODEC_NRESET);
 	set_sa11xx_uda1341_egpio(IPAQ_EGPIO_AUDIO_ON);
 	set_sa11xx_uda1341_egpio(IPAQ_EGPIO_QMUTE);
-#endif
  
 	/* Wait for the UDA1341 to wake up */
 	mdelay(1); //FIXME - was removed by Perex - Why?
@@ -331,21 +316,13 @@ static void sa11xx_uda1341_audio_init(st
 	/* make the left and right channels unswapped (flip the WS latch) */
 	Ser4SSDR = 0;
 
-#ifdef CONFIG_H3600_HAL
-	h3600_audio_mute(0);
-#else	
-	clr_sa11xx_uda1341_egpio(IPAQ_EGPIO_QMUTE);        
-#endif     
+	clr_sa11xx_uda1341_egpio(IPAQ_EGPIO_QMUTE);
 }
 
 static void sa11xx_uda1341_audio_shutdown(struct sa11xx_uda1341 *sa11xx_uda1341)
 {
 	/* mute on */
-#ifdef CONFIG_H3600_HAL
-	h3600_audio_mute(1);
-#else	
 	set_sa11xx_uda1341_egpio(IPAQ_EGPIO_QMUTE);
-#endif
 	
 	/* disable the audio power and all signals leading to the audio chip */
 	l3_close(sa11xx_uda1341->uda1341);
@@ -354,13 +331,9 @@ static void sa11xx_uda1341_audio_shutdow
 
 	/* power off and mute off */
 	/* FIXME - is muting off necesary??? */
-#ifdef CONFIG_H3600_HAL
-	h3600_audio_power(0);
-	h3600_audio_mute(0);
-#else	
+
 	clr_sa11xx_uda1341_egpio(IPAQ_EGPIO_AUDIO_ON);
 	clr_sa11xx_uda1341_egpio(IPAQ_EGPIO_QMUTE);
-#endif	
 }
 
 /* }}} */
