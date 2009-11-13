Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZKMCTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZKMCTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 21:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZKMCTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 21:19:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51149 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbZKMCTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 21:19:45 -0500
Date: Fri, 13 Nov 2009 13:19:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       vikram pandita <vikram.pandita@ti.com>
Subject: linux-next: manual merge of the sound tree with the omap tree
Message-Id: <20091113131947.03d1b259.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
arch/arm/mach-omap2/board-zoom2.c between commit
3541a57ebeb4c817e6e25bb0c2a2c174d6edb7c4 ("omap: zoom2: split board file
for software reuse") from the omap tree and commits
f8d9aad96d0d7b57d0bf2e4de21fdda3a42f4449 ("OMAP: Platform support for
twl4030_codec MFD") and 953e2f3d272db9db6671ad4f4244820557a71cf7 ("OMAP:
Configure audio_mclk for twl4030-codec MFD") from the sound tree.

The former moved the code that the latter modifies into another file.  I
have added the following merge fixup patch and can carry it as necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 13 Nov 2009 13:17:56 +1100
Subject: [PATCH] sound: merger fixup for omap board-zoom2 updates

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 54619d5..f570949 100755
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -217,6 +217,15 @@ static struct twl4030_madc_platform_data zoom_madc_data = {
 	.irq_line	= 1,
 };
 
+static struct twl4030_codec_audio_data zoom2_audio_data = {
+	.audio_mclk = 26000000,
+};
+
+static struct twl4030_codec_data zoom2_codec_data = {
+	.audio_mclk = 26000000,
+	.audio = &zoom2_audio_data,
+};
+
 static struct twl4030_platform_data zoom_twldata = {
 	.irq_base	= TWL4030_IRQ_BASE,
 	.irq_end	= TWL4030_IRQ_END,
@@ -227,6 +236,7 @@ static struct twl4030_platform_data zoom_twldata = {
 	.usb		= &zoom_usb_data,
 	.gpio		= &zoom_gpio_data,
 	.keypad		= &zoom_kp_twl4030_data,
+	.codec		= &zoom2_codec_data,
 	.vmmc1          = &zoom_vmmc1,
 	.vmmc2          = &zoom_vmmc2,
 	.vsim           = &zoom_vsim,
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
