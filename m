Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbXLKW0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbXLKW0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757240AbXLKWXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:23:43 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38542 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757248AbXLKWXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:23:42 -0500
Date: Tue, 11 Dec 2007 23:23:43 +0100
From: Adrian Bunk <bunk@kernel.org>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/media/video/bt8xx/ section fixes
Message-ID: <20071211222343.GX14204@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch with CONFIG_HOTPLUG=n:

<--  snip  -->

...
WARNING: vmlinux.o(.text+0x881632): Section mismatch: reference to .init.text.20:bttv_check_chipset (between 'bttv_init_module' and 'bttv_cleanup_module')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/media/video/bt8xx/bttv-cards.c  |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

ff5427b559f57118a845cafc987690a55f5d0df5 
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 3abd9fa..585d1ef 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -5080,7 +5080,7 @@ static void PXC200_muxsel(struct bttv *btv, unsigned int input)
 /* ----------------------------------------------------------------------- */
 /* motherboard chipset specific stuff                                      */
 
-void __devinit bttv_check_chipset(void)
+void __init bttv_check_chipset(void)
 {
 	int pcipci_fail = 0;
 	struct pci_dev *dev = NULL;
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index a88b56e..cff9d22 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -4988,7 +4988,7 @@ static struct pci_driver bttv_pci_driver = {
 #endif
 };
 
-static int bttv_init_module(void)
+static int __init bttv_init_module(void)
 {
 	int ret;
 
@@ -5021,7 +5021,7 @@ static int bttv_init_module(void)
 	return pci_register_driver(&bttv_pci_driver);
 }
 
-static void bttv_cleanup_module(void)
+static void __exit bttv_cleanup_module(void)
 {
 	pci_unregister_driver(&bttv_pci_driver);
 	bus_unregister(&bttv_sub_bus_type);

