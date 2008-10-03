Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYJCXHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYJCXHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYJCXG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:06:57 -0400
Received: from www.sr71.net ([198.145.64.142]:59245 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796AbYJCXG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:06:56 -0400
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
From: Dave Hansen <dave@sr71.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0810031608000.6462-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0810031608000.6462-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 16:06:54 -0700
Message-Id: <1223075214.7798.5.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, here's output with both Thomas/Hugh's timing fix as well as the USB
snooping turned on.  The disconnects still happen, but I did get some
good snoop output:

Oct  3 16:01:59 nimitz kernel: [  180.273883] usb usb7: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.273894] usb usb7: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.273935] usb usb7: opened by process 6485: hald-addon-usb-

grepping for hald:
dave@nimitz:~$ ps aux | grep hald
111       6407  0.5  0.1   6340  4352 ?        Ss   15:59   0:00 /usr/sbin/hald
root      6411  0.0  0.0   3348  1152 ?        S    15:59   0:00 hald-runner
root      6485  0.1  0.0   2996  1140 ?        S    15:59   0:00 hald-addon-usb-csr: listening on 'MX700 Optical Mouse'
...

If I kill off 'hald-addon-usb-csr', then the resets stop happening.
Restart hal, and they come back.  

Oct  3 16:01:59 nimitz kernel: [  180.273883] usb usb7: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.273894] usb usb7: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.273935] usb usb7: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.273940] usb usb7: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.392126] usb 3-4: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.393185] usb 3-4.3: USB disconnect, address 16
Oct  3 16:01:59 nimitz kernel: [  180.393191] usb 3-4.3.4: USB disconnect, address 17
Oct  3 16:01:59 nimitz kernel: [  180.437913] usb 3-4.3: new high speed USB device using ehci_hcd and address 18
Oct  3 16:01:59 nimitz kernel: [  180.494705] usb 3-4.3: configuration #1 chosen from 1 choice
Oct  3 16:01:59 nimitz kernel: [  180.495101] hub 3-4.3:1.0: USB hub found
Oct  3 16:01:59 nimitz kernel: [  180.495409] hub 3-4.3:1.0: 4 ports detected
Oct  3 16:01:59 nimitz kernel: [  180.600101] usb 3-4: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.600144] usb usb3: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.600147] usb usb3: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.600167] usb 3-4: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.600170] usb 3-4: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.600179] usb usb3: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.600182] usb usb3: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.619896] usb usb6: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.620387] usb usb6: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.620766] usb usb6: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.621179] usb usb6: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.640068] usb usb5: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.640509] usb usb5: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.640866] usb usb5: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.641278] usb usb5: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.641599] usb 4-1: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.642006] usb 4-1: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.642347] usb usb4: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.642757] usb usb4: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.643108] usb 4-1: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.643524] usb 4-1: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.643872] usb usb4: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.644159] usb 3-4.3.4: new high speed USB device using ehci_hcd and address 19
Oct  3 16:01:59 nimitz kernel: [  180.644856] usb usb4: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.645180] usb 2-1: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.645612] usb 2-1: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.645954] usb usb2: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.646531] usb usb2: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.646888] usb 2-1: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.647314] usb 2-1: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.647640] usb usb2: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.648106] usb usb2: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.667895] usb usb1: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.668340] usb usb1: usbdev_ioctl: CONNECTINFO
Oct  3 16:01:59 nimitz kernel: [  180.668689] usb usb1: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.669101] usb usb1: usbdev_ioctl: IOCTL
Oct  3 16:01:59 nimitz kernel: [  180.669420] usb 2-1: opened by process 6485: hald-addon-usb-
Oct  3 16:01:59 nimitz kernel: [  180.669823] usb 2-1: usbdev_ioctl: CONTROL
Oct  3 16:01:59 nimitz kernel: [  180.669827] usb 2-1: control read: bRequest=09 bRrequestType=c0 wValue=0003 wIndex=0000 wLength=0008
Oct  3 16:01:59 nimitz kernel: [  180.673036] usb 2-1: control read: data 20 3d 8b 45 05 0b 01 ee 
Oct  3 16:01:59 nimitz kernel: [  180.701219] usb 3-4.3.4: configuration #1 chosen from 1 choice
Oct  3 16:01:59 nimitz kernel: [  180.701552] hub 3-4.3.4:1.0: USB hub found
Oct  3 16:01:59 nimitz kernel: [  180.701905] hub 3-4.3.4:1.0: 4 ports detected

-- Dave

