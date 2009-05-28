Return-Path: <linux-kernel-owner+w=401wt.eu-S1762413AbZE1OTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762413AbZE1OTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762598AbZE1OTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:19:11 -0400
Received: from tango.0pointer.de ([85.214.72.216]:34832 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760022AbZE1OTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:19:10 -0400
Date: Thu, 28 May 2009 16:14:33 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: linux-kernel@vger.kernel.org
Cc: mchehab@redhat.com
Subject: [PATCH] V4L/pwc - use usb_interface as parent, not usb_device
Message-ID: <20090528141433.GA16534@omega>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code creates a sysfs device path where the video4linux
device is child of the usb device itself instead of the interface it
belongs to. That is evil and confuses udev.

This patch does basically the same thing as Kay's similar patch for the
ov511 driver:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce96d0a44a4f8d1bb3dc12b5e98cb688c1bc730d

(A while back I sent this patch to Mauro, but it never appeared in any
tree, so I am reposting this on lkml, in the hope someone will pick it
up.)

Lennart
---
 drivers/media/video/pwc/pwc-if.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index 7c542ca..92d4177 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -1783,7 +1783,7 @@ static int usb_pwc_probe(struct usb_interface *intf, const struct usb_device_id
 		return -ENOMEM;
 	}
 	memcpy(pdev->vdev, &pwc_template, sizeof(pwc_template));
-	pdev->vdev->parent = &(udev->dev);
+	pdev->vdev->parent = &intf->dev;
 	strcpy(pdev->vdev->name, name);
 	video_set_drvdata(pdev->vdev, pdev);
 
-- 
1.6.2.2



Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net         ICQ# 11060553
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
