Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbXIBUCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbXIBUCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXIBUBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:01:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38300 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbXIBUBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:01:52 -0400
Date: Mon, 3 Sep 2007 01:45:00 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org
Subject: [PATCH -mm] sb16: Shut up uninitialized var build warning
In-Reply-To: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
Message-ID: <alpine.LFD.0.999.0709030143550.29617@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i
 n>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="464262402-680809842-1188764104=:29617"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--464262402-680809842-1188764104=:29617
Content-Type: TEXT/PLAIN; charset=iso-2022-jp


sound/isa/sb16/sb16.c: In function ‘snd_sb16_isa_probe’:
sound/isa/sb16/sb16.c:559: warning: ‘err’ may be used uninitialized in this function

is a bogus warning, so let's shut it up.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 sound/isa/sb/sb16.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/sound/isa/sb/sb16.c~fix	2007-09-02 21:41:51.000000000 +0530
+++ linux-2.6.23-rc4-mm1/sound/isa/sb/sb16.c	2007-09-02 21:42:56.000000000 +0530
@@ -556,7 +556,6 @@ static int __devinit snd_sb16_isa_match(
 
 static int __devinit snd_sb16_isa_probe(struct device *pdev, unsigned int dev)
 {
-	int err;
 	static int possible_irqs[] = {5, 9, 10, 7, -1};
 	static int possible_dmas8[] = {1, 3, 0, -1};
 	static int possible_dmas16[] = {5, 6, 7, -1};
@@ -585,6 +584,8 @@ static int __devinit snd_sb16_isa_probe(
 	else {
 		static int possible_ports[] = {0x220, 0x240, 0x260, 0x280};
 		int i;
+		int uninitialized_var(err);
+
 		for (i = 0; i < ARRAY_SIZE(possible_ports); i++) {
 			port[dev] = possible_ports[i];
 			err = snd_sb16_isa_probe1(dev, pdev);
--464262402-680809842-1188764104=:29617--
