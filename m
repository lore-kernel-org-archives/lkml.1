Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521Ab0AZXnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab0AZXnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770Ab0AZXnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:43:35 -0500
Received: from kroah.org ([198.145.64.141]:35267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0AZXnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:31 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:25 2010
Message-Id: <20100126233925.886005383@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chandra Seetharaman <sekharan@us.ibm.com>,
       Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [38/98] [SCSI] scsi_dh: create sysfs file, dh_state for all SCSI disk devices
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chandra Seetharaman <sekharan@us.ibm.com>

commit 5917290ce9b376866b165d02a5ed88d5ecdb32d0 upstream.

Create the sysfs file, dh_state even if the new SCSI device is not
in the any of the device handler's internal lists.

Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Acked-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/device_handler/scsi_dh.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -304,18 +304,15 @@ static int scsi_dh_notifier(struct notif
 	sdev = to_scsi_device(dev);
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		err = device_create_file(dev, &scsi_dh_state_attr);
+		/* don't care about err */
 		devinfo = device_handler_match(NULL, sdev);
-		if (!devinfo)
-			goto out;
-
-		err = scsi_dh_handler_attach(sdev, devinfo);
-		if (!err)
-			err = device_create_file(dev, &scsi_dh_state_attr);
+		if (devinfo)
+			err = scsi_dh_handler_attach(sdev, devinfo);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		device_remove_file(dev, &scsi_dh_state_attr);
 		scsi_dh_handler_detach(sdev, NULL);
 	}
-out:
 	return err;
 }
 


