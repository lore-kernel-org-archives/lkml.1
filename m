Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0BVM1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:27:55 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36184 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0BVM1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:27:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bL/xG3DBslD6ApL1s9ff1bzE+mDNDP2Hs1GV+f8XnfQsp07DYFzscODvvengrwx7vc
         PMdRZ8DhOjl6LdKeHavsh7YmhFkZXO9rqEjCAopkEGsN7ju/Lsw8BQqAototMhiLRGYe
         3paa+AbRF5/g9kX4cRussAEYvflEDWkiTniwI=
From: Stefan Melmuk <stefan.melmuk@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Stefan Melmuk <stefan.melmuk@gmail.com>
Subject: [PATCH 8/8] cdrom: fixed EXPORT_SYMBOL coding style issue
Date: Mon, 22 Feb 2010 13:26:38 +0100
Message-Id: <1266841598-19662-8-git-send-email-stefan.melmuk@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
References: <1266841598-19662-1-git-send-email-stefan.melmuk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all EXPORT_SYMBOL(foo) coding style warnings.

Signed-off-by: Stefan Melmuk <stefan.melmuk@gmail.com>
---
 drivers/cdrom/cdrom.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 4d96369..24e48b1 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -439,6 +439,7 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	mutex_unlock(&cdrom_mutex);
 	return 0;
 }
+EXPORT_SYMBOL(register_cdrom);
 #undef ENSURE
 
 void unregister_cdrom(struct cdrom_device_info *cdi)
@@ -455,6 +456,7 @@ void unregister_cdrom(struct cdrom_device_info *cdi)
 	cdi->ops->n_minors--;
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" unregistered\n", cdi->name);
 }
+EXPORT_SYMBOL(unregister_cdrom);
 
 int cdrom_get_media_event(struct cdrom_device_info *cdi,
 			  struct media_event_desc *med)
@@ -482,6 +484,7 @@ int cdrom_get_media_event(struct cdrom_device_info *cdi,
 	memcpy(med, &buffer[sizeof(*eh)], sizeof(*med));
 	return 0;
 }
+EXPORT_SYMBOL(cdrom_get_media_event);
 
 /*
  * the first prototypes used 0x2c as the page code for the mrw mode page,
@@ -1029,6 +1032,7 @@ err:
 	cdi->use_count--;
 	return ret;
 }
+EXPORT_SYMBOL(cdrom_open);
 
 static
 int open_for_data(struct cdrom_device_info *cdi)
@@ -1229,6 +1233,7 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 			cdo->tray_move(cdi, 1);
 	}
 }
+EXPORT_SYMBOL(cdrom_release);
 
 static int cdrom_read_mech_status(struct cdrom_device_info *cdi,
 				  struct cdrom_changer_info *buf)
@@ -1313,6 +1318,7 @@ int cdrom_number_of_slots(struct cdrom_device_info *cdi)
 	kfree(info);
 	return nslots;
 }
+EXPORT_SYMBOL(cdrom_number_of_slots);
 
 
 /* If SLOT < 0, unload the current slot.  Otherwise, try to load SLOT. */
@@ -1433,6 +1439,7 @@ int cdrom_media_changed(struct cdrom_device_info *cdi)
 		return 0;
 	return media_changed(cdi, 0);
 }
+EXPORT_SYMBOL(cdrom_media_changed);
 
 /* badly broken, I know. Is due for a fixup anytime. */
 static void cdrom_count_tracks(struct cdrom_device_info *cdi, tracktype* tracks)
@@ -1527,6 +1534,7 @@ void init_cdrom_command(struct packet_command *cgc, void *buf, int len,
 	cgc->data_direction = type;
 	cgc->timeout = CDROM_DEF_TIMEOUT;
 }
+EXPORT_SYMBOL(init_cdrom_command);
 
 /* DVD handling */
 
@@ -1949,6 +1957,7 @@ int cdrom_mode_sense(struct cdrom_device_info *cdi,
 	cgc->data_direction = CGC_DATA_READ;
 	return cdo->generic_packet(cdi, cgc);
 }
+EXPORT_SYMBOL(cdrom_mode_sense);
 
 int cdrom_mode_select(struct cdrom_device_info *cdi,
 		      struct packet_command *cgc)
@@ -1964,6 +1973,7 @@ int cdrom_mode_select(struct cdrom_device_info *cdi,
 	cgc->data_direction = CGC_DATA_WRITE;
 	return cdo->generic_packet(cdi, cgc);
 }
+EXPORT_SYMBOL(cdrom_mode_select);
 
 static int cdrom_read_subchannel(struct cdrom_device_info *cdi,
 				 struct cdrom_subchnl *subchnl, int mcn)
@@ -2802,6 +2812,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 
 	return -ENOSYS;
 }
+EXPORT_SYMBOL(cdrom_ioctl);
 
 /*
  * Required when we need to use READ_10 to issue other than 2048 block
@@ -3322,6 +3333,7 @@ use_toc:
 	*last_written = toc.cdte_addr.lba;
 	return 0;
 }
+EXPORT_SYMBOL(cdrom_get_last_written);
 
 /* return the next writable block. also for udf file system. */
 static int cdrom_get_next_writable(struct cdrom_device_info *cdi, long *next_writable)
@@ -3373,18 +3385,6 @@ use_last_written:
 	}
 }
 
-EXPORT_SYMBOL(cdrom_get_last_written);
-EXPORT_SYMBOL(register_cdrom);
-EXPORT_SYMBOL(unregister_cdrom);
-EXPORT_SYMBOL(cdrom_open);
-EXPORT_SYMBOL(cdrom_release);
-EXPORT_SYMBOL(cdrom_ioctl);
-EXPORT_SYMBOL(cdrom_media_changed);
-EXPORT_SYMBOL(cdrom_number_of_slots);
-EXPORT_SYMBOL(cdrom_mode_select);
-EXPORT_SYMBOL(cdrom_mode_sense);
-EXPORT_SYMBOL(init_cdrom_command);
-EXPORT_SYMBOL(cdrom_get_media_event);
 
 #ifdef CONFIG_SYSCTL
 
-- 
1.7.0

