Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYAWFmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYAWFmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYAWFmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 00:42:06 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:42591 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYAWFmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 00:42:01 -0500
Date: Tue, 22 Jan 2008 21:39:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: perex@perex.cz, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH] sound: fix cs5535 section mismatch
Message-Id: <20080122213943.939bc1cb.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

snd_cs5535audio_mixer() is only called by __devinit snd_cs5535audio_probe(),
so the mixer function can also be __devinit.

WARNING: vmlinux.o(.text+0xfdbba0): Section mismatch: reference to .init.data:ac97_quirks (between 'snd_cs5535audio_mixer' and 'process_bm0_irq')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/cs5535audio/cs5535audio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc8-git5.orig/sound/pci/cs5535audio/cs5535audio.c
+++ linux-2.6.24-rc8-git5/sound/pci/cs5535audio/cs5535audio.c
@@ -145,7 +145,7 @@ static unsigned short snd_cs5535audio_ac
 	return snd_cs5535audio_codec_read(cs5535au, reg);
 }
 
-static int snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
+static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 {
 	struct snd_card *card = cs5535au->card;
 	struct snd_ac97_bus *pbus;
