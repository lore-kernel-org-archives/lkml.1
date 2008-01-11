Return-Path: <linux-kernel-owner+w=401wt.eu-S1761868AbYAKVDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761868AbYAKVDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 16:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761799AbYAKVDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 16:03:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761711AbYAKVDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 16:03:03 -0500
Date: Fri, 11 Jan 2008 13:02:34 -0800
From: Greg KH <gregkh@suse.de>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Message-ID: <20080111210234.GA3070@suse.de>
References: <1199992265.9266.19.camel@linux-z60t> <20080110195403.GA29384@suse.de> <3415E2A2AB26944B9159CDB22001004D022572F5@nestea.sierrawireless.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3415E2A2AB26944B9159CDB22001004D022572F5@nestea.sierrawireless.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 09:24:36AM -0800, Kevin Lloyd wrote:
> > Those device ids are already in my tree, as it was my understanding
> that
> > you would not be sending me patches for them :)
> You're right, I normally wouldn't, but since someone else already had, I
> figured it would be alright.
> > I'll split this patch up into something that updates the device ids
> and
> > then does all of the other changes.  The device ids can go into 2.6.24
> > (and -stable if I miss the merge window), but the other changes should
> > wait until 2.6.25.
> >
> > Any objection to this?
> Actually some of the added functionality (calc_num_ports) is required
> for
> device 0x0023 and will be necessary for future devices (should someone 
> want to add the VID/PID of a new device it will likely require the added
> 
> support).
> 
> So my preference would be to please include the other changes in the 
> 2.6.24 release.

Hm, no, the intrusion into the driver is just too much this late in the
release cycle to allow this.

Now I will be glad to only add the new device ids for the devices that
do not rely on the new changes right now, but that's it.

So, right now I have a separate patch split out of your original one
that is below.  Should I modify it and not include some of these device
ids right now?  You mention 0023, is that the only one I should remove
from this patch?

thanks,

greg k-h

-------------

From: Kevin Lloyd <klloyd@sierrawireless.com>
Subject: USB: sierra driver - add devices

From: Kevin Lloyd <linux@sierrawireless.com>

The following improvements were made:
 - Added new product support: MC5725, AC 880 U, MP 3G (UMTS & CDMA)

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/sierra.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -104,6 +104,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U */
+	{ USB_DEVICE(0x1199, 0x0023) },	/* Sierra Wireless AirCard */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
@@ -117,8 +118,12 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E */
+	{ USB_DEVICE(0x1199, 0x6855) },	/* Sierra Wireless AirCard 880 U */
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881 U */
 
+	{ USB_DEVICE(0x1199, 0x6468) }, /* Sierra Wireless MP3G - EVDO */
+	{ USB_DEVICE(0x1199, 0x6469) }, /* Sierra Wireless MP3G - UMTS/HSPA */
+
 	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
 	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
 
@@ -143,6 +148,7 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
 	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U*/
+	{ USB_DEVICE(0x1199, 0x0023) },	/* Sierra Wireless AirCard */
 
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
@@ -156,7 +162,10 @@ static struct usb_device_id id_table_3po
 	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
 	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880E */
 	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881E */
+	{ USB_DEVICE(0x1199, 0x6855) },	/* Sierra Wireless AirCard 880 U */
 	{ USB_DEVICE(0x1199, 0x6856) },	/* Sierra Wireless AirCard 881U */
+	{ USB_DEVICE(0x1199, 0x6468) }, /* Sierra Wireless MP3G - EVDO */
+	{ USB_DEVICE(0x1199, 0x6469) }, /* Sierra Wireless MP3G - UMTS/HSPA */
 	{ }
 };
 
