Return-Path: <linux-kernel-owner+w=401wt.eu-S1751185AbXCCKi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbXCCKi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 05:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbXCCKi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 05:38:26 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:50549 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXCCKiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 05:38:25 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Andreas Laumann <al@authentidate.de>
Subject: Re: usbserial not working/oops on removal
Date: Sat, 3 Mar 2007 11:38:20 +0100
User-Agent: KMail/1.9.1
Cc: Kevin Fenzi <kevin@scrye.com>, linux-kernel@vger.kernel.org
References: <20070302193715.568098a6@ningauble.scrye.com> <200703030745.19547.oliver@neukum.org> <1172906384.26337.13.camel@justine.inexnet.de>
In-Reply-To: <1172906384.26337.13.camel@justine.inexnet.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703031138.20582.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH43ejgwwk=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 3. März 2007 08:19 schrieb Andreas Laumann:
> Am Samstag, den 03.03.2007, 07:45 +0100 schrieb Oliver Neukum:
> > Am Samstag, 3. März 2007 03:37 schrieb Kevin Fenzi:
> > > I'm seeing some oddity with the latest fedora development kernel and a
> > > usbserial device. 
> > 
> > Very interesting. Is this repeatable? Does unplugging have the same effect?
> 
> I see it also on fedora rawhide using reinersct (cyberjack) scard
> readers and it repeatable.
> The first usbserial devices likes to register the line number 255 which
> indeed is invalid.

OK, please try this patch.

	Regards
		Oliver

--- linux-2.6.21-rc1/drivers/usb/serial/usb-serial.c.alt	2007-02-21 05:32:30.000000000 +0100
+++ linux-2.6.21-rc1/drivers/usb/serial/usb-serial.c	2007-02-26 15:32:50.000000000 +0100
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
