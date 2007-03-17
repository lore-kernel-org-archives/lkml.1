Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXCQAg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXCQAg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 20:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966005AbXCQAg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 20:36:28 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:56976 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964798AbXCQAg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 20:36:26 -0400
Date: Sat, 17 Mar 2007 01:36:06 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: stuartm@connecttech.com, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070317003342.14847.72517.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] usb/serial/whiteheat: Convert to generic boolean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386


diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index bf16e9e..27c5f8f 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -1109,7 +1109,7 @@ static int firm_send_command (struct usb_serial_port *port, __u8 command, __u8 *
 	command_port = port->serial->port[COMMAND_PORT];
 	command_info = usb_get_serial_port_data(command_port);
 	spin_lock_irqsave(&command_info->lock, flags);
-	command_info->command_finished = FALSE;
+	command_info->command_finished = false;
 	
 	transfer_buffer = (__u8 *)command_port->write_urb->transfer_buffer;
 	transfer_buffer[0] = command;
@@ -1124,12 +1124,12 @@ static int firm_send_command (struct usb_serial_port *port, __u8 command, __u8 *
 	spin_unlock_irqrestore(&command_info->lock, flags);
 
 	/* wait for the command to complete */
-	wait_event_interruptible_timeout(command_info->wait_command, 
-		(command_info->command_finished != FALSE), COMMAND_TIMEOUT);
+	wait_event_interruptible_timeout(command_info->wait_command,
+		(bool)command_info->command_finished, COMMAND_TIMEOUT);
 
 	spin_lock_irqsave(&command_info->lock, flags);
 
-	if (command_info->command_finished == FALSE) {
+	if (command_info->command_finished == false) {
 		dbg("%s - command timed out.", __FUNCTION__);
 		retval = -ETIMEDOUT;
 		goto exit;
diff --git a/drivers/usb/serial/whiteheat.h b/drivers/usb/serial/whiteheat.h
index d714eff..f160797 100644
--- a/drivers/usb/serial/whiteheat.h
+++ b/drivers/usb/serial/whiteheat.h
@@ -20,10 +20,6 @@
 #define __LINUX_USB_SERIAL_WHITEHEAT_H
 
 
-#define FALSE	0
-#define TRUE	1
-
-
 /* WhiteHEAT commands */
 #define WHITEHEAT_OPEN			1	/* open the port */
 #define WHITEHEAT_CLOSE			2	/* close the port */
