Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYHBNPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYHBNPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYHBNPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:15:36 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:34209 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbYHBNPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:15:35 -0400
MIME-Version: 1.0
Date: Sat, 02 Aug 2008 15:15:26 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Krzysztof Helt <krzysztof.h1@wp.pl>, stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Takashi Iwai <tiwai@suse.de>, Oliver Pinter <oliver.pntr@gmail.com>
Subject: [RFC, 2.6.26.2-rc1] ALSA: cs4232: fix crash during chip PNP detection
Reply-To: oliver.pntr@gmail.com
Message-ID: <132676714a8f13219734d5b2e6ac3384@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b15ebe2616289da258f85b3ff142fca237ef9f59 Mon Sep 17 00:00:00 2001
From: Krzysztof Helt <krzysztof.h1@wp.pl>
Date: Wed, 23 Jul 2008 07:48:49 +0200
Subject: [PATCH] ALSA: cs4232: fix crash during chip PNP detection

[ Upstream commit b15ebe2616289da258f85b3ff142fca237ef9f59 ]

The acard->wss pointer is uninitialized in this function
which leads to crash during chip PNP detection.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Acked-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index dbe63db..4d4b8dd 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -325,6 +325,7 @@ static int __devinit snd_cs423x_pnp_init_mpu(int dev,
struct pnp_dev *pdev)
 static int __devinit snd_card_cs4232_pnp(int dev, struct snd_card_cs4236
*acard,
 					 struct pnp_dev *pdev)
 {
+	acard->wss = pdev;
 	if (snd_cs423x_pnp_init_wss(dev, acard->wss) < 0)
 		return -EBUSY;
 	cport[dev] = -1;


