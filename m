Return-Path: <linux-kernel-owner+w=401wt.eu-S966827AbXIKGlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966827AbXIKGlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXIKGj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:39:29 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55177 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040AbXIKGj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:39:27 -0400
Date: Mon, 10 Sep 2007 23:35:02 -0700
From: Greg KH <greg@kroah.com>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Problem charging blackberry 8700c with berry_charge (2.6.22.6)
Message-ID: <20070911063502.GK27404@kroah.com>
References: <20070908220229.6e669e62.kernel1@cyberdogtech.com> <20070909105212.GA14929@kroah.com> <20070909144356.cdf6a5b3.kernel1@cyberdogtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909144356.cdf6a5b3.kernel1@cyberdogtech.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 09, 2007 at 02:43:56PM -0400, Matt LaPlante wrote:
> On Sun, 9 Sep 2007 03:52:12 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Sat, Sep 08, 2007 at 10:02:29PM -0400, Matt LaPlante wrote:
> > > I'm running the 2.6.22.6 kernel with the berry_charge module loaded.
> > > I connect my 8700c via USB, but the blackberry does not appear to
> > > charge. The power icon does not change, and even after staying
> > > connected for an extended period, the device does not appear to be
> > > gaining any power.  The cable is good, as I can plug it into my
> > > Windows machine and it begins charging immediately.  I see the
> > > following in dmesg:
> > > 
> > > [ 6638.606493] usb 1-2: new full speed USB device using uhci_hcd and address 2
> > > [ 6638.776524] usb 1-2: configuration #1 chosen from 1 choice
> > > [ 6639.639611] usbcore: registered new interface driver berry_charge
> > > [ 6639.837097] usb 1-2: Second magic command failed: -71.
> > 
> > 
> > Ick, that's not nice.  Can you enable CONFIG_USB_DEBUG and debugging for
> > the berry_charge driver:
> > 	modprobe berry_charge debug=1
> > 
> > and let us know what happens?
> 
> Here you go...

This looks really odd:

> Sep  9 13:49:00 prizm kernel: [  583.455679] berry_charge 1-2:1.0: usb_probe_interface
> Sep  9 13:49:00 prizm kernel: [  583.455681] berry_charge 1-2:1.0: usb_probe_interface - got id
> Sep  9 13:49:00 prizm kernel: [  583.455685] usb 1-2: Power is set to 100mA
> Sep  9 13:49:00 prizm kernel: [  583.455687] usb 1-2: Sending first magic command
> Sep  9 13:49:00 prizm kernel: [  583.457577] usb 1-2: Sending second magic command
> Sep  9 13:49:00 prizm kernel: [  583.458578] usb 1-2: Calling set_configuration
> Sep  9 13:49:00 prizm kernel: [  583.458727] drivers/usb/core/inode.c: creating file '002'
> Sep  9 13:49:00 prizm kernel: [  583.458741] usb 1-2: usb_disable_device nuking non-ep0 URBs
> Sep  9 13:49:00 prizm kernel: [  583.458744] usb 1-2: unregistering interface 1-2:1.0

Ok, we send everything properly but then things get wierd:

> Sep  9 13:49:00 prizm kernel: [  583.461732] berry_charge 1-2:1.0: usb_probe_interface
> Sep  9 13:49:00 prizm kernel: [  583.461734] berry_charge 1-2:1.0: usb_probe_interface - got id
> Sep  9 13:49:00 prizm kernel: [  583.461738] usb 1-2: Power is set to 100mA
> Sep  9 13:49:00 prizm kernel: [  583.461740] usb 1-2: Sending first magic command
> Sep  9 13:49:00 prizm kernel: [  583.462615] usb 1-2: Sending second magic command
> Sep  9 13:49:00 prizm kernel: [  583.463568] usb 1-2: Calling set_configuration
> Sep  9 13:49:00 prizm kernel: [  583.463679] usb 1-2: usb_disable_device nuking non-ep0 URBs
> Sep  9 13:49:00 prizm kernel: [  583.463683] usb 1-2: unregistering interface 1-2:1.0

