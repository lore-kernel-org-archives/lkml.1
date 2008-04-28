Return-Path: <linux-kernel-owner+w=401wt.eu-S937809AbYD1X71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937809AbYD1X71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937366AbYD1X6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:58:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:60898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937349AbYD1X6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:58:53 -0400
Subject: patch usb-mos7840-test-and-propagate-set_uart_reg-return-value.patch added to gregkh-2.6 tree
To: 12o3l@tiscali.nl, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org, steve@xemacs.org
From: <gregkh@suse.de>
Date: Mon, 28 Apr 2008 16:53:11 -0700
In-Reply-To: <4806CF18.2050403@tiscali.nl>
Message-ID: <12094267913945@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: mos7840: test and propagate set_uart_reg return value

to my gregkh-2.6 tree.  Its filename is

     usb-mos7840-test-and-propagate-set_uart_reg-return-value.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From 12o3l@tiscali.nl Wed Apr 16 21:16:30 2008
From: Roel Kluin <12o3l@tiscali.nl>
Date: Thu, 17 Apr 2008 06:16:24 +0200
Subject: USB: mos7840: test and propagate set_uart_reg return value
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,  lkml <linux-kernel@vger.kernel.org>
Message-ID: <4806CF18.2050403@tiscali.nl>


The test for an mos7840_set_uart_reg() error return value only works when
status is signed. propagate its error value.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Cc: SL Baur <steve@xemacs.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/mos7840.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1713,7 +1713,7 @@ static int mos7840_tiocmset(struct usb_s
 {
 	struct moschip_port *mos7840_port;
 	unsigned int mcr;
-	unsigned int status;
+	int status;
 
 	dbg("%s - port %d", __func__, port->number);
 
@@ -1740,11 +1740,10 @@ static int mos7840_tiocmset(struct usb_s
 
 	mos7840_port->shadowMCR = mcr;
 
-	status = 0;
 	status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER, mcr);
 	if (status < 0) {
 		dbg("setting MODEM_CONTROL_REGISTER Failed\n");
-		return -1;
+		return status;
 	}
 
 	return 0;


Patches currently in gregkh-2.6 which might be from 12o3l@tiscali.nl are

usb/usb-mos7840-test-and-propagate-set_uart_reg-return-value.patch
