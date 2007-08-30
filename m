Return-Path: <linux-kernel-owner+w=401wt.eu-S1763202AbXH3WQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbXH3WQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 18:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbXH3WQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 18:16:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:2528 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972AbXH3WQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 18:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rPN0uVaLkNkFwqKsHljGMjfB7I8AOLgPou9Jym1/3uNqW8JC+Dm0/yt6pVPxxkAVJl84wsWXY4wJRi/8Y+tY104aI3Gm6sKNiTzVbUhSwdqxZQ6nLz+YDkeiEoUjs+9v2+Nw2g3qj+IDcyLVN5BXR69KFBkueh7D8tyGp0XlThM=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH] input: Silence 'unused variable' warning in iforce joystick driver
Date: Fri, 31 Aug 2007 00:13:12 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@ucw.cz>,
       Johann Deneux <johann.deneux@gmail.com>, dtor@mail.ru,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708310013.12347.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the iforce driver we currently get this warning

 drivers/input/joystick/iforce/iforce-packets.c: In function 'iforce_get_id_packet':
 drivers/input/joystick/iforce/iforce-packets.c:249: warning: unused variable 'status'

if CONFIG_JOYSTICK_IFORCE_USB is not defined.

The warning is easy to avoid by simply moving the variable inside 
the only case in the switch that actually use it.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/drivers/input/joystick/iforce/iforce-packets.c b/drivers/input/joystick/iforce/iforce-packets.c
index 3154ccd..48d4a86 100644
--- a/drivers/input/joystick/iforce/iforce-packets.c
+++ b/drivers/input/joystick/iforce/iforce-packets.c
@@ -246,13 +246,12 @@ void iforce_process_packet(struct iforce *iforce, u16 cmd, unsigned char *data)
 
 int iforce_get_id_packet(struct iforce *iforce, char *packet)
 {
-	int status;
-
 	switch (iforce->bus) {
 
 	case IFORCE_USB:
-
 #ifdef CONFIG_JOYSTICK_IFORCE_USB
+		int status;
+
 		iforce->cr.bRequest = packet[0];
 		iforce->ctrl->dev = iforce->usbdev;
 


