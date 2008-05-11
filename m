Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYEKMwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYEKMwK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 08:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbYEKMvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 08:51:42 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42966 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYEKMvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 08:51:40 -0400
Date: Sun, 11 May 2008 14:51:37 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, ricardo@scarybox.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/4] sound/pci: use unsigned for loop index
Message-ID: <Pine.LNX.4.64.0805111451050.29620@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

A few more cases in the spirit of the patch "Trivial: Replacement of always
>0 ints with unsigned ints" submitted by Ricardo Martins <ricardo@scarybox.net>

The transformation was made using the following semantic patch
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@ // find anything that might decrement the variable
identifier i;
expression E;
position p;
@@

  int i@p;
  ...
(
  &i
|
  i--
|
  --i
|
  i-=E
|
  i+=E
)

@x disable decl_init@
identifier r.i;
expression E;
position p1 != r.p;
@@

(
  volatile int i = 0;
|
  volatile int i;
|
+ unsigned
  int i@p1 = 0;
|
+ unsigned
  int i@p1;
)
  <... when != i = E      
(
  i = 0
|
  i = 1
)
  ...>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

 sound/pci/emu10k1/emu10k1x.c   |    4 ++--
 sound/pci/es1938.c             |    4 ++--
 sound/pci/fm801.c              |   10 +++++-----
 sound/pci/via82xx_modem.c      |    4 ++--
 sound/pci/ymfpci/ymfpci_main.c |    6 +++---
 5 files changed, 14 insertions(+), 14 deletions(-)

