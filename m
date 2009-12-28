Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZL1WFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZL1WFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZL1WF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:05:28 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61514 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZL1WCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:02:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=MVsI7O/s2yXMRvOQhEPGDxBKFGUZdsh1iY6O76Aysz+8QD6A8Ci8pYhqg6ek9pwnoo
         aQ6k8Czi5Nt1Y1KKu5gTSJ8sZF5h5hev+YUpYAtd+6aM5yEj9ss4YO2Sz6mgBqLHMp+C
         lTV4+mSj+IFwxqEOUdSQmT1XRVuwaHJWHOu1s=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 03/14] USB: ch341: use le16_to_cpup to be explicit about endianess
Date: Mon, 28 Dec 2009 23:01:47 +0100
Message-Id: <1262037718-31424-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ch341.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 2942c6d..4fd01d6 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -422,7 +422,7 @@ static void ch341_break_ctl(struct tty_struct *tty, int break_state)
 	}
 	dbg("%s - New ch341 break register contents - reg1: %x, reg2: %x",
 			__func__, break_reg[0], break_reg[1]);
-	reg_contents = (uint16_t)break_reg[0] | ((uint16_t)break_reg[1] << 8);
+	reg_contents = le16_to_cpup((uint16_t *)break_reg);
 	r = ch341_control_out(port->serial->dev, CH341_REQ_WRITE_REG,
 			ch341_break_reg, reg_contents);
 	if (r < 0)
-- 
1.6.6

