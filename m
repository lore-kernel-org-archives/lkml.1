Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbYB1TNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbYB1TNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760616AbYB1TL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:11:27 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:33712 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760385AbYB1TLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:11:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gnfjzK42FMPM1GhxmrOZfoNU4frd1FJxU74giobwEONb2YBSWZ0+xX+WqL/1VSh5B0XNWjuyfEoCLcE3NTKWjUx464mmnntbS1sjA8YggA9Eot9JU+oiAgrWsY2/iXEOvmIkpD1ZrTQ8m00dTUcl26AZPOAadCJViE7oei3WQso=
Subject: [PATCH 5/8] sound: virtuoso.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 11:11:13 -0800
Message-Id: <1204225873.20280.83.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use priv_idx as an identifier.
sound/pci/oxygen/virtuoso.c:277:15: warning: symbol 'index' shadows an earlier one
sound/pci/oxygen/virtuoso.c:56:12: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/oxygen/virtuoso.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/oxygen/virtuoso.c b/sound/pci/oxygen/virtuoso.c
index 40e92f5..bb2f172 100644
--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -274,12 +274,12 @@ static void xonar_gpio_changed(struct oxygen *chip)
 
 static void mute_ac97_ctl(struct oxygen *chip, unsigned int control)
 {
-	unsigned int index = chip->controls[control]->private_value & 0xff;
+	unsigned int priv_idx = chip->controls[control]->private_value & 0xff;
 	u16 value;
 
-	value = oxygen_read_ac97(chip, 0, index);
+	value = oxygen_read_ac97(chip, 0, priv_idx);
 	if (!(value & 0x8000)) {
-		oxygen_write_ac97(chip, 0, index, value | 0x8000);
+		oxygen_write_ac97(chip, 0, priv_idx, value | 0x8000);
 		snd_ctl_notify(chip->card, SNDRV_CTL_EVENT_MASK_VALUE,
 			       &chip->controls[control]->id);
 	}
-- 
1.5.4.3.342.g99e8


