Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZBYV3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZBYV3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbZBYV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:29:08 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:40301 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599AbZBYV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:29:06 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 4/7] sound/pci/emu10k1: fix sparse warning: different
	signedness
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 22:28:59 +0100
Message-ID: <20090225212853.9226.86574.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
References: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:
  sound/pci/emu10k1/emu10k1_main.c:723:66: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:724:68: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:748:74: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:751:66: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:759:73: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:760:73: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:837:50: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:845:50: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:881:50: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:889:57: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:890:57: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:895:60: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:897:60: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:899:60: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:910:56: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:914:57: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:918:56: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:922:57: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:924:58: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:936:60: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:1073:60: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:1088:60: warning: incorrect type in argument 3 (different signedness)
  sound/pci/emu10k1/emu10k1_main.c:1093:58: warning: incorrect type in argument 3 (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/pci/emu10k1/emu10k1_main.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index f76781f..f18bd62 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -711,8 +711,7 @@ static int snd_emu1010_load_firmware(struct snd_emu10k1 *emu, const char *filena
 static int emu1010_firmware_thread(void *data)
 {
 	struct snd_emu10k1 *emu = data;
-	int tmp, tmp2;
-	int reg;
+	u32 tmp, tmp2, reg;
 	int err;
 
 	for (;;) {
@@ -758,7 +757,7 @@ static int emu1010_firmware_thread(void *data)
 			snd_printk(KERN_INFO "emu1010: Audio Dock Firmware loaded\n");
 			snd_emu1010_fpga_read(emu, EMU_DOCK_MAJOR_REV, &tmp);
 			snd_emu1010_fpga_read(emu, EMU_DOCK_MINOR_REV, &tmp2);
-			snd_printk(KERN_INFO "Audio Dock ver:%d.%d\n",
+			snd_printk(KERN_INFO "Audio Dock ver: %u.%u\n",
 				   tmp, tmp2);
 			/* Sync clocking between 1010 and Dock */
 			/* Allow DLL to settle */
@@ -805,8 +804,7 @@ static int emu1010_firmware_thread(void *data)
 static int snd_emu10k1_emu1010_init(struct snd_emu10k1 *emu)
 {
 	unsigned int i;
-	int tmp, tmp2;
-	int reg;
+	u32 tmp, tmp2, reg;
 	int err;
 	const char *filename = NULL;
 
@@ -888,7 +886,7 @@ static int snd_emu10k1_emu1010_init(struct snd_emu10k1 *emu)
 	snd_printk(KERN_INFO "emu1010: Hana Firmware loaded\n");
 	snd_emu1010_fpga_read(emu, EMU_HANA_MAJOR_REV, &tmp);
 	snd_emu1010_fpga_read(emu, EMU_HANA_MINOR_REV, &tmp2);
-	snd_printk(KERN_INFO "emu1010: Hana version: %d.%d\n", tmp, tmp2);
+	snd_printk(KERN_INFO "emu1010: Hana version: %u.%u\n", tmp, tmp2);
 	/* Enable 48Volt power to Audio Dock */
 	snd_emu1010_fpga_write(emu, EMU_HANA_DOCK_PWR, EMU_HANA_DOCK_PWR_ON);
 

