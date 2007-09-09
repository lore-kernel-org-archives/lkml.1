Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbXIISoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbXIISoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 14:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbXIISoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 14:44:11 -0400
Received: from mail3.cyberdogtech.com ([209.40.194.40]:42594 "EHLO
	mail3.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758858AbXIISoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 14:44:08 -0400
Date: Sun, 9 Sep 2007 14:43:56 -0400
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: Problem charging blackberry 8700c with berry_charge (2.6.22.6)
Message-Id: <20070909144356.cdf6a5b3.kernel1@cyberdogtech.com>
In-Reply-To: <20070909105212.GA14929@kroah.com>
References: <20070908220229.6e669e62.kernel1@cyberdogtech.com>
	<20070909105212.GA14929@kroah.com>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.13; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2007 03:52:12 -0700
Greg KH <greg@kroah.com> wrote:

> On Sat, Sep 08, 2007 at 10:02:29PM -0400, Matt LaPlante wrote:
> > I'm running the 2.6.22.6 kernel with the berry_charge module loaded.
> > I connect my 8700c via USB, but the blackberry does not appear to
> > charge. The power icon does not change, and even after staying
> > connected for an extended period, the device does not appear to be
> > gaining any power.  The cable is good, as I can plug it into my
> > Windows machine and it begins charging immediately.  I see the
> > following in dmesg:
> > 
> > [ 6638.606493] usb 1-2: new full speed USB device using uhci_hcd and address 2
> > [ 6638.776524] usb 1-2: configuration #1 chosen from 1 choice
> > [ 6639.639611] usbcore: registered new interface driver berry_charge
> > [ 6639.837097] usb 1-2: Second magic command failed: -71.
> 
> 
> Ick, that's not nice.  Can you enable CONFIG_USB_DEBUG and debugging for
> the berry_charge driver:
> 	modprobe berry_charge debug=1
> 
> and let us know what happens?

Here you go...

Sep  9 13:47:58 prizm kernel: [  521.256235] usbcore: registered new interface driver berry_charge
Sep  9 13:49:00 prizm kernel: [  582.750808] usb usb5: usb resume
Sep  9 13:49:00 prizm kernel: [  582.750814] usb usb5: finish resume
Sep  9 13:49:00 prizm kernel: [  582.750825] hub 5-0:1.0: hub_resume
Sep  9 13:49:00 prizm kernel: [  582.750828] ehci_hcd 0000:00:10.4: resume root hub
Sep  9 13:49:00 prizm kernel: [  582.793723] hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0000
Sep  9 13:49:00 prizm kernel: [  582.793864] ehci_hcd 0000:00:10.4: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
Sep  9 13:49:00 prizm kernel: [  582.793978] hub 5-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
Sep  9 13:49:00 prizm kernel: [  582.923607] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
Sep  9 13:49:00 prizm kernel: [  582.981556] ehci_hcd 0000:00:10.4: port 2 full speed --> companion
Sep  9 13:49:00 prizm kernel: [  582.981565] ehci_hcd 0000:00:10.4: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
Sep  9 13:49:00 prizm kernel: [  582.981676] usb usb1: usb resume
Sep  9 13:49:00 prizm kernel: [  582.981678] usb usb1: finish resume
Sep  9 13:49:00 prizm kernel: [  582.981684] hub 1-0:1.0: hub_resume
Sep  9 13:49:00 prizm kernel: [  582.981686] usb usb1: wakeup_rh
Sep  9 13:49:00 prizm kernel: [  582.993728] hub 5-0:1.0: port 2 not reset yet, waiting 50ms
Sep  9 13:49:00 prizm kernel: [  583.049727] ehci_hcd 0000:00:10.4: GetStatus port 2 status 003802 POWER OWNER sig=j CSC
Sep  9 13:49:00 prizm kernel: [  583.049906] hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0004
Sep  9 13:49:00 prizm kernel: [  583.049982] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
Sep  9 13:49:00 prizm kernel: [  583.050058] uhci_hcd 0000:00:10.0: port 2 portsc 0093,00
Sep  9 13:49:00 prizm kernel: [  583.050128] hub 1-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
Sep  9 13:49:00 prizm kernel: [  583.177674] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
Sep  9 13:49:00 prizm kernel: [  583.289675] usb 1-2: new full speed USB device using uhci_hcd and address 2
Sep  9 13:49:00 prizm kernel: [  583.421643] usb 1-2: ep0 maxpacket = 16
Sep  9 13:49:00 prizm kernel: [  583.441583] usb 1-2: default language 0x0409
Sep  9 13:49:00 prizm kernel: [  583.453603] usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
Sep  9 13:49:00 prizm kernel: [  583.453609] usb 1-2: Product: BlackBerry Device
Sep  9 13:49:00 prizm kernel: [  583.453611] usb 1-2: Manufacturer: Research In Motion
Sep  9 13:49:00 prizm kernel: [  583.453661] usb 1-2: uevent
Sep  9 13:49:00 prizm kernel: [  583.453685] usb 1-2: usb_probe_device
Sep  9 13:49:00 prizm kernel: [  583.453736] usb 1-2: configuration #1 chosen from 1 choice
Sep  9 13:49:00 prizm kernel: [  583.455613] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.455652] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.455657] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.455679] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.455681] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.455685] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.455687] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.457577] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.458578] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.458727] drivers/usb/core/inode.c: creating file '002'
Sep  9 13:49:00 prizm kernel: [  583.458741] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.458744] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.458770] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.458787] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.458803] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.458820] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.458833] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.458837] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.461663] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.461706] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.461711] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.461732] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.461734] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.461738] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.461740] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.462615] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.463568] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.463679] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.463683] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.463707] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.463725] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.463741] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.463757] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.463769] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.463774] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.465576] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.465602] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.465606] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.465623] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.465625] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.465642] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.465644] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.466570] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.467566] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.467675] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.467679] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.467703] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.467721] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.467739] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.467756] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.467768] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.467773] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.469573] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.469594] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.469599] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.469613] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.469616] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.469619] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.469621] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.470568] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.471565] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.471671] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.471674] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.471696] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.471714] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.471731] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.471748] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.471760] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.471764] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.473571] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.473593] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.473598] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.473613] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.473615] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.473618] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.473620] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.474583] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.475580] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.475688] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.475691] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.475714] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.475732] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.475749] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.475766] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.475778] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.475782] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.477574] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.477600] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.477605] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.477621] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.477624] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.477634] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.477636] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.478566] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.479563] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.479674] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.479677] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.479700] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.479718] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.479735] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.479752] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.479763] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.479768] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.481570] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.481592] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.481596] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.481611] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.481614] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.481617] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.481619] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.482563] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.483561] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.483671] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.483674] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.483696] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.483714] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.483731] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.483749] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.483760] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.483765] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.485571] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.485593] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.485598] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.485614] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.485617] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.485620] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.485622] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.486564] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.487560] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.487668] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.487672] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.487695] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.487714] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.487731] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.487748] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.487760] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.487764] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.489569] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.489595] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.489599] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.489616] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.489618] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.489622] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.489624] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.490564] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.491560] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.491670] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.491673] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.491696] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.491713] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.491730] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.491746] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.491758] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.491763] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.493567] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.493591] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.493596] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.493613] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.493615] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.493618] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.493620] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.494575] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.495581] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.495693] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.495697] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:00 prizm kernel: [  583.495719] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:00 prizm kernel: [  583.495737] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:00 prizm kernel: [  583.495754] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:00 prizm kernel: [  583.495771] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:00 prizm kernel: [  583.495784] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.495789] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.497566] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:00 prizm kernel: [  583.497591] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.497596] usb 1-2:1.0: uevent
Sep  9 13:49:00 prizm kernel: [  583.497612] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:00 prizm kernel: [  583.497614] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:00 prizm kernel: [  583.497618] usb 1-2: Power is set to 100mA
Sep  9 13:49:00 prizm kernel: [  583.497620] usb 1-2: Sending first magic command
Sep  9 13:49:00 prizm kernel: [  583.498560] usb 1-2: Sending second magic command
Sep  9 13:49:00 prizm kernel: [  583.499558] usb 1-2: Calling set_configuration
Sep  9 13:49:00 prizm kernel: [  583.499669] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:00 prizm kernel: [  583.499672] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.499694] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.499712] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.499729] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.499746] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.499758] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.499763] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.502562] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.502590] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.502594] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.502611] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.502613] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.502617] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.502619] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.503564] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.504556] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.504670] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.504674] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.504697] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.504714] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.504731] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.504748] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.504760] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.504765] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.506562] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.506586] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.506590] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.506606] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.506608] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.506611] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.506613] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.507560] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.508554] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.508666] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.508670] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.508693] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.508711] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.508728] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.508746] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.508758] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.508762] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.510562] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.510587] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.510591] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.510607] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.510610] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.510613] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.510615] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.511557] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.512553] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.512660] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.512664] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.512685] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.512703] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.512720] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.512736] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.512748] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.512752] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.514563] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.514591] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.514595] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.514612] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.514615] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.514618] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.514620] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.515557] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.516552] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.516667] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.516670] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.516694] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.516712] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.516730] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.516746] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.516759] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.516763] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.518561] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.518588] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.518592] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.518609] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.518611] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.518615] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.518617] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.519555] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.520551] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.520658] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.520661] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.520683] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.520700] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.520717] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.520733] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.520745] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.520749] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.522582] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.522609] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.522613] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.522630] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.522632] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.522636] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.522638] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.523570] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.524550] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.524663] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.524666] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.524690] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.524707] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.524725] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.524742] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.524755] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.524759] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.526560] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.526585] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.526590] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.526607] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.526609] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.526612] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.526614] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.527553] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.528549] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.528660] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.528663] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.528686] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.528704] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.528721] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.528737] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.528749] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.528754] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.530559] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.530585] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.530590] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.530607] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.530609] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.530612] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.530614] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.531552] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.532547] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.532662] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.532666] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.532689] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.532707] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.532723] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.532741] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.532753] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.532757] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.534559] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.534585] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.534590] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.534606] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.534609] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.534612] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.534614] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.535551] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.536546] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.536655] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.536659] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.536681] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.536699] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.536717] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.536734] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.536747] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.536751] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.538557] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.538585] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.538589] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.538605] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.538607] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.538610] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.538613] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.539549] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.540545] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.540653] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.540656] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.540679] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.540696] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.540713] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.540729] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.540742] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.540747] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.542555] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.542579] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.542583] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.542600] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.542603] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.542606] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.542608] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.543550] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.544544] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.544654] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.544658] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.544681] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.544698] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.544715] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.544731] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.544743] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.544747] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.546582] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.546610] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.546614] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.546631] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.546633] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.546637] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.546639] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.547567] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.548543] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.548658] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.548662] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.548685] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.548703] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.548720] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.548737] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.548749] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.548753] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.551550] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.551575] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.551579] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.551596] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.551598] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.551601] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.551603] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.552550] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.553541] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.553667] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.553670] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.553694] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.553712] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.553729] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.553750] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.553762] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.553767] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.556549] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.556576] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.556580] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.556597] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.556599] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.556602] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.556604] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.557546] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.558546] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.558671] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.558674] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.558697] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.558715] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.558731] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.558756] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.558769] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.558774] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.561552] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.561583] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.561588] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.561606] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.561608] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.561612] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.561614] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.562551] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.563540] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.563660] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.563664] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.563688] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.563706] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.563723] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.563749] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.563762] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.563766] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.565548] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.565572] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.565576] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.565592] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.565594] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.565598] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.565600] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.566544] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.567539] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.567653] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.567656] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.567680] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.567698] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.567715] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.567740] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.567753] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.567757] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.569546] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.569570] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.569574] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.569591] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.569593] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.569596] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.569598] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.570566] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.571550] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.571672] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.571676] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.571700] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.571719] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.571737] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.571755] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.571776] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.571781] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.573545] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.573569] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.573574] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.573589] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.573591] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.573594] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.573596] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.574541] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.575535] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.575654] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.575657] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.575681] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.575698] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.575715] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.575731] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.575753] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.575757] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.577551] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.577578] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.577582] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.577600] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.577602] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.577606] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.577608] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.578540] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.579536] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.579659] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.579663] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.579686] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.579705] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.579722] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.579739] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.579760] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.579765] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.581544] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.581568] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.581572] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.581589] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.581591] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.581594] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.581596] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.582540] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.583533] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.583652] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.583656] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.583680] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.583698] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.583714] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.583731] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.583754] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.583758] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.585543] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.585568] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.585573] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.585589] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.585591] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.585595] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.585597] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.586539] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.587533] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.587649] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.587653] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.587676] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.587694] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.587711] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.587727] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.587748] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.587752] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.589541] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.589566] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.589570] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.589586] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.589589] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.589592] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.589594] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.590555] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.591554] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.591676] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.591679] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.591703] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.591721] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.591739] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.591755] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.591776] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.591781] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.594544] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.594576] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.594580] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.594597] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.594600] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.594603] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.594605] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.595536] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.596530] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.596650] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.596653] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.596677] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.596695] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.596712] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.596729] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.596742] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.596746] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.599539] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.599570] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.599575] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.599593] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.599595] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.599598] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.599601] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.600539] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.601528] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.601668] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.601672] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.601694] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.601712] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.601728] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.601745] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.601757] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.601762] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.604538] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.604566] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.604571] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.604589] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.604591] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.604595] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.604597] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.605534] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.606527] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.606643] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.606646] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.606670] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.606688] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.606704] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.606722] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.606735] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.606739] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.609538] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.609568] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.609572] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.609590] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.609592] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.609595] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.609597] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.610533] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.611525] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.611643] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.611647] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.611671] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.611688] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.611705] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.611722] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.611734] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.611739] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.613537] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.613564] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.613569] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.613585] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.613588] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.613591] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.613593] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.614527] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.615527] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.615650] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.615654] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.615678] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.615696] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.615714] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.615731] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.615744] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.615748] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.617535] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.617562] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.617567] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.617583] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.617585] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.617589] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.617591] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.618543] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.619547] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.619666] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.619669] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.619692] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.619710] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.619726] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.619743] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.619757] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.619761] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.621532] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.621558] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.621562] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.621578] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.621581] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.621584] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.621586] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.622526] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.623523] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.623644] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.623648] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.623671] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.623689] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.623706] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.623723] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.623736] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.623741] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.625532] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.625557] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.625561] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.625577] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.625579] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.625582] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.625584] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.626525] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.627522] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.627640] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.627643] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.627666] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.627684] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.627701] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.627718] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.627730] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.627734] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.629530] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.629556] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.629560] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.629576] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.629579] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.629582] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.629584] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.630523] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.631520] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.631637] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.631640] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.631663] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.631681] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.631699] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.631716] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.631729] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.631733] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.633528] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.633550] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.633555] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.633570] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.633573] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.633576] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.633578] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.634522] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.635519] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.635634] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.635637] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.635659] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.635677] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.635694] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.635711] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.635724] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.635728] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.638553] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.638585] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.638589] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.638608] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.638610] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.638613] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.638615] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.639544] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.640518] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.640638] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.640641] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.640665] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.640683] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.640700] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.640717] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.640730] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.640735] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.642526] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.642553] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.642557] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.642574] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.642576] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.642580] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.642582] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.643521] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.644517] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.644634] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.644637] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.644661] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.644678] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.644695] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.644711] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.644723] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.644728] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.646526] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.646554] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.646558] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.646575] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.646577] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.646580] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.646583] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.647520] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.648515] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.648629] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.648633] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.648656] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.648673] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.648690] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.648707] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.648721] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.648725] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.650525] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.650550] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.650554] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.650571] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.650573] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.650576] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.650578] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.651520] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.652514] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.652633] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.652637] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.652661] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.652680] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.652697] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.652714] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.652727] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.652731] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.655524] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.655555] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.655559] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.655577] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.655579] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.655583] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.655585] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.656519] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.657515] usb 1-2: Calling set_configuration
Sep  9 13:49:01 prizm kernel: [  583.657639] usb 1-2: usb_disable_device nuking non-ep0 URBs
Sep  9 13:49:01 prizm kernel: [  583.657643] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.657666] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.657684] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.657700] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.657717] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.657729] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.657734] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.659522] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  583.659549] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.659553] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.659570] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  583.659572] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  583.659575] usb 1-2: Power is set to 100mA
Sep  9 13:49:01 prizm kernel: [  583.659577] usb 1-2: Sending first magic command
Sep  9 13:49:01 prizm kernel: [  583.660516] usb 1-2: Sending second magic command
Sep  9 13:49:01 prizm kernel: [  583.661506] usb 1-2: uhci_result_common: failed with status 440000
Sep  9 13:49:01 prizm kernel: [  583.661518] usb 1-2: Second magic command failed: -71.
Sep  9 13:49:01 prizm kernel: [  583.760363] hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0004
Sep  9 13:49:01 prizm kernel: [  583.760377] ehci_hcd 0000:00:10.4: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
Sep  9 13:49:01 prizm kernel: [  583.760384] hub 5-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
Sep  9 13:49:01 prizm kernel: [  583.885625] hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
Sep  9 13:49:01 prizm kernel: [  583.941788] ehci_hcd 0000:00:10.4: port 2 full speed --> companion
Sep  9 13:49:01 prizm kernel: [  583.941797] ehci_hcd 0000:00:10.4: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
Sep  9 13:49:01 prizm kernel: [  583.941829] hub 5-0:1.0: port 2 not reset yet, waiting 50ms
Sep  9 13:49:01 prizm kernel: [  583.997680] ehci_hcd 0000:00:10.4: GetStatus port 2 status 003802 POWER OWNER sig=j CSC
Sep  9 13:49:01 prizm kernel: [  583.997713] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
Sep  9 13:49:01 prizm kernel: [  583.997725] uhci_hcd 0000:00:10.0: port 2 portsc 009b,00
Sep  9 13:49:01 prizm kernel: [  583.997737] hub 1-0:1.0: port 2, status 0101, change 0003, 12 Mb/s
Sep  9 13:49:01 prizm kernel: [  583.997740] usb 1-2: USB disconnect, address 2
Sep  9 13:49:01 prizm kernel: [  583.997742] usb 1-2: unregistering device
Sep  9 13:49:01 prizm kernel: [  583.997744] usb 1-2: usb_disable_device nuking all URBs
Sep  9 13:49:01 prizm kernel: [  583.997750] usb 1-2: unregistering interface 1-2:1.0
Sep  9 13:49:01 prizm kernel: [  583.997794] usb_endpoint usbdev1.2_ep81: ep_device_release called for usbdev1.2_ep81
Sep  9 13:49:01 prizm kernel: [  583.997815] usb_endpoint usbdev1.2_ep02: ep_device_release called for usbdev1.2_ep02
Sep  9 13:49:01 prizm kernel: [  583.997833] usb_endpoint usbdev1.2_ep83: ep_device_release called for usbdev1.2_ep83
Sep  9 13:49:01 prizm kernel: [  583.997851] usb_endpoint usbdev1.2_ep04: ep_device_release called for usbdev1.2_ep04
Sep  9 13:49:01 prizm kernel: [  583.997866] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.997871] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  583.997926] usb_endpoint usbdev1.2_ep00: ep_device_release called for usbdev1.2_ep00
Sep  9 13:49:01 prizm kernel: [  583.997954] usb 1-2: uevent
Sep  9 13:49:01 prizm kernel: [  584.125617] hub 1-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
Sep  9 13:49:01 prizm kernel: [  584.237606] usb 1-2: new full speed USB device using uhci_hcd and address 3
Sep  9 13:49:01 prizm kernel: [  584.373586] usb 1-2: ep0 maxpacket = 16
Sep  9 13:49:01 prizm kernel: [  584.393318] usb 1-2: default language 0x0409
Sep  9 13:49:01 prizm kernel: [  584.405319] usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
Sep  9 13:49:01 prizm kernel: [  584.405326] usb 1-2: Product: BlackBerry Device
Sep  9 13:49:01 prizm kernel: [  584.405328] usb 1-2: Manufacturer: Research In Motion
Sep  9 13:49:01 prizm kernel: [  584.405366] usb 1-2: uevent
Sep  9 13:49:01 prizm kernel: [  584.405385] usb 1-2: usb_probe_device
Sep  9 13:49:01 prizm kernel: [  584.405435] usb 1-2: configuration #1 chosen from 1 choice
Sep  9 13:49:01 prizm kernel: [  584.407317] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
Sep  9 13:49:01 prizm kernel: [  584.407342] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  584.407347] usb 1-2:1.0: uevent
Sep  9 13:49:01 prizm kernel: [  584.407367] berry_charge 1-2:1.0: usb_probe_interface
Sep  9 13:49:01 prizm kernel: [  584.407370] berry_charge 1-2:1.0: usb_probe_interface - got id
Sep  9 13:49:01 prizm kernel: [  584.407373] usb 1-2: Power is set to 500mA
Sep  9 13:49:01 prizm kernel: [  584.407375] usb 1-2: device is already charging, power is set to 500mA
Sep  9 13:49:01 prizm kernel: [  584.407498] drivers/usb/core/inode.c: creating file '003'
Sep  9 13:49:01 prizm kernel: [  584.407509] hub 5-0:1.0: state 7 ports 8 chg 0000 evt 0004
Sep  9 13:49:01 prizm kernel: [  584.407520] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0004
Sep  9 13:49:03 prizm kernel: [  586.405512] usb 1-2: usb auto-suspend
Sep  9 13:49:03 prizm kernel: [  586.421471] hub 5-0:1.0: hub_suspend
Sep  9 13:49:03 prizm kernel: [  586.421481] ehci_hcd 0000:00:10.4: suspend root hub
Sep  9 13:49:03 prizm kernel: [  586.421496] usb usb5: usb auto-suspend
Sep  9 13:49:05 prizm kernel: [  588.421351] hub 1-0:1.0: hub_suspend
Sep  9 13:49:05 prizm kernel: [  588.421361] usb usb1: suspend_rh
Sep  9 13:49:05 prizm kernel: [  588.421481] usb usb1: usb auto-suspend

