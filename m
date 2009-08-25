Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZHYU7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZHYU7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbZHYU7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:59:37 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60642 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbZHYU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: tiwai@suse.de
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 3/4] SOUND: via82xx, use uninitialized_var(chip)
Date: Tue, 25 Aug 2009 22:59:36 +0200
Message-Id: <1251233977-5819-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251233977-5819-1-git-send-email-jirislaby@gmail.com>
References: <1251233977-5819-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid wrong compiler warnings, use unitialized_var(chip) in
snd_via82xx_probe's from via82xx and via82xx_modem drivers.

'chip' is unused when unset due to retval being nonzero.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
---
 sound/pci/via82xx.c       |    2 +-
 sound/pci/via82xx_modem.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index acfa476..0ae6224 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2435,7 +2435,7 @@ static int __devinit snd_via82xx_probe(struct pci_dev *pci,
 				       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
-	struct via82xx *chip;
+	struct via82xx *uninitialized_var(chip);
 	int chip_type = 0, card_type;
 	unsigned int i;
 	int err;
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 47eb615..f230f5e 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1165,7 +1165,7 @@ static int __devinit snd_via82xx_probe(struct pci_dev *pci,
 				       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
-	struct via82xx_modem *chip;
+	struct via82xx_modem *uninitialized_var(chip);
 	int chip_type = 0, card_type;
 	unsigned int i;
 	int err;
-- 
1.6.3.3

