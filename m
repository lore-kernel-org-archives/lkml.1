Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbXIBUIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbXIBUIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXIBUIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:08:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56858 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXIBUIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:08:02 -0400
Date: Mon, 3 Sep 2007 01:51:10 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org
Subject: [PATCH -mm] es18xx: Shut up uninitialized var build warning
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030150180.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-74108432-1188764474=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-74108432-1188764474=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


sound/isa/es18xx.c: In function ‘snd_es18xx_isa_probe’:
sound/isa/es18xx.c:2251: warning: ‘err’ may be used uninitialized in this function

gcc is a sad, sad compiler. This warning is bogus so let's shut it up.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 sound/isa/es18xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/sound/isa/es18xx.c~fix	2007-09-02 21:16:54.000000000 +0530
+++ linux-2.6.23-rc4-mm1/sound/isa/es18xx.c	2007-09-02 21:30:13.000000000 +0530
@@ -2248,7 +2248,6 @@ static int __devinit snd_es18xx_isa_prob
 
 static int __devinit snd_es18xx_isa_probe(struct device *pdev, unsigned int dev)
 {
-	int err;
 	static int possible_irqs[] = {5, 9, 10, 7, 11, 12, -1};
 	static int possible_dmas[] = {1, 0, 3, 5, -1};
 
@@ -2276,6 +2275,8 @@ static int __devinit snd_es18xx_isa_prob
 	} else {
 		static unsigned long possible_ports[] = {0x220, 0x240, 0x260, 0x280};
 		int i;
+		int uninitialized_var(err);
+
 		for (i = 0; i < ARRAY_SIZE(possible_ports); i++) {
 			port[dev] = possible_ports[i];
 			err = snd_es18xx_isa_probe1(dev, pdev);
--464262402-74108432-1188764474=:29617--
