Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbYLZJDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbYLZJDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbYLZJCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:02:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYLZJCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:02:47 -0500
Date: Fri, 26 Dec 2008 10:02:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: [GIT PATCHES for 2.6.28] V4L/DVB fixes
Message-ID: <20081226090220.GF755@elte.hu>
References: <20081224121252.7560391e@caramujo.chehab.org> <20081225081907.GA4628@elte.hu> <20081225212459.4c7e31b4@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225212459.4c7e31b4@caramujo.chehab.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> On Thu, 25 Dec 2008 09:19:07 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > FYI, v2.6.28 still fails to build with certain configs:
> > 
> >  drivers/media/dvb/built-in.o: In function `dib7000p_set_gpio':
> >  (.text+0x3f242): multiple definition of `dib7000p_set_gpio'
> >  drivers/media/video/built-in.o:(.text+0xb8c1e): first defined here
> >  drivers/media/dvb/built-in.o: In function `dib7000p_i2c_enumeration':
> >  (.text+0x3f282): multiple definition of `dib7000p_i2c_enumeration'
> >  drivers/media/video/built-in.o:(.text+0xb8c3e): first defined here
> >  drivers/media/dvb/built-in.o: In function `dib7000p_set_wbd_ref':
> >  (.text+0x3f1c1): multiple definition of `dib7000p_set_wbd_ref'
> >  drivers/media/video/built-in.o:(.text+0xb8bfe): first defined here
> >    LD      drivers/net/built-in.o
> >  make[2]: *** [drivers/media/built-in.o] Error 1
> > 
> > Config attached. The patch below works it around in tip/master. Can test 
> > any patch for this bug.
> 
> Please test the enclosed patch.

thanks Mauro - i've reverted all my local drivers/media/dvb/ hacks (see 
them below) and applied your fix, and started testing things. Will let you 
know if i run into any other kind of build or boot trouble.

	Ingo

--------------->

diff --git a/drivers/media/dvb/dm1105/Kconfig b/drivers/media/dvb/dm1105/Kconfig
index 1332301..d5fc581 100644
--- a/drivers/media/dvb/dm1105/Kconfig
+++ b/drivers/media/dvb/dm1105/Kconfig
@@ -7,6 +7,8 @@ config DVB_DM1105
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
+	# build failure
+	depends on 0
 	help
 	  Support for cards based on the SDMC DM1105 PCI chip like
 	  DvbWorld 2002
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 49f7b20..448d42b 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -1,6 +1,7 @@
 config DVB_USB
 	tristate "Support for various USB DVB devices"
 	depends on DVB_CORE && USB && I2C && INPUT
+	depends on BROKEN
 	help
 	  By enabling this you will be able to choose the various supported
 	  USB1.1 and USB2.0 DVB devices.
@@ -235,6 +236,7 @@ config DVB_USB_OPERA1
 config DVB_USB_AF9005
 	tristate "Afatech AF9005 DVB-T USB1.1 support"
 	depends on DVB_USB && EXPERIMENTAL
+	depends on BROKEN
 	select MEDIA_TUNER_MT2060 if !MEDIA_TUNER_CUSTOMIZE
 	select MEDIA_TUNER_QT1010 if !MEDIA_TUNER_CUSTOMIZE
 	help