diff -u -p a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
--- a/sound/pci/emu10k1/emu10k1x.c 2008-04-27 11:41:12.000000000 +0200
+++ b/sound/pci/emu10k1/emu10k1x.c 2008-05-11 12:19:47.000000000 +0200
@@ -457,7 +457,7 @@ static int snd_emu10k1x_pcm_prepare(stru
 	int voice = epcm->voice->number;
 	u32 *table_base = (u32 *)(emu->dma_buffer.area+1024*voice);
 	u32 period_size_bytes = frames_to_bytes(runtime, runtime->period_size);
-	int i;
+	unsigned int i;
 	
 	for(i = 0; i < runtime->periods; i++) {
 		*table_base++=runtime->dma_addr+(i*period_size_bytes);
@@ -785,7 +785,7 @@ static irqreturn_t snd_emu10k1x_interrup
 
 	struct emu10k1x *chip = dev_id;
 	struct emu10k1x_voice *pvoice = chip->voices;
-	int i;
+	unsigned int i;
 	int mask;
 
 	status = inl(chip->port + IPR);
diff -u -p a/sound/pci/es1938.c b/sound/pci/es1938.c
--- a/sound/pci/es1938.c 2008-04-27 11:41:12.000000000 +0200
+++ b/sound/pci/es1938.c 2008-05-11 12:19:59.000000000 +0200
@@ -316,7 +316,7 @@ static int snd_es1938_mixer_bits(struct 
  * -----------------------------------------------------------------*/
 static void snd_es1938_write_cmd(struct es1938 *chip, unsigned char cmd)
 {
-	int i;
+	unsigned int i;
 	unsigned char v;
 	for (i = 0; i < WRITE_LOOP_TIMEOUT; i++) {
 		if (!(v = inb(SLSB_REG(chip, READSTATUS)) & 0x80)) {
@@ -405,7 +405,7 @@ static int snd_es1938_bits(struct es1938
  * --------------------------------------------------------------------*/
 static void snd_es1938_reset(struct es1938 *chip)
 {
-	int i;
+	unsigned int i;
 
 	outb(3, SLSB_REG(chip, RESET));
 	inb(SLSB_REG(chip, RESET));
diff -u -p a/sound/pci/fm801.c b/sound/pci/fm801.c
--- a/sound/pci/fm801.c 2008-04-27 11:41:12.000000000 +0200
+++ b/sound/pci/fm801.c 2008-05-11 12:19:46.000000000 +0200
@@ -768,7 +768,7 @@ static unsigned int snd_fm801_tea575x_25
 	struct fm801 *chip = tea->private_data;
 	unsigned short reg;
 	unsigned int val = 0;
-	int i;
+	unsigned int i;
 	
 	spin_lock_irq(&chip->reg_lock);
 	reg = inw(FM801_REG(chip, GPIO_CTRL));
@@ -856,7 +856,7 @@ static unsigned int snd_fm801_tea575x_25
 	struct fm801 *chip = tea->private_data;
 	unsigned short reg;
 	unsigned int val = 0;
-	int i;
+	unsigned int i;
 	
 	spin_lock_irq(&chip->reg_lock);
 	reg = inw(FM801_REG(chip, GPIO_CTRL));
@@ -944,7 +944,7 @@ static unsigned int snd_fm801_tea575x_64
 	struct fm801 *chip = tea->private_data;
 	unsigned short reg;
 	unsigned int val = 0;
-	int i;
+	unsigned int i;
 	
 	spin_lock_irq(&chip->reg_lock);
 	reg = inw(FM801_REG(chip, GPIO_CTRL));
@@ -1540,7 +1540,7 @@ static int snd_fm801_suspend(struct pci_
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct fm801 *chip = card->private_data;
-	int i;
+	unsigned int i;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
 	snd_pcm_suspend_all(chip->pcm);
@@ -1560,7 +1560,7 @@ static int snd_fm801_resume(struct pci_d
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct fm801 *chip = card->private_data;
-	int i;
+	unsigned int i;
 
 	pci_set_power_state(pci, PCI_D0);
 	pci_restore_state(pci);
diff -u -p a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
--- a/sound/pci/via82xx_modem.c 2008-04-27 11:41:12.000000000 +0200
+++ b/sound/pci/via82xx_modem.c 2008-05-11 12:19:42.000000000 +0200
@@ -1022,7 +1022,7 @@ static int snd_via82xx_suspend(struct pc
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct via82xx_modem *chip = card->private_data;
-	int i;
+	unsigned int i;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
 	for (i = 0; i < 2; i++)
@@ -1042,7 +1042,7 @@ static int snd_via82xx_resume(struct pci
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct via82xx_modem *chip = card->private_data;
-	int i;
+	unsigned int i;
 
 	pci_set_power_state(pci, PCI_D0);
 	pci_restore_state(pci);
diff -u -p a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
--- a/sound/pci/ymfpci/ymfpci_main.c 2008-04-27 11:41:12.000000000 +0200
+++ b/sound/pci/ymfpci/ymfpci_main.c 2008-05-11 12:20:01.000000000 +0200
@@ -109,7 +109,7 @@ static u16 snd_ymfpci_codec_read(struct 
 	if (snd_ymfpci_codec_ready(chip, 0))
 		return ~0;
 	if (chip->device_id == PCI_DEVICE_ID_YAMAHA_744 && chip->rev < 2) {
-		int i;
+		unsigned int i;
 		for (i = 0; i < 600; i++)
 			snd_ymfpci_readw(chip, YDSXGR_PRISTATUSDATA);
 	}
@@ -2034,7 +2034,7 @@ static inline void snd_ymfpci_convert_fr
 #else
 static void snd_ymfpci_convert_from_le(const struct firmware *fw)
 {
-	int i;
+	unsigned int i;
 	u32 *data = (u32 *)fw->data;
 
 	for (i = 0; i < fw->size / 4; ++i)
@@ -2088,7 +2088,7 @@ MODULE_FIRMWARE("yamaha/ds1e_ctrl.fw");
 
 static void snd_ymfpci_download_image(struct snd_ymfpci *chip)
 {
-	int i;
+	unsigned int i;
 	u16 ctrl;
 	u32 *inst;
 
