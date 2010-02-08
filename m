Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab0BHSQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:16:07 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47819 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752047Ab0BHSQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:16:05 -0500
Date: Mon, 8 Feb 2010 13:16:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: S2R resume crash in 2.6.33-rc7 - NULL pointer dereference in
 dev_get_drvdata() for usbhid
In-Reply-To: <20100208175145.606ca761@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1002081313260.1316-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Bruno [UTF-8] Prémont wrote:

> 2.6.33-rc7 (don't know if any previous version resumes properly)
> crashes during resume from S2Ram when my USB keyboard is connected but
> resumes properly (viafb corruption put apart) when the USB keyboard is
> not connected.
> 
> Keyboard detection:
> [    3.070054] usb 2-2: new full speed USB device using uhci_hcd and address 2
> [    3.220179] kbd_mode used greatest stack depth: 2228 bytes left
> [    3.276403] usb 2-2: New USB device found, idVendor=058f, idProduct=9462
> [    3.276514] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    3.276619] usb 2-2: Product: Multimedia USB Keyboard
> [    3.276711] usb 2-2: Manufacturer: Multimedia USB Keyboard
> [    3.278056] loadkeys used greatest stack depth: 1904 bytes left
> [    3.278791] init-early.sh used greatest stack depth: 1700 bytes left
> [    3.282561] hub 2-2:1.0: USB hub found
> [    3.286387] hub 2-2:1.0: 3 ports detected
> [    3.571454] usb 2-2.1: new full speed USB device using uhci_hcd and address 3
> [    3.761474] usb 2-2.1: New USB device found, idVendor=058f, idProduct=9462
> [    3.761584] usb 2-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [    3.761719] usb 2-2.1: Product: Multimedia USB Keyboard
> [    3.762518] usb 2-2.1: Manufacturer: Multimedia USB Keyboard
> [    3.762612] usb 2-2.1: SerialNumber: Multimedia USB Keyboard
> [    3.789221] input: Multimedia USB Keyboard Multimedia USB Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2
> -2/2-2.1/2-2.1:1.0/input/input4
> [    3.789585] generic-usb 0003:058F:9462.0001: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedi
> a USB Keyboard] on usb-0000:00:10.0-2.1/input0
> [    3.818001] generic-usb: probe of 0003:058F:9462.0002 failed with error -22

> Could the crash be related to the generic-usb probe error?

Yes, it could.  Can you post the contents of 
/sys/kernel/debug/usb/devices (after mounting a debugfs filesystem on 
/sys/kernel/debug), with the keyboard plugged in?

Alan Stern

