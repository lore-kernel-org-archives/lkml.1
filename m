Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389Ab0AEAnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab0AEAnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433Ab0AEAfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:50 -0500
Received: from kroah.org ([198.145.64.141]:34470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab0AEAfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Carpenter <error27@gmail.com>,
       Douglas Schilling Landgraf <dougsland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Brandon Philips <brandon@ifup.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 62/97] V4L/DVB (13596): ov511.c typo: lock => unlock
Date: Mon,  4 Jan 2010 16:33:15 -0800
Message-Id: <1262651630-7354-62-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

commit 50e9d31183ed61c787b870cb3ee8f6c3db8c8a1e upstream.

This was found with a static checker and has not been tested, but it seems
pretty clear that the mutex_lock() was supposed to be mutex_unlock()

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Douglas Schilling Landgraf <dougsland@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Brandon Philips <brandon@ifup.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/media/video/ov511.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index 0bc2cf5..2bed9e2 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -5878,7 +5878,7 @@ ov51x_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		goto error;
 	}
 
-	mutex_lock(&ov->lock);
+	mutex_unlock(&ov->lock);
 
 	return 0;
 
-- 
1.6.6

