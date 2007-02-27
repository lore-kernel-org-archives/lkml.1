Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXB0Kq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXB0Kq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXB0Kq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:46:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbXB0Kq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:46:56 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.21-rc1: mmc reader no longer works, usb oops
Date: Tue, 27 Feb 2007 11:46:53 +0100
User-Agent: KMail/1.9.1
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <20070227103620.GA8205@elf.ucw.cz>
In-Reply-To: <20070227103620.GA8205@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702271146.53414.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 27. Februar 2007 11:36 schrieb Pavel Machek:
> Hi!
> 
> MMC card reader in x60 no longer works in -rc1. (Will have to check if
> it worked before s2ram).
> 
> When playing with usb-serial, I got this oops (upon trying to start
> minicom /dev/ttyUSB0 while linux gadget on the other end was
> crashing).

Does this help?

--- a/drivers/usb/serial/usb-serial.c	2007-02-21 05:32:30.000000000 +0100
+++ b/drivers/usb/serial/usb-serial.c	2007-02-26 15:32:50.000000000 +0100
@@ -826,7 +826,6 @@
 			num_ports = type->num_ports;
 	}
 
-	serial->minor = minor;
 	serial->num_ports = num_ports;
 	serial->num_bulk_in = num_bulk_in;
 	serial->num_bulk_out = num_bulk_out;
@@ -980,6 +979,7 @@
 		dev_err(&interface->dev, "No more free serial devices\n");
 		goto probe_error;
 	}
+	serial->minor = minor;
 
 	/* register all of the individual ports with the driver core */
 	for (i = 0; i < num_ports; ++i) {
