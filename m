Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbYGCMBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbYGCMBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbYGCMAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:00:09 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53079 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYGCMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:00:05 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Adam Williamson <awilliamson@mandriva.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents use of device
Date: Thu, 3 Jul 2008 10:05:57 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, bugme-daemon@bugzilla.kernel.org,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org
References: <RzbtSgMztjP.A.jRD._spXIB@albercik> <200807022333.25275.oliver@neukum.org> <1215034900.6054.204.camel@lenovo.local.net>
In-Reply-To: <1215034900.6054.204.camel@lenovo.local.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031005.59691.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 02 Juli 2008 23:41:40 schrieb Adam Williamson:
> On Wed, 2008-07-02 at 23:33 +0200, Oliver Neukum wrote:
> 
> > This is odd. Your device shows one interface with one endpoint bulk and
> > bulk out respectively. Yet two ports are created. Odd.
> 
> OK. If you mean /dev/ttyUSB0 and /dev/ttyUSB1 are always both created
> when the device is plugged in - yep. This is the case in the working

Now this is very hard to explain. From the code in 2.6.25 it is clear that
only ttyUSB0 will be created. Please verify that indeed you get ttyUSB0
and ttyUSB1 with the kernel working for you.

> kernel too. From what I've seen in howtos and the like, this seems to be
> the case for most such devices. Well, let me know what else you need
> from me. :)

As far as I can tell somebody changed the ipaq driver in 2.6.26-rc6. I cannot
find the exact patch that did it in Greg's directory. As it causes a regression
here's a reversal.

	Regards
		Oliver

Signed-off-by: Oliver Neukum <oneukum@suse.de>

---

--- linux-2.6.26-greg/drivers/usb/serial/ipaq.alt.c	2008-07-03 09:01:37.000000000 +0200
+++ linux-2.6.26-greg/drivers/usb/serial/ipaq.c	2008-07-03 09:01:47.000000000 +0200
@@ -570,7 +570,7 @@ static struct usb_serial_driver ipaq_dev
 	.description =		"PocketPC PDA",
 	.usb_driver = 		&ipaq_driver,
 	.id_table =		ipaq_id_table,
-	.num_ports =		2,
+	.num_ports =		1,
 	.open =			ipaq_open,
 	.close =		ipaq_close,
 	.attach =		ipaq_startup,



