Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZLaPvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZLaPvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 10:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZLaPvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 10:51:35 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41339 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZLaPsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 10:48:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DBCIoZEen0j8LFGormY67zww2njmDUNGFSr+Tdp6P2nZ0CBMc7Dcngk5L49qH9hHkz
         O8qvVqY4DizS9MvVL0Oo638eN0IqdyVl5919JivYZjoRhDLAQ/YylhmyHOWVCL3wPAmt
         gqOWlI3Khti+zTlIPK4OCAQ8zXUeoTIw5SfQs=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 03/13] USB: ch341: use get_unaligned_le16 in break_ctl
Date: Thu, 31 Dec 2009 16:47:59 +0100
Message-Id: <1262274489-12447-4-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ch341.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 2942c6d..6230d24 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -22,6 +22,7 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 #include <linux/serial.h>
+#include <asm/unaligned.h>
 
 #define DEFAULT_BAUD_RATE 9600
 #define DEFAULT_TIMEOUT   1000
@@ -422,7 +423,7 @@ static void ch341_break_ctl(struct tty_struct *tty, int break_state)
 	}
 	dbg("%s - New ch341 break register contents - reg1: %x, reg2: %x",
 			__func__, break_reg[0], break_reg[1]);
-	reg_contents = (uint16_t)break_reg[0] | ((uint16_t)break_reg[1] << 8);
+	reg_contents = get_unaligned_le16(break_reg);
 	r = ch341_control_out(port->serial->dev, CH341_REQ_WRITE_REG,
 			ch341_break_reg, reg_contents);
 	if (r < 0)
-- 
1.6.6

