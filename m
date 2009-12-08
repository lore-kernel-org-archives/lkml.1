Return-Path: <linux-kernel-owner+w=401wt.eu-S932083AbZLHPV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbZLHPV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbZLHPV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:21:58 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:33452 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755930AbZLHPV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:21:57 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Tue, 8 Dec 2009 16:21:56 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0912071015180.3064-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912071015180.3064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912081621.57290.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009, Alan Stern wrote:
> On Mon, 7 Dec 2009, Ondrej Zary wrote:
> > > > diff between ehci and uhci logs:
> > > > There seems to be some problem with timing.
> > > > Also order of ehci_usb vs uhci_usb loading changes.
> > >
> > > That order doesn't matter much.  But this...
> >
> > Looks like it does matter. I compiled ehci_hcd in kernel and left
> > uhci_hcd as module - and the hub was always attached to ehci. Compiled
> > uhci_hcd in kernel and ehci_hcd as module - and it was always attached to
> > uhci. So the HW is probably OK.
>
> As a matter of fact, it probably isn't.  The hub should have switched
> over to EHCI when the module was loaded.  The question remains whether
> the problem is in the hub or in the EHCI controller.

This problem seems to be caused by camera:
Bus 002 Device 030: ID 041e:4068 Creative Technology, Ltd Webcam Live! Notebook

When the camera is disconnected, the hub always correctly attaches to ehci.
When the camera is connected directly to the USB port, the hub sometimes
attaches to ehci and sometimes not.
When the camera is connected to the hub, BIOS hangs on the splash screen
on reboot (i.e. can boot only first time after power cycle).

The camera has also a weird "feature". When disconnected and reconnected in
less than 3 seconds, it fails to initialize:
(connected directly)
[   77.032147] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   77.035776] uhci_hcd 0000:00:1d.1: port 2 portsc 0093,00
[   77.039326] hub 3-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
[   77.168197] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
[   77.280199] usb 3-2: new full speed USB device using uhci_hcd and address 4
[   77.286877] usb 3-2: uhci_result_common: failed with status 440000
[   77.292878] usb 3-2: uhci_result_common: failed with status 440000
[   77.299887] usb 3-2: uhci_result_common: failed with status 440000
[   77.412185] usb 3-2: device descriptor read/64, error -71
[   77.519890] usb 3-2: uhci_result_common: failed with status 440000
[   77.526889] usb 3-2: uhci_result_common: failed with status 440000
[   77.532888] usb 3-2: uhci_result_common: failed with status 440000
[   77.648190] usb 3-2: device descriptor read/64, error -71
[   77.864179] usb 3-2: new full speed USB device using uhci_hcd and address 5
[   77.870887] usb 3-2: uhci_result_common: failed with status 440000
[   77.876883] usb 3-2: uhci_result_common: failed with status 440000
[   77.883894] usb 3-2: uhci_result_common: failed with status 440000
[   77.996165] usb 3-2: device descriptor read/64, error -71
[   78.103895] usb 3-2: uhci_result_common: failed with status 440000
[   78.109890] usb 3-2: uhci_result_common: failed with status 440000
[   78.116899] usb 3-2: uhci_result_common: failed with status 440000
[   78.232165] usb 3-2: device descriptor read/64, error -71
[   78.448191] usb 3-2: new full speed USB device using uhci_hcd and address 6
[   78.454890] usb 3-2: uhci_result_common: failed with status 440000
[   78.663897] usb 3-2: uhci_result_common: failed with status 440000
[   78.868108] usb 3-2: device not accepting address 6, error -71
[   78.980165] usb 3-2: new full speed USB device using uhci_hcd and address 7
[   78.986898] usb 3-2: uhci_result_common: failed with status 440000
[   79.195906] usb 3-2: uhci_result_common: failed with status 440000
[   79.400105] usb 3-2: device not accepting address 7, error -71
[   79.403633] hub 3-0:1.0: unable to enumerate USB device on port 2
[   81.000161] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0004
[   81.003625] uhci_hcd 0000:00:1d.1: port 2 portsc 0082,00
[   81.007091] hub 3-0:1.0: port 2, status 0100, change 0001, 12 Mb/s
[   81.136163] hub 3-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100

(connected to hub)
[   45.872440] hub 1-1:1.0: state 7 ports 7 chg 0000 evt 0008
[   45.876320] hub 1-1:1.0: port 3, status 0101, change 0001, 12 Mb/s
[   46.008352] hub 1-1:1.0: debounce: port 3: total 100ms stable 100ms status 0x101
[   46.084365] usb 1-1.3: new full speed USB device using ehci_hcd and address 17
[   46.160373] usb 1-1.3: device descriptor read/64, error -32
[   46.336381] usb 1-1.3: device descriptor read/64, error -32
[   46.512369] usb 1-1.3: new full speed USB device using ehci_hcd and address 18
[   46.588371] usb 1-1.3: device descriptor read/64, error -32
[   46.764370] usb 1-1.3: device descriptor read/64, error -32
[   46.940390] usb 1-1.3: new full speed USB device using ehci_hcd and address 19
[   47.352115] usb 1-1.3: device not accepting address 19, error -32
[   47.428366] usb 1-1.3: new full speed USB device using ehci_hcd and address 20
[   47.840132] usb 1-1.3: device not accepting address 20, error -32
[   47.844156] hub 1-1:1.0: unable to enumerate USB device on port 3
[   47.847949] hub 1-1:1.0: state 7 ports 7 chg 0000 evt 0008
[   47.852220] hub 1-1:1.0: port 3, status 0100, change 0001, 12 Mb/s
[   47.984389] hub 1-1:1.0: debounce: port 3: total 100ms stable 100ms status 0x100


So I'll probably keep the camera disconnected.

-- 
Ondrej Zary
