Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbXKAK0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbXKAK0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXKAK0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:26:01 -0400
Received: from smtp102.biz.mail.mud.yahoo.com ([68.142.200.237]:30931 "HELO
	smtp102.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754641AbXKAK0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:26:00 -0400
X-YMail-OSG: jFyaD_4VM1ntrOigtizSuZbAILVBDgITrR2v4f6WWp_.VmuHizqu.ZjM0YYD0TEcf7tnpdJiIQ--
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: linux-kernel@vger.kernel.org
Subject: Re: ti_usb_3410_5052 breakage in 2.6.24-rc1
Date: Thu, 1 Nov 2007 03:25:54 -0700
User-Agent: KMail/1.9.7
Cc: Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net
References: <200710312225.44210.sfking@fdwdc.com> <20071101061954.GA11303@kroah.com>
In-Reply-To: <20071101061954.GA11303@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711010325.55147.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Per a suggestion by David Brownwell, rebuilt with CONFIG_USB_DEBUG enabled and 
loading usbserial and ti_usb_3410_5052 with debug=1, I see in 'dmesg'

'drivers/usb/serial/usb-serial.c: wrong number of endpoints'

 which is pretty much what I expected, throwing some more printk's in 
usb-serial gives:

drivers/usb/serial/usb-serial.c: num_interrupt_in = 0, expected 1
drivers/usb/serial/usb-serial.c: num_interrupt_out = 0, expected 0
drivers/usb/serial/usb-serial.c: num_bulk_in = 0, expected 1
drivers/usb/serial/usb-serial.c: num_bulk_out = 1, expected 1

Okay, so
---

Changing num_interrupt_in and num_bulk_in from 1 to NUM_DONT_CARE makes 
ti_usb_3410_5052 work again, but is it the right thing to do?

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 ti_usb_3410_5052.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c 
b/drivers/usb/serial/ti_usb_3410_5052.c
index 1f01494..337f5ce 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -264,8 +264,8 @@ static struct usb_serial_driver ti_1port_device = {
 	.description		= "TI USB 3410 1 port adapter",
 	.usb_driver		= &ti_usb_driver,
 	.id_table		= ti_id_table_3410,
-	.num_interrupt_in	= 1,
-	.num_bulk_in		= 1,
+	.num_interrupt_in	= NUM_DONT_CARE,
+	.num_bulk_in		= NUM_DONT_CARE,
 	.num_bulk_out		= 1,
 	.num_ports		= 1,
 	.attach			= ti_startup,
