Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZIKAaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZIKAaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZIKAa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:30:29 -0400
Received: from kroah.org ([198.145.64.141]:38108 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306AbZIKA3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:29:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:11 2009
Message-Id: <20090911002411.613796207@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:23:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 17/22] sound: oxygen: fix MCLK rate for 192 kHz playback
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=sound-oxygen-fix-mclk-rate-for-192-khz-playback.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Clemens Ladisch <clemens@ladisch.de>

commit b91ab72b830e1494c2c7f8de05ccb2ab2c9cfb26 upstream.

Do not forget to program the MCLK ratio for the I2S output.
Otherwise, the master clock frequency can be too high for
the DACs at sample frequencies above 96 kHz.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/oxygen/oxygen_pcm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/oxygen/oxygen_pcm.c
+++ b/sound/pci/oxygen/oxygen_pcm.c
@@ -469,9 +469,11 @@ static int oxygen_multich_hw_params(stru
 	oxygen_write16_masked(chip, OXYGEN_I2S_MULTICH_FORMAT,
 			      oxygen_rate(hw_params) |
 			      chip->model.dac_i2s_format |
+			      oxygen_i2s_mclk(hw_params) |
 			      oxygen_i2s_bits(hw_params),
 			      OXYGEN_I2S_RATE_MASK |
 			      OXYGEN_I2S_FORMAT_MASK |
+			      OXYGEN_I2S_MCLK_MASK |
 			      OXYGEN_I2S_BITS_MASK);
 	oxygen_update_dac_routing(chip);
 	oxygen_update_spdif_source(chip);


