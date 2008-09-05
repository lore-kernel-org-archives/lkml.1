Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYIEKYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYIEKYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbYIEKVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:21:38 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:51198 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYIEKVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:21:31 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="74640985"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@sirena.org.uk
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 9/9] ASoC: Blackfin: add Blackfin arch ASoC Kconfig and Makefile
Date: Fri,  5 Sep 2008 18:21:42 +0800
Message-Id: <1220610102-7716-10-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
References: <1220610102-7716-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/blackfin/Kconfig  |   85 +++++++++++++++++++++++++++++++++++++++++++
 sound/soc/blackfin/Makefile |   20 ++++++++++
 2 files changed, 105 insertions(+), 0 deletions(-)
 create mode 100644 sound/soc/blackfin/Kconfig
 create mode 100644 sound/soc/blackfin/Makefile

diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
new file mode 100644
index 0000000..f98331d
--- /dev/null
+++ b/sound/soc/blackfin/Kconfig
@@ -0,0 +1,85 @@
+config SND_BF5XX_I2S
+	tristate "SoC I2S Audio for the ADI BF5xx chip"
+	depends on BLACKFIN && SND_SOC
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  the Blackfin SPORT (synchronous serial ports) interface in I2S
+	  mode (supports single stereo In/Out).
+	  You will also need to select the audio interfaces to support below.
+
+config SND_BF5XX_SOC_SSM2602
+	tristate "SoC SSM2602 Audio support for BF52x ezkit"
+	depends on SND_BF5XX_I2S
+	select SND_BF5XX_SOC_I2S
+	select SND_SOC_SSM2602
+	select I2C
+	select I2C_BLACKFIN_TWI
+	help
+	  Say Y if you want to add support for SoC audio on BF527-EZKIT.
+
+config SND_BF5XX_AC97
+	tristate "SoC AC97 Audio for the ADI BF5xx chip"
+	depends on BLACKFIN && SND_SOC
+	help
+	  Say Y or M if you want to add support for codecs attached to
+	  the Blackfin SPORT (synchronous serial ports) interface in slot 16
+	  mode (pseudo AC97 interface).
+	  You will also need to select the audio interfaces to support below.
+
+	  Note:
+	  AC97 codecs which do not implment the slot-16 mode will not function
+	  properly with this driver. This driver is known to work with the
+	  Analog Devices line of AC97 codecs.
+
+config SND_MMAP_SUPPORT
+	bool "Enable MMAP Support"
+	depends on SND_BF5XX_AC97
+	default y
+	help
+	  Say y if you want AC97 driver to support mmap mode.
+	  We introduce an intermediate buffer to simulate mmap.
+
+config SND_BF5XX_SOC_SPORT
+	tristate
+	
+config SND_BF5XX_SOC_I2S
+	tristate
+	select SND_BF5XX_SOC_SPORT
+
+config SND_BF5XX_SOC_AC97
+	tristate
+	select AC97_BUS
+	select SND_SOC_AC97_BUS
+	select SND_BF5XX_SOC_SPORT
+
+config SND_BF5XX_SOC_AD1980
+	tristate "SoC AD1980/1 Audio support for BF5xx"
+	depends on SND_BF5XX_AC97
+	select SND_BF5XX_SOC_AC97
+	select SND_SOC_AD1980
+	help
+	  Say Y if you want to add support for SoC audio on BF5xx STAMP/EZKIT.
+
+config SND_BF5XX_SPORT_NUM
+	int "Set a SPORT for Sound chip"
+	depends on (SND_BF5XX_I2S || SND_BF5XX_AC97)
+	range 0 3 if BF54x
+	range 0 1 if (BF53x || BF561)
+	default 0
+	help
+	  Set the correct SPORT for sound chip.
+
+config SND_BF5XX_HAVE_COLD_RESET
+	bool "BOARD has COLD Reset GPIO"
+	depends on SND_BF5XX_AC97
+	default y if BFIN548_EZKIT
+	default n if !BFIN548_EZKIT
+	
+config SND_BF5XX_RESET_GPIO_NUM
+	int "Set a GPIO for cold reset"
+	depends on SND_BF5XX_HAVE_COLD_RESET
+	range 0 159
+	default 19 if BFIN548_EZKIT
+	default 5 if BFIN537_STAMP
+	help
+	  Set the correct GPIO for RESET the sound chip.
diff --git a/sound/soc/blackfin/Makefile b/sound/soc/blackfin/Makefile
new file mode 100644
index 0000000..9ea8bd9
--- /dev/null
+++ b/sound/soc/blackfin/Makefile
@@ -0,0 +1,20 @@
+# Blackfin Platform Support
+snd-bf5xx-ac97-objs := bf5xx-ac97-pcm.o
+snd-bf5xx-i2s-objs := bf5xx-i2s-pcm.o
+snd-soc-bf5xx-sport-objs := bf5xx-sport.o
+snd-soc-bf5xx-ac97-objs := bf5xx-ac97.o
+snd-soc-bf5xx-i2s-objs := bf5xx-i2s.o
+
+obj-$(CONFIG_SND_BF5XX_AC97) += snd-bf5xx-ac97.o
+obj-$(CONFIG_SND_BF5XX_I2S) += snd-bf5xx-i2s.o
+obj-$(CONFIG_SND_BF5XX_SOC_SPORT) += snd-soc-bf5xx-sport.o
+obj-$(CONFIG_SND_BF5XX_SOC_AC97) += snd-soc-bf5xx-ac97.o
+obj-$(CONFIG_SND_BF5XX_SOC_I2S) += snd-soc-bf5xx-i2s.o
+
+# Blackfin Machine Support
+snd-ad1980-objs := bf5xx-ad1980.o
+snd-ssm2602-objs := bf5xx-ssm2602.o
+
+
+obj-$(CONFIG_SND_BF5XX_SOC_AD1980) += snd-ad1980.o
+obj-$(CONFIG_SND_BF5XX_SOC_SSM2602) += snd-ssm2602.o
-- 
1.5.6
