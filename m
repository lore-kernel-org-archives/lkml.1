Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbYH0Jk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbYH0Jk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYH0Jjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:39:31 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:21266 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbYH0JjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:39:23 -0400
X-IronPort-AV: E=Sophos;i="4.32,278,1217822400"; 
   d="scan'208";a="74159090"
From: Bryan Wu <cooloney@kernel.org>
To: perex@perex.cz, liam.girdwood@wolfsonmicro.com,
       broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/4] ASOC: Blackfin driver for ALSA SoC framework
Date: Wed, 27 Aug 2008 17:39:25 +0800
Message-Id: <1219829968-6431-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/Kconfig                   |    1 +
 sound/soc/Makefile                  |    2 +-
 sound/soc/blackfin/Kconfig          |   85 +++
 sound/soc/blackfin/Makefile         |   20 +
 sound/soc/blackfin/bf5xx-ac97-pcm.c |  424 +++++++++++++++
 sound/soc/blackfin/bf5xx-ac97-pcm.h |   29 +
 sound/soc/blackfin/bf5xx-ac97.c     |  417 ++++++++++++++
 sound/soc/blackfin/bf5xx-ac97.h     |   36 ++
 sound/soc/blackfin/bf5xx-ad1980.c   |  116 ++++
 sound/soc/blackfin/bf5xx-i2s-pcm.c  |  293 ++++++++++
 sound/soc/blackfin/bf5xx-i2s-pcm.h  |   29 +
 sound/soc/blackfin/bf5xx-i2s.c      |  183 +++++++
 sound/soc/blackfin/bf5xx-i2s.h      |   14 +
 sound/soc/blackfin/bf5xx-sport.c    | 1018 +++++++++++++++++++++++++++++++++++
 sound/soc/blackfin/bf5xx-sport.h    |  192 +++++++
 sound/soc/blackfin/bf5xx-ssm2602.c  |  195 +++++++
 16 files changed, 3053 insertions(+), 1 deletions(-)
 create mode 100644 sound/soc/blackfin/Kconfig
 create mode 100644 sound/soc/blackfin/Makefile
 create mode 100644 sound/soc/blackfin/bf5xx-ac97-pcm.c
 create mode 100644 sound/soc/blackfin/bf5xx-ac97-pcm.h
 create mode 100644 sound/soc/blackfin/bf5xx-ac97.c
 create mode 100644 sound/soc/blackfin/bf5xx-ac97.h
 create mode 100644 sound/soc/blackfin/bf5xx-ad1980.c
 create mode 100644 sound/soc/blackfin/bf5xx-i2s-pcm.c
 create mode 100644 sound/soc/blackfin/bf5xx-i2s-pcm.h
 create mode 100644 sound/soc/blackfin/bf5xx-i2s.c
 create mode 100644 sound/soc/blackfin/bf5xx-i2s.h
 create mode 100644 sound/soc/blackfin/bf5xx-sport.c
 create mode 100644 sound/soc/blackfin/bf5xx-sport.h
 create mode 100644 sound/soc/blackfin/bf5xx-ssm2602.c

diff --git a/sound/soc/Kconfig b/sound/soc/Kconfig
index f743530..82e4d79 100644
--- a/sound/soc/Kconfig
+++ b/sound/soc/Kconfig
@@ -25,6 +25,7 @@ config SND_SOC_AC97_BUS
 source "sound/soc/at32/Kconfig"
 source "sound/soc/at91/Kconfig"
 source "sound/soc/au1x/Kconfig"
+source "sound/soc/blackfin/Kconfig"
 source "sound/soc/pxa/Kconfig"
 source "sound/soc/s3c24xx/Kconfig"
 source "sound/soc/sh/Kconfig"
diff --git a/sound/soc/Makefile b/sound/soc/Makefile
index 933a66d..d849349 100644
--- a/sound/soc/Makefile
+++ b/sound/soc/Makefile
@@ -2,4 +2,4 @@ snd-soc-core-objs := soc-core.o soc-dapm.o
 
 obj-$(CONFIG_SND_SOC)	+= snd-soc-core.o
 obj-$(CONFIG_SND_SOC)	+= codecs/ at32/ at91/ pxa/ s3c24xx/ sh/ fsl/ davinci/
