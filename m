Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZLaPsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZLaPsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZLaPst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:48:49 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:39953 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbZLaPsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rvLuMTBSifUiZC5Yl8vM96COWCFDS/h8plBtMToxQAQN9KhiCJgvPy5Gy6g5c1mUkS
         NAqRpIMR3Uj4tSRgPKZEUue3KecxlRg1y5560XWDVXeeZ2RyqlQnUowR2DfgVyI5/XhO
         2qBWzvSi62NDDhIqdEReDsA9KiWeUwc2o4XdY=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 01/13] USB: ch341: replace printk warnings with dev_err
Date: Thu, 31 Dec 2009 16:47:57 +0100
Message-Id: <1262274489-12447-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ch341.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 59eff72..5e455f4 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -399,8 +399,8 @@ static void ch341_break_ctl(struct tty_struct *tty, int break_state)
 	r = ch341_control_in(port->serial->dev, CH341_REQ_READ_REG,
 			ch341_break_reg, 0, break_reg, sizeof(break_reg));
 	if (r < 0) {
-		printk(KERN_WARNING "%s: USB control read error whilst getting"
-				" break register contents.\n", __FILE__);
+		dev_err(&port->dev, "%s - USB control read error (%d)\n",
+				__func__, r);
 		return;
 	}
 	dbg("%s - initial ch341 break register contents - reg1: %x, reg2: %x",
@@ -420,8 +420,8 @@ static void ch341_break_ctl(struct tty_struct *tty, int break_state)
 	r = ch341_control_out(port->serial->dev, CH341_REQ_WRITE_REG,
 			ch341_break_reg, reg_contents);
 	if (r < 0)
-		printk(KERN_WARNING "%s: USB control write error whilst setting"
-				" break register contents.\n", __FILE__);
+		dev_err(&port->dev, "%s - USB control write error (%d)\n",
+				__func__, r);
 }
 
 static int ch341_tiocmset(struct tty_struct *tty, struct file *file,
-- 
1.6.6

