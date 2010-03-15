Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935766Ab0COH4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:56:31 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:51821 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934691Ab0COH43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:56:29 -0400
Date: Mon, 15 Mar 2010 08:56:26 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1283654668.20100315085626@eikelenboom.it>
To: Libin <libin.yang@amd.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
       <linux-kernel@vger.kernel.org>, <andiry.xu@amd.com>
Subject: Re: [2.6.34-rc1] Problem using USB 1.1 device on USB 3.0 xhci host controller
In-Reply-To: <1268622339.2105.11.camel@younglee-laptop>
References: <1751702501.20100312174345@eikelenboom.it> <20100312232538.GA13353@xanatos> <1622196186.20100313120113@eikelenboom.it> <1268622339.2105.11.camel@younglee-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Libin,

Nope, no system hang, the only symptom is that the device is not working, (v4l application seems to wait for video frames but they do not arrive).

-

Sander

Monday, March 15, 2010, 4:05:39 AM, you wrote:

> On Sat, 2010-03-13 at 12:01 +0100, Sander Eikelenboom wrote:
>> The patches applied cleanly, but the device doesn't work yet.
>> complete dmesg and lsusb -vvv attached.

> Thanks for reporting the issue. We will look into the issue. From the
> description, it seems the initialization has passed, right? What's the
> symptom? Does the system hang?

