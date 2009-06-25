Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbZFYGSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbZFYGSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 02:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZFYGSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 02:18:08 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1604 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZFYGSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 02:18:08 -0400
Subject: [PATCH 20/19] sound: Use PCI_VDEVICE for CREATIVE and ECTIVA
From: Joe Perches <joe@perches.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       alsa-devel@alsa-project.org
In-Reply-To: <s5hmy7wn9gr.wl%tiwai@suse.de>
References: <cover.1245906151.git.joe@perches.com>
	 <e27f875baa15d3d3e34c2a005cea9d702e822c57.1245906153.git.joe@perches.com>
	 <s5hocscna17.wl%tiwai@suse.de> <1245908832.395.5.camel@Joe-Laptop.home>
	 <s5hmy7wn9gr.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 23:18:02 -0700
Message-Id: <1245910682.395.14.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 07:55 +0200, Takashi Iwai wrote:
> Heh, but it's obvious when you read the commend in the entry :)

Scripts are automatic.  Now you want me to work...

> Anyway, could you change that entry and repost?  Nno need to repost
> all in the series, of course :)

Here's a patch on top of the others to use CREATIVE and ECTIVA

Signed-off-by: Joe Perches <joe@perches.com>

 sound/pci/ca0106/ca0106_main.c |    2 +-
 sound/pci/emu10k1/emu10k1.c    |    6 +++---
 sound/pci/emu10k1/emu10k1x.c   |    2 +-
 sound/pci/ens1370.c            |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 57b992a..f24bf1e 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -1876,7 +1876,7 @@ static int snd_ca0106_resume(struct pci_dev *pci)
 
 // PCI IDs
 static struct pci_device_id snd_ca0106_ids[] = {
-	{ 0x1102, 0x0007, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },	/* Audigy LS or Live 24bit */
+	{ PCI_VDEVICE(CREATIVE, 0x0007), 0 },	/* Audigy LS or Live 24bit */
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, snd_ca0106_ids);
diff --git a/sound/pci/emu10k1/emu10k1.c b/sound/pci/emu10k1/emu10k1.c
index c7f3b99..168af67 100644
--- a/sound/pci/emu10k1/emu10k1.c
+++ b/sound/pci/emu10k1/emu10k1.c
@@ -77,9 +77,9 @@ MODULE_PARM_DESC(subsystem, "Force card subsystem model.");
  * Class 0401: 1102:0008 (rev 00) Subsystem: 1102:1001 -> Audigy2 Value  Model:SB0400
  */
 static struct pci_device_id snd_emu10k1_ids[] = {
-	{ 0x1102, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },	/* EMU10K1 */
-	{ 0x1102, 0x0004, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1 },	/* Audigy */
-	{ 0x1102, 0x0008, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 1 },	/* Audigy 2 Value SB0400 */
+	{ PCI_VDEVICE(CREATIVE, 0x0002), 0 },	/* EMU10K1 */
+	{ PCI_VDEVICE(CREATIVE, 0x0004), 1 },	/* Audigy */
+	{ PCI_VDEVICE(CREATIVE, 0x0008), 1 },	/* Audigy 2 Value SB0400 */
 	{ 0, }
 };
 
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 4d3ad79..36e08bd 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -1607,7 +1607,7 @@ static void __devexit snd_emu10k1x_remove(struct pci_dev *pci)
 
 // PCI IDs
 static struct pci_device_id snd_emu10k1x_ids[] = {
-	{ 0x1102, 0x0006, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },	/* Dell OEM version (EMU10K1) */
+	{ PCI_VDEVICE(CREATIVE, 0x0006), 0 },	/* Dell OEM version (EMU10K1) */
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, snd_emu10k1x_ids);
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index d589bbc..2b82c5c 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -450,7 +450,7 @@ static struct pci_device_id snd_audiopci_ids[] = {
 #ifdef CHIP1371
 	{ PCI_VDEVICE(ENSONIQ, 0x1371), 0, },	/* ES1371 */
 	{ PCI_VDEVICE(ENSONIQ, 0x5880), 0, },	/* ES1373 - CT5880 */
-	{ 0x1102, 0x8938, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },	/* Ectiva EV1938 */
+	{ PCI_VDEVICE(ECTIVA, 0x8938), 0, },	/* Ectiva EV1938 */
 #endif
 	{ 0, }
 };


