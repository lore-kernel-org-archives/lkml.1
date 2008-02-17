Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYBQMb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYBQMb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbYBQMX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:26 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55079 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Daniel Mack <daniel@caiaq.de>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 20/27] [ALSA] caiaq - fix section mismatch warning
Date: Sun, 17 Feb 2008 13:22:57 +0100
Message-Id: <1203250984-11285-20-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x11ec01a): Section mismatch in reference from the function setup_card() to the function .devinit.text:snd_usb_caiaq_control_init()

setup_card() are only used by init_card().
init_card() are only used by snd_probe()
snd_probe() are used for the .probe parameter in usb_driver.probe

Annotate them all __devinit to fix the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
---
 sound/usb/caiaq/caiaq-device.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/caiaq/caiaq-device.c b/sound/usb/caiaq/caiaq-device.c
index 58d25e4..7c44a2c 100644
--- a/sound/usb/caiaq/caiaq-device.c
+++ b/sound/usb/caiaq/caiaq-device.c
@@ -245,7 +245,7 @@ int snd_usb_caiaq_set_auto_msg (struct snd_usb_caiaqdev *dev,
 					  tmp, sizeof(tmp));
 }
 
-static void setup_card(struct snd_usb_caiaqdev *dev)
+static void __devinit setup_card(struct snd_usb_caiaqdev *dev)
 {
 	int ret;
 	char val[4];
@@ -359,7 +359,7 @@ static struct snd_card* create_card(struct usb_device* usb_dev)
 	return card;
 }
 
-static int init_card(struct snd_usb_caiaqdev *dev)
+static int __devinit init_card(struct snd_usb_caiaqdev *dev)
 {
 	char *c;
 	struct usb_device *usb_dev = dev->chip.dev;
@@ -428,7 +428,7 @@ static int init_card(struct snd_usb_caiaqdev *dev)
 	return 0;
 }
 
-static int snd_probe(struct usb_interface *intf, 
+static int __devinit snd_probe(struct usb_interface *intf, 
 		     const struct usb_device_id *id)
 {
 	int ret;
-- 
1.5.4.rc3.14.g44397

