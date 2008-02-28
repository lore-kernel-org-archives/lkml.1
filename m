Return-Path: <linux-kernel-owner+w=401wt.eu-S1763304AbYB1A6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763304AbYB1A6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761572AbYB1A40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:51661 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbYB1A4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t+RqMcz8tptoLY9IX6SIsz22iOIPDmlaZpDFwVJZAMt2TwOqKrEmugA5yV86RUQux0T+NLz9j/fjf+BwkxOi1YuqKQDMDYQXdTe5moNlxHUVxBkd1tDs4cN5lVxiITVZ23w7rSWRpGx3xvDKNE8Z1Z5yMye5udQ6+0ZqR+JDNYU=
Subject: [PATCH 08/12] sound: ac97_pcm.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:07 -0800
Message-Id: <1204160167.20280.56.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

err is always assigned before it is used, no need to declare another
inside the if statement.
sound/pci/ac97/ac97_pcm.c:577:7: warning: symbol 'err' shadows an earlier one
sound/pci/ac97/ac97_pcm.c:572:6: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/ac97/ac97_pcm.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/pci/ac97/ac97_pcm.c b/sound/pci/ac97/ac97_pcm.c
index 3674f35..48cbda9 100644
--- a/sound/pci/ac97/ac97_pcm.c
+++ b/sound/pci/ac97/ac97_pcm.c
@@ -574,7 +574,6 @@ int snd_ac97_pcm_open(struct ac97_pcm *pcm, unsigned int rate,
 	r = rate > 48000;
 	bus = pcm->bus;
 	if (cfg == AC97_PCM_CFG_SPDIF) {
-		int err;
 		for (cidx = 0; cidx < 4; cidx++)
 			if (bus->codec[cidx] && (bus->codec[cidx]->ext_id & AC97_EI_SPDIF)) {
 				err = set_spdif_rate(bus->codec[cidx], rate);
-- 
1.5.4.3.342.g99e8


