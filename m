Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXICKZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXICKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXICKZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:25:20 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:36969 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbXICKZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=fdTjbrYL6c/PyeLescZqOxiTwxe89la8OVxUlc1B+9MzMeyDRPUhHqR3nNykNWDUlOvek22q33FXJLz1SwqBZ2itIkqS17Shk3DQB6182zlNv0K6qhox8Iw4ZOHOFQ3z4A/tntydAY4UBQosHZgf/20GooKr/ZqRj1uGHfTKQNI=
Message-ID: <2ff216280709030325r626d98b3h2c5a48e90470610b@mail.gmail.com>
Date: Mon, 3 Sep 2007 15:55:18 +0530
From: "Abhijit Bhopatkar" <bain@devslashzero.com>
To: "Takashi Iwai" <tiwai@suse.de>, "Ivan N. Zlatev" <contact@i-nz.net>,
       "Jaroslav Kysela" <perex@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH] [ALSA] Added new pin config for first gen macbook.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 5e78b60c82831144
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit 5d5d3bc3eddf2ad97b2cb090b92580e7fed6cee1 changed all
pin configs for intel macs, but it breaks sound on
Macbook first generation.

Readded a known working pin config for first gen macbooks.

Signed-off-by: Abhijit Bhopatkar <bainonline@gmail.com>
---
 sound/pci/hda/patch_sigmatel.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 3f25de7..a2b0422 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -585,6 +585,12 @@ static unsigned int intel_mac_v5_pin_configs[10] = {
        0x400000fc, 0x400000fb,
 };

+static unsigned int intel_macbook_first_gen_pin_configs[10] = {
+       0x0321e230, 0x03a1e020, 0x9017e110, 0x01014010,
+       0x01a19021, 0x0381e021, 0x1345e240, 0x13c5e22e,
+       0x02a19320, 0x400000fb,
+};
+
 static unsigned int stac922x_dell_pin_configs[10] = {
        0x0221121e, 0x408103ff, 0x02a1123e, 0x90100310,
        0x408003f1, 0x0221122f, 0x03451340, 0x40c003f2,
@@ -603,7 +609,7 @@ static unsigned int *stac922x_brd_tbl[STAC_922X_MODELS] = {
        [STAC_INTEL_MAC_V5] = intel_mac_v5_pin_configs,
        /* for backward compitability */
        [STAC_MACMINI] = intel_mac_v3_pin_configs,
-       [STAC_MACBOOK] = intel_mac_v5_pin_configs,
+       [STAC_MACBOOK] = intel_macbook_first_gen_pin_configs,
        [STAC_MACBOOK_PRO_V1] = intel_mac_v3_pin_configs,
        [STAC_MACBOOK_PRO_V2] = intel_mac_v3_pin_configs,
        [STAC_IMAC_INTEL] = intel_mac_v2_pin_configs,
@@ -2132,6 +2138,8 @@ static int patch_stac922x(struct hda_codec *codec)
                        spec->board_config = STAC_INTEL_MAC_V4;
                        break;
                case 0x106b0a00:
+                       spec->board_config = STAC_MACBOOK;
+                       break;
                case 0x106b2200:
                        spec->board_config = STAC_INTEL_MAC_V5;
                        break;
-- 
1.5.2.4
