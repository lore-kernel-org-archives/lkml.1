Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509Ab0AEUM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab0AEUM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372Ab0AEUMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:12:41 -0500
Received: from kroah.org ([198.145.64.141]:49944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab0AEUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:11 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:01 2010
Message-Id: <20100105200300.935778564@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: pancho horrillo <pancho@pancho.name>
Subject: [15/39] USB: Fix a bug on appledisplay.c regarding signedness
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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


