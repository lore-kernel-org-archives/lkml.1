Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbZLGJDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbZLGJDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759102AbZLGJC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:02:59 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:36871 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758284AbZLGJC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:02:56 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Mon, 7 Dec 2009 10:02:52 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912041614170.3070-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912041614170.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912071002.54308.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 December 2009, Alan Stern wrote:
> On Fri, 4 Dec 2009, Ondrej Zary wrote:
> > [    3.712039] usb 2-1: new full speed USB device using uhci_hcd and
> > address 2 [    3.726791] kjournald starting.  Commit interval 5 seconds
> > [    3.726817] EXT3-fs (sda2): mounted filesystem with ordered data mode
> > [    3.851384] usb 2-1: not running at top speed; connect to a high speed
> > hub [    3.859379] usb 2-1: New USB device found, idVendor=2001,
> > idProduct=f103 [    3.859387] usb 2-1: New USB device strings: Mfr=0,
> > Product=0, SerialNumber=0 [    3.862635] hub 2-1:1.0: USB hub found
> > [    3.864385] hub 2-1:1.0: 7 ports detected
>
> That's the problem.  Notice the "not running at top speed" message?
> Something went wrong when the hub was detected.  It could be a problem
> in your EHCI controller or a problem in the hub.
>
> You can get more information about this by unplugging the hub, running
> usbmon (on the 0u file), and then plugging the hub back in.
>
> > diff between ehci and uhci logs:
> > There seems to be some problem with timing.
> > Also order of ehci_usb vs uhci_usb loading changes.
>
> That order doesn't matter much.  But this...

Looks like it does matter. I compiled ehci_hcd in kernel and left uhci_hcd as 
module - and the hub was always attached to ehci. Compiled uhci_hcd in kernel 
and ehci_hcd as module - and it was always attached to uhci. So the HW is 
probably OK.

> > --- dmesg-ehci.txt-	2009-12-04 20:01:39.000000000 +0100
> > +++ dmesg-uhci.txt-	2009-12-04 20:01:31.000000000 +0100
> > @@ -144,10 +144,9 @@
> >   Console: colour VGA+ 80x25
> >   console [tty0] enabled
> >   hpet clockevent registered
> > - Fast TSC calibration failed
> > - TSC: PIT calibration matches HPET. 1 loops
> > - Detected 1608.000 MHz processor.
> > - Calibrating delay loop (skipped), value calculated using timer
> > frequency.. 3216.00 BogoMIPS (lpj=6432000) + Fast TSC calibration using
> > PIT
> > + Detected 1608.123 MHz processor.
> > + Calibrating delay loop (skipped), value calculated using timer
> > frequency.. 3216.24 BogoMIPS (lpj=6432492) Security Framework initialized
> >   SELinux:  Disabled at boot.
> >   Mount-cache hash table entries: 512
> > @@ -180,7 +179,7 @@
> >   CPU1: Thermal monitoring enabled (TM2)
> >   CPU1: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
> >   Brought up 2 CPUs
> > - Total of 2 processors activated (9326.27 BogoMIPS).
> > + Total of 2 processors activated (6432.20 BogoMIPS).
>
> Those two differences seem strange to me.  You might want to report it
> in a new email thread on LKML.  You might also want to see if the same
> thing happens with a 2.6.32 kernel.
>
> > > This may be a bug in ehci-hcd, a bug in your EHCI hardware, or a bug in
> > > the hub.  Can you try using a different high-speed hub to see if it
> > > makes any difference?
> >
> > Yes, I'll try it next week (I have only remote access now).
> > I have different 7-port hub available to test (should be with Philips
> > chipset).
>
> It's worth a try.  Still, the original problem you saw (the oops in
> ehci-hcd) is in software, not in hardware, so the hub can't be entirely
> responsible.
>
> Alan Stern

-- 
Ondrej Zary