We do it again.

> Sep  9 13:49:00 prizm kernel: [  583.465623] berry_charge 1-2:1.0: usb_probe_interface
> Sep  9 13:49:00 prizm kernel: [  583.465625] berry_charge 1-2:1.0: usb_probe_interface - got id
> Sep  9 13:49:00 prizm kernel: [  583.465642] usb 1-2: Power is set to 100mA
> Sep  9 13:49:00 prizm kernel: [  583.465644] usb 1-2: Sending first magic command
> Sep  9 13:49:00 prizm kernel: [  583.466570] usb 1-2: Sending second magic command
> Sep  9 13:49:00 prizm kernel: [  583.467566] usb 1-2: Calling set_configuration
> Sep  9 13:49:00 prizm kernel: [  583.467675] usb 1-2: usb_disable_device nuking non-ep0 URBs
> Sep  9 13:49:00 prizm kernel: [  583.467679] usb 1-2: unregistering interface 1-2:1.0

And again.

> Sep  9 13:49:00 prizm kernel: [  583.469613] berry_charge 1-2:1.0: usb_probe_interface
> Sep  9 13:49:00 prizm kernel: [  583.469616] berry_charge 1-2:1.0: usb_probe_interface - got id
> Sep  9 13:49:00 prizm kernel: [  583.469619] usb 1-2: Power is set to 100mA
> Sep  9 13:49:00 prizm kernel: [  583.469621] usb 1-2: Sending first magic command
> Sep  9 13:49:00 prizm kernel: [  583.470568] usb 1-2: Sending second magic command
> Sep  9 13:49:00 prizm kernel: [  583.471565] usb 1-2: Calling set_configuration
> Sep  9 13:49:00 prizm kernel: [  583.471671] usb 1-2: usb_disable_device nuking non-ep0 URBs
> Sep  9 13:49:00 prizm kernel: [  583.471674] usb 1-2: unregistering interface 1-2:1.0

And so on, numerous times.

This continues for a long time, until finally:

> Sep  9 13:49:01 prizm kernel: [  583.659570] berry_charge 1-2:1.0: usb_probe_interface
> Sep  9 13:49:01 prizm kernel: [  583.659572] berry_charge 1-2:1.0: usb_probe_interface - got id
> Sep  9 13:49:01 prizm kernel: [  583.659575] usb 1-2: Power is set to 100mA
> Sep  9 13:49:01 prizm kernel: [  583.659577] usb 1-2: Sending first magic command
> Sep  9 13:49:01 prizm kernel: [  583.660516] usb 1-2: Sending second magic command
> Sep  9 13:49:01 prizm kernel: [  583.661506] usb 1-2: uhci_result_common: failed with status 440000
> Sep  9 13:49:01 prizm kernel: [  583.661518] usb 1-2: Second magic command failed: -71.

The command fails, and _then_ the blackberry finally resets itself:


> Sep  9 13:49:01 prizm kernel: [  583.760363] hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0004
> Sep  9 13:49:01 prizm kernel: [  583.760377] ehci_hcd 0000:00:10.4: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
> Sep  9 13:49:01 prizm kernel: [  583.760384] hub 5-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
> Sep  9 13:49:01 prizm kernel: [  583.885625] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
> Sep  9 13:49:01 prizm kernel: [  583.941788] ehci_hcd 0000:00:10.4: port 2 full speed --> companion
> Sep  9 13:49:01 prizm kernel: [  583.941797] ehci_hcd 0000:00:10.4: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
> Sep  9 13:49:01 prizm kernel: [  583.941829] hub 5-0:1.0: port 2 not reset yet, waiting 50ms
> Sep  9 13:49:01 prizm kernel: [  583.997680] ehci_hcd 0000:00:10.4: GetStatus port 2 status 003802 POWER OWNER sig=j CSC
> Sep  9 13:49:01 prizm kernel: [  583.997713] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
> Sep  9 13:49:01 prizm kernel: [  583.997725] uhci_hcd 0000:00:10.0: port 2 portsc 009b,00
> Sep  9 13:49:01 prizm kernel: [  583.997737] hub 1-0:1.0: port 2, status 0101, change 0003, 12 Mb/s
> Sep  9 13:49:01 prizm kernel: [  583.997740] usb 1-2: USB disconnect, address 2
> Sep  9 13:49:01 prizm kernel: [  583.997742] usb 1-2: unregistering device
> Sep  9 13:49:01 prizm kernel: [  583.997744] usb 1-2: usb_disable_device nuking all URBs
> Sep  9 13:49:01 prizm kernel: [  583.997750] usb 1-2: unregistering interface 1-2:1.0

