Return-Path: <linux-kernel-owner+w=401wt.eu-S1761285AbYD2Ur2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761285AbYD2Ur2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbYD2Uq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:46:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761544AbYD2Uq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:46:56 -0400
Date: Tue, 29 Apr 2008 22:46:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch] sound/video: fix sound/i2c/other/tea575x-tuner.c build bug
Message-ID: <20080429204643.GA22078@elte.hu>
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


fix build failure triggered on latest -git by this config:

 http://redhat.com/~mingo/misc/config-Tue_Apr_29_22_33_36_CEST_2008.bad

sound/i2c/other/tea575x-tuner.c: In function 'snd_tea575x_ioctl':
sound/i2c/other/tea575x-tuner.c:95: error: 'VIDIOCGCAP' undeclared (first use in this function)
sound/i2c/other/tea575x-tuner.c:95: error: (Each undeclared identifier is reported only once
sound/i2c/other/tea575x-tuner.c:95: error: for each function it appears in.)
sound/i2c/other/tea575x-tuner.c:97: error: storage size of 'v' isn't known

the CONFIG_SND_FM801_TEA575X code still depends on VIDEO_V4L1_COMPAT 
APIs.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 sound/pci/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux/sound/pci/Kconfig
===================================================================
--- linux.orig/sound/pci/Kconfig
+++ linux/sound/pci/Kconfig
@@ -529,6 +529,7 @@ config SND_FM801_TEA575X
 	depends on SND_FM801_TEA575X_BOOL
 	default SND_FM801
 	select VIDEO_V4L1
+	select VIDEO_V4L1_COMPAT
 	select VIDEO_DEV
 
 config SND_HDA_INTEL
