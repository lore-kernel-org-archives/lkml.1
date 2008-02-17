Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYBQM2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYBQM2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYBQMXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:14 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55082 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbYBQMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 27/27] [ALSA] hdsp - fix section mismatch warnings
Date: Sun, 17 Feb 2008 13:23:04 +0100
Message-Id: <1203250984-11285-27-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: sound/pci/rme9652/snd-hdsp.o(.text+0x34bc): Section mismatch in reference from the function hdsp_check_for_firmware() to the function .devinit.text:hdsp_request_fw_loader()
WARNING: sound/pci/rme9652/snd-hdsp.o(.text+0x4ac6): Section mismatch in reference from the function snd_hdsp_proc_read() to the function .devinit.text:hdsp_request_fw_loader()

Calling hdsp_request_fw_loader() were triggered from /proc
so this is not restricted to init or hotplug.
So removing the __devexit annotation of this function
and one of the functions fix the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
---
 sound/pci/rme9652/hdsp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index c2bd438..6f07a25 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -745,7 +745,7 @@ static int hdsp_get_iobox_version (struct hdsp *hdsp)
 
 
 #ifdef HDSP_FW_LOADER
-static int __devinit hdsp_request_fw_loader(struct hdsp *hdsp);
+static int hdsp_request_fw_loader(struct hdsp *hdsp);
 #endif
 
 static int hdsp_check_for_firmware (struct hdsp *hdsp, int load_on_demand)
@@ -4688,7 +4688,7 @@ static struct snd_pcm_ops snd_hdsp_capture_ops = {
 	.copy =		snd_hdsp_capture_copy,
 };
 
-static int __devinit snd_hdsp_create_hwdep(struct snd_card *card,
+static int snd_hdsp_create_hwdep(struct snd_card *card,
 					   struct hdsp *hdsp)
 {
 	struct snd_hwdep *hw;
@@ -4857,7 +4857,7 @@ static int snd_hdsp_create_alsa_devices(struct snd_card *card, struct hdsp *hdsp
 
 #ifdef HDSP_FW_LOADER
 /* load firmware via hotplug fw loader */
-static int __devinit hdsp_request_fw_loader(struct hdsp *hdsp)
+static int hdsp_request_fw_loader(struct hdsp *hdsp)
 {
 	const char *fwfile;
 	const struct firmware *fw;
-- 
1.5.4.rc3.14.g44397