And the device comes back like expected:

> Sep  9 13:49:01 prizm kernel: [  584.237606] usb 1-2: new full speed USB device using uhci_hcd and address 3
> Sep  9 13:49:01 prizm kernel: [  584.373586] usb 1-2: ep0 maxpacket = 16
> Sep  9 13:49:01 prizm kernel: [  584.393318] usb 1-2: default language 0x0409
> Sep  9 13:49:01 prizm kernel: [  584.405319] usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
> Sep  9 13:49:01 prizm kernel: [  584.405326] usb 1-2: Product: BlackBerry Device
> Sep  9 13:49:01 prizm kernel: [  584.405328] usb 1-2: Manufacturer: Research In Motion
> Sep  9 13:49:01 prizm kernel: [  584.405366] usb 1-2: uevent
> Sep  9 13:49:01 prizm kernel: [  584.405385] usb 1-2: usb_probe_device
> Sep  9 13:49:01 prizm kernel: [  584.405435] usb 1-2: configuration #1 chosen from 1 choice
> Sep  9 13:49:01 prizm kernel: [  584.407317] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
> Sep  9 13:49:01 prizm kernel: [  584.407342] usb 1-2:1.0: uevent
> Sep  9 13:49:01 prizm kernel: [  584.407347] usb 1-2:1.0: uevent
> Sep  9 13:49:01 prizm kernel: [  584.407367] berry_charge 1-2:1.0: usb_probe_interface
> Sep  9 13:49:01 prizm kernel: [  584.407370] berry_charge 1-2:1.0: usb_probe_interface - got id
> Sep  9 13:49:01 prizm kernel: [  584.407373] usb 1-2: Power is set to 500mA
> Sep  9 13:49:01 prizm kernel: [  584.407375] usb 1-2: device is already charging, power is set to 500mA

And the device is properly charging.

So, it should all be working now, it's just that we kept sending things
over and over and over, which is very strange.

> Sep  9 13:49:01 prizm kernel: [  584.407498] drivers/usb/core/inode.c: creating file '003'
> Sep  9 13:49:01 prizm kernel: [  584.407509] hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0004
> Sep  9 13:49:01 prizm kernel: [  584.407520] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
> Sep  9 13:49:03 prizm kernel: [  586.405512] usb 1-2: usb auto-suspend
> Sep  9 13:49:03 prizm kernel: [  586.421471] hub 5-0:1.0: hub_suspend
> Sep  9 13:49:03 prizm kernel: [  586.421481] ehci_hcd 0000:00:10.4: suspend root hub
> Sep  9 13:49:03 prizm kernel: [  586.421496] usb usb5: usb auto-suspend
> Sep  9 13:49:05 prizm kernel: [  588.421351] hub 1-0:1.0: hub_suspend
> Sep  9 13:49:05 prizm kernel: [  588.421361] usb usb1: suspend_rh
> Sep  9 13:49:05 prizm kernel: [  588.421481] usb usb1: usb auto-suspend

Ah, oh wait, now we just turned the power off.

Try disabling CONFIG_USB_SUSPEND and see if that fixes this issue.  Or
you can manually turn the power back on to your blackberry by writing to
the autosuspend file for the usb device in sysfs, but that can be a
pain.

Let me know if just changing that config option works for you.

thanks,

greg k-h
