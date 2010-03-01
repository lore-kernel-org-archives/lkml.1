Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab0CANLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 08:11:20 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46651 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0CANLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 08:11:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=sE8LOzEgcPDbGrieZqkipm+bU3KSOTdnRiBW8hXUVAg7fKkGzzYJpukb3mT2pggyhm
         dqtsPorhTW41hCy4FHblDG9OnUTbFpX3kPKPaka/JRHEMUE33cpZZL3bigvue79N4ph9
         Juut2kkYI5SNqjNSVw2fDyqkAJ2Yj0inK7jRw=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Winischhofer <thomas@winischhofer.net>,
       Pete Zaitcev <zaitcev@redhat.com>, Tanaka Akira <akr@fsij.org>
Cc: linux-kernel@vger.kernel.org, Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] sisusbvga: Remove the BKL from ioctl
Date: Mon,  1 Mar 2010 14:10:56 +0100
Message-Id: <1267449056-30274-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems to me that BKL is not needed here because necessary locking is already
provided by mutex sisusb->lock.

Also change the returned value to long.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/usb/misc/sisusbvga/sisusb.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 8b37a4b..b0746c3 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -2964,13 +2964,12 @@ sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct sisusb_usb_data *sisusb;
 	struct sisusb_info x;
 	struct sisusb_command y;
-	int	retval = 0;
+	long retval = 0;
 	u32 __user *argp = (u32 __user *)arg;
 
 	if (!(sisusb = (struct sisusb_usb_data *)file->private_data))
 		return -ENODEV;
 
-	lock_kernel();
 	mutex_lock(&sisusb->lock);
 
 	/* Sanity check */
@@ -3029,7 +3028,6 @@ sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 err_out:
 	mutex_unlock(&sisusb->lock);
-	unlock_kernel();
 	return retval;
 }
 
-- 
1.6.3.3

