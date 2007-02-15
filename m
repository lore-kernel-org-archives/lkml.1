Return-Path: <linux-kernel-owner+w=401wt.eu-S1751494AbXBOBVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbXBOBVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 20:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbXBOBVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 20:21:04 -0500
Received: from smtp.andrew.cmu.edu ([128.2.10.82]:51975 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbXBOBVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 20:21:03 -0500
X-Greylist: delayed 1165 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Feb 2007 20:21:03 EST
Message-ID: <45D3B0EC.8030804@cmu.edu>
Date: Wed, 14 Feb 2007 20:01:32 -0500
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0b1 (X11/20070206)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: discuss-gnuradio@gnu.org
Subject: USB ehci problems with USRP, -71 EPROTO
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

I am having troubles connecting and interfacing to a device called a 
USRP via USB which is used with GNU Radio.  At one time, the setup 
worked perfectly fine with no errors.  Then i tried to give a regular 
user permission to the USB device and everything went downhill.

Now, whenever I plugin the device sometimes I sometimes get the error:
usb 1-7: device descriptor read/all, error -71

Whenever I don't get the error, I try to proceed normally to uploading a 
new image to the USRP and I get the following error from gnuradio:
write_internal_ram failed: error sending control message: Protocol error

This generates the following dmesg errors:
usb 1-7: usbfs: USBDEVFS_CONTROL failed cmd python rqt 64 rq 160 len 3 
ret -71
usb 1-7: usbfs: USBDEVFS_CONTROL failed cmd python rqt 64 rq 160 len 5 
ret -71
usb 1-7: usbfs: USBDEVFS_CONTROL failed cmd python rqt 64 rq 160 len 8 
ret -71
usb 1-7: usbfs: USBDEVFS_CONTROL failed cmd python rqt 64 rq 160 len 3 
ret -71

Another set of errors produced by gnuradio are these:
usrp_open_interface:usb_set_alt_interface: failed
could not set alt intf 0/0: Protocol error
open_nth_cmd_interface: open_cmd_interface failed

-----

I was able to plug the USRP into another machine with GNU Radio and 
successfully flash new firmware to it 100% successfully several times. 
I cannot get a single firmware on using my machine and the USRP.

Heres what else I've tried:
   - un-installing and re-installing GNU Radio
   - switching USB ports on the machine
   - switching USB cables
   - rebuilding the kernel
   - installing a newer version of udev
   - using a different USRP on my machine (doesn't work)

I'm not sure what else to try... heres what I did between when it worked 
and broke, trying to set the USB permissions properly:

-----------------

I tried udev first, and created /etc/udev/rules.d/60-usrp.rules:
# USRP without loaded firmware (FX2)
BUS=="usb", SYSFS{idVendor}=="fffe", SYSFS{idProduct}=="0002", 
SYSFS{bcdDevice}=="0002", GROUP="usrp", RUN+="/usr/local/bin/usrper 
load_standard_bits"
BUS=="usb", SYSFS{idVendor}=="fffe", SYSFS{idProduct}=="0002", 
SYSFS{bcdDevice}=="0004", GROUP="usrp", RUN+="/usr/local/bin/usrper 
load_standard_bits"

# USRP with loaded firmware
BUS=="usb", SYSFS{idVendor}=="fffe", SYSFS{idProduct}=="0002", 
SYSFS{bcdDevice}=="0102", GROUP="usrp"
BUS=="usb", SYSFS{idVendor}=="fffe", SYSFS{idProduct}=="0002", 
SYSFS{bcdDevice}=="0104", GROUP="usrp"

-----------------

So the other method was with hotplug, and i made /etc/hotplug/usb/usrp:
#!/bin/sh
chown root:usb "$DEVICE"
chmod ug+rw "$DEVICE"

and usrp.usermap:
usrp    0x0003  0xfffe  0x0002  0    0  0    0  0       0       0       0

-----------------

I would greatly appreciate any help and suggestions.

Thanks!
George
