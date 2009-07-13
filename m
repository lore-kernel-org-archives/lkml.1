Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbZGMUS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbZGMUS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbZGMUS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:18:28 -0400
Received: from ox1.aei.mpg.de ([194.94.224.6]:59080 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756887AbZGMUS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:18:27 -0400
X-Greylist: delayed 1935 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 16:18:27 EDT
Date: Mon, 13 Jul 2009 21:45:03 +0200
From: "Carlos R. Mafra" <crmafra@aei.mpg.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] USB: option: Remove unused variable 
Message-ID: <20090713194502.GA20723@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f600eacfbca47d286e549d1be36bf07b9e2479e2 Mon Sep 17 00:00:00 2001
From: Carlos R. Mafra <crmafra@aei.mpg.de>
Date: Mon, 13 Jul 2009 21:28:24 +0200
Subject: [PATCH] USB: option: Remove unused variable

After commit f092c240494f2d807401d93f95f683909b90af96 ("USB: option:
remove unnecessary and erroneous code") the variable 'serial' becomes
unused, as gcc-4.3.2 points out:

drivers/usb/serial/option.c: In function 'option_instat_callback':
drivers/usb/serial/option.c:834: warning: unused variable 'serial'
drivers/usb/serial/option.c: In function 'option_open':
drivers/usb/serial/option.c:930: warning: unused variable 'serial'

So I removed it.

Signed-off-by: Carlos R. Mafra <crmafra@aei.mpg.de>
---
 drivers/usb/serial/option.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 98262dd..77b9563 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -831,7 +831,6 @@ static void option_instat_callback(struct urb *urb)
 	int status = urb->status;
 	struct usb_serial_port *port =  urb->context;
 	struct option_port_private *portdata = usb_get_serial_port_data(port);
-	struct usb_serial *serial = port->serial;
 
 	dbg("%s", __func__);
 	dbg("%s: urb %p port %p has data %p", __func__, urb, port, portdata);
@@ -927,7 +926,6 @@ static int option_open(struct tty_struct *tty,
 			struct usb_serial_port *port, struct file *filp)
 {
 	struct option_port_private *portdata;
-	struct usb_serial *serial = port->serial;
 	int i, err;
 	struct urb *urb;
 
-- 
1.6.2.4

