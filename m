Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476Ab0AEAxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab0AEAxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990Ab0AEAxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:53:11 -0500
Received: from kroah.org ([198.145.64.141]:34154 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab0AEAe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:56 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, pancho horrillo <pancho@pancho.name>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/97] USB: Fix a bug on appledisplay.c regarding signedness
Date: Mon,  4 Jan 2010 16:32:35 -0800
Message-Id: <1262651630-7354-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: pancho horrillo <pancho@pancho.name>

commit 37e9066b2f85480d99d3795373f5ef0b00ac1189 upstream.

brightness status is reported by the Apple Cinema Displays as an
'unsigned char' (u8) value, but the code used 'char' instead.

Note that he driver was developed on the PowerPC architecture,
where the two types are synonymous, which is not always the case.

Fixed that.  Otherwise the driver will interpret brightness
levels > 127 as negative, and fail to load.

Signed-off-by: pancho horrillo <pancho@pancho.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/misc/appledisplay.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 1d8e39a..62ff5e7 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -72,8 +72,8 @@ struct appledisplay {
 	struct usb_device *udev;	/* usb device */
 	struct urb *urb;		/* usb request block */
 	struct backlight_device *bd;	/* backlight device */
-	char *urbdata;			/* interrupt URB data buffer */
-	char *msgdata;			/* control message data buffer */
+	u8 *urbdata;			/* interrupt URB data buffer */
+	u8 *msgdata;			/* control message data buffer */
 
 	struct delayed_work work;
 	int button_pressed;
-- 
1.6.6

