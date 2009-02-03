Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbZBCD0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbZBCD0m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbZBCD0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:26:33 -0500
Received: from rtr.ca ([76.10.145.34]:60547 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZBCD0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:26:32 -0500
Message-ID: <4987B965.6020609@rtr.ca>
Date: Mon, 02 Feb 2009 22:26:29 -0500
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-i2c@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] ir-kbd-i2c: support Hauppauge HVR-1600 R/C port
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the ir-kbd-i2c driver to recognize the remote-control port
on the Hauppauge HV-1600 hybrid tuner card.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- old/drivers/media/video/ir-kbd-i2c.c	2008-12-24 18:26:37.000000000 -0500
+++ linux/drivers/media/video/ir-kbd-i2c.c	2009-02-01 13:08:19.000000000 -0500
@@ -354,6 +354,11 @@
 			} else {
 				ir_codes    = ir_codes_rc5_tv;
 			}
+		} else if (adap->id == I2C_HW_B_CX2341X) {
+			name        = "Hauppauge";
+			ir_type     = IR_TYPE_RC5;
+			ir->get_key = get_key_haup_xvr;
+			ir_codes    = ir_codes_hauppauge_new;
 		} else {
 			/* Handled by saa7134-input */
 			name        = "SAA713x remote";
@@ -449,7 +454,7 @@
 	   That's why we probe 0x1a (~0x34) first. CB
 	*/
 
-	static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, -1};
+	static const int probe_bttv[] = { 0x1a, 0x18, 0x4b, 0x64, 0x30, 0x71, -1};
 	static const int probe_saa7134[] = { 0x7a, 0x47, 0x71, 0x2d, -1 };
 	static const int probe_em28XX[] = { 0x30, 0x47, -1 };
 	static const int probe_cx88[] = { 0x18, 0x6b, 0x71, -1 };
