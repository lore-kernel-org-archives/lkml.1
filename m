Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbZAEJEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbZAEJEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZAEJD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:03:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:13711 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZAEJD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:03:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,331,1228118400"; 
   d="scan'208";a="96414759"
Date: Mon, 5 Jan 2009 17:03:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andreas Mohr <andi@lisas.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: cannot reliably detect USB device
Message-ID: <20090105090339.GA25753@localhost>
References: <20081225104753.GB15733@localhost> <20090101174453.GA3805@rhlx01.hs-esslingen.de> <ac3eb2510901031407m68230817u9a491d982026a5fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510901031407m68230817u9a491d982026a5fe@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 12:07:46AM +0200, Kay Sievers wrote:
> On Thu, Jan 1, 2009 at 18:44, Andreas Mohr <andi@lisas.de> wrote:
> >> > > I have a pl2303 USB-RS232 converter that cannot be reliably
> >> > > detected.
> >> >
> >> > Faulty hardware?  Flaky cables?  Bad connections?  If this is
> >> > reproducable for the same device on multiple machines, I'd just go buy
> >> > a
> >> > new device :)
> >>
> >> I decided to give it a last try before planning a replacement - then I
> >> find that /dev/ttyUSB0 could be created if I enlarge the retry times.
> >>
> >> It could take 10 seconds to get a valid response. It must go crazy.
> >
> > Detected _instantly_ on 2.6.28 here:
> >
> > [59750.560209] usb 1-1: USB disconnect, address 5
> > [59750.561888] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
> > [59750.561970] pl2303 1-1:1.0: device disconnected
> > [59752.904108] usb 1-1: new full speed USB device using uhci_hcd and address 6
> > [59753.059546] usb 1-1: configuration #1 chosen from 1 choice
> > [59753.061460] pl2303 1-1:1.0: pl2303 converter detected
> > [59753.114738] usb 1-1: pl2303 converter now attached to ttyUSB0
> >
> > (the 3-second delay basically was me waiting before reinserting)
> >
> >
> > Bus 001 Device 006: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
> >
> > Label: "GMUS-03 USB Serial Adapter"
> >
> > Detection test only, _not_ used for actual serial communication currently...
> >
> >
> > But there are more PL2303 adapters than flies on this planet,
> > thus someone else also has some input on this?
> 
> Mine works fine with today's Linux git tree:
>   usb 1-2.2: new full speed USB device using uhci_hcd and address 11
>   usb 1-2.2: configuration #1 chosen from 1 choice
>   pl2303 1-2.2:1.0: pl2303 converter detected
>   usb 1-2.2: pl2303 converter now attached to ttyUSB0

Experiments show that my old pl2303 can only be detected in
one particular USB port of HP 6910p, but no luck for lenovo T61.

Till now I have tried one new pl2303 device and two more ch341
devices, and all of them can be detected happily :-)

[27492.928651] usb 3-2: new full speed USB device using uhci_hcd and address 8
[27493.084947] usb 3-2: configuration #1 chosen from 1 choice
[27493.087322] pl2303 3-2:1.0: pl2303 converter detected
[27493.099552] usb 3-2: pl2303 converter now attached to ttyUSB0
[27493.100171] drivers/usb/core/inode.c: creating file '008'
[27493.100440] usb 3-2: New USB device found, idVendor=067b, idProduct=2303
[27493.100447] usb 3-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[28481.464217] usb 3-2: USB disconnect, address 8
[28481.465219] usb 3-2: pl2303_write_bulk_callback - failed resubmitting write urb, error -19
[28481.465229] pl2303 ttyUSB0: pl2303_send - failed submitting write urb, error -19
[28481.468514] pl2303 3-2:1.0: device disconnected
[28481.570055] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0

[28487.656159] usb 3-2: new full speed USB device using uhci_hcd and address 9
[28487.816708] usb 3-2: configuration #1 chosen from 1 choice
[28487.819107] drivers/usb/core/inode.c: creating file '009'
[28487.819439] usb 3-2: New USB device found, idVendor=4348, idProduct=5523
[28487.819447] usb 3-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[28487.819453] usb 3-2: Product: USB-SER!
[28487.879918] USB Serial support registered for ch341-uart
[28487.880045] ch341 3-2:1.0: ch341-uart converter detected
[28487.892767] usb 3-2: ch341-uart converter now attached to ttyUSB0
[28487.892856] usbcore: registered new interface driver ch341
[28489.400229] usb 3-2: USB disconnect, address 9
[28489.406187] ch341-uart ttyUSB0: ch341-uart converter now disconnected from ttyUSB0
[28489.406273] ch341 3-2:1.0: device disconnected

[28494.105148] usb 3-2: new full speed USB device using uhci_hcd and address 10
[28494.269692] usb 3-2: configuration #1 chosen from 1 choice
[28494.271475] ch341 3-2:1.0: ch341-uart converter detected
[28494.284668] usb 3-2: ch341-uart converter now attached to ttyUSB0
[28494.285594] drivers/usb/core/inode.c: creating file '010'
[28494.285862] usb 3-2: New USB device found, idVendor=4348, idProduct=5523
[28494.285870] usb 3-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[28494.285877] usb 3-2: Product: USB-SER!
[28496.344254] usb 3-2: USB disconnect, address 10
[28496.347735] ch341-uart ttyUSB0: ch341-uart converter now disconnected from ttyUSB0
[28496.347819] ch341 3-2:1.0: device disconnected

Thanks,
Fengguang

