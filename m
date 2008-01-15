Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbYAOApZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbYAOApZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYAOApM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:45:12 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:38437 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYAOApL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:45:11 -0500
Subject: [PATCH, v2] Input: tell mousedev to handle HP remote console
	virtual mouse using absolute coordinates
From: Micah Parrish <micah.parrish@hp.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Chiang, Alexander" <achiang@hp.com>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 17:45:56 -0700
Message-Id: <1200357956.6630.24.camel@strongbad>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HP Integrated Remote Console Virtual Mouse, which is standard equipment 
on all Proliant and Integrity servers, produces absolute coordinates 
instead of relative coordinates.  This is done to synchronize the 
position of the mouse cursor on the client desktop with the mouse 
cursor position on the server.  Mousedev is not designed to pass 
those absolute events directly to X, but it can translate them 
into relative movements.  It currently does this for tablet like devices 
and touchpads.  This patch tells mousedev to also enable this function for
the HP virtual mouse.  This patch is narrower in scope than my previous
patch of the same name, which enabled abs-to-rel translation for all 
devices with ABS_X, ABS_Y, and BTN_LEFT.

This patch enables the mouse pointer to move when using the remote
console.  Without this patch, the cursor will not move.

Signed-off-by: Micah Parrish <micah.parrish@hp.com>
---

 mousedev.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 9173916..e67a9cc 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -829,6 +829,16 @@ static const struct input_device_id mousedev_ids[] = {
                .keybit = { [LONG(BTN_TOOL_FINGER)] = BIT(BTN_TOOL_FINGER) },
                .absbit = { BIT(ABS_X) | BIT(ABS_Y) | BIT(ABS_PRESSURE) | BIT(ABS_TOOL_WIDTH) },
        },      /* A touchpad */
+       {
+               .vendor = 0x03f0,
+               .product = 0x1126,
+               .flags = INPUT_DEVICE_ID_MATCH_EVBIT 
+                       | INPUT_DEVICE_ID_MATCH_KEYBIT 
+                       | INPUT_DEVICE_ID_MATCH_ABSBIT,
+               .evbit = { BIT(EV_KEY) | BIT(EV_ABS) | BIT(EV_SYN) },
+               .keybit = { [LONG(BTN_LEFT)] = BIT(BTN_LEFT) },
+               .absbit = { BIT(ABS_X) | BIT(ABS_Y) },
+       },      /* hp ILO2 High Performance mouse */
 
        { },    /* Terminating entry */
 };


