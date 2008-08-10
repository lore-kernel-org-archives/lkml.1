Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYHJWJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYHJWJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 18:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYHJWJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 18:09:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:13481 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbYHJWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=YHc9QRamULiBd19vf9rxLnRwKElTNSLuEA1C7gPlF1+DiCidZHwIyO+xsSUdtkK/KD
         AezBQKFiQ3djV/lcloCNF0CWrmLU6bHAUYr9ivxRQunVqLXi2et8C8G2X/H9fb3sEfJV
         4/th0bMCwvGlK+GZNqDBO4FGdPEptW0cdtRuY=
Date: Mon, 11 Aug 2008 02:09:04 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ice1724/revo: simple clean up
Message-ID: <20080810220904.GD5093@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>

ice1724/revo: simple clean up


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 sound/pci/ice1712/revo.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/pci/ice1712/revo.c b/sound/pci/ice1712/revo.c
index 4d26314..5e1b156 100644
--- a/sound/pci/ice1712/revo.c
+++ b/sound/pci/ice1712/revo.c
@@ -524,16 +524,20 @@ static int __devinit revo_init(struct snd_ice1712 *ice)
 	ak = ice->akm = kcalloc(2, sizeof(struct snd_akm4xxx), GFP_KERNEL);
 	if (! ak)
 		return -ENOMEM;
-	ice->akm_codecs = 2;
 	switch (ice->eeprom.subvendor) {
 	case VT1724_SUBDEVICE_REVOLUTION71:
 		ice->akm_codecs = 2;
-		if ((err = snd_ice1712_akm4xxx_init(ak, &akm_revo_front, &akm_revo_front_priv, ice)) < 0)
+		err = snd_ice1712_akm4xxx_init(ak, &akm_revo_front,
+						&akm_revo_front_priv, ice);
+		if (err < 0)
 			return err;
-		if ((err = snd_ice1712_akm4xxx_init(ak + 1, &akm_revo_surround, &akm_revo_surround_priv, ice)) < 0)
+		err = snd_ice1712_akm4xxx_init(ak+1, &akm_revo_surround,
+						&akm_revo_surround_priv, ice);
+		if (err < 0)
 			return err;
 		/* unmute all codecs */
-		snd_ice1712_gpio_write_bits(ice, VT1724_REVO_MUTE, VT1724_REVO_MUTE);
+		snd_ice1712_gpio_write_bits(ice, VT1724_REVO_MUTE,
+						VT1724_REVO_MUTE);
 		break;
 	case VT1724_SUBDEVICE_REVOLUTION51:
 		ice->akm_codecs = 2;
