Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYEKMus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYEKMus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 08:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYEKMuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 08:50:39 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46494 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbYEKMuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 08:50:37 -0400
Date: Sun, 11 May 2008 14:50:33 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: perex@perex.cz, ricardo@scarybox.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] sound/isa: use unsigned for loop index
Message-ID: <Pine.LNX.4.64.0805111450000.29620@ask.diku.dk>
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

 sound/isa/es1688/es1688_lib.c      |    2 +-
 sound/isa/es18xx.c                 |    4 ++--
 sound/isa/opti9xx/opti92x-ad1848.c |    2 +-
 sound/isa/sgalaxy.c                |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)


diff -u -p a/sound/isa/es1688/es1688_lib.c b/sound/isa/es1688/es1688_lib.c
--- a/sound/isa/es1688/es1688_lib.c 2008-04-16 13:28:05.000000000 +0200
+++ b/sound/isa/es1688/es1688_lib.c 2008-05-11 12:20:19.000000000 +0200
@@ -101,7 +101,7 @@ static unsigned char snd_es1688_mixer_re
 
 static int snd_es1688_reset(struct snd_es1688 *chip)
 {
-	int i;
+	unsigned int i;
 
 	outb(3, ES1688P(chip, RESET));		/* valid only for ESS chips, SB -> 1 */
 	udelay(10);
diff -u -p a/sound/isa/es18xx.c b/sound/isa/es18xx.c
--- a/sound/isa/es18xx.c 2008-04-16 13:28:05.000000000 +0200
+++ b/sound/isa/es18xx.c 2008-05-11 12:20:16.000000000 +0200
@@ -361,7 +361,7 @@ static inline int snd_es18xx_mixer_writa
 
 static int snd_es18xx_reset(struct snd_es18xx *chip)
 {
-	int i;
+	unsigned int i;
         outb(0x03, chip->port + 0x06);
         inb(chip->port + 0x06);
         outb(0x00, chip->port + 0x06);
@@ -2238,7 +2238,7 @@ static int __devinit snd_es18xx_isa_prob
 		return snd_es18xx_isa_probe1(dev, pdev);
 	} else {
 		static unsigned long possible_ports[] = {0x220, 0x240, 0x260, 0x280};
-		int i;
+		unsigned int i;
 		for (i = 0; i < ARRAY_SIZE(possible_ports); i++) {
 			port[dev] = possible_ports[i];
 			err = snd_es18xx_isa_probe1(dev, pdev);
diff -u -p a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
--- a/sound/isa/opti9xx/opti92x-ad1848.c 2008-04-16 13:28:05.000000000 +0200
+++ b/sound/isa/opti9xx/opti92x-ad1848.c 2008-05-11 12:20:18.000000000 +0200
@@ -1204,7 +1204,7 @@ static int snd_opti93x_capture_close(str
 static void snd_opti93x_init(struct snd_opti93x *chip)
 {
 	unsigned long flags;
-	int i;
+	unsigned int i;
 
 	spin_lock_irqsave(&chip->lock, flags);
 	snd_opti93x_mce_up(chip);
diff -u -p a/sound/isa/sgalaxy.c b/sound/isa/sgalaxy.c
--- a/sound/isa/sgalaxy.c 2008-04-16 13:28:05.000000000 +0200
+++ b/sound/isa/sgalaxy.c 2008-05-11 12:20:18.000000000 +0200
@@ -79,7 +79,7 @@ MODULE_PARM_DESC(dma1, "DMA1 # for Sound
 
 static int snd_sgalaxy_sbdsp_reset(unsigned long port)
 {
-	int i;
+	unsigned int i;
 
 	outb(1, SBP1(port, RESET));
 	udelay(10);
