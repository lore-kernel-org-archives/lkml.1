Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYLINET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYLINET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 08:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYLINEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 08:04:09 -0500
Received: from mx-out.forthnet.gr ([193.92.150.104]:43943 "EHLO
	mx-out.forthnet.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYLINEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 08:04:08 -0500
X-Greylist: delayed 1884 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 08:04:07 EST
Authentication-Results: MX-IN-01.forthnet.gr smtp.mail=markos.chandras@gmail.com; spf=neutral
Authentication-Results: MX-IN-01.forthnet.gr header.from=markos.chandras@gmail.com; sender-id=neutral
From: Markos Chandras <markos.chandras@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] bluetooth usb hci: ISSC usb dongle with buggy SCO support
Date: Tue, 9 Dec 2008 14:31:41 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.26-gentoo-r4; KDE/4.1.3; x86_64; ; )
Cc: Luca Santarelli <hrk@users.sourceforge.net>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200812050002.13560.hrk@users.sourceforge.net> <20081207001953.c04b9357.akpm@linux-foundation.org>
In-Reply-To: <20081207001953.c04b9357.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091431.41917.markos.chandras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 December 2008 10:19:53 Andrew Morton wrote:
> On Fri, 5 Dec 2008 00:02:13 +0100 Luca Santarelli 
<hrk@users.sourceforge.net> wrote:
> > From: Luca Santarelli <hrk <t> users.sourceforge.net>
> >
> > As reported at:
> > http://bugs.gentoo.org/show_bug.cgi?id=249523
> > and in reference of similar patches such as:
> > http://thread.gmane.org/gmane.linux.bluez.devel/15067
> >
> > This patch changes the blacklist entry for the ISSC bluetooth USB
> > dongle fixing the issue of the repeatedly appearing message
> >
> >   hci_scodata_packet: hci0 SCO packet for unknown connection handle 92
> >
> > in the kernel logs.
> >
> > Sighed-off-by: Luca Santarelli <hrk <at> users.sourceforge.net>
> > ---
> > This is my first kernel patch ever, I read the docs, but please notify
> > me if I made any mistake. Thank you all for your work, I'm happy to have
> > been able to contribute to this!
> >
> > The patch has been run against 2.6.27.7 and has been tested on three x86
> > machines, showing no issues. In my own tests, the dongle has been then
> > used to connect to devices and everything worked fine.
> >
> > --- linux-2.6.27.7/drivers/bluetooth/hci_usb.c.orig	2008-12-04
> > 20:18:38.000000000 +0100 +++
> > linux-2.6.27.7/drivers/bluetooth/hci_usb.c	2008-12-04 20:19:37.000000000
> > +0100 @@ -148,8 +148,8 @@ static struct usb_device_id blacklist_id
> >  	{ USB_DEVICE(0x047d, 0x105d), .driver_info = HCI_RESET },
> >  	{ USB_DEVICE(0x047d, 0x105e), .driver_info = HCI_RESET |
> > HCI_WRONG_SCO_MTU },
> >
> > -	/* ISSC Bluetooth Adapter v3.1 */
> > -	{ USB_DEVICE(0x1131, 0x1001), .driver_info = HCI_RESET },
> > +	/* ISSC Bluetooth Adapter v3.1 with buggy SCO support */
> > +	{ USB_DEVICE(0x1131, 0x1001), .driver_info = HCI_RESET |
> > HCI_BROKEN_ISOC },
> >
> >  	/* RTX Telecom based adapters with buggy SCO support */
> >  	{ USB_DEVICE(0x0400, 0x0807), .driver_info = HCI_BROKEN_ISOC },
>
> linux-next has:
>
> commit 12421b40b81d101d7535e03f1af197365adc932b
> Author: Marcel Holtmann <marcel@holtmann.org>
> Date:   Sun Nov 30 12:17:21 2008 +0100
>
>     Bluetooth: Remove deprecated hci_usb driver
>
>     The old hci_usb driver has been fully replaced with the new btusb
> driver and all major distributions switched to the new driver now. This
> removes it since it should not be used at all anymore.
>
> so please confirm that btusb correctly supports that hardware?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Unfortunatelly it doesnt work here. The new driver cant recognize my device. I 
am using gentoo-sources-2.6.26-r4 ( which means linux-sources-2.6.26-5).

I ll post again my device info from lsusb. I ll try to come up with a patch is 
possible

Bus 002 Device 002: ID 1131:1001 Integrated System Solution Corp. KY-BT100 
Bluetooth Adapter

Thanks
-- 
Markos Chandras
