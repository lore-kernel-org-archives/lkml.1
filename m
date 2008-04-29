Return-Path: <linux-kernel-owner+w=401wt.eu-S1764750AbYD2Sxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764750AbYD2Sxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762235AbYD2SvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:51:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:41379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348AbYD2SvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:51:11 -0400
Date: Tue, 29 Apr 2008 11:50:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oliver Neukum <oliver@neukum.org>
Subject: [09/12] USB: remove broken usb-serial num_endpoints check
Message-ID: <20080429185002.GK24199@suse.de>
References: <20080429184543.308594866@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-remove-broken-usb-serial-num_endpoints-check.patch"
In-Reply-To: <20080429184911.GA24199@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit: 07c3b1a1001614442c665570942a3107a722c314

The num_interrupt_in, num_bulk_in, and other checks in the usb-serial
code are just wrong, there are too many different devices out there with
different numbers of endpoints.  We need to just be sticking with the
device ids instead of trying to catch this kind of thing.  It broke too
many different devices.

This fixes a large number of usb-serial devices to get them working
properly again.


Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/usb-serial.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -844,6 +844,7 @@ int usb_serial_probe(struct usb_interfac
 	serial->num_interrupt_in = num_interrupt_in;
 	serial->num_interrupt_out = num_interrupt_out;
 
+#if 0
 	/* check that the device meets the driver's requirements */
 	if ((type->num_interrupt_in != NUM_DONT_CARE &&
 				type->num_interrupt_in != num_interrupt_in)
@@ -857,6 +858,7 @@ int usb_serial_probe(struct usb_interfac
 		kfree(serial);
 		return -EIO;
 	}
+#endif
 
 	/* found all that we need */
 	dev_info(&interface->dev, "%s converter detected\n",

-- 
