Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbZL1WCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbZL1WCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZL1WCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:02:34 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61514 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZL1WCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:02:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vfLApnc2LEIVIy2PE0lVWB2zpcS1n3OmKVRoQU4s+yhUQY0VW/KLhKfuhxUb3MLwZ7
         96xFxw9+WEcqRi7cgLNuEOWwPuyAqDWaeX7klUnb9kFScQnH6kHYONTnaaaJOCxDsBKy
         xBI5M1lzpKhYMunMS/PCRtt4FeH7t69jMBMX4=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 01/14] USB: ch341: replace printk warnings with dev_err
Date: Mon, 28 Dec 2009 23:01:45 +0100
Message-Id: <1262037718-31424-2-git-send-email-jhovold@gmail.com>
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

