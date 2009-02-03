Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbZBCPea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbZBCPea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 10:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZBCPeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 10:34:22 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:63288 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZBCPeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 10:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=YVf2r8JHRCuGTBaFphcces31rGiv65VDfYuzwB/dD5q7FV445I2i++oaqcgcQSHCp7
         jwrDV5BPzSJN4S+TnMLHVW29mY715pnMqPEVoASZWac80TonTpIoxexxhOS6bYj1HFVU
         tFPkJ56mea+0Ku9JbniaDNksxQGrFiy+CUTQU=
Message-ID: <498863FC.1090008@gmail.com>
Date: Tue, 03 Feb 2009 16:34:20 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: riku.voipio@iki.fi, rpurdie@rpsys.net, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: always true: (x != 1 || x != 2)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

see vi include/linux/input.h +710:

#define SND_BELL                0x01
#define SND_TONE                0x02

so (code != SND_BELL || code != SND_TONE) is always true 

I think this was intended?
--------------------->8------------------8<-----------------------
(code != SND_BELL || code != SND_TONE) is always true 

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 76ec749..6a481cf 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -169,7 +169,7 @@ static int pca9532_event(struct input_dev *dev, unsigned int type,
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 
-	if (type != EV_SND && (code != SND_BELL || code != SND_TONE))
+	if (type != EV_SND && (code != SND_BELL && code != SND_TONE))
 		return -1;
 
 	/* XXX: allow different kind of beeps with psc/pwm modifications */
