Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbZHYVAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbZHYVAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbZHYU7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:59:37 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60643 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbZHYU7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:36 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: tiwai@suse.de
Cc: perex@perex.cz, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/4] SOUND: atiixp, use uninitialized_var(chip)
Date: Tue, 25 Aug 2009 22:59:34 +0200
Message-Id: <1251233977-5819-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid wrong compiler warnings, use unitialized_var(chip) in
snd_atiixp_probe's from atiixp and atiixp_modem drivers.

'chip' is unused when unset due to retval being nonzero.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
---
 sound/pci/atiixp.c       |    2 +-
 sound/pci/atiixp_modem.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/atiixp.c b/sound/pci/atiixp.c
index d6752df..436ffea 100644
--- a/sound/pci/atiixp.c
+++ b/sound/pci/atiixp.c
@@ -1648,7 +1648,7 @@ static int __devinit snd_atiixp_probe(struct pci_dev *pci,
 				     const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
-	struct atiixp *chip;
+	struct atiixp *uninitialized_var(chip);
 	int err;
 
 	err = snd_card_create(index, id, THIS_MODULE, 0, &card);
diff --git a/sound/pci/atiixp_modem.c b/sound/pci/atiixp_modem.c
index e7e147b..b6191f2 100644
--- a/sound/pci/atiixp_modem.c
+++ b/sound/pci/atiixp_modem.c
@@ -1285,7 +1285,7 @@ static int __devinit snd_atiixp_probe(struct pci_dev *pci,
 				      const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
-	struct atiixp_modem *chip;
+	struct atiixp_modem *uninitialized_var(chip);
 	int err;
 
 	err = snd_card_create(index, id, THIS_MODULE, 0, &card);
-- 
1.6.3.3

