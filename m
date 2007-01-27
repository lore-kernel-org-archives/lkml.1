Return-Path: <linux-kernel-owner+w=401wt.eu-S1751685AbXA0M4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbXA0M4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 07:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXA0M4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 07:56:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42213 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbXA0M4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 07:56:24 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 27 Jan 2007 13:54:23 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/2] ieee1394: dv1394: tidy up card removal
To: Pieter Palmers <pieterp@joow.be>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.dbcf96797342e52f@s5r6.in-berlin.de>
Message-ID: <tkrat.2e6ca70a2a3b2380@s5r6.in-berlin.de>
References: <45BA743B.2080401@joow.be> <45BA85A1.1030707@s5r6.in-berlin.de>
 <45BB106E.706@joow.be> <45BB14A7.6040400@s5r6.in-berlin.de>
 <45BB18DE.1090802@joow.be> <45BB1F42.4000404@s5r6.in-berlin.de>
 <tkrat.dbcf96797342e52f@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

small coding style touch-up and terser coding

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/dv1394.c |   36 +++++++++++++-----------------------
 1 files changed, 13 insertions(+), 23 deletions(-)

Index: linux-2.6.20-rc6/drivers/ieee1394/dv1394.c
===================================================================
--- linux-2.6.20-rc6.orig/drivers/ieee1394/dv1394.c	2007-01-27 13:30:05.000000000 +0100
+++ linux-2.6.20-rc6/drivers/ieee1394/dv1394.c	2007-01-27 13:34:14.000000000 +0100
@@ -2255,47 +2255,37 @@ static int dv1394_init(struct ti_ohci *o
 	return 0;
 }
 
-static void dv1394_un_init(struct video_card *video)
+static void dv1394_remove_host(struct hpsb_host *host)
 {
-	/* obviously nobody has the driver open at this point */
-	do_dv1394_shutdown(video, 1);
-	kfree(video);
-}
-
-
-static void dv1394_remove_host (struct hpsb_host *host)
-{
-	struct video_card *video;
+	struct video_card *video, *tmp_video;
 	unsigned long flags;
-	int id = host->id, found_ohci_card = 0;
+	int found_ohci_card = 0;
 
-	/* find the corresponding video_cards */
 	do {
-		struct video_card *tmp_vid;
-
 		video = NULL;
-
 		spin_lock_irqsave(&dv1394_cards_lock, flags);
-		list_for_each_entry(tmp_vid, &dv1394_cards, list) {
-			if ((tmp_vid->id >> 2) == id) {
-				list_del(&tmp_vid->list);
-				video = tmp_vid;
+		list_for_each_entry(tmp_video, &dv1394_cards, list) {
+			if ((tmp_video->id >> 2) == host->id) {
+				list_del(&tmp_video->list);
+				video = tmp_video;
 				found_ohci_card = 1;
 				break;
 			}
 		}
 		spin_unlock_irqrestore(&dv1394_cards_lock, flags);
 
-		if (video)
-			dv1394_un_init(video);
-	} while (video != NULL);
+		if (video) {
+			do_dv1394_shutdown(video, 1);
+			kfree(video);
+		}
+	} while (video);
 
 	if (found_ohci_card)
 		class_device_destroy(hpsb_protocol_class, MKDEV(IEEE1394_MAJOR,
 			   IEEE1394_MINOR_BLOCK_DV1394 * 16 + (host->id << 2)));
 }
 
-static void dv1394_add_host (struct hpsb_host *host)
+static void dv1394_add_host(struct hpsb_host *host)
 {
 	struct ti_ohci *ohci;
 	int id = host->id;


-- 
Stefan Richter
-=====-=-=== ---= ==-==
http://arcgraph.de/sr/

