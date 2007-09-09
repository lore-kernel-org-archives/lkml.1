Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXIIU0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXIIU0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbXIIUY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:24:58 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60716 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759434AbXIIUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:24:57 -0400
Date: Sun, 9 Sep 2007 22:25:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Frank A Kingswood <frank@kingswood-consulting.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [-mm patch] usb/serial/ch341.c: make 4 functions static
Message-ID: <20070909202504.GO3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
> +gregkh-usb-usb-driver-for-ch341-usb-serial-adaptor.patch
>...
>  USB tree updates
>...

This patch makes four needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/usb/serial/ch341.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

c7046a47d2d1dd5dc6a8fcc298b8c5f7497b3aaa 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index eb68106..6b252ce 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -66,7 +66,8 @@ static int ch341_control_in(struct usb_device *dev,
 	return r;
 }
 
-int ch341_set_baudrate(struct usb_device *dev, struct ch341_private *priv)
+static int ch341_set_baudrate(struct usb_device *dev,
+			      struct ch341_private *priv)
 {
 	short a, b;
 	int r;
@@ -108,14 +109,15 @@ int ch341_set_baudrate(struct usb_device *dev, struct ch341_private *priv)
 	return r;
 }
 
-int ch341_set_handshake(struct usb_device *dev, struct ch341_private *priv)
+static int ch341_set_handshake(struct usb_device *dev,
+			       struct ch341_private *priv)
 {
 	dbg("ch341_set_handshake(%d,%d)", priv->dtr, priv->rts);
 	return ch341_control_out(dev, 0xa4,
 		~((priv->dtr?1<<5:0)|(priv->rts?1<<6:0)), 0);
 }
 
-int ch341_get_status(struct usb_device *dev)
+static int ch341_get_status(struct usb_device *dev)
 {
 	char *buffer;
 	int r;
@@ -142,7 +144,7 @@ out:	kfree(buffer);
 
 /* -------------------------------------------------------------------------- */
 
-int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
+static int ch341_configure(struct usb_device *dev, struct ch341_private *priv)
 {
 	char *buffer;
 	int r;

