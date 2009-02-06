Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbZBFSvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbZBFSvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbZBFSvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:51:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:10256 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZBFSvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:51:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Y0t4BdZ5LWwejk9dqkOzeq0ZR5OSlrjSgo30IZ66S2NkuTiBjHTy51ps6e94j+DpJP
         V5QPa4zlnQZ1YwUtvCqmJQrEyp2qOlGt5BKONPKVou/MzgkNGkG1wNlin90ob72+FJCx
         PzO3AhjMVIZMsrg9hVr1RuSscYxwhRvl7R6DE=
Message-ID: <498C86A1.8030404@gmail.com>
Date: Fri, 06 Feb 2009 19:51:13 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: riku.voipio@iki.fi, rpurdie@rpsys.net, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] leds: Fix &&/|| confusion
References: <498863FC.1090008@gmail.com> <adaiqnnxwxm.fsf@cisco.com>
In-Reply-To: <adaiqnnxwxm.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > -	if (type != EV_SND && (code != SND_BELL || code != SND_TONE))
>  > +	if (type != EV_SND && (code != SND_BELL && code != SND_TONE))
> 
> Actually more likely seems to be
> 
> 	if (type != EV_SND || (code != SND_BELL && code != SND_TONE))

Thanks for your review,

----------------------->8--------------8<-------------------------------
Fix &&/|| confusion

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 76ec749..11d3f1e 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -169,7 +169,7 @@ static int pca9532_event(struct input_dev *dev, unsigned int type,
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 
-	if (type != EV_SND && (code != SND_BELL || code != SND_TONE))
+	if (type != EV_SND || (code != SND_BELL && code != SND_TONE))
 		return -1;
 
 	/* XXX: allow different kind of beeps with psc/pwm modifications */
