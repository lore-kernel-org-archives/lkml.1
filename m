Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbZJASHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbZJASHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZJASHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:07:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:53377 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756050AbZJASHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:07:51 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX18RQeIo7K4R0RCo6WaxPniBtqru4tFTBr55nOeUM8
	yK6fOQHpgJpVnb
From: Sven Eckelmann <sven.eckelmann@gmx.de>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven.eckelmann@gmx.de>
Subject: [PATCH] ALSA: ctxfi: Swapped SURROUND-SIDE mute
Date: Thu,  1 Oct 2009 20:06:39 +0200
Message-Id: <1254420399-14411-1-git-send-email-sven.eckelmann@gmx.de>
X-Mailer: git-send-email 1.6.4.3
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Soundblaster X-FI Titenium with emu20k2 the SIDE and SURROUND mute
functions are swapped.
It was checked with 'speaker-test -c 8 -s 3' and (un)mute surround or
'speaker-test -c 8 -s 7' and (un)mute side. The volume seems not
to be affected and works as expected.

Signed-off-by: Sven Eckelmann <sven.eckelmann@gmx.de>
---
This patch is tested with commit 55fe27f7e2c9d24ce870136bd99ae67b020122d1
which arranges the channels on emu20k2.

 sound/pci/ctxfi/ctatc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index b1b3a64..7545464 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1037,7 +1037,7 @@ static int atc_line_front_unmute(struct ct_atc *atc, unsigned char state)
 
 static int atc_line_surround_unmute(struct ct_atc *atc, unsigned char state)
 {
-	return atc_daio_unmute(atc, state, LINEO4);
+	return atc_daio_unmute(atc, state, LINEO2);
 }
 
 static int atc_line_clfe_unmute(struct ct_atc *atc, unsigned char state)
@@ -1047,7 +1047,7 @@ static int atc_line_clfe_unmute(struct ct_atc *atc, unsigned char state)
 
 static int atc_line_rear_unmute(struct ct_atc *atc, unsigned char state)
 {
-	return atc_daio_unmute(atc, state, LINEO2);
+	return atc_daio_unmute(atc, state, LINEO4);
 }
 
 static int atc_line_in_unmute(struct ct_atc *atc, unsigned char state)
-- 
1.6.4.3

