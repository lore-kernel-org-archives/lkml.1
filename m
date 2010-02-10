Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0BJCD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 21:03:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41817 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab0BJCD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 21:03:56 -0500
Date: Wed, 10 Feb 2010 13:03:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the sound tree with the i.MX tree
Message-Id: <20100210130351.4b56f192.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
arch/arm/plat-mxc/Makefile between commit
aae7019382896cf1075a93acc564e42601bc44a2 ("imx: only define deprecated
symbols conditionally") from the i.MX tree and commit
8380222ec9458d38a4e0cc3cb688ad7fff311df4 ("ASoC: Add a new imx-ssi sound
driver") from the sound tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-mxc/Makefile
index 7322bca,6cee38d..0000000
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@@ -14,6 -12,8 +14,10 @@@ obj-$(CONFIG_MXC_PWM)  += pwm.
  obj-$(CONFIG_USB_EHCI_MXC) += ehci.o
  obj-$(CONFIG_MXC_ULPI) += ulpi.o
  obj-$(CONFIG_ARCH_MXC_AUDMUX_V1) += audmux-v1.o
 +CFLAGS_audmux-v1.o = -DIMX_NEEDS_DEPRECATED_SYMBOLS
  obj-$(CONFIG_ARCH_MXC_AUDMUX_V2) += audmux-v2.o
 +CFLAGS_audmux-v2.o = -DIMX_NEEDS_DEPRECATED_SYMBOLS
+ ifdef CONFIG_SND_IMX_SOC
+ obj-y += ssi-fiq.o
+ obj-y += ssi-fiq-ksym.o
+ endif
