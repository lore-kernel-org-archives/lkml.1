Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZKLQbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZKLQbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 11:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZKLQbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 11:31:05 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:37162 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZKLQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 11:31:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=VJR8seWF7ALZxBobbDmhrFLMRQkYDDQ8gbmIIrGN+bwpai4H/7hX4yz2JRsb4AZY6l
         SczKiqMxS3s5KPjrU3QQfXqfel/WhtDLJtevbhQQmntiG6AEpMwbiau0uo+8sHm2qmWr
         FOtqthVOQJju+Yx2AqYno70Uhq5xFQYLKRHMQ=
Message-ID: <4AFC3B1F.1050901@gmail.com>
Date: Thu, 12 Nov 2009 17:43:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH]  OSS: fix error return in dma_ioctl()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The returned error should stay negative

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 sound/oss/audio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/oss/audio.c b/sound/oss/audio.c
index b69c05b..7df48a2 100644
--- a/sound/oss/audio.c
+++ b/sound/oss/audio.c
@@ -838,7 +838,7 @@ static int dma_ioctl(int dev, unsigned int cmd, void __user *arg)
 					if ((err = audio_devs[dev]->d->prepare_for_input(dev,
 						     dmap_in->fragment_size, dmap_in->nbufs)) < 0) {
 						spin_unlock_irqrestore(&dmap_in->lock,flags);
-						return -err;
+						return err;
 					}
 					dmap_in->dma_mode = DMODE_INPUT;
 					audio_devs[dev]->enable_bits |= PCM_ENABLE_INPUT;
