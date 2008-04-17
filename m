Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbYDQEQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbYDQEQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYDQEQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:16:28 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:37829 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYDQEQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:16:27 -0400
Message-ID: <4806CF18.2050403@tiscali.nl>
Date: Thu, 17 Apr 2008 06:16:24 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mos7840: test and propagate set_uart_reg return value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test for an mos7840_set_uart_reg() error return value only works when
status is signed. propagate its error value.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index aeeb9cb..ef1ede2 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1713,7 +1713,7 @@ static int mos7840_tiocmset(struct usb_serial_port *port, struct file *file,
 {
 	struct moschip_port *mos7840_port;
 	unsigned int mcr;
-	unsigned int status;
+	int status;
 
 	dbg("%s - port %d", __FUNCTION__, port->number);
 
@@ -1739,11 +1739,10 @@ static int mos7840_tiocmset(struct usb_serial_port *port, struct file *file,
 
 	mos7840_port->shadowMCR = mcr;
 
-	status = 0;
 	status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, mcr);
 	if (status < 0) {
 		dbg("setting MODEM_CONTROL_REGISTER Failed\n");
-		return -1;
+		return status;
 	}
 
 	return 0;