>> 
>> Highlights from dmesg:
>> 
>> [    1.738043] usb 9-3: skipped 4 descriptors after interface
>> [    1.738045] usb 9-3: skipped 2 descriptors after interface
>> [    1.738048] usb 9-3: skipped 1 descriptor after endpoint
>> [    1.738050] usb 9-3: skipped 2 descriptors after interface
>> [    1.738053] usb 9-3: skipped 1 descriptor after endpoint
>> [    1.738055] usb 9-3: skipped 2 descriptors after interface
>> [    1.738057] usb 9-3: skipped 1 descriptor after endpoint
>> [    1.738059] usb 9-3: skipped 2 descriptors after interface
>> [    1.738061] usb 9-3: skipped 1 descriptor after endpoint
>> [    1.741021] xhci_hcd 0000:03:00.0: WARN: short transfer on control ep
>> [    1.742039] usb 9-3: default language 0x0409
>> [    1.765016] xhci_hcd 0000:03:00.0: WARN: short transfer on control ep
>> [    1.766036] usb 9-3: udev 2, busnum 9, minor = 1025
>> [    1.766038] usb 9-3: New USB device found, idVendor=0471, idProduct=0311
>> [    1.766244] usb 9-3: New USB device strings: Mfr=0, Product=0, SerialNumber=1
>> [    1.766448] usb 9-3: SerialNumber: 01680000EA164101
>> [    1.766811] usb 9-3: usb_probe_device
>> [    1.766813] usb 9-3: configuration #1 chosen from 1 choice
>> [    1.767184] usb 9-3: Successful Endpoint Configure command
>> [    1.769035] usb 9-3: adding 9-3:1.0 (config #1, interface 0)
>> [    1.769151] usb 9-3: adding 9-3:1.1 (config #1, interface 1)
>> [    1.769235] usb 9-3: adding 9-3:1.2 (config #1, interface 2)
>> 
>> [    4.483174] pwc: Philips PCVC740K (ToUCam Pro)/PCVC840 (ToUCam II) USB webcam detected.
>> [    4.515833] xhci_hcd 0000:03:00.0: WARN: short transfer on control ep
>> [    4.516894] pwc: Registered as video0.
>> [    4.518834] xhci_hcd 0000:03:00.0: WARN: Stalled endpoint
>> [    4.520834] xhci_hcd 0000:03:00.0: WARN: Stalled endpoint
>> [    4.521051] Philips webcam 9-3:1.1: usb_probe_interface
>> [    4.521053] Philips webcam 9-3:1.1: usb_probe_interface - got id
>> [    4.521058] Philips webcam 9-3:1.2: usb_probe_interface
>> [    4.521060] Philips webcam 9-3:1.2: usb_probe_interface - got id
>> [    4.521073] usbcore: registered new interface driver Philips webcam
>> 
>> 
>> And when trying to actually grab pictures from the device:
>> 
>> [   12.957593] usb 9-3: Successful Endpoint Configure command
>> [   12.967542] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7ac74000, num_trbs = 10
>> [   12.967553] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7af8c000, num_trbs = 10
>> [   12.985500] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with no TDs queued?
>> [   20.946116] eth1: no IPv6 routers present
>> [   40.029279] usb 9-3: Successful Endpoint Configure command
>> [   40.039186] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7a814000, num_trbs = 10
>> [   40.039198] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7b734000, num_trbs = 10
>> [   40.057195] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with no TDs queued?
>> [   40.216270] usb 9-3: Successful Endpoint Configure command
>> [   40.226183] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7a9c0000, num_trbs = 10
>> [   40.226193] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7a98c000, num_trbs = 10
>> [   40.245183] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with no TDs queued?
>> [   40.399261] usb 9-3: Successful Endpoint Configure command
>> [   40.408210] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7a9c0000, num_trbs = 10
>> [   40.408220] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7a98c000, num_trbs = 10
>> [   47.145805] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with no TDs queued?
>> [   48.076894] usb 9-3: Successful Endpoint Configure command
>> [   48.086805] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7b180000, num_trbs = 10
>> [   48.086816] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7b47c000, num_trbs = 10
>> [   48.105803] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with no TDs queued?
>> [   48.263885] usb 9-3: Successful Endpoint Configure command
>> [   48.273796] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7bba0000, num_trbs = 10
>> [   48.273807] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7af6c000, num_trbs = 10
>> [   48.292793] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with no TDs queued?
>> [   48.446875] usb 9-3: Successful Endpoint Configure command
>> [   48.456784] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7bba0000, num_trbs = 10
>> [   48.456794] usb 9-3: ep 0x85 - urb len = 0x2580 (9600), addr = 0x7af6c000, num_trbs = 10
>> [   51.778648] xhci_hcd 0000:03:00.0: WARN Event TRB for slot 1 ep 10 with no TDs queued?
>> 
>> 
>> 
>> 
>> Saturday, March 13, 2010, 12:25:38 AM, you wrote:
>> 
>> > On Fri, Mar 12, 2010 at 05:43:45PM +0100, Sander Eikelenboom wrote:
>> >> Hi Sarah,
>> >> 
>> >> I'm trying to use an USB 1.1 device on a USB 3.0 host controller, but it doesn't seem to work (tested with kernel versions up to 2.6.34-rc1):
>> >> - with lsusb I can only see a usb 3.0 root hub (with a USB 2.0 host controller, i'am always seeing the roothubs for lower speeds as well, so maybe this is the problem ?)
>> >> - with lsusb I can see the usb 1.1 device connected to the USB 3.0 root hub.
>> >> - the driver from the usb 1.1 device get loaded, but it gives errors, and (it's a webcam) doesn't give video.
>> >> - the manufacturer claims it should be backwards compatible hardware.
>> >> 
>> >> - Should this work with the current (expirimental) state of the xhci-hcd driver in linux ?
>> >> 
>> >> The hardware is (asus U3S6):
>> >> 03:00.0 USB Controller [0c03]: NEC Corporation Device [1033:0194] (rev 03) (prog-if 30)
>> >>         Subsystem: ASUSTeK Computer Inc. Device [1043:8413]
>> 
>> > From the log files, it looks like your usb 1.1 device is a webcam; is
>> > that correct?
>> 
>> >> [    5.097306] pwc: Philips webcam module version 10.0.13 loaded.
>> >> [    5.097507] pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
>> >> [    5.097859] pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
>> >> [    5.098215] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
>> >> [    5.098557] pwc: Trace options: 0x0001
>> >> [    5.098576] Philips webcam 9-3:1.0: usb_probe_interface
>> >> [    5.098578] Philips webcam 9-3:1.0: usb_probe_interface - got id
>> > ...
>> >> [   13.116489] pwc: isoc_init() submit_urb 0 failed with error -22
>> 
>> > Webcams have isochronous endpoints, and the xHCI driver doesn't support
>> > isochronous transfers yet.  There are patches to add isochronous
>> > support, but they're still under going review.  They missed the 2.6.34
>> > merge window, so I'm not sure if they'll make it into 2.6.34 or 2.6.35.
>> > If you want to try them out, the latest versions of the patches are
>> > here:
>> 
>> > http://marc.info/?l=linux-usb&m=126838645617885&w=2
>> > http://marc.info/?l=linux-usb&m=126838648717923&w=2
>> > http://marc.info/?l=linux-usb&m=126838649217932&w=2
>> 
>> > Let me know if they work for you.
>> 
>> > Sarah Sharp





-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

