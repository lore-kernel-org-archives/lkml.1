Return-Path: <linux-kernel-owner+w=401wt.eu-S1030305AbXCCPdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030305AbXCCPdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 10:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030381AbXCCPdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 10:33:23 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:58938 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030305AbXCCPdW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 10:33:22 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Andreas Laumann <al@authentidate.de>
Subject: Re: usbserial not working/oops on removal
Date: Sat, 3 Mar 2007 16:33:18 +0100
User-Agent: KMail/1.9.1
Cc: Kevin Fenzi <kevin@scrye.com>, linux-kernel@vger.kernel.org
References: <20070302193715.568098a6@ningauble.scrye.com> <200703031138.20582.oliver@neukum.org> <1172928441.3710.8.camel@justine.inexnet.de>
In-Reply-To: <1172928441.3710.8.camel@justine.inexnet.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703031633.18597.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH43ejgwwk=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 3. März 2007 14:27 schrieb Andreas Laumann:
> Unfortunately your fix  does not work.  The first one seems registered
> correctly, but after that it fails again for the next one.

Please try this additional patch on top of the first.

	Regards
		Oliver

--- a/drivers/usb/serial/usb-serial.c	2007-03-03 16:28:22.000000000 +0100
+++ b/drivers/usb/serial/usb-serial.c	2007-03-03 16:28:26.000000000 +0100
@@ -847,7 +847,6 @@
 		port = kzalloc(sizeof(struct usb_serial_port), GFP_KERNEL);
 		if (!port)
 			goto probe_error;
-		port->number = i + serial->minor;
 		port->serial = serial;
 		spin_lock_init(&port->lock);
 		mutex_init(&port->mutex);
@@ -982,6 +981,9 @@
 	}
 	serial->minor = minor;
 
+	for (i = 0; i < max_endpoints; ++i)
+		serial->port[i]->number = i + serial->minor;
+
 	/* register all of the individual ports with the driver core */
 	for (i = 0; i < num_ports; ++i) {
 		port = serial->port[i];
