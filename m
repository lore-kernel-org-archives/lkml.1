Return-Path: <linux-kernel-owner+w=401wt.eu-S932291Ab0ANW3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0ANW3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762Ab0ANW2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:52 -0500
Received: from kroah.org ([198.145.64.141]:60611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618Ab0ANW2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 32/52] ASoC: Fix WM8350 DSP mode B configuration
Date: Thu, 14 Jan 2010 14:27:11 -0800
Message-Id: <1263508051-7868-32-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-31-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 5ee518ecbcb5934e284ea51a19a939c891f5f7ea upstream.

We need to set the LRCLK inversion bit to select DSP mode.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/soc/codecs/wm8350.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8350.c b/sound/soc/codecs/wm8350.c
index 593d5b9..2089fe7 100644
--- a/sound/soc/codecs/wm8350.c
+++ b/sound/soc/codecs/wm8350.c
@@ -925,7 +925,7 @@ static int wm8350_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 		iface |= 0x3 << 8;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
-		iface |= 0x3 << 8;	/* lg not sure which mode */
+		iface |= 0x3 << 8 | WM8350_AIF_LRCLK_INV;
 		break;
 	default:
 		return -EINVAL;
-- 
1.6.6

