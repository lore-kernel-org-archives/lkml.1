Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbXFQPCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbXFQPCU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbXFQPCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:02:11 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:48156 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750717AbXFQPCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:02:09 -0400
Message-ID: <46754CDF.4080109@interia.pl>
Date: Sun, 17 Jun 2007 17:01:51 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.0 (X11/20070524)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: video4linux-list@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Hardware MPEG audio fix for SAA7134 based "KNC One TV-Station
 DVR" card
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-EMID: 9bc86acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With previous patch card is generating MPEG audio stream too.
Unfortunatly I2S audio output is muted. Unmute it.

Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
---
 drivers/media/video/saa7134/saa7134-empress.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -96,6 +96,10 @@ static int ts_open(struct inode *inode, struct file *file)
 	if (dev->empress_users)
 		goto done_up;
 
+	/* Unmute audio */
+	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
+		saa_readb(SAA7134_AUDIO_MUTE_CTRL) & ~(1 << 6));
+
 	dev->empress_users++;
 	file->private_data = dev;
 	err = 0;
@@ -121,6 +125,10 @@ static int ts_release(struct inode *inode, struct file *file)
 	/* stop the encoder */
 	ts_reset_encoder(dev);
 
+	/* Mute audio */
+	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
+		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
+
 	mutex_unlock(&dev->empress_tsq.lock);
 	return 0;
 }
-- 


----------------------------------------------------------------------
W sklepie orange.pl dostaniesz wiecej minut na rozmowy 
i telefon od 1 zl. Kup on-line >>> 
http://link.interia.pl/f1aad


