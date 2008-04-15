Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbYDUNb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbYDUNb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760225AbYDUNTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:41 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:35324 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760218AbYDUNTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=O97D8u0Ukn2oKA6V9SEqAtI0xPgVfyRCvX2yDf7ilH1G508GBQRB9NbnxvDaJmwc/g+fjn75CSs9YsqIknwriYJWJn8NjM1IhXD6+fJLUW1HT510A9GK2LFS97YxiwL00kbtXQFZljRFJpaavkEHqwnY87LLFHg0WG2ksLeaF68=
Message-Id: <04021e4e401d7ac2051839dd5b00a701c9119dd9.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Tue, 15 Apr 2008 01:31:47 -0400
Subject: [PATCH 25/37] Input: xpad - set proper buffer length for outgoing requests
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Michael Gruber <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The messages for led/rumble are exactly 3 and 8 bytes respectively.
Hence set up the transfer_buffer_length accordingly.

Signed-off-by: Michael Gruber <lists.mg@googlemail.com>
Acked-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index d4d289e..52ddb04 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -558,6 +558,7 @@ static int xpad_play_effect(struct input_dev *dev, void *data,
 		xpad->odata[5] = 0x00;
 		xpad->odata[6] = 0x00;
 		xpad->odata[7] = 0x00;
+		xpad->irq_out->transfer_buffer_length = 8;
 		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
 	}
 
@@ -594,6 +595,7 @@ static void xpad_send_led_command(struct usb_xpad *xpad, int command)
 		xpad->odata[0] = 0x01;
 		xpad->odata[1] = 0x03;
 		xpad->odata[2] = command;
+		xpad->irq_out->transfer_buffer_length = 3;
 		usb_submit_urb(xpad->irq_out, GFP_KERNEL);
 		mutex_unlock(&xpad->odata_mutex);
 	}
-- 
1.5.5.rc2.6.gf58d


