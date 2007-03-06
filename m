Return-Path: <linux-kernel-owner+w=401wt.eu-S933252AbXCFMoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933252AbXCFMoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 07:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933253AbXCFMoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 07:44:10 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:4556 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933252AbXCFMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 07:44:09 -0500
Date: Tue, 6 Mar 2007 13:43:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jaroslav Kysela <perex@suse.cz>
Subject: [PATCH] strlcpy is smart enough
Message-Id: <20070306134322.aa8241bf.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

strlcpy already accounts for the trailing zero in its length
computation, so there is no need to substract one to the buffer size.

Untested, as I do not have the hardware.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 arch/s390/kernel/debug.c              |    2 +-
 arch/xtensa/platform-iss/network.c    |    2 +-
 drivers/net/ehea/ehea_ethtool.c       |    4 ++--
 sound/aoa/codecs/snd-aoa-codec-onyx.c |    4 ++--
 sound/aoa/codecs/snd-aoa-codec-tas.c  |    4 ++--
 sound/oss/btaudio.c                   |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.21-rc2.orig/arch/s390/kernel/debug.c	2007-03-06 13:20:19.000000000 +0100
+++ linux-2.6.21-rc2/arch/s390/kernel/debug.c	2007-03-06 13:34:27.000000000 +0100
@@ -268,7 +268,7 @@ debug_info_alloc(char *name, int pages_p
 	rc->level          = level;
 	rc->buf_size       = buf_size;
 	rc->entry_size     = sizeof(debug_entry_t) + buf_size;
-	strlcpy(rc->name, name, sizeof(rc->name)-1);
+	strlcpy(rc->name, name, sizeof(rc->name));
 	memset(rc->views, 0, DEBUG_MAX_VIEWS * sizeof(struct debug_view *));
 	memset(rc->debugfs_entries, 0 ,DEBUG_MAX_VIEWS *
 		sizeof(struct dentry*));
--- linux-2.6.21-rc2.orig/arch/xtensa/platform-iss/network.c	2007-03-06 13:20:19.000000000 +0100
+++ linux-2.6.21-rc2/arch/xtensa/platform-iss/network.c	2007-03-06 13:34:27.000000000 +0100
@@ -251,7 +251,7 @@ static int tuntap_open(struct iss_net_pr
 
 	memset(&ifr, 0, sizeof ifr);
 	ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
-	strlcpy(ifr.ifr_name, dev_name, sizeof ifr.ifr_name - 1);
+	strlcpy(ifr.ifr_name, dev_name, sizeof ifr.ifr_name);
 
 	if ((err = simc_ioctl(fd, TUNSETIFF, (void*) &ifr)) < 0) {
 		printk("Failed to set interface, returned %d "
--- linux-2.6.21-rc2.orig/drivers/net/ehea/ehea_ethtool.c	2007-03-06 13:20:19.000000000 +0100
+++ linux-2.6.21-rc2/drivers/net/ehea/ehea_ethtool.c	2007-03-06 13:34:27.000000000 +0100
@@ -144,8 +144,8 @@ static int ehea_nway_reset(struct net_de
 static void ehea_get_drvinfo(struct net_device *dev,
 			       struct ethtool_drvinfo *info)
 {
-	strlcpy(info->driver, DRV_NAME, sizeof(info->driver) - 1);
-	strlcpy(info->version, DRV_VERSION, sizeof(info->version) - 1);
+	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
 }
 
 static u32 ehea_get_msglevel(struct net_device *dev)
--- linux-2.6.21-rc2.orig/sound/aoa/codecs/snd-aoa-codec-onyx.c	2007-03-06 13:20:19.000000000 +0100
+++ linux-2.6.21-rc2/sound/aoa/codecs/snd-aoa-codec-onyx.c	2007-03-06 13:34:27.000000000 +0100
@@ -1018,7 +1018,7 @@ static int onyx_create(struct i2c_adapte
 	onyx->i2c.driver = &onyx_driver;
 	onyx->i2c.adapter = adapter;
 	onyx->i2c.addr = addr & 0x7f;
-	strlcpy(onyx->i2c.name, "onyx audio codec", I2C_NAME_SIZE-1);
+	strlcpy(onyx->i2c.name, "onyx audio codec", I2C_NAME_SIZE);
 
 	if (i2c_attach_client(&onyx->i2c)) {
 		printk(KERN_ERR PFX "failed to attach to i2c\n");
@@ -1033,7 +1033,7 @@ static int onyx_create(struct i2c_adapte
 		goto fail;
 	}
 
-	strlcpy(onyx->codec.name, "onyx", MAX_CODEC_NAME_LEN-1);
+	strlcpy(onyx->codec.name, "onyx", MAX_CODEC_NAME_LEN);
 	onyx->codec.owner = THIS_MODULE;
 	onyx->codec.init = onyx_init_codec;
 	onyx->codec.exit = onyx_exit_codec;
--- linux-2.6.21-rc2.orig/sound/aoa/codecs/snd-aoa-codec-tas.c	2007-03-06 13:20:19.000000000 +0100
+++ linux-2.6.21-rc2/sound/aoa/codecs/snd-aoa-codec-tas.c	2007-03-06 13:34:27.000000000 +0100
@@ -899,14 +899,14 @@ static int tas_create(struct i2c_adapter
 	tas->i2c.addr = addr;
 	/* seems that half is a saner default */
 	tas->drc_range = TAS3004_DRC_MAX / 2;
-	strlcpy(tas->i2c.name, "tas audio codec", I2C_NAME_SIZE-1);
+	strlcpy(tas->i2c.name, "tas audio codec", I2C_NAME_SIZE);
 
 	if (i2c_attach_client(&tas->i2c)) {
 		printk(KERN_ERR PFX "failed to attach to i2c\n");
 		goto fail;
 	}
 
-	strlcpy(tas->codec.name, "tas", MAX_CODEC_NAME_LEN-1);
+	strlcpy(tas->codec.name, "tas", MAX_CODEC_NAME_LEN);
 	tas->codec.owner = THIS_MODULE;
 	tas->codec.init = tas_init_codec;
 	tas->codec.exit = tas_exit_codec;
--- linux-2.6.21-rc2.orig/sound/oss/btaudio.c	2007-03-06 13:20:19.000000000 +0100
+++ linux-2.6.21-rc2/sound/oss/btaudio.c	2007-03-06 13:38:00.000000000 +0100
@@ -344,7 +344,7 @@ static int btaudio_mixer_ioctl(struct in
 	if (cmd == SOUND_OLD_MIXER_INFO) {
 		_old_mixer_info info;
 		memset(&info,0,sizeof(info));
-                strlcpy(info.id,"bt878",sizeof(info.id)-1);
+                strlcpy(info.id, "bt878", sizeof(info.id));
                 strlcpy(info.name,"Brooktree Bt878 audio",sizeof(info.name));
                 if (copy_to_user(argp, &info, sizeof(info)))
                         return -EFAULT;


-- 
Jean Delvare
