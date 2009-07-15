Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbZGOGYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbZGOGYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZGOGYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:24:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:53215 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbZGOGYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:24:08 -0400
Subject: drivers/usb/serial/option.c compiler warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Matthias Urlichs <smurf@smurf.noris.de>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jul 2009 11:53:47 +0530
Message-Id: <1247639027.2437.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting compiler warning in linus tree:

  CC [M]  drivers/usb/serial/option.o
drivers/usb/serial/option.c: In function ‘option_instat_callback’:
drivers/usb/serial/option.c:834: warning: unused variable ‘serial’
drivers/usb/serial/option.c: In function ‘option_open’:
drivers/usb/serial/option.c:930: warning: unused variable ‘serial’

This fixes the warning in my case, hope this will be helpful :

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
JSR

