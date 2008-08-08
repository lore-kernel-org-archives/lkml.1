Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbYHHLjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbYHHLjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbYHHLjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:39:39 -0400
Received: from mail.tut.by ([195.137.160.40]:42666 "EHLO speedy.tutby.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317AbYHHLjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:39:39 -0400
Subject: [PATCH] sound/pci/cs46xx/cs46xx_lib.c: remove unused variable
	warning
From: Michael Borisov <niro@tut.by>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       abramo@alsa-project.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Fri, 08 Aug 2008 14:39:22 +0300
Message-Id: <1218195562.4609.7.camel@niro-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile warning:
sound/pci/cs46xx/cs46xx_lib.c: In function ‘snd_cs46xx_resume’:
sound/pci/cs46xx/cs46xx_lib.c:3614: warning: unused variable ‘i’

 cs46xx_lib.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Signed-off-by: Michael Borisov <niro@tut.by>
---
diff --git a/sound/pci/cs46xx/cs46xx_lib.c
b/sound/pci/cs46xx/cs46xx_lib.c
index e214e56..07bb7e0 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -3611,7 +3611,7 @@ int snd_cs46xx_resume(struct pci_dev *pci)
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct snd_cs46xx *chip = card->private_data;
-	int i, amp_saved;
+	int amp_saved;
 
 	pci_set_power_state(pci, PCI_D0);
 	pci_restore_state(pci);
@@ -3633,6 +3633,7 @@ int snd_cs46xx_resume(struct pci_dev *pci)
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
 	cs46xx_dsp_resume(chip);
 	/* restore some registers */
+	int i;
 	for (i = 0; i < ARRAY_SIZE(saved_regs); i++)
 		snd_cs46xx_pokeBA0(chip, saved_regs[i], chip->saved_regs[i]);
 #else


