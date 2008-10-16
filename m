Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbYJPRRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbYJPRRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYJPROJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:09 -0400
Received: from kroah.org ([198.145.64.141]:46926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754911AbYJPROH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:07 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Ben Collins <ben.collins@ubuntu.com>
Subject: [PATCH 05/46] device create: ieee1394: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:06 -0700
Message-Id: <1224177047-11859-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Cc: Ben Collins <ben.collins@ubuntu.com>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ieee1394/dv1394.c    |    8 ++++----
 drivers/ieee1394/raw1394.c   |    8 ++++----
 drivers/ieee1394/video1394.c |    5 ++---
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/ieee1394/dv1394.c b/drivers/ieee1394/dv1394.c
index b6eb2cf..9236c0d 100644
--- a/drivers/ieee1394/dv1394.c
+++ b/drivers/ieee1394/dv1394.c
@@ -2296,10 +2296,10 @@ static void dv1394_add_host(struct hpsb_host *host)
 
 	ohci = (struct ti_ohci *)host->hostdata;
 
-	device_create_drvdata(hpsb_protocol_class, NULL,
-			      MKDEV(IEEE1394_MAJOR,
-				    IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id<<2)), NULL,
-			      "dv1394-%d", id);
+	device_create(hpsb_protocol_class, NULL,
+		      MKDEV(IEEE1394_MAJOR,
+			    IEEE1394_MINOR_BLOCK_DV1394 * 16 + (id<<2)),
+		      NULL, "dv1394-%d", id);
 
 	dv1394_init(ohci, DV1394_NTSC, MODE_RECEIVE);
 	dv1394_init(ohci, DV1394_NTSC, MODE_TRANSMIT);
diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index 6fa9e4a..c7833bb 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -3010,10 +3010,10 @@ static int __init init_raw1394(void)
 	hpsb_register_highlevel(&raw1394_highlevel);
 
 	if (IS_ERR
-	    (device_create_drvdata(
-	      hpsb_protocol_class, NULL,
-	      MKDEV(IEEE1394_MAJOR, IEEE1394_MINOR_BLOCK_RAW1394 * 16),
-	      NULL, RAW1394_DEVICE_NAME))) {
+	    (device_create(hpsb_protocol_class, NULL,
+			   MKDEV(IEEE1394_MAJOR,
+				 IEEE1394_MINOR_BLOCK_RAW1394 * 16),
+			   NULL, RAW1394_DEVICE_NAME))) {
 		ret = -EFAULT;
 		goto out_unreg;
 	}
diff --git a/drivers/ieee1394/video1394.c b/drivers/ieee1394/video1394.c
index 25db6e6..6e73b06 100644
--- a/drivers/ieee1394/video1394.c
+++ b/drivers/ieee1394/video1394.c
@@ -1341,9 +1341,8 @@ static void video1394_add_host (struct hpsb_host *host)
 	hpsb_set_hostinfo_key(&video1394_highlevel, host, ohci->host->id);
 
 	minor = IEEE1394_MINOR_BLOCK_VIDEO1394 * 16 + ohci->host->id;
-	device_create_drvdata(hpsb_protocol_class, NULL,
-			      MKDEV(IEEE1394_MAJOR, minor), NULL,
-			      "%s-%d", VIDEO1394_DRIVER_NAME, ohci->host->id);
+	device_create(hpsb_protocol_class, NULL, MKDEV(IEEE1394_MAJOR, minor),
+		      NULL, "%s-%d", VIDEO1394_DRIVER_NAME, ohci->host->id);
 }
 
 
-- 
1.6.0.2