-obj-$(CONFIG_SND_SOC)	+= omap/ au1x/
+obj-$(CONFIG_SND_SOC)	+= omap/ au1x/ blackfin/
diff --git a/sound/soc/blackfin/Kconfig b/sound/soc/blackfin/Kconfig
new file mode 100644
index 0000000..92d58b2
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
+	  AC'97 codecs which do not implment the slot-16 mode will not function
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
diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.c b/sound/soc/blackfin/bf5xx-ac97-pcm.c
new file mode 100644
index 0000000..b272563
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ac97-pcm.c
@@ -0,0 +1,424 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-ac97-pcm.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC
+ *
+ * Rev:          $Id: bf5xx-ac97-pcm.c 4104 2008-06-06 06:51:48Z cliff $
+ *
+ * Modified:
+ *               Copyright 2008 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include <asm/dma.h>
+
+#include "bf5xx-ac97-pcm.h"
+#include "bf5xx-ac97.h"
+#include "bf5xx-sport.h"
+
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+static void bf5xx_mmap_copy(struct snd_pcm_substream *substream,
+	 snd_pcm_uframes_t count)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		bf5xx_pcm_to_ac97(
+				(struct ac97_frame *)sport->tx_dma_buf + sport->tx_pos,
+				(__u32 *)runtime->dma_area + sport->tx_pos, count);
+		sport->tx_pos += runtime->period_size;
+		if (sport->tx_pos >= runtime->buffer_size)
+			sport->tx_pos %= runtime->buffer_size;
+	} else {
+		bf5xx_ac97_to_pcm(
+				(struct ac97_frame *)sport->rx_dma_buf + sport->rx_pos,
+				(__u32 *)runtime->dma_area + sport->rx_pos, count);
+		sport->rx_pos += runtime->period_size;
+		if (sport->rx_pos >= runtime->buffer_size)
+			sport->rx_pos %= runtime->buffer_size;
+	}
+}
+#endif
+
+static void bf5xx_dma_irq(void *data)
+{
+	struct snd_pcm_substream *pcm = data;
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+	struct snd_pcm_runtime *runtime = pcm->runtime;
+	bf5xx_mmap_copy(pcm, runtime->period_size);
+#endif
+	snd_pcm_period_elapsed(pcm);
+}
+
+/* The memory size for pure pcm data is 128*1024 = 0x20000 bytes.
+ * The total rx/tx buffer is for ac97 frame to hold all pcm data
+ * is  0x20000 * sizeof(struct ac97_frame) / 4.
+ */
+#ifdef CONFIG_SND_MMAP_SUPPORT
+static const struct snd_pcm_hardware bf5xx_pcm_hardware = {
+	.info			= SNDRV_PCM_INFO_INTERLEAVED |
+				   SNDRV_PCM_INFO_MMAP |
+				   SNDRV_PCM_INFO_MMAP_VALID |
+				   SNDRV_PCM_INFO_BLOCK_TRANSFER,
+#else
+static const struct snd_pcm_hardware bf5xx_pcm_hardware = {
+	.info			= SNDRV_PCM_INFO_INTERLEAVED |
+				  SNDRV_PCM_INFO_BLOCK_TRANSFER,
+#endif
+	.formats		= SNDRV_PCM_FMTBIT_S16_LE,
+	.period_bytes_min	= 32,
+	.period_bytes_max	= 0x10000,
+	.periods_min		= 1,
+	.periods_max		= PAGE_SIZE/32,
+	.buffer_bytes_max	= 0x20000, /* 128 kbytes */
+	.fifo_size		= 16,
+};
+
+static int bf5xx_pcm_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max * sizeof(struct ac97_frame)/4;
+
+	snd_pcm_lib_malloc_pages(substream, size);
+
+	return 0;
+}
+
+static int bf5xx_pcm_hw_free(struct snd_pcm_substream *substream)
+{
+	snd_pcm_lib_free_pages(substream);
+	return 0;
+}
+
+static int bf5xx_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	/* An intermediate buffer is introduced for implementing mmap for
+	 * SPORT working in TMD mode(include AC97).
+	 */
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max * sizeof(struct ac97_frame)/4;
+	/*clean up intermediate buffer*/
+	memset(sport->tx_dma_buf, 0, size);
+	memset(sport->rx_dma_buf, 0, size);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		sport_set_tx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_tx_dma(sport, sport->tx_dma_buf, runtime->periods,
+				runtime->period_size * sizeof(struct ac97_frame));
+	} else {
+		sport_set_rx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_rx_dma(sport, sport->rx_dma_buf, runtime->periods,
+				runtime->period_size * sizeof(struct ac97_frame));
+	}
+#else
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		sport_set_tx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_tx_dma(sport, runtime->dma_area, runtime->periods,
+				runtime->period_size * sizeof(struct ac97_frame));
+	} else {
+		sport_set_rx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_rx_dma(sport, runtime->dma_area, runtime->periods,
+				runtime->period_size * sizeof(struct ac97_frame));
+	}
+#endif
+	return 0;
+}
+
+static int bf5xx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	int ret = 0;
+
+	pr_debug("%s %s\n", substream->stream?"Capture":"Playback", \
+			cmd?" start":" stop");
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			sport_tx_start(sport);
+		else
+			sport_rx_start(sport);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+			sport->tx_pos = 0;
+#endif
+			sport_tx_stop(sport);
+		} else {
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+			sport->rx_pos = 0;
+#endif
+			sport_rx_stop(sport);
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static snd_pcm_uframes_t bf5xx_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	unsigned int curr;
+
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		curr = sport->tx_pos;
+	else
+		curr = sport->rx_pos;
+#else
+
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		curr = sport_curr_offset_tx(sport) / sizeof(struct ac97_frame);
+	else {
+		curr = sport_curr_offset_rx(sport) / sizeof(struct ac97_frame);
+	pr_debug("%s pointer curr:0x%0x\n", substream->stream ? \
+			"Capture":"Playback", curr);
+	}
+#endif
+	return curr;
+}
+
+static int bf5xx_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int ret;
+
+	pr_debug("%s enter\n", __func__);
+	snd_soc_set_runtime_hwparams(substream, &bf5xx_pcm_hardware);
+
+	ret = snd_pcm_hw_constraint_integer(runtime, \
+			SNDRV_PCM_HW_PARAM_PERIODS);
+	if (ret < 0)
+		goto out;
+
+	if (sport_handle != NULL)
+		runtime->private_data = sport_handle;
+	else {
+		printk(KERN_ERR "sport_handle is NULL\n");
+		return -1;
+	}
+	return 0;
+
+ out:
+	return ret;
+}
+
+static int bf5xx_pcm_close(struct snd_pcm_substream *substream)
+{
+	pr_debug("%s enter\n", __func__);
+	/*Nothing need to be cleared here*/
+	return 0;
+}
+
+#ifdef CONFIG_SND_MMAP_SUPPORT
+static int bf5xx_pcm_mmap(struct snd_pcm_substream *substream,
+	struct vm_area_struct *vma)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	size_t size = vma->vm_end - vma->vm_start;
+	vma->vm_start = (unsigned long)runtime->dma_area;
+	vma->vm_end = vma->vm_start + size;
+	vma->vm_flags |=  VM_SHARED;
+	return 0 ;
+}
+#else
+static	int bf5xx_pcm_copy(struct snd_pcm_substream *substream, int channel,
+		    snd_pcm_uframes_t pos,
+		    void __user *buf, snd_pcm_uframes_t count)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	pr_debug("%s copy pos:0x%lx count:0x%lx\n",
+			substream->stream?"Capture":"Playback", pos, count);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+		bf5xx_pcm_to_ac97(
+				(struct ac97_frame *)runtime->dma_area + pos,
+				buf, count);
+	else
+		bf5xx_ac97_to_pcm(
+				(struct ac97_frame *)runtime->dma_area + pos,
+				buf, count);
+	return 0;
+}
+#endif
+
+struct snd_pcm_ops bf5xx_pcm_ops = {
+	.open		= bf5xx_pcm_open,
+	.close		= bf5xx_pcm_close,
+	.ioctl		= snd_pcm_lib_ioctl,
+	.hw_params	= bf5xx_pcm_hw_params,
+	.hw_free	= bf5xx_pcm_hw_free,
+	.prepare	= bf5xx_pcm_prepare,
+	.trigger	= bf5xx_pcm_trigger,
+	.pointer	= bf5xx_pcm_pointer,
+#ifdef CONFIG_SND_MMAP_SUPPORT
+	.mmap		= bf5xx_pcm_mmap,
+#else
+	.copy		= bf5xx_pcm_copy,
+#endif
+};
+
+static int bf5xx_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
+{
+	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
+	struct snd_dma_buffer *buf = &substream->dma_buffer;
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max * sizeof(struct ac97_frame)/4;
+
+	buf->dev.type = SNDRV_DMA_TYPE_DEV;
+	buf->dev.dev = pcm->card->dev;
+	buf->private_data = NULL;
+	buf->area = dma_alloc_coherent(pcm->card->dev, size, &buf->addr, GFP_KERNEL);
+	if (!buf->area) {
+		printk(KERN_ERR "Failed to allocate dma memory-Please increase uncached DMA memory region\n");
+		return -ENOMEM;
+	}
+	buf->bytes = size;
+
+	pr_debug("%s, area:%p, size:0x%08lx\n", __func__, buf->area, buf->bytes);
+	if (stream == SNDRV_PCM_STREAM_PLAYBACK)
+		sport_handle->tx_buf = buf->area;
+	else
+		sport_handle->rx_buf = buf->area;
+/*Need to allocate local buffer when enable MMAP for SPORT working in TMD mode(include AC97).*/
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		if (!sport_handle->tx_dma_buf) {
+			sport_handle->tx_dma_buf = dma_alloc_coherent(NULL, \
+				size, &sport_handle->tx_dma_phy, GFP_KERNEL);
+			if (!sport_handle->tx_dma_buf) {
+				printk(KERN_ERR "Failed to allocate memory for tx dma buf-Please increase uncached DMA memory region\n");
+				return -ENOMEM;
+			} else
+				memset(sport_handle->tx_dma_buf, 0, size);
+		} else
+			memset(sport_handle->tx_dma_buf, 0, size);
+	} else {
+		if (!sport_handle->rx_dma_buf) {
+			sport_handle->rx_dma_buf = dma_alloc_coherent(NULL, \
+				size, &sport_handle->rx_dma_phy, GFP_KERNEL);
+			if (!sport_handle->rx_dma_buf) {
+				printk(KERN_ERR "Failed to allocate memory for rx dma buf-Please increase uncached DMA memory region\n");
+				return -ENOMEM;
+			} else
+				memset(sport_handle->rx_dma_buf, 0, size);
+		} else
+			memset(sport_handle->rx_dma_buf, 0, size);
+	}
+#endif
+	return 0;
+}
+
+static void bf5xx_pcm_free_dma_buffers(struct snd_pcm *pcm)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_dma_buffer *buf;
+	int stream;
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max * sizeof(struct ac97_frame)/4;
+#endif
+	for (stream = 0; stream < 2; stream++) {
+		substream = pcm->streams[stream].substream;
+		if (!substream)
+			continue;
+
+		buf = &substream->dma_buffer;
+		if (!buf->area)
+			continue;
+		dma_free_coherent(NULL, buf->bytes, buf->area, 0);
+		buf->area = NULL;
+#if defined(CONFIG_SND_MMAP_SUPPORT)
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		if (sport_handle->tx_dma_buf)
+			dma_free_coherent(NULL, size, \
+				sport_handle->tx_dma_buf, 0);
+		sport_handle->tx_dma_buf = NULL;
+	} else {
+
+		if (sport_handle->rx_dma_buf)
+			dma_free_coherent(NULL, size, \
+				sport_handle->rx_dma_buf, 0);
+		sport_handle->rx_dma_buf = NULL;
+	}
+#endif
+	}
+	if (sport_handle)
+		sport_done(sport_handle);
+}
+
+static u64 bf5xx_pcm_dmamask = DMA_32BIT_MASK;
+
+int bf5xx_pcm_new(struct snd_card *card, struct snd_soc_codec_dai *dai,
+	struct snd_pcm *pcm)
+{
+	int ret = 0;
+
+	pr_debug("%s enter\n", __func__);
+	if (!card->dev->dma_mask)
+		card->dev->dma_mask = &bf5xx_pcm_dmamask;
+	if (!card->dev->coherent_dma_mask)
+		card->dev->coherent_dma_mask = DMA_32BIT_MASK;
+
+	if (dai->playback.channels_min) {
+		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
+			SNDRV_PCM_STREAM_PLAYBACK);
+		if (ret)
+			goto out;
+	}
+
+	if (dai->capture.channels_min) {
+		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
+			SNDRV_PCM_STREAM_CAPTURE);
+		if (ret)
+			goto out;
+	}
+ out:
+	return ret;
+}
+
+struct snd_soc_platform bf5xx_ac97_soc_platform = {
+	.name		= "bf5xx-audio",
+	.pcm_ops 	= &bf5xx_pcm_ops,
+	.pcm_new	= bf5xx_pcm_new,
+	.pcm_free	= bf5xx_pcm_free_dma_buffers,
+};
+EXPORT_SYMBOL_GPL(bf5xx_ac97_soc_platform);
+
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("ADI Blackfin AC97 PCM DMA module");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.h b/sound/soc/blackfin/bf5xx-ac97-pcm.h
new file mode 100644
index 0000000..5831300
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ac97-pcm.h
@@ -0,0 +1,29 @@
+/*
+ * linux/sound/arm/bf5xx-ac97-pcm.h -- ALSA PCM interface for the Blackfin
+ *
+ * Copyright 2007 Analog Device Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BF5XX_AC97_PCM_H
+#define _BF5XX_AC97_PCM_H
+
+struct bf5xx_pcm_dma_params {
+	char *name;			/* stream identifier */
+};
+
+struct bf5xx_gpio {
+	u32 sys;
+	u32	rx;
+	u32 tx;
+	u32 clk;
+	u32 frm;
+};
+
+/* platform data */
+extern struct snd_soc_platform bf5xx_ac97_soc_platform;
+
+#endif
diff --git a/sound/soc/blackfin/bf5xx-ac97.c b/sound/soc/blackfin/bf5xx-ac97.c
new file mode 100644
index 0000000..685a494
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ac97.c
@@ -0,0 +1,417 @@
+/*
+ * bf5xx-ac97.c -- AC97 support for the ADI blackfin chip.
+ *
+ * Author:	Roy Huang
+ * Created:	11th. June 2007
+ * Copyright:	Analog Device Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/wait.h>
+#include <linux/delay.h>
+#include <linux/proc_fs.h>
+
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/ac97_codec.h>
+#include <sound/initval.h>
+#include <sound/soc.h>
+
+#include <asm/irq.h>
+#include <asm/gpio.h>
+#include <asm/portmux.h>
+#include <linux/mutex.h>
+
+#include "bf5xx-sport.h"
+#include "bf5xx-ac97.h"
+
+#if defined(CONFIG_BF54x)
+#define PIN_REQ_SPORT_0 {P_SPORT0_TFS, P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS, \
+		 P_SPORT0_DRPRI, P_SPORT0_RSCLK, 0}
+
+#define PIN_REQ_SPORT_1 {P_SPORT1_TFS, P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS, \
+		 P_SPORT1_DRPRI, P_SPORT1_RSCLK, 0}
+
+#define PIN_REQ_SPORT_2 {P_SPORT2_TFS, P_SPORT2_DTPRI, P_SPORT2_TSCLK, P_SPORT2_RFS, \
+		 P_SPORT2_DRPRI, P_SPORT2_RSCLK, 0}
+
+#define PIN_REQ_SPORT_3 {P_SPORT3_TFS, P_SPORT3_DTPRI, P_SPORT3_TSCLK, P_SPORT3_RFS, \
+		 P_SPORT3_DRPRI, P_SPORT3_RSCLK, 0}
+#else
+#define PIN_REQ_SPORT_0 {P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS, \
+		 P_SPORT0_DRPRI, P_SPORT0_RSCLK, 0}
+#define PIN_REQ_SPORT_1 {P_SPORT1_DTPRI, P_SPORT1_TSCLK, P_SPORT1_RFS, \
+		 P_SPORT1_DRPRI, P_SPORT1_RSCLK, 0}
+#endif
+
+static int *cmd_count;
+static int sport_num = CONFIG_SND_BF5XX_SPORT_NUM;
+
+#if defined(CONFIG_BF54x)
+static struct sport_param sport_params[4] = {
+	{
+		.dma_rx_chan	= CH_SPORT0_RX,
+		.dma_tx_chan	= CH_SPORT0_TX,
+		.err_irq	= IRQ_SPORT0_ERR,
+		.regs		= (struct sport_register *)SPORT0_TCR1,
+	},
+	{
+		.dma_rx_chan	= CH_SPORT1_RX,
+		.dma_tx_chan	= CH_SPORT1_TX,
+		.err_irq	= IRQ_SPORT1_ERR,
+		.regs		= (struct sport_register *)SPORT1_TCR1,
+	},
+	{
+		.dma_rx_chan	= CH_SPORT2_RX,
+		.dma_tx_chan	= CH_SPORT2_TX,
+		.err_irq	= IRQ_SPORT2_ERR,
+		.regs		= (struct sport_register *)SPORT2_TCR1,
+	},
+	{
+		.dma_rx_chan	= CH_SPORT3_RX,
+		.dma_tx_chan	= CH_SPORT3_TX,
+		.err_irq	= IRQ_SPORT3_ERR,
+		.regs		= (struct sport_register *)SPORT3_TCR1,
+	}
+};
+#else
+static struct sport_param sport_params[2] = {
+	{
+		.dma_rx_chan	= CH_SPORT0_RX,
+		.dma_tx_chan	= CH_SPORT0_TX,
+		.err_irq	= IRQ_SPORT0_ERROR,
+		.regs		= (struct sport_register *)SPORT0_TCR1,
+	},
+	{
+		.dma_rx_chan	= CH_SPORT1_RX,
+		.dma_tx_chan	= CH_SPORT1_TX,
+		.err_irq	= IRQ_SPORT1_ERROR,
+		.regs		= (struct sport_register *)SPORT1_TCR1,
+	}
+};
+#endif
+
+void bf5xx_pcm_to_ac97(struct ac97_frame *dst, const __u32 *src, \
+		size_t count)
+{
+	while (count--) {
+		dst->ac97_tag = TAG_VALID | TAG_PCM;
+		(dst++)->ac97_pcm = *src++;
+	}
+}
+EXPORT_SYMBOL(bf5xx_pcm_to_ac97);
+
+void bf5xx_ac97_to_pcm(const struct ac97_frame *src, __u32 *dst, \
+		size_t count)
+{
+	while (count--) {
+		*(dst++) = (src++)->ac97_pcm;
+	}
+}
+EXPORT_SYMBOL(bf5xx_ac97_to_pcm);
+
+static unsigned int sport_tx_curr_frag(struct sport_device *sport)
+{
+	return sport->tx_curr_frag = sport_curr_offset_tx(sport) / \
+			sport->tx_fragsize;
+}
+
+static void enqueue_cmd(struct snd_ac97 *ac97, __u16 addr, __u16 data)
+{
+	struct sport_device *sport = sport_handle;
+	int nextfrag = sport_tx_curr_frag(sport);
+	struct ac97_frame *nextwrite;
+
+	incfrag(sport, &nextfrag, 1);
+	incfrag(sport, &nextfrag, 1);
+
+	nextwrite = (struct ac97_frame *)(sport->tx_buf + \
+			nextfrag * sport->tx_fragsize);
+	pr_debug("sport->tx_buf:%p, nextfrag:0x%x nextwrite:%p, cmd_count:%d\n",
+			sport->tx_buf, nextfrag, nextwrite, cmd_count[nextfrag]);
+	nextwrite[cmd_count[nextfrag]].ac97_tag |= TAG_CMD;
+	nextwrite[cmd_count[nextfrag]].ac97_addr = addr;
+	nextwrite[cmd_count[nextfrag]].ac97_data = data;
+	++cmd_count[nextfrag];
+	pr_debug("ac97_sport: Inserting %02x/%04x into fragment %d\n",
+			addr >> 8, data, nextfrag);
+}
+
+static unsigned short bf5xx_ac97_read(struct snd_ac97 *ac97,
+	unsigned short reg)
+{
+	struct ac97_frame out_frame[2], in_frame[2];
+
+	pr_debug("%s enter 0x%x\n", __func__, reg);
+
+	/* When dma descriptor is enabled, the register should not be read */
+	if (sport_handle->tx_run || sport_handle->rx_run) {
+		printk(KERN_ERR "Could you send a mail to author "
+				"to report this?\n");
+		return -EFAULT;
+	}
+
+	memset(&out_frame, 0, 2 * sizeof(struct ac97_frame));
+	memset(&in_frame, 0, 2 * sizeof(struct ac97_frame));
+	out_frame[0].ac97_tag = TAG_VALID | TAG_CMD;
+	out_frame[0].ac97_addr = ((reg << 8) | 0x8000);
+	sport_send_and_recv(sport_handle, (unsigned char *)&out_frame,
+			(unsigned char *)&in_frame,
+			2 * sizeof(struct ac97_frame));
+	return in_frame[1].ac97_data;
+}
+
+void bf5xx_ac97_write(struct snd_ac97 *ac97, unsigned short reg,
+	unsigned short val)
+{
+	pr_debug("%s enter 0x%x:0x%04x\n", __func__, reg, val);
+
+	if (sport_handle->tx_run) {
+		enqueue_cmd(ac97, (reg << 8), val); /* write */
+		enqueue_cmd(ac97, (reg << 8) | 0x8000, 0); /* read back */
+	} else {
+		struct ac97_frame frame;
+		memset(&frame, 0, sizeof(struct ac97_frame));
+		frame.ac97_tag = TAG_VALID | TAG_CMD;
+		frame.ac97_addr = (reg << 8);
+		frame.ac97_data = val;
+		sport_send_and_recv(sport_handle, (unsigned char *)&frame, \
+				NULL, sizeof(struct ac97_frame));
+	}
+}
+
+static void bf5xx_ac97_warm_reset(struct snd_ac97 *ac97)
+{
+#if defined(CONFIG_BF54x) || defined(CONFIG_BF561) || \
+ (defined(BF537_FAMILY) && (CONFIG_SND_BF5XX_SPORT_NUM == 1))
+
+#define CONCAT(a, b, c) a ## b ## c
+#define BFIN_SPORT_RFS(x) CONCAT(P_SPORT, x, _RFS)
+
+	u16 per = BFIN_SPORT_RFS(CONFIG_SND_BF5XX_SPORT_NUM);
+	u16 gpio = P_IDENT(BFIN_SPORT_RFS(CONFIG_SND_BF5XX_SPORT_NUM));
+
+	pr_debug("%s enter\n", __func__);
+
+	peripheral_free(per);
+	gpio_request(gpio, "bf5xx-ac97");
+	gpio_direction_output(gpio, 1);
+	udelay(2);
+	gpio_set_value(gpio, 0);
+	udelay(1);
+	gpio_free(gpio);
+	peripheral_request(per, "soc-audio");
+#else
+	printk(KERN_INFO"%s: Not implemented\n", __func__);
+#endif
+}
+
+static void bf5xx_ac97_cold_reset(struct snd_ac97 *ac97)
+{
+#ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
+	pr_debug("%s enter\n", __func__);
+
+	/* It is specified for bf548-ezkit */
+	gpio_set_value(CONFIG_SND_BF5XX_RESET_GPIO_NUM, 0);
+	/* Keep reset pin low for 1 ms */
+	mdelay(1);
+	gpio_set_value(CONFIG_SND_BF5XX_RESET_GPIO_NUM, 1);
+	/* Wait for bit clock recover */
+	mdelay(1);
+#endif
+}
+
+struct snd_ac97_bus_ops soc_ac97_ops = {
+	.read	= bf5xx_ac97_read,
+	.write	= bf5xx_ac97_write,
+	.warm_reset	= bf5xx_ac97_warm_reset,
+	.reset	= bf5xx_ac97_cold_reset,
+};
+EXPORT_SYMBOL_GPL(soc_ac97_ops);
+
+#ifdef CONFIG_PM
+static int bf5xx_ac97_suspend(struct platform_device *pdev,
+	struct snd_soc_cpu_dai *dai)
+{
+	struct sport_device *sport =
+		(struct sport_device *)dai->private_data;
+
+	pr_debug("%s : sport %d\n", __func__, dai->id);
+	if (!dai->active)
+		return 0;
+	if (dai->capture.active)
+		sport_rx_stop(sport);
+	if (dai->playback.active)
+		sport_tx_stop(sport);
+	return 0;
+}
+
+static int bf5xx_ac97_resume(struct platform_device *pdev,
+	struct snd_soc_cpu_dai *dai)
+{
+	int ret;
+	struct sport_device *sport =
+		(struct sport_device *)dai->private_data;
+
+	pr_debug("%s : sport %d\n", __func__, dai->id);
+	if (!dai->active)
+		return 0;
+	ret = sport_set_multichannel(sport_handle, 16, 0x1F, 1);
+
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+	ret = sport_config_rx(sport_handle, IRFS, 0xF, 0, (16*16-1));
+
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+	ret = sport_config_tx(sport_handle, ITFS, 0xF, 0, (16*16-1));
+
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+
+	if (dai->capture.active)
+		sport_rx_start(sport);
+	if (dai->playback.active)
+		sport_tx_start(sport);
+	return 0;
+}
+
+#else
+#define bf5xx_ac97_suspend	NULL
+#define bf5xx_ac97_resume	NULL
+#endif
+
+static struct proc_dir_entry *ac_entry;
+
+/* For test purpose, read a register from codec */
+static int proc_write(struct file *file, const char __user *buffer,
+		unsigned long count, void *data)
+{
+	struct ac97_frame out_frame[2], in_frame[2];
+	unsigned long reg = simple_strtoul(buffer, NULL, 16);
+
+	memset(&out_frame, 0, 2 * sizeof(struct ac97_frame));
+	out_frame[0].ac97_tag = TAG_VALID | TAG_CMD;
+	out_frame[0].ac97_addr = (unsigned short) ((reg << 8) | 0x8000);
+	sport_send_and_recv(sport_handle, (unsigned char *)&out_frame,
+				(unsigned char *)&in_frame,
+				2 * sizeof(struct ac97_frame));
+	printk(KERN_INFO"0x%x:%04x\n", out_frame[0].ac97_addr, \
+			in_frame[1].ac97_data);
+
+	return count;
+}
+
+static int bf5xx_ac97_probe(struct platform_device *pdev)
+{
+	int ret;
+#if defined(CONFIG_BF54x)
+	u16 sport_req[][7] = {PIN_REQ_SPORT_0, PIN_REQ_SPORT_1,
+				 PIN_REQ_SPORT_2, PIN_REQ_SPORT_3};
+#else
+	u16 sport_req[][7] = {PIN_REQ_SPORT_0, PIN_REQ_SPORT_1};
+#endif
+	cmd_count = (int *)get_zeroed_page(GFP_KERNEL);
+	if (cmd_count == NULL)
+		return -ENOMEM;
+
+	if (peripheral_request_list(&sport_req[sport_num][0], "soc-audio")) {
+		printk(KERN_ERR "Requesting Peripherals failed\n");
+		return -EFAULT;
+		}
+
+#ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
+	/* Request PB3 as reset pin */
+	if (gpio_request(CONFIG_SND_BF5XX_RESET_GPIO_NUM, "SND_AD198x RESET")) {
+		printk(KERN_ERR "Failed to request GPIO_%d for reset\n",
+				CONFIG_SND_BF5XX_RESET_GPIO_NUM);
+		peripheral_free_list(&sport_req[sport_num][0]);
+		return -1;
+	}
+	gpio_direction_output(CONFIG_SND_BF5XX_RESET_GPIO_NUM, 1);
+#endif
+	sport_handle = sport_init(&sport_params[sport_num], 2, \
+			sizeof(struct ac97_frame), NULL);
+	if (!sport_handle) {
+		peripheral_free_list(&sport_req[sport_num][0]);
+#ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
+		gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
+#endif
+		return -ENODEV;
+	}
+	/*SPORT works in TDM mode to simulate AC97 transfers*/
+	ret = sport_set_multichannel(sport_handle, 16, 0x1F, 1);
+
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+	ret = sport_config_rx(sport_handle, IRFS, 0xF, 0, (16*16-1));
+
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+	ret = sport_config_tx(sport_handle, ITFS, 0xF, 0, (16*16-1));
+
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+	ac_entry = create_proc_entry("driver/sport_ac97", 0600, NULL);
+	ac_entry->read_proc = NULL;
+	ac_entry->write_proc = proc_write;
+	ac_entry->data = sport_handle;
+	return 0;
+}
+
+static void bf5xx_ac97_remove(struct platform_device *pdev)
+{
+	free_page((unsigned long)cmd_count);
+	cmd_count = NULL;
+	remove_proc_entry("driver/sport_ac97", NULL);
+#ifdef CONFIG_SND_BF5XX_HAVE_COLD_RESET
+	gpio_free(CONFIG_SND_BF5XX_RESET_GPIO_NUM);
+#endif
+}
+
+struct snd_soc_cpu_dai bfin_ac97_dai = {
+	.name = "bf5xx-ac97",
+	.id = 0,
+	.type = SND_SOC_DAI_AC97,
+	.probe = bf5xx_ac97_probe,
+	.remove = bf5xx_ac97_remove,
+	.suspend = bf5xx_ac97_suspend,
+	.resume = bf5xx_ac97_resume,
+	.playback = {
+		.stream_name = "AC97 Playback",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE, },
+	.capture = {
+		.stream_name = "AC97 Capture",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_48000,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE, },
+};
+EXPORT_SYMBOL_GPL(bfin_ac97_dai);
+
+MODULE_AUTHOR("Roy Huang");
+MODULE_DESCRIPTION("AC97 driver for ADI Blackfin");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/blackfin/bf5xx-ac97.h b/sound/soc/blackfin/bf5xx-ac97.h
new file mode 100644
index 0000000..725ede8
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ac97.h
@@ -0,0 +1,36 @@
+/*
+ * linux/sound/arm/bf5xx-ac97.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BF5XX_AC97_H
+#define _BF5XX_AC97_H
+
+extern struct snd_ac97_bus_ops bf5xx_ac97_ops;
+extern struct snd_ac97 *ac97;
+/* Frame format in memory, only support stereo currently */
+struct ac97_frame {
+	u16 ac97_tag;		/* slot 0 */
+	u16 ac97_addr;		/* slot 1 */
+	u16 ac97_data;		/* slot 2 */
+	u32 ac97_pcm;		/* slot 3 and 4: left and right pcm data */
+} __attribute__ ((packed));
+
+#define TAG_VALID		0x8000
+#define TAG_CMD			0x6000
+#define TAG_PCM_LEFT		0x1000
+#define TAG_PCM_RIGHT		0x0800
+#define TAG_PCM			(TAG_PCM_LEFT | TAG_PCM_RIGHT)
+
+extern struct snd_soc_cpu_dai bfin_ac97_dai;
+
+void bf5xx_pcm_to_ac97(struct ac97_frame *dst, const __u32 *src, \
+		size_t count);
+
+void bf5xx_ac97_to_pcm(const struct ac97_frame *src, __u32 *dst, \
+		size_t count);
+
+#endif
diff --git a/sound/soc/blackfin/bf5xx-ad1980.c b/sound/soc/blackfin/bf5xx-ad1980.c
new file mode 100644
index 0000000..74732e2
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ad1980.c
@@ -0,0 +1,116 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-ad1980.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC
+ *
+ * Rev:          $Id: bf5xx-ad1980.c 4104 2008-06-06 06:51:48Z cliff $
+ *
+ * Modified:
+ *               Copyright 2008 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <asm/dma.h>
+
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+
+#include <asm/gpio.h>
+#include <asm/portmux.h>
+
+#include "../codecs/ad1980.h"
+#include "bf5xx-sport.h"
+#include "bf5xx-ac97-pcm.h"
+#include "bf5xx-ac97.h"
+
+static struct snd_soc_machine bf5xx_board;
+
+static int bf5xx_board_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_cpu_dai *cpu_dai = rtd->dai->cpu_dai;
+
+	pr_debug("%s enter\n", __func__);
+	cpu_dai->private_data = sport_handle;
+	return 0;
+}
+
+static struct snd_soc_ops bf5xx_board_ops = {
+	.startup = bf5xx_board_startup,
+};
+
+static struct snd_soc_dai_link bf5xx_board_dai = {
+	.name = "AC97",
+	.stream_name = "AC97 HiFi",
+	.cpu_dai = &bfin_ac97_dai,
+	.codec_dai = &ad1980_dai,
+	.ops = &bf5xx_board_ops,
+};
+
+static struct snd_soc_machine bf5xx_board = {
+	.name = "bf5xx-board",
+	.dai_link = &bf5xx_board_dai,
+	.num_links = 1,
+};
+
+static struct snd_soc_device bf5xx_board_snd_devdata = {
+	.machine = &bf5xx_board,
+	.platform = &bf5xx_ac97_soc_platform,
+	.codec_dev = &soc_codec_dev_ad1980,
+};
+
+static struct platform_device *bf5xx_board_snd_device;
+
+static int __init bf5xx_board_init(void)
+{
+	int ret;
+
+	bf5xx_board_snd_device = platform_device_alloc("soc-audio", -1);
+	if (!bf5xx_board_snd_device)
+		return -ENOMEM;
+
+	platform_set_drvdata(bf5xx_board_snd_device, &bf5xx_board_snd_devdata);
+	bf5xx_board_snd_devdata.dev = &bf5xx_board_snd_device->dev;
+	ret = platform_device_add(bf5xx_board_snd_device);
+
+	if (ret)
+		platform_device_put(bf5xx_board_snd_device);
+
+	return ret;
+}
+
+static void __exit bf5xx_board_exit(void)
+{
+	platform_device_unregister(bf5xx_board_snd_device);
+}
+
+module_init(bf5xx_board_init);
+module_exit(bf5xx_board_exit);
+
+/* Module information */
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("ALSA SoC AD1980/1 BF5xx board");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
new file mode 100644
index 0000000..b001cfa
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -0,0 +1,293 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-i2s-pcm.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC
+ *
+ * Rev:          $Id: bf5xx-i2s-pcm.c 4104 2008-06-06 06:51:48Z cliff $
+ *
+ * Modified:
+ *               Copyright 2008 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+
+#include <asm/dma.h>
+
+#include "bf5xx-i2s-pcm.h"
+#include "bf5xx-i2s.h"
+#include "bf5xx-sport.h"
+
+static void bf5xx_dma_irq(void *data)
+{
+	struct snd_pcm_substream *pcm = data;
+	snd_pcm_period_elapsed(pcm);
+}
+
+static const struct snd_pcm_hardware bf5xx_pcm_hardware = {
+	.info			= SNDRV_PCM_INFO_INTERLEAVED |
+				   SNDRV_PCM_INFO_MMAP |
+				   SNDRV_PCM_INFO_MMAP_VALID |
+				   SNDRV_PCM_INFO_BLOCK_TRANSFER,
+	.formats		= SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S32_LE,
+	.period_bytes_min	= 32,
+	.period_bytes_max	= 0x10000,
+	.periods_min		= 1,
+	.periods_max		= PAGE_SIZE/32,
+	.buffer_bytes_max	= 0x20000, /* 128 kbytes */
+	.fifo_size		= 16,
+};
+
+static int bf5xx_pcm_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max;
+	snd_pcm_lib_malloc_pages(substream, size);
+
+	return 0;
+}
+
+static int bf5xx_pcm_hw_free(struct snd_pcm_substream *substream)
+{
+	snd_pcm_lib_free_pages(substream);
+
+	return 0;
+}
+
+static int bf5xx_pcm_prepare(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	int period_bytes = frames_to_bytes(runtime, runtime->period_size);
+
+	pr_debug("%s enter\n", __func__);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		sport_set_tx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_tx_dma(sport, runtime->dma_area, runtime->periods, period_bytes);
+	} else {
+		sport_set_rx_callback(sport, bf5xx_dma_irq, substream);
+		sport_config_rx_dma(sport, runtime->dma_area, runtime->periods, period_bytes);
+	}
+
+	return 0;
+}
+
+static int bf5xx_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	int ret = 0;
+
+	pr_debug("%s %s\n", substream->stream?"Capture":"Playback", \
+			cmd?" start":" stop");
+	switch (cmd) {
+	case SNDRV_PCM_TRIGGER_START:
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			sport_tx_start(sport);
+		else
+			sport_rx_start(sport);
+		break;
+	case SNDRV_PCM_TRIGGER_STOP:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			sport_tx_stop(sport);
+		else
+			sport_rx_stop(sport);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static snd_pcm_uframes_t bf5xx_pcm_pointer(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct sport_device *sport = runtime->private_data;
+	unsigned int diff;
+	snd_pcm_uframes_t frames;
+	pr_debug("%s enter\n", __func__);
+	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
+		diff = sport_curr_offset_tx(sport);
+		frames = bytes_to_frames(substream->runtime, diff);
+	} else {
+		diff = sport_curr_offset_rx(sport);
+		frames = bytes_to_frames(substream->runtime, diff);
+	}
+	return frames;
+}
+
+static int bf5xx_pcm_open(struct snd_pcm_substream *substream)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	int ret;
+
+	pr_debug("%s enter\n", __func__);
+	snd_soc_set_runtime_hwparams(substream, &bf5xx_pcm_hardware);
+
+	ret = snd_pcm_hw_constraint_integer(runtime, \
+			SNDRV_PCM_HW_PARAM_PERIODS);
+	if (ret < 0)
+		goto out;
+
+	if (sport_handle != NULL)
+		runtime->private_data = sport_handle;
+	else {
+		printk(KERN_ERR "sport_handle is NULL\n");
+		return -1;
+	}
+	return 0;
+
+ out:
+	return ret;
+}
+
+static int bf5xx_pcm_close(struct snd_pcm_substream *substream)
+{
+	pr_debug("%s enter\n", __func__);
+	/*Nothing need to be cleared here*/
+
+	return 0;
+}
+
+static int bf5xx_pcm_mmap(struct snd_pcm_substream *substream,
+	struct vm_area_struct *vma)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	size_t size = vma->vm_end - vma->vm_start;
+	vma->vm_start = (unsigned long)runtime->dma_area;
+	vma->vm_end = vma->vm_start + size;
+	vma->vm_flags |=  VM_SHARED;
+
+	return 0 ;
+}
+
+struct snd_pcm_ops bf5xx_pcm_ops = {
+	.open		= bf5xx_pcm_open,
+	.close		= bf5xx_pcm_close,
+	.ioctl		= snd_pcm_lib_ioctl,
+	.hw_params	= bf5xx_pcm_hw_params,
+	.hw_free	= bf5xx_pcm_hw_free,
+	.prepare	= bf5xx_pcm_prepare,
+	.trigger	= bf5xx_pcm_trigger,
+	.pointer	= bf5xx_pcm_pointer,
+	.mmap		= bf5xx_pcm_mmap,
+};
+
+static int bf5xx_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
+{
+	struct snd_pcm_substream *substream = pcm->streams[stream].substream;
+	struct snd_dma_buffer *buf = &substream->dma_buffer;
+	size_t size = bf5xx_pcm_hardware.buffer_bytes_max;
+
+	buf->dev.type = SNDRV_DMA_TYPE_DEV;
+	buf->dev.dev = pcm->card->dev;
+	buf->private_data = NULL;
+	buf->area = dma_alloc_coherent(pcm->card->dev, size, &buf->addr, GFP_KERNEL);
+	if (!buf->area) {
+		printk(KERN_ERR "Failed to allocate dma memory-Please increase uncached DMA memory region\n");
+		return -ENOMEM;
+	}
+	buf->bytes = size;
+
+	pr_debug("%s, area:%p, size:0x%08lx\n", __func__, buf->area, buf->bytes);
+	if (stream == SNDRV_PCM_STREAM_PLAYBACK)
+		sport_handle->tx_buf = buf->area;
+	else
+		sport_handle->rx_buf = buf->area;
+
+	return 0;
+}
+
+static void bf5xx_pcm_free_dma_buffers(struct snd_pcm *pcm)
+{
+	struct snd_pcm_substream *substream;
+	struct snd_dma_buffer *buf;
+	int stream;
+
+	for (stream = 0; stream < 2; stream++) {
+		substream = pcm->streams[stream].substream;
+		if (!substream)
+			continue;
+
+		buf = &substream->dma_buffer;
+		if (!buf->area)
+			continue;
+		dma_free_coherent(NULL, buf->bytes, buf->area, 0);
+		buf->area = NULL;
+	}
+	if (sport_handle)
+		sport_done(sport_handle);
+}
+
+static u64 bf5xx_pcm_dmamask = DMA_32BIT_MASK;
+
+int bf5xx_pcm_new(struct snd_card *card, struct snd_soc_codec_dai *dai,
+	struct snd_pcm *pcm)
+{
+	int ret = 0;
+
+	pr_debug("%s enter\n", __func__);
+	if (!card->dev->dma_mask)
+		card->dev->dma_mask = &bf5xx_pcm_dmamask;
+	if (!card->dev->coherent_dma_mask)
+		card->dev->coherent_dma_mask = DMA_32BIT_MASK;
+
+	if (dai->playback.channels_min) {
+		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
+			SNDRV_PCM_STREAM_PLAYBACK);
+		if (ret)
+			goto out;
+	}
+
+	if (dai->capture.channels_min) {
+		ret = bf5xx_pcm_preallocate_dma_buffer(pcm,
+			SNDRV_PCM_STREAM_CAPTURE);
+		if (ret)
+			goto out;
+	}
+ out:
+	return ret;
+}
+
+struct snd_soc_platform bf5xx_i2s_soc_platform = {
+	.name		= "bf5xx-audio",
+	.pcm_ops 	= &bf5xx_pcm_ops,
+	.pcm_new	= bf5xx_pcm_new,
+	.pcm_free	= bf5xx_pcm_free_dma_buffers,
+};
+EXPORT_SYMBOL_GPL(bf5xx_i2s_soc_platform);
+
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("ADI Blackfin I2S PCM DMA module");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.h b/sound/soc/blackfin/bf5xx-i2s-pcm.h
new file mode 100644
index 0000000..5ab26e1
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.h
@@ -0,0 +1,29 @@
+/*
+ * linux/sound/arm/bf5xx-i2s-pcm.h -- ALSA PCM interface for the Blackfin
+ *
+ * Copyright 2007 Analog Device Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BF5XX_I2S_PCM_H
+#define _BF5XX_I2S_PCM_H
+
+struct bf5xx_pcm_dma_params {
+	char *name;			/* stream identifier */
+};
+
+struct bf5xx_gpio {
+	u32 sys;
+	u32	rx;
+	u32 tx;
+	u32 clk;
+	u32 frm;
+};
+
+/* platform data */
+extern struct snd_soc_platform bf5xx_i2s_soc_platform;
+
+#endif
diff --git a/sound/soc/blackfin/bf5xx-i2s.c b/sound/soc/blackfin/bf5xx-i2s.c
new file mode 100644
index 0000000..6810aa5
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-i2s.c
@@ -0,0 +1,183 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-i2s.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC
+ *
+ * Rev:          $Id: bf5xx-i2s.c 4104 2008-06-06 06:51:48Z cliff $
+ *
+ * Modified:
+ *               Copyright 2008 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/initval.h>
+#include <sound/soc.h>
+
+#include <asm/irq.h>
+#include <asm/gpio.h>
+#include <asm/portmux.h>
+#include <linux/mutex.h>
+
+#include "bf5xx-sport.h"
+#include "bf5xx-i2s.h"
+
+static int sport_num = CONFIG_SND_BF5XX_SPORT_NUM;
+
+static struct sport_param sport_params[2] = {
+	{
+		.dma_rx_chan	= CH_SPORT0_RX,
+		.dma_tx_chan	= CH_SPORT0_TX,
+		.err_irq	= IRQ_SPORT0_ERROR,
+		.regs		= (struct sport_register *)SPORT0_TCR1,
+	},
+	{
+		.dma_rx_chan	= CH_SPORT1_RX,
+		.dma_tx_chan	= CH_SPORT1_TX,
+		.err_irq	= IRQ_SPORT1_ERROR,
+		.regs		= (struct sport_register *)SPORT1_TCR1,
+	}
+};
+
+static int bf5xx_i2s_probe(struct platform_device *pdev)
+{
+	int ret;
+	u16 sport_req[][7] = { {P_SPORT0_DTPRI, P_SPORT0_TSCLK, P_SPORT0_RFS,
+		 P_SPORT0_DRPRI, P_SPORT0_RSCLK, 0}, {P_SPORT1_DTPRI,
+		 P_SPORT1_TSCLK, P_SPORT1_RFS, P_SPORT1_DRPRI, P_SPORT1_RSCLK, 0} };
+	if (peripheral_request_list(&sport_req[sport_num][0], "soc-audio")) {
+		printk(KERN_ERR "Requesting Peripherals failed\n");
+		return -EFAULT;
+	}
+	pr_debug("%s enter\n", __func__);
+	/*request DMA for SPORT*/
+	sport_handle = sport_init(&sport_params[sport_num], 4, \
+			2 * sizeof(u32), NULL);
+	if (!sport_handle) {
+		peripheral_free_list(&sport_req[sport_num][0]);
+		return -ENODEV;
+	}
+	/*  TX and RX are not independent,they are enabled at the same time,
+	 *  even if only one side is running.So,we need to configure both of them in advance.
+	 *  CPU DAI format:I2S,word length:32 bit,slave mode.
+	 */
+	ret = sport_config_rx(sport_handle, RFSR | RCKFE, RSFSE|0x1f, 0, 0);
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+	ret = sport_config_tx(sport_handle, TFSR | TCKFE, TSFSE|0x1f, 0, 0);
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int bf5xx_i2s_suspend(struct platform_device *dev,
+	struct snd_soc_cpu_dai *dai)
+{
+	struct sport_device *sport =
+		(struct sport_device *)dai->private_data;
+
+	pr_debug("%s : sport %d\n", __func__, dai->id);
+	if (!dai->active)
+		return 0;
+	if (dai->capture.active)
+		sport_rx_stop(sport);
+	if (dai->playback.active)
+		sport_tx_stop(sport);
+	return 0;
+}
+
+static int bf5xx_i2s_resume(struct platform_device *pdev,
+	struct snd_soc_cpu_dai *dai)
+{
+	int ret;
+	struct sport_device *sport =
+		(struct sport_device *)dai->private_data;
+
+	pr_debug("%s : sport %d\n", __func__, dai->id);
+	if (!dai->active)
+		return 0;
+	ret = sport_config_rx(sport_handle, RFSR | RCKFE, RSFSE|0x1f, 0, 0);
+
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+	ret = sport_config_tx(sport_handle, TFSR | TCKFE, TSFSE|0x1f, 0, 0);
+	if (ret) {
+		printk(KERN_ERR "SPORT is busy!\n");
+		return -EBUSY;
+	}
+
+	if (dai->capture.active)
+		sport_rx_start(sport);
+	if (dai->playback.active)
+		sport_tx_start(sport);
+	return 0;
+}
+
+#else
+#define bf5xx_i2s_suspend	NULL
+#define bf5xx_i2s_resume	NULL
+#endif
+
+#define BF5XX_I2S_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_11025 |\
+		SNDRV_PCM_RATE_16000 | SNDRV_PCM_RATE_22050 | \
+		SNDRV_PCM_RATE_44100 | SNDRV_PCM_RATE_48000 | \
+		SNDRV_PCM_RATE_96000)
+
+struct snd_soc_cpu_dai bf5xx_i2s_dai = {
+	.name = "bf5xx-i2s",
+	.id = 0,
+	.type = SND_SOC_DAI_I2S,
+	.probe = bf5xx_i2s_probe,
+	.suspend = bf5xx_i2s_suspend,
+	.resume = bf5xx_i2s_resume,
+	.playback = {
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = BF5XX_I2S_RATES,
+		.formats = SNDRV_PCM_FMTBIT_S32_LE,},
+	.capture = {
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = BF5XX_I2S_RATES,
+		.formats = SNDRV_PCM_FMTBIT_S32_LE,},
+};
+EXPORT_SYMBOL_GPL(bf5xx_i2s_dai);
+
+/* Module information */
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("I2S driver for ADI Blackfin");
+MODULE_LICENSE("GPL");
+
diff --git a/sound/soc/blackfin/bf5xx-i2s.h b/sound/soc/blackfin/bf5xx-i2s.h
new file mode 100644
index 0000000..3731273
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-i2s.h
@@ -0,0 +1,14 @@
+/*
+ * linux/sound/arm/bf5xx-i2s.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _BF5XX_I2S_H
+#define _BF5XX_I2S_H
+
+extern struct snd_soc_cpu_dai bf5xx_i2s_dai;
+
+#endif
diff --git a/sound/soc/blackfin/bf5xx-sport.c b/sound/soc/blackfin/bf5xx-sport.c
new file mode 100644
index 0000000..52de7c1
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-sport.c
@@ -0,0 +1,1018 @@
+/*
+ * File:         bf5xx_ac97_sport.c
+ * Based on:
+ * Author:       Roy Huang <roy.huang@analog.com>
+ *
+ * Created:      Tue Sep 21 10:52:42 CEST 2004
+ * Description:
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <asm/bug.h>
+#include <asm/gpio.h>
+#include <asm/portmux.h>
+#include <asm/dma.h>
+#include <asm/blackfin.h>
+#include <asm/cacheflush.h>
+
+#include "bf5xx-sport.h"
+/* delay between frame sync pulse and first data bit in multichannel mode */
+#define FRAME_DELAY (1<<12)
+
+struct sport_device *sport_handle;
+EXPORT_SYMBOL(sport_handle);
+/* note: multichannel is in units of 8 channels,
+ * tdm_count is # channels NOT / 8 ! */
+int sport_set_multichannel(struct sport_device *sport,
+		int tdm_count, u32 mask, int packed)
+{
+	pr_debug("%s tdm_count=%d mask:0x%08x packed=%d\n", __func__,
+			tdm_count, mask, packed);
+
+	if ((sport->regs->tcr1 & TSPEN) || (sport->regs->rcr1 & RSPEN))
+		return -EBUSY;
+
+	if (tdm_count & 0x7)
+		return -EINVAL;
+
+	if (tdm_count > 32)
+		return -EINVAL; /* Only support less than 32 channels now */
+
+	if (tdm_count) {
+		sport->regs->mcmc1 = ((tdm_count>>3)-1) << 12;
+		sport->regs->mcmc2 = FRAME_DELAY | MCMEN | \
+				(packed ? (MCDTXPE|MCDRXPE) : 0);
+
+		sport->regs->mtcs0 = mask;
+		sport->regs->mrcs0 = mask;
+		sport->regs->mtcs1 = 0;
+		sport->regs->mrcs1 = 0;
+		sport->regs->mtcs2 = 0;
+		sport->regs->mrcs2 = 0;
+		sport->regs->mtcs3 = 0;
+		sport->regs->mrcs3 = 0;
+	} else {
+		sport->regs->mcmc1 = 0;
+		sport->regs->mcmc2 = 0;
+
+		sport->regs->mtcs0 = 0;
+		sport->regs->mrcs0 = 0;
+	}
+
+	sport->regs->mtcs1 = 0; sport->regs->mtcs2 = 0; sport->regs->mtcs3 = 0;
+	sport->regs->mrcs1 = 0; sport->regs->mrcs2 = 0; sport->regs->mrcs3 = 0;
+
+	SSYNC();
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_set_multichannel);
+
+int sport_config_rx(struct sport_device *sport, unsigned int rcr1,
+		unsigned int rcr2, unsigned int clkdiv, unsigned int fsdiv)
+{
+	if ((sport->regs->tcr1 & TSPEN) || (sport->regs->rcr1 & RSPEN))
+		return -EBUSY;
+
+	sport->regs->rcr1 = rcr1;
+	sport->regs->rcr2 = rcr2;
+	sport->regs->rclkdiv = clkdiv;
+	sport->regs->rfsdiv = fsdiv;
+
+	SSYNC();
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_config_rx);
+
+int sport_config_tx(struct sport_device *sport, unsigned int tcr1,
+		unsigned int tcr2, unsigned int clkdiv, unsigned int fsdiv)
+{
+	if ((sport->regs->tcr1 & TSPEN) || (sport->regs->rcr1 & RSPEN))
+		return -EBUSY;
+
+	sport->regs->tcr1 = tcr1;
+	sport->regs->tcr2 = tcr2;
+	sport->regs->tclkdiv = clkdiv;
+	sport->regs->tfsdiv = fsdiv;
+
+	SSYNC();
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_config_tx);
+
+static void setup_desc(struct dmasg *desc, void *buf, int fragcount,
+		size_t fragsize, unsigned int cfg,
+		unsigned int x_count, unsigned int ycount, size_t wdsize)
+{
+
+	int i;
+
+	for (i = 0; i < fragcount; ++i) {
+		desc[i].next_desc_addr  = (unsigned long)&(desc[i + 1]);
+		desc[i].start_addr = (unsigned long)buf + i*fragsize;
+		desc[i].cfg = cfg;
+		desc[i].x_count = x_count;
+		desc[i].x_modify = wdsize;
+		desc[i].y_count = ycount;
+		desc[i].y_modify = wdsize;
+	}
+
+	/* make circular */
+	desc[fragcount-1].next_desc_addr = (unsigned long)desc;
+
+	pr_debug("setup desc: desc0=%p, next0=%lx, desc1=%p,"
+		"next1=%lx\nx_count=%x,y_count=%x,addr=0x%lx,cfs=0x%x\n",
+		&(desc[0]), desc[0].next_desc_addr,
+		&(desc[1]), desc[1].next_desc_addr,
+		desc[0].x_count, desc[0].y_count,
+		desc[0].start_addr,desc[0].cfg);
+}
+
+static int sport_start(struct sport_device *sport)
+{
+	enable_dma(sport->dma_rx_chan);
+	enable_dma(sport->dma_tx_chan);
+	sport->regs->rcr1 |= RSPEN;
+	sport->regs->tcr1 |= TSPEN;
+	SSYNC();
+
+	return 0;
+}
+
+static int sport_stop(struct sport_device *sport)
+{
+	sport->regs->tcr1 &= ~TSPEN;
+	sport->regs->rcr1 &= ~RSPEN;
+	SSYNC();
+
+	disable_dma(sport->dma_rx_chan);
+	disable_dma(sport->dma_tx_chan);
+	return 0;
+}
+
+static inline int sport_hook_rx_dummy(struct sport_device *sport)
+{
+	struct dmasg *desc, temp_desc;
+	unsigned long flags;
+
+	BUG_ON(sport->dummy_rx_desc == NULL);
+	BUG_ON(sport->curr_rx_desc == sport->dummy_rx_desc);
+
+	/* Maybe the dummy buffer descriptor ring is damaged */
+	sport->dummy_rx_desc->next_desc_addr = \
+			(unsigned long)(sport->dummy_rx_desc+1);
+
+	local_irq_save(flags);
+	desc = (struct dmasg *)get_dma_next_desc_ptr(sport->dma_rx_chan);
+	/* Copy the descriptor which will be damaged to backup */
+	temp_desc = *desc;
+	desc->x_count = 0xa;
+	desc->y_count = 0;
+	desc->next_desc_addr = (unsigned long)(sport->dummy_rx_desc);
+	local_irq_restore(flags);
+	/* Waiting for dummy buffer descriptor is already hooked*/
+	while ((get_dma_curr_desc_ptr(sport->dma_rx_chan) - \
+			sizeof(struct dmasg)) != \
+			(unsigned long)sport->dummy_rx_desc) {}
+	sport->curr_rx_desc = sport->dummy_rx_desc;
+	/* Restore the damaged descriptor */
+	*desc = temp_desc;
+
+	return 0;
+}
+
+static inline int sport_rx_dma_start(struct sport_device *sport, int dummy)
+{
+	if (dummy) {
+		sport->dummy_rx_desc->next_desc_addr = \
+				(unsigned long) sport->dummy_rx_desc;
+		sport->curr_rx_desc = sport->dummy_rx_desc;
+	} else
+		sport->curr_rx_desc = sport->dma_rx_desc;
+
+	set_dma_next_desc_addr(sport->dma_rx_chan, \
+			(unsigned long)(sport->curr_rx_desc));
+	set_dma_x_count(sport->dma_rx_chan, 0);
+	set_dma_x_modify(sport->dma_rx_chan, 0);
+	set_dma_config(sport->dma_rx_chan, (DMAFLOW_LARGE | NDSIZE_9 | \
+				WDSIZE_32 | WNR));
+	set_dma_curr_addr(sport->dma_rx_chan, sport->curr_rx_desc->start_addr);
+	SSYNC();
+
+	return 0;
+}
+
+static inline int sport_tx_dma_start(struct sport_device *sport, int dummy)
+{
+	if (dummy) {
+		sport->dummy_tx_desc->next_desc_addr = \
+				(unsigned long) sport->dummy_tx_desc;
+		sport->curr_tx_desc = sport->dummy_tx_desc;
+	} else
+		sport->curr_tx_desc = sport->dma_tx_desc;
+
+	set_dma_next_desc_addr(sport->dma_tx_chan, \
+			(unsigned long)(sport->curr_tx_desc));
+	set_dma_x_count(sport->dma_tx_chan, 0);
+	set_dma_x_modify(sport->dma_tx_chan, 0);
+	set_dma_config(sport->dma_tx_chan, (DMAFLOW_LARGE | NDSIZE_9 | WDSIZE_32));
+	set_dma_curr_addr(sport->dma_tx_chan, sport->curr_tx_desc->start_addr);
+	SSYNC();
+
+	return 0;
+}
+
+int sport_rx_start(struct sport_device *sport)
+{
+	unsigned long flags;
+	pr_debug("%s enter\n", __func__);
+	if (sport->rx_run)
+		return -EBUSY;
+	if (sport->tx_run) {
+		/* tx is running, rx is not running */
+		BUG_ON(sport->dma_rx_desc == NULL);
+		BUG_ON(sport->curr_rx_desc != sport->dummy_rx_desc);
+		local_irq_save(flags);
+		while ((get_dma_curr_desc_ptr(sport->dma_rx_chan) - \
+			sizeof(struct dmasg)) != \
+			(unsigned long)sport->dummy_rx_desc) {}
+		sport->dummy_rx_desc->next_desc_addr = \
+				(unsigned long)(sport->dma_rx_desc);
+		local_irq_restore(flags);
+		sport->curr_rx_desc = sport->dma_rx_desc;
+	} else {
+		sport_tx_dma_start(sport, 1);
+		sport_rx_dma_start(sport, 0);
+		sport_start(sport);
+	}
+
+	sport->rx_run = 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_rx_start);
+
+int sport_rx_stop(struct sport_device *sport)
+{
+	pr_debug("%s enter\n", __func__);
+
+	if (!sport->rx_run)
+		return 0;
+	if (sport->tx_run) {
+		/* TX dma is still running, hook the dummy buffer */
+		sport_hook_rx_dummy(sport);
+	} else {
+		/* Both rx and tx dma will be stopped */
+		sport_stop(sport);
+		sport->curr_rx_desc = NULL;
+		sport->curr_tx_desc = NULL;
+	}
+
+	sport->rx_run = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_rx_stop);
+
+static inline int sport_hook_tx_dummy(struct sport_device *sport)
+{
+	struct dmasg *desc, temp_desc;
+	unsigned long flags;
+
+	BUG_ON(sport->dummy_tx_desc == NULL);
+	BUG_ON(sport->curr_tx_desc == sport->dummy_tx_desc);
+
+	sport->dummy_tx_desc->next_desc_addr = \
+			(unsigned long)(sport->dummy_tx_desc+1);
+
+	/* Shorten the time on last normal descriptor */
+	local_irq_save(flags);
+	desc = (struct dmasg *)get_dma_next_desc_ptr(sport->dma_tx_chan);
+	/* Store the descriptor which will be damaged */
+	temp_desc = *desc;
+	desc->x_count = 0xa;
+	desc->y_count = 0;
+	desc->next_desc_addr = (unsigned long)(sport->dummy_tx_desc);
+	local_irq_restore(flags);
+	/* Waiting for dummy buffer descriptor is already hooked*/
+	while ((get_dma_curr_desc_ptr(sport->dma_tx_chan) - \
+			sizeof(struct dmasg)) != \
+			(unsigned long)sport->dummy_tx_desc) {}
+	sport->curr_tx_desc = sport->dummy_tx_desc;
+	/* Restore the damaged descriptor */
+	*desc = temp_desc;
+
+	return 0;
+}
+
+int sport_tx_start(struct sport_device *sport)
+{
+	unsigned flags;
+	pr_debug("%s: tx_run:%d, rx_run:%d\n", __func__,
+			sport->tx_run, sport->rx_run);
+	if (sport->tx_run)
+		return -EBUSY;
+	if (sport->rx_run) {
+		BUG_ON(sport->dma_tx_desc == NULL);
+		BUG_ON(sport->curr_tx_desc != sport->dummy_tx_desc);
+		/* Hook the normal buffer descriptor */
+		local_irq_save(flags);
+		while ((get_dma_curr_desc_ptr(sport->dma_tx_chan) - \
+			sizeof(struct dmasg)) != \
+			(unsigned long)sport->dummy_tx_desc) {}
+		sport->dummy_tx_desc->next_desc_addr = \
+				(unsigned long)(sport->dma_tx_desc);
+		local_irq_restore(flags);
+		sport->curr_tx_desc = sport->dma_tx_desc;
+	} else {
+
+		sport_tx_dma_start(sport, 0);
+		/* Let rx dma run the dummy buffer */
+		sport_rx_dma_start(sport, 1);
+		sport_start(sport);
+	}
+	sport->tx_run = 1;
+	return 0;
+}
+EXPORT_SYMBOL(sport_tx_start);
+
+int sport_tx_stop(struct sport_device *sport)
+{
+	if (!sport->tx_run)
+		return 0;
+	if (sport->rx_run) {
+		/* RX is still running, hook the dummy buffer */
+		sport_hook_tx_dummy(sport);
+	} else {
+		/* Both rx and tx dma stopped */
+		sport_stop(sport);
+		sport->curr_rx_desc = NULL;
+		sport->curr_tx_desc = NULL;
+	}
+
+	sport->tx_run = 0;
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_tx_stop);
+
+static inline int compute_wdsize(size_t wdsize)
+{
+	switch (wdsize) {
+	case 1:
+		return WDSIZE_8;
+	case 2:
+		return WDSIZE_16;
+	case 4:
+	default:
+		return WDSIZE_32;
+	}
+}
+
+int sport_config_rx_dma(struct sport_device *sport, void *buf,
+		int fragcount, size_t fragsize)
+{
+	unsigned int x_count;
+	unsigned int y_count;
+	unsigned int cfg;
+	dma_addr_t addr;
+
+	pr_debug("%s buf:%p, frag:%d, fragsize:0x%lx\n", __func__, \
+			buf, fragcount, fragsize);
+
+	x_count = fragsize / sport->wdsize;
+	y_count = 0;
+
+	/* for fragments larger than 64k words we use 2d dma,
+	 * denote fragecount as two numbers' mutliply and both of them
+	 * are less than 64k.*/
+	if (x_count >= 0x10000) {
+		int i, count = x_count;
+
+		for (i = 16; i > 0; i--) {
+			x_count = 1 << i;
+			if ((count & (x_count - 1)) == 0) {
+				y_count = count >> i;
+				if (y_count < 0x10000)
+					break;
+			}
+		}
+		if (i == 0)
+			return -EINVAL;
+	}
+	pr_debug("%s(x_count:0x%x, y_count:0x%x)\n", __func__,
+			x_count, y_count);
+
+	if (sport->dma_rx_desc) {
+		dma_free_coherent(NULL, sport->rx_desc_bytes, sport->dma_rx_desc, 0);
+	}
+
+	/* Allocate a new descritor ring as current one. */
+	sport->dma_rx_desc = dma_alloc_coherent(NULL, \
+			fragcount * sizeof(struct dmasg),	&addr, 0);
+	sport->rx_desc_bytes = fragcount * sizeof(struct dmasg);
+
+	if (!sport->dma_rx_desc) {
+		printk(KERN_ERR "Failed to allocate memory for rx desc\n");
+		return -ENOMEM;
+	}
+
+	sport->rx_buf = buf;
+	sport->rx_fragsize = fragsize;
+	sport->rx_frags = fragcount;
+
+	cfg     = 0x7000 | DI_EN | compute_wdsize(sport->wdsize) | WNR | \
+		  (DESC_ELEMENT_COUNT << 8); /* large descriptor mode */
+
+	if (y_count != 0)
+		cfg |= DMA2D;
+
+	setup_desc(sport->dma_rx_desc, buf, fragcount, fragsize,
+			cfg|DMAEN, x_count, y_count, sport->wdsize);
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_config_rx_dma);
+
+int sport_config_tx_dma(struct sport_device *sport, void *buf, \
+		int fragcount, size_t fragsize)
+{
+	unsigned int x_count;
+	unsigned int y_count;
+	unsigned int cfg;
+	dma_addr_t addr;
+
+	pr_debug("%s buf:%p, fragcount:%d, fragsize:0x%lx\n",
+			__func__, buf, fragcount, fragsize);
+
+	x_count = fragsize/sport->wdsize;
+	y_count = 0;
+
+	/* for fragments larger than 64k words we use 2d dma,
+	 * denote fragecount as two numbers' mutliply and both of them
+	 * are less than 64k.*/
+	if (x_count >= 0x10000) {
+		int i, count = x_count;
+
+		for (i = 16; i > 0; i--) {
+			x_count = 1 << i;
+			if ((count & (x_count - 1)) == 0) {
+				y_count = count >> i;
+				if (y_count < 0x10000)
+					break;
+			}
+		}
+		if (i == 0)
+			return -EINVAL;
+	}
+	pr_debug("%s x_count:0x%x, y_count:0x%x\n", __func__,
+			x_count, y_count);
+
+
+	if (sport->dma_tx_desc) {
+		dma_free_coherent(NULL, sport->tx_desc_bytes, \
+				sport->dma_tx_desc, 0);
+	}
+
+	sport->dma_tx_desc = dma_alloc_coherent(NULL, \
+			fragcount * sizeof(struct dmasg), &addr, 0);
+	sport->tx_desc_bytes = fragcount * sizeof(struct dmasg);
+	if (!sport->dma_tx_desc) {
+		printk(KERN_ERR "Failed to allocate memory for tx desc\n");
+		return -ENOMEM;
+	}
+
+	sport->tx_buf = buf;
+	sport->tx_fragsize = fragsize;
+	sport->tx_frags = fragcount;
+	cfg     = 0x7000 | DI_EN | compute_wdsize(sport->wdsize) | \
+		  (DESC_ELEMENT_COUNT << 8); /* large descriptor mode */
+
+	if (y_count != 0)
+		cfg |= DMA2D;
+
+	setup_desc(sport->dma_tx_desc, buf, fragcount, fragsize,
+			cfg|DMAEN, x_count, y_count, sport->wdsize);
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_config_tx_dma);
+
+/* setup dummy dma descriptor ring, which don't generate interrupts,
+ * the x_modify is set to 0 */
+static int sport_config_rx_dummy(struct sport_device *sport)
+{
+	struct dmasg *desc;
+	unsigned config;
+
+	pr_debug("%s entered\n", __func__);
+#if L1_DATA_A_LENGTH != 0
+	desc = (struct dmasg*)l1_data_sram_alloc(2 * sizeof(*desc));
+#else
+	{
+		dma_addr_t addr;
+		desc = dma_alloc_coherent(NULL, 2 * sizeof(*desc), &addr, 0);
+	}
+#endif
+	if (desc == NULL) {
+		printk(KERN_ERR "Failed to allocate memory for dummy rx desc\n");
+		return -ENOMEM;
+	}
+	memset(desc, 0, 2 * sizeof(*desc));
+	sport->dummy_rx_desc = desc;
+	desc->start_addr = (unsigned long)sport->dummy_buf;
+	config = DMAFLOW_LARGE | NDSIZE_9 | compute_wdsize(sport->wdsize) | WNR | DMAEN;
+	desc->cfg = config;
+	desc->x_count = sport->dummy_count/sport->wdsize;
+	desc->x_modify = sport->wdsize;
+	desc->y_count = 0;
+	desc->y_modify = 0;
+	memcpy(desc+1, desc, sizeof(*desc));
+	desc->next_desc_addr = (unsigned long)(desc+1);
+	desc[1].next_desc_addr = (unsigned long)desc;
+	return 0;
+}
+
+static int sport_config_tx_dummy(struct sport_device *sport)
+{
+	struct dmasg *desc;
+	unsigned int config;
+
+	pr_debug("%s entered\n", __func__);
+
+#if L1_DATA_A_LENGTH != 0
+	desc = (struct dmasg*)l1_data_sram_alloc(2 * sizeof(*desc));
+#else
+	{
+		dma_addr_t addr;
+		desc = dma_alloc_coherent(NULL, 2*sizeof(*desc), &addr, 0);
+	}
+#endif
+	if (!desc) {
+		printk(KERN_ERR "Failed to allocate memory for dummy tx desc\n");
+		return -ENOMEM;
+	}
+	memset(desc, 0, 2 * sizeof(*desc));
+	sport->dummy_tx_desc = desc;
+	desc->start_addr = (unsigned long)sport->dummy_buf + \
+		sport->dummy_count;
+	config = DMAFLOW_LARGE | NDSIZE_9 | compute_wdsize(sport->wdsize) | DMAEN;
+	desc->cfg = config;
+	desc->x_count = sport->dummy_count/sport->wdsize;
+	desc->x_modify = sport->wdsize;
+	desc->y_count = 0;
+	desc->y_modify = 0;
+	memcpy(desc+1, desc, sizeof(*desc));
+	desc->next_desc_addr = (unsigned long)(desc+1);
+	desc[1].next_desc_addr = (unsigned long)desc;
+	return 0;
+}
+
+unsigned long sport_curr_offset_rx(struct sport_device *sport)
+{
+	unsigned long curr = get_dma_curr_addr(sport->dma_rx_chan);
+
+	return ((unsigned char *)curr - sport->rx_buf);
+}
+EXPORT_SYMBOL(sport_curr_offset_rx);
+
+unsigned long sport_curr_offset_tx(struct sport_device *sport)
+{
+	unsigned long curr = get_dma_curr_addr(sport->dma_tx_chan);
+	return ((unsigned char *)curr - sport->tx_buf);
+}
+EXPORT_SYMBOL(sport_curr_offset_tx);
+
+void incfrag(struct sport_device *sport, int *frag, int tx)
+{
+	++(*frag);
+	if (tx == 1 && *frag == sport->tx_frags)
+		*frag = 0;
+
+	if (tx == 0 && *frag == sport->rx_frags)
+		*frag = 0;
+}
+EXPORT_SYMBOL(incfrag);
+
+void decfrag(struct sport_device *sport, int *frag, int tx)
+{
+	--(*frag);
+	if (tx == 1 && *frag == 0)
+		*frag = sport->tx_frags;
+
+	if (tx == 0 && *frag == 0)
+		*frag = sport->rx_frags;
+}
+EXPORT_SYMBOL(decfrag);
+
+static int sport_check_status(struct sport_device *sport,
+		unsigned int *sport_stat,
+		unsigned int *rx_stat,
+		unsigned int *tx_stat)
+{
+	int status = 0;
+
+	if (sport_stat) {
+		SSYNC();
+		status = sport->regs->stat;
+		if (status & (TOVF|TUVF|ROVF|RUVF))
+			sport->regs->stat = (status & (TOVF|TUVF|ROVF|RUVF));
+		SSYNC();
+		*sport_stat = status;
+	}
+
+	if (rx_stat) {
+		SSYNC();
+		status = get_dma_curr_irqstat(sport->dma_rx_chan);
+		if (status & (DMA_DONE|DMA_ERR))
+			clear_dma_irqstat(sport->dma_rx_chan);
+		SSYNC();
+		*rx_stat = status;
+	}
+
+	if (tx_stat) {
+		SSYNC();
+		status = get_dma_curr_irqstat(sport->dma_tx_chan);
+		if (status & (DMA_DONE|DMA_ERR))
+			clear_dma_irqstat(sport->dma_tx_chan);
+		SSYNC();
+		*tx_stat = status;
+	}
+
+	return 0;
+}
+
+int  sport_dump_stat(struct sport_device *sport, char *buf, size_t len)
+{
+	int ret;
+
+	ret = snprintf(buf, len,
+			"sts: 0x%04x\n"
+			"rx dma %d sts: 0x%04x tx dma %d sts: 0x%04x\n",
+			sport->regs->stat,
+			sport->dma_rx_chan,
+			get_dma_curr_irqstat(sport->dma_rx_chan),
+			sport->dma_tx_chan,
+			get_dma_curr_irqstat(sport->dma_tx_chan));
+	buf += ret;
+	len -= ret;
+
+	ret += snprintf(buf, len,
+			"curr_rx_desc:0x%p, curr_tx_desc:0x%p\n"
+			"dma_rx_desc:0x%p, dma_tx_desc:0x%p\n"
+			"dummy_rx_desc:0x%p, dummy_tx_desc:0x%p\n",
+			sport->curr_rx_desc, sport->curr_tx_desc,
+			sport->dma_rx_desc, sport->dma_tx_desc,
+			sport->dummy_rx_desc, sport->dummy_tx_desc);
+
+	return ret;
+}
+
+static irqreturn_t rx_handler(int irq, void *dev_id)
+{
+	unsigned int rx_stat;
+	struct sport_device *sport = dev_id;
+
+	pr_debug("%s enter\n", __func__);
+	sport_check_status(sport, NULL, &rx_stat, NULL);
+	if (!(rx_stat & DMA_DONE)) {
+		printk(KERN_ERR "rx dma is already stopped\n");
+	}
+	if (sport->rx_callback) {
+		sport->rx_callback(sport->rx_data);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static irqreturn_t tx_handler(int irq, void *dev_id)
+{
+	unsigned int tx_stat;
+	struct sport_device *sport = dev_id;
+	pr_debug("%s enter\n", __func__);
+	sport_check_status(sport, NULL, NULL, &tx_stat);
+	if (!(tx_stat & DMA_DONE)) {
+		printk(KERN_ERR "tx dma is already stopped\n");
+		return IRQ_HANDLED;
+	}
+	if (sport->tx_callback) {
+		sport->tx_callback(sport->tx_data);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static irqreturn_t err_handler(int irq, void *dev_id)
+{
+	unsigned int status = 0;
+	struct sport_device *sport = dev_id;
+
+	pr_debug("%s\n", __func__);
+	if (sport_check_status(sport, &status, NULL, NULL)) {
+		printk(KERN_ERR "error checking status ??");
+		return IRQ_NONE;
+	}
+
+	if (status & (TOVF|TUVF|ROVF|RUVF)) {
+		printk(KERN_INFO  "sport status error:%s%s%s%s\n",
+				status & TOVF ? " TOVF" : "",
+				status & TUVF ? " TUVF" : "",
+				status & ROVF ? " ROVF" : "",
+				status & RUVF ? " RUVF" : "");
+		if (status & TOVF || status & TUVF) {
+			disable_dma(sport->dma_tx_chan);
+			if (sport->tx_run)
+				sport_tx_dma_start(sport, 0);
+			else
+				sport_tx_dma_start(sport, 1);
+			enable_dma(sport->dma_tx_chan);
+		} else {
+			disable_dma(sport->dma_rx_chan);
+			if (sport->rx_run)
+				sport_rx_dma_start(sport, 0);
+			else
+				sport_rx_dma_start(sport, 1);
+			enable_dma(sport->dma_rx_chan);
+		}
+	}
+	status = sport->regs->stat;
+	if (status & (TOVF|TUVF|ROVF|RUVF))
+		sport->regs->stat = (status & (TOVF|TUVF|ROVF|RUVF));
+	SSYNC();
+
+	if (sport->err_callback)
+		sport->err_callback(sport->err_data);
+
+	return IRQ_HANDLED;
+}
+
+int sport_set_rx_callback(struct sport_device *sport,
+		       void (*rx_callback)(void *), void *rx_data)
+{
+	BUG_ON(rx_callback == NULL);
+	sport->rx_callback = rx_callback;
+	sport->rx_data = rx_data;
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_set_rx_callback);
+
+int sport_set_tx_callback(struct sport_device *sport,
+		void (*tx_callback)(void *), void *tx_data)
+{
+	BUG_ON(tx_callback == NULL);
+	sport->tx_callback = tx_callback;
+	sport->tx_data = tx_data;
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_set_tx_callback);
+
+int sport_set_err_callback(struct sport_device *sport,
+		void (*err_callback)(void *), void *err_data)
+{
+	BUG_ON(err_callback == NULL);
+	sport->err_callback = err_callback;
+	sport->err_data = err_data;
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_set_err_callback);
+
+struct sport_device *sport_init(struct sport_param *param, unsigned wdsize,
+		unsigned dummy_count, void *private_data)
+{
+	int ret;
+	struct sport_device *sport;
+	pr_debug("%s enter\n", __func__);
+	BUG_ON(param == NULL);
+	BUG_ON(wdsize == 0 || dummy_count == 0);
+	sport = kmalloc(sizeof(struct sport_device), GFP_KERNEL);
+	if (!sport) {
+		printk(KERN_ERR "Failed to allocate for sport device\n");
+		return NULL;
+	}
+
+	memset(sport, 0, sizeof(struct sport_device));
+	sport->dma_rx_chan = param->dma_rx_chan;
+	sport->dma_tx_chan = param->dma_tx_chan;
+	sport->err_irq = param->err_irq;
+	sport->regs = param->regs;
+	sport->private_data = private_data;
+
+	if (request_dma(sport->dma_rx_chan, "SPORT RX Data") == -EBUSY) {
+		printk(KERN_ERR "Failed to request RX dma %d\n", \
+				sport->dma_rx_chan);
+		goto __init_err1;
+	}
+	if (set_dma_callback(sport->dma_rx_chan, rx_handler, sport) != 0) {
+		printk(KERN_ERR "Failed to request RX irq %d\n", \
+				sport->dma_rx_chan);
+		goto __init_err2;
+	}
+
+	if (request_dma(sport->dma_tx_chan, "SPORT TX Data") == -EBUSY) {
+		printk(KERN_ERR "Failed to request TX dma %d\n", \
+				sport->dma_tx_chan);
+		goto __init_err2;
+	}
+
+	if (set_dma_callback(sport->dma_tx_chan, tx_handler, sport) != 0) {
+		printk(KERN_ERR "Failed to request TX irq %d\n", \
+				sport->dma_tx_chan);
+		goto __init_err3;
+	}
+
+	if (request_irq(sport->err_irq, err_handler, IRQF_SHARED, "SPORT err",
+			sport) < 0) {
+		printk(KERN_ERR "Failed to request err irq:%d\n", \
+				sport->err_irq);
+		goto __init_err3;
+	}
+
+	printk(KERN_ERR "dma rx:%d tx:%d, err irq:%d, regs:%p\n",
+			sport->dma_rx_chan, sport->dma_tx_chan,
+			sport->err_irq, sport->regs);
+
+	sport->wdsize = wdsize;
+	sport->dummy_count = dummy_count;
+
+#if L1_DATA_A_LENGTH != 0
+	sport->dummy_buf = l1_data_sram_alloc(dummy_count * 2);
+#else
+	sport->dummy_buf = kmalloc(dummy_count * 2, GFP_KERNEL);
+#endif
+	if (sport->dummy_buf == NULL) {
+		printk(KERN_ERR "Failed to allocate dummy buffer\n");
+		goto __error;
+	}
+
+	memset(sport->dummy_buf, 0, dummy_count * 2);
+	ret = sport_config_rx_dummy(sport);
+	if (ret) {
+		printk(KERN_ERR "Failed to config rx dummy ring\n");
+		goto __error;
+	}
+	ret = sport_config_tx_dummy(sport);
+	if (ret) {
+		printk(KERN_ERR "Failed to config tx dummy ring\n");
+		goto __error;
+	}
+
+	return sport;
+__error:
+	free_irq(sport->err_irq, sport);
+__init_err3:
+	free_dma(sport->dma_tx_chan);
+__init_err2:
+	free_dma(sport->dma_rx_chan);
+__init_err1:
+	kfree(sport);
+	return NULL;
+}
+EXPORT_SYMBOL(sport_init);
+
+void sport_done(struct sport_device *sport)
+{
+	if (sport == NULL)
+		return;
+
+	sport_stop(sport);
+	if (sport->dma_rx_desc)
+		dma_free_coherent(NULL, sport->rx_desc_bytes, sport->dma_rx_desc, 0);
+	if (sport->dma_tx_desc)
+		dma_free_coherent(NULL, sport->tx_desc_bytes, sport->dma_tx_desc, 0);
+
+#if L1_DATA_A_LENGTH != 0
+	l1_data_sram_free(sport->dummy_rx_desc);
+	l1_data_sram_free(sport->dummy_tx_desc);
+	l1_data_sram_free(sport->dummy_buf);
+#else
+	dma_free_coherent(NULL, 2*sizeof(struct dmasg), sport->dummy_rx_desc, 0);
+	dma_free_coherent(NULL, 2*sizeof(struct dmasg), sport->dummy_tx_desc, 0);
+	kfree(sport->dummy_buf);
+#endif
+	free_dma(sport->dma_rx_chan);
+	free_dma(sport->dma_tx_chan);
+	free_irq(sport->err_irq, sport);
+
+	kfree(sport);
+		sport = NULL;
+}
+EXPORT_SYMBOL(sport_done);
+/*
+* It is only used to send several bytes when dma is not enabled
+ * sport controller is configured but not enabled.
+ * Multichannel cannot works with pio mode */
+/* Used by ac97 to write and read codec register */
+int sport_send_and_recv(struct sport_device *sport, u8 *out_data, \
+		u8 *in_data, int len)
+{
+	unsigned short dma_config;
+	unsigned short status;
+	unsigned long flags;
+	unsigned long wait = 0;
+
+	pr_debug("%s enter, out_data:%p, in_data:%p len:%d\n", \
+			__func__, out_data, in_data, len);
+	pr_debug("tcr1:0x%04x, tcr2:0x%04x, tclkdiv:0x%04x, tfsdiv:0x%04x\n"
+			"mcmc1:0x%04x, mcmc2:0x%04x\n",
+			sport->regs->tcr1, sport->regs->tcr2,
+			sport->regs->tclkdiv, sport->regs->tfsdiv,
+			sport->regs->mcmc1, sport->regs->mcmc2);
+	flush_dcache_range((unsigned)out_data, (unsigned)(out_data + len));
+
+	/* Enable tx dma */
+	dma_config = (RESTART | WDSIZE_16 | DI_EN);
+	set_dma_start_addr(sport->dma_tx_chan, (unsigned long)out_data);
+	set_dma_x_count(sport->dma_tx_chan, len/2);
+	set_dma_x_modify(sport->dma_tx_chan, 2);
+	set_dma_config(sport->dma_tx_chan, dma_config);
+	enable_dma(sport->dma_tx_chan);
+
+	if (in_data != NULL) {
+		invalidate_dcache_range((unsigned)in_data, \
+				(unsigned)(in_data + len));
+		/* Enable rx dma */
+		dma_config = (RESTART | WDSIZE_16 | WNR | DI_EN);
+		set_dma_start_addr(sport->dma_rx_chan, (unsigned long)in_data);
+		set_dma_x_count(sport->dma_rx_chan, len/2);
+		set_dma_x_modify(sport->dma_rx_chan, 2);
+		set_dma_config(sport->dma_rx_chan, dma_config);
+		enable_dma(sport->dma_rx_chan);
+	}
+
+	local_irq_save(flags);
+	sport->regs->tcr1 |= TSPEN;
+	sport->regs->rcr1 |= RSPEN;
+	SSYNC();
+
+	status = get_dma_curr_irqstat(sport->dma_tx_chan);
+	while (status & DMA_RUN) {
+		udelay(1);
+		status = get_dma_curr_irqstat(sport->dma_tx_chan);
+		pr_debug("DMA status:0x%04x\n", status);
+		if (wait++ > 100)
+			goto __over;
+	}
+	status = sport->regs->stat;
+	wait = 0;
+
+	while (!(status & TXHRE)) {
+		pr_debug("sport status:0x%04x\n", status);
+		udelay(1);
+		status = *(volatile unsigned short*)&sport->regs->stat;
+		if (wait++ > 1000)
+			goto __over;
+	}
+	/* Wait for the last byte sent out */
+	udelay(20);
+	pr_debug("sport status:0x%04x\n", status);
+
+__over:
+	sport->regs->tcr1 &= ~TSPEN;
+	sport->regs->rcr1 &= ~RSPEN;
+	SSYNC();
+	disable_dma(sport->dma_tx_chan);
+	/* Clear the status */
+	clear_dma_irqstat(sport->dma_tx_chan);
+	if (in_data != NULL) {
+		disable_dma(sport->dma_rx_chan);
+		clear_dma_irqstat(sport->dma_rx_chan);
+	}
+	SSYNC();
+	local_irq_restore(flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(sport_send_and_recv);
+
+MODULE_AUTHOR("Roy Huang");
+MODULE_DESCRIPTION("SPORT driver for ADI Blackfin");
+MODULE_LICENSE("GPL");
+
diff --git a/sound/soc/blackfin/bf5xx-sport.h b/sound/soc/blackfin/bf5xx-sport.h
new file mode 100644
index 0000000..9ad749f
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-sport.h
@@ -0,0 +1,192 @@
+/*
+ * File:         bf5xx_ac97_sport.h
+ * Based on:
+ * Author:       Roy Huang <roy.huang@analog.com>
+ *
+ * Created:
+ * Description:
+ *
+ *               Copyright 2004-2007 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#ifndef __BF5XX_SPORT_H__
+#define __BF5XX_SPORT_H__
+
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <asm/dma.h>
+
+struct sport_register {
+	u16 tcr1;	u16 reserved0;
+	u16 tcr2;	u16 reserved1;
+	u16 tclkdiv;	u16 reserved2;
+	u16 tfsdiv;	u16 reserved3;
+	u32 tx;
+	u32 reserved_l0;
+	u32 rx;
+	u32 reserved_l1;
+	u16 rcr1;	u16 reserved4;
+	u16 rcr2;	u16 reserved5;
+	u16 rclkdiv;	u16 reserved6;
+	u16 rfsdiv;	u16 reserved7;
+	u16 stat;	u16 reserved8;
+	u16 chnl;	u16 reserved9;
+	u16 mcmc1;	u16 reserved10;
+	u16 mcmc2;	u16 reserved11;
+	u32 mtcs0;
+	u32 mtcs1;
+	u32 mtcs2;
+	u32 mtcs3;
+	u32 mrcs0;
+	u32 mrcs1;
+	u32 mrcs2;
+	u32 mrcs3;
+};
+
+#define DESC_ELEMENT_COUNT 9
+
+struct sport_device {
+	int dma_rx_chan;
+	int dma_tx_chan;
+	int err_irq;
+	struct sport_register *regs;
+
+	unsigned char *rx_buf;
+	unsigned char *tx_buf;
+	unsigned int rx_fragsize;
+	unsigned int tx_fragsize;
+	unsigned int rx_frags;
+	unsigned int tx_frags;
+	unsigned int wdsize;
+
+	/* for dummy dma transfer */
+	void *dummy_buf;
+	unsigned int dummy_count;
+
+	/* DMA descriptor ring head of current audio stream*/
+	struct dmasg *dma_rx_desc;
+	struct dmasg *dma_tx_desc;
+	unsigned int rx_desc_bytes;
+	unsigned int tx_desc_bytes;
+
+	unsigned int rx_run:1; /* rx is running */
+	unsigned int tx_run:1; /* tx is running */
+
+	struct dmasg *dummy_rx_desc;
+	struct dmasg *dummy_tx_desc;
+
+	struct dmasg *curr_rx_desc;
+	struct dmasg *curr_tx_desc;
+
+	int rx_curr_frag;
+	int tx_curr_frag;
+
+	unsigned int rcr1;
+	unsigned int rcr2;
+	int rx_tdm_count;
+
+	unsigned int tcr1;
+	unsigned int tcr2;
+	int tx_tdm_count;
+
+	void (*rx_callback)(void *data);
+	void *rx_data;
+	void (*tx_callback)(void *data);
+	void *tx_data;
+	void (*err_callback)(void *data);
+	void *err_data;
+	unsigned char *tx_dma_buf;
+	unsigned char *rx_dma_buf;
+#ifdef CONFIG_SND_MMAP_SUPPORT
+	dma_addr_t tx_dma_phy;
+	dma_addr_t rx_dma_phy;
+	int tx_pos;/*pcm sample count*/
+	int rx_pos;
+	unsigned int tx_buffer_size;
+	unsigned int rx_buffer_size;
+#endif
+	void *private_data;
+};
+
+extern struct sport_device *sport_handle;
+
+struct sport_param {
+	int dma_rx_chan;
+	int dma_tx_chan;
+	int err_irq;
+	struct sport_register *regs;
+};
+
+struct sport_device *sport_init(struct sport_param *param, unsigned wdsize,
+		unsigned dummy_count, void *private_data);
+
+void sport_done(struct sport_device *sport);
+
+/* first use these ...*/
+
+/* note: multichannel is in units of 8 channels, tdm_count is number of channels
+ *  NOT / 8 ! all channels are enabled by default */
+int sport_set_multichannel(struct sport_device *sport, int tdm_count,
+		u32 mask, int packed);
+
+int sport_config_rx(struct sport_device *sport,
+		unsigned int rcr1, unsigned int rcr2,
+		unsigned int clkdiv, unsigned int fsdiv);
+
+int sport_config_tx(struct sport_device *sport,
+		unsigned int tcr1, unsigned int tcr2,
+		unsigned int clkdiv, unsigned int fsdiv);
+
+/* ... then these: */
+
+/* buffer size (in bytes) == fragcount * fragsize_bytes */
+
+/* this is not a very general api, it sets the dma to 2d autobuffer mode */
+
+int sport_config_rx_dma(struct sport_device *sport, void *buf,
+		int fragcount, size_t fragsize_bytes);
+
+int sport_config_tx_dma(struct sport_device *sport, void *buf,
+		int fragcount, size_t fragsize_bytes);
+
+int sport_tx_start(struct sport_device *sport);
+int sport_tx_stop(struct sport_device *sport);
+int sport_rx_start(struct sport_device *sport);
+int sport_rx_stop(struct sport_device *sport);
+
+/* for use in interrupt handler */
+unsigned long sport_curr_offset_rx(struct sport_device *sport);
+unsigned long sport_curr_offset_tx(struct sport_device *sport);
+
+void incfrag(struct sport_device *sport, int *frag, int tx);
+void decfrag(struct sport_device *sport, int *frag, int tx);
+
+int sport_set_rx_callback(struct sport_device *sport,
+		       void (*rx_callback)(void *), void *rx_data);
+int sport_set_tx_callback(struct sport_device *sport,
+		       void (*tx_callback)(void *), void *tx_data);
+int sport_set_err_callback(struct sport_device *sport,
+		       void (*err_callback)(void *), void *err_data);
+
+int sport_send_and_recv(struct sport_device *sport, u8 *out_data, \
+		u8 *in_data, int len);
+#endif /* BF53X_SPORT_H */
diff --git a/sound/soc/blackfin/bf5xx-ssm2602.c b/sound/soc/blackfin/bf5xx-ssm2602.c
new file mode 100644
index 0000000..41e161f
--- /dev/null
+++ b/sound/soc/blackfin/bf5xx-ssm2602.c
@@ -0,0 +1,195 @@
+/*
+ * File:         sound/soc/blackfin/bf5xx-ssm2602.c
+ * Author:       Cliff Cai <Cliff.Cai@analog.com>
+ *
+ * Created:      Tue June 06 2008
+ * Description:  Driver for SSM2602 sound chip built in ADSP-BF52xC
+ *
+ * Rev:          $Id: bf5xx-ssm2602.c 4104 2008-06-06 06:51:48Z cliff $
+ *
+ * Modified:
+ *               Copyright 2008 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+
+#include <sound/driver.h>
+#include <sound/core.h>
+#include <sound/pcm.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/pcm_params.h>
+
+#include <asm/dma.h>
+#include <asm/gpio.h>
+#include <asm/portmux.h>
+#include "../codecs/ssm2602.h"
+#include "bf5xx-sport.h"
+#include "bf5xx-i2s-pcm.h"
+#include "bf5xx-i2s.h"
+
+static struct snd_soc_machine bf5xx_ssm2602;
+
+static int bf5xx_ssm2602_startup(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_cpu_dai *cpu_dai = rtd->dai->cpu_dai;
+
+	pr_debug("%s enter\n", __func__);
+	cpu_dai->private_data = sport_handle;
+	return 0;
+}
+
+static int bf5xx_ssm2602_hw_params(struct snd_pcm_substream *substream,
+	struct snd_pcm_hw_params *params)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_codec_dai *codec_dai = rtd->dai->codec_dai;
+	unsigned int clk = 0;
+	int ret = 0;
+
+	pr_debug("%s rate %d format %x\n", __func__, params_rate(params),
+		params_format(params));
+	/*
+	 * WARNING - TODO
+	 *
+	 * This code assumes there is a variable clocksource for the SSM2602.
+	 * i.e. it supplies MCLK depending on rate.
+	 *
+	 * If you are using a crystal source then modify the below case
+	 * statement with a static frequency.
+	 *
+	 * If you are using the SPORT to generate clocking then this is
+	 * where to do it.
+	 */
+
+	switch (params_rate(params)) {
+	case 8000:
+	case 16000:
+	case 48000:
+	case 96000:
+	case 11025:
+	case 22050:
+	case 44100:
+		clk = 12000000;
+		break;
+	}
+
+	/*
+	 * CODEC is master for BCLK and LRC in this configuration.
+	 */
+
+	/* set codec DAI configuration */
+	ret = codec_dai->dai_ops.set_fmt(codec_dai, SND_SOC_DAIFMT_I2S |
+		SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_CBM_CFM);
+	if (ret < 0)
+		return ret;
+
+	ret = codec_dai->dai_ops.set_sysclk(codec_dai, SSM2602_SYSCLK, clk,
+		SND_SOC_CLOCK_IN);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static struct snd_soc_ops bf5xx_ssm2602_ops = {
+	.startup = bf5xx_ssm2602_startup,
+	.hw_params = bf5xx_ssm2602_hw_params,
+};
+
+static int bf5xx_ssm2602_init_dev(struct snd_soc_codec *codec)
+{
+	pr_debug("%s enter\n", __func__);
+
+	snd_soc_dapm_sync_endpoints(codec);
+	return 0;
+}
+
+static struct snd_soc_dai_link bf5xx_ssm2602_dai = {
+	.name = "ssm2602",
+	.stream_name = "SSM2602",
+	.cpu_dai = &bf5xx_i2s_dai,
+	.codec_dai = &ssm2602_dai,
+	.init = bf5xx_ssm2602_init_dev,
+	.ops = &bf5xx_ssm2602_ops,
+};
+
+/*
+ * SSM2602 2 wire address is determined by CSB
+ * state during powerup.
+ *    low  = 0x1a
+ *    high = 0x1b
+ */
+
+static struct ssm2602_setup_data bf5xx_ssm2602_setup = {
+	.i2c_address = 0x1b,
+};
+
+static struct snd_soc_machine bf5xx_ssm2602 = {
+	.name = "bf5xx_ssm2602",
+	.dai_link = &bf5xx_ssm2602_dai,
+	.num_links = 1,
+};
+
+static struct snd_soc_device bf5xx_ssm2602_snd_devdata = {
+	.machine = &bf5xx_ssm2602,
+	.platform = &bf5xx_i2s_soc_platform,
+	.codec_dev = &soc_codec_dev_ssm2602,
+	.codec_data = &bf5xx_ssm2602_setup,
+};
+
+static struct platform_device *bf52x_ssm2602_snd_device;
+
+static int __init bf5xx_ssm2602_init(void)
+{
+	int ret;
+
+	pr_debug("%s enter\n", __func__);
+	bf52x_ssm2602_snd_device = platform_device_alloc("soc-audio", -1);
+	if (!bf52x_ssm2602_snd_device)
+		return -ENOMEM;
+
+	platform_set_drvdata(bf52x_ssm2602_snd_device, &bf5xx_ssm2602_snd_devdata);
+	bf5xx_ssm2602_snd_devdata.dev = &bf52x_ssm2602_snd_device->dev;
+	ret = platform_device_add(bf52x_ssm2602_snd_device);
+
+	if (ret)
+		platform_device_put(bf52x_ssm2602_snd_device);
+
+	return ret;
+}
+
+static void __exit bf5xx_ssm2602_exit(void)
+{
+	pr_debug("%s enter\n", __func__);
+	platform_device_unregister(bf52x_ssm2602_snd_device);
+}
+
+module_init(bf5xx_ssm2602_init);
+module_exit(bf5xx_ssm2602_exit);
+
+/* Module information */
+MODULE_AUTHOR("Cliff Cai");
+MODULE_DESCRIPTION("ALSA SoC SSM2602 BF527-EZKIT");
+MODULE_LICENSE("GPL");
+
-- 
1.5.6
