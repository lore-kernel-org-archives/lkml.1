Return-Path: <linux-kernel-owner+w=401wt.eu-S1761998AbYDUN2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761998AbYDUN2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbYDUNTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:32 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:27661 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191AbYDUNT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=VJeJFnr0NoAb8c831kUk/d8rvkEi6GoRVaXIPJMQmVASQYgbbMXjWiqaf1RTr/Hm31pCJ2BY9tyot+nWytOOjdx5ZwyHKzI+J/U6JSkXZYlccmWC90bppYdhult6OK0EonSyZdoeoWT1Hy9/yqL2juCEtCoQKT1Q+Qt+GX5LiRQ=
Message-Id: <cfbe20106fa00e89c1fb2c74dbff0ba80e0e539d.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Thu, 3 Apr 2008 16:18:57 -0400
Subject: [PATCH 16/37] Input: xpad - enable force feedback on xbox 360 controllers only
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Anssi Hannula <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4994cd8dadcf9d484ab3ec19f3c7c7a4e5353c1c introduced a
regression which causes xpad to report force feedback cababilities
for non-360 controllers too, even while there is no actual support
for those.

Fix that by adding a check for XTYPE_XBOX360 to xpad_init_ff().

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/xpad.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index b48f705..fd80113 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -499,6 +499,9 @@ static int xpad_play_effect(struct input_dev *dev, void *data,
 
 static int xpad_init_ff(struct usb_xpad *xpad)
 {
+	if (xpad->xtype != XTYPE_XBOX360)
+		return 0;
+
 	input_set_capability(xpad->dev, EV_FF, FF_RUMBLE);
 
 	return input_ff_create_memless(xpad->dev, NULL, xpad_play_effect);
-- 
1.5.5.rc2.6.gf58d


