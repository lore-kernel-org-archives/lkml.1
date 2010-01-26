Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337Ab0AZXu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0AZXu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130Ab0AZXuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:50:00 -0500
Received: from kroah.org ([198.145.64.141]:35436 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab0AZXoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:06 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:30 2010
Message-Id: <20100126233930.579319555@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [74/98] V4L/DVB (13826): uvcvideo: Fix controls blacklisting
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 385097e08b9c24655626ed760bc67eb7e50115a0 upstream.

The control blacklisting code erroneously used usb_match_id() by passing
a pointer to a usb_device_id structure instead of an array of such
structures.

Replace the usb_match_id() call by usb_match_id_one().

Thanks to Paulo Assis for diagnosing the bug and providing an initial
fix.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/uvc/uvc_ctrl.c
+++ b/drivers/media/video/uvc/uvc_ctrl.c
@@ -1405,7 +1405,7 @@ uvc_ctrl_prune_entity(struct uvc_device 
 	size = entity->processing.bControlSize;
 
 	for (i = 0; i < ARRAY_SIZE(blacklist); ++i) {
-		if (!usb_match_id(dev->intf, &blacklist[i].id))
+		if (!usb_match_one_id(dev->intf, &blacklist[i].id))
 			continue;
 
 		if (blacklist[i].index >= 8 * size ||


