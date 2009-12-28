Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbZL1WEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbZL1WEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 17:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZL1WEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 17:04:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60134 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZL1WCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 17:02:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=d+R+QJ0FQzTPMxPg5TDGlSeBc0x/hAGXkK++uLExK56q2BEa1phy4ooHJFcS8xCHmK
         riahfQXISvoW0iJCOygbn+0NIA2jLyv14NV/7m4fSfiEAomRolH4D1Il+IxK6g9uQGDV
         AMIMGKJW0tgdkd3aPZBpH3GRn65YhsOLRBRsM=
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johan Hovold <jhovold@gmail.com>, Lonnie Mendez <dignome@gmail.com>
Subject: [PATCH 05/14] USB: cypress_m8: fix endianess bug
Date: Mon, 28 Dec 2009 23:01:49 +0100
Message-Id: <1262037718-31424-6-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
References: <1262037718-31424-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Lonnie Mendez <dignome@gmail.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/cypress_m8.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 478983f..b34c812 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -379,7 +379,7 @@ static int cypress_serial_control(struct tty_struct *tty,
 					__func__, new_baudrate);
 
 		/* fill the feature_buffer with new configuration */
-		*((u_int32_t *)feature_buffer) = new_baudrate;
+		*((u32 *)feature_buffer) = cpu_to_le32(new_baudrate);
 		feature_buffer[4] |= data_bits;   /* assign data bits in 2 bit space ( max 3 ) */
 		/* 1 bit gap */
 		feature_buffer[4] |= (stop_bits << 3);   /* assign stop bits in 1 bit space */
@@ -456,7 +456,7 @@ static int cypress_serial_control(struct tty_struct *tty,
 			/* store the config in one byte, and later
 			   use bit masks to check values */
 			priv->current_config = feature_buffer[4];
-			priv->baud_rate = *((u_int32_t *)feature_buffer);
+			priv->baud_rate = le32_to_cpup((u32 *)feature_buffer);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 	}
-- 
1.6.6

