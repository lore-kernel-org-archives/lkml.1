Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787AbYJDSNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbYJDSNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 14:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYJDSMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 14:12:54 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2305 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754455AbYJDSMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 14:12:53 -0400
Date: Sat, 4 Oct 2008 14:12:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dave Hansen <dave@sr71.net>
cc: Thomas Gleixner <tglx@linutronix.de>, gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
In-Reply-To: <1223075214.7798.5.camel@nimitz>
Message-ID: <Pine.LNX.4.44L0.0810041411250.13228-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Dave Hansen wrote:

> OK, here's output with both Thomas/Hugh's timing fix as well as the USB
> snooping turned on.  The disconnects still happen, but I did get some
> good snoop output:
> 
> Oct  3 16:01:59 nimitz kernel: [  180.273883] usb usb7: opened by process 6485: hald-addon-usb-
> Oct  3 16:01:59 nimitz kernel: [  180.273894] usb usb7: usbdev_ioctl: CONNECTINFO
> Oct  3 16:01:59 nimitz kernel: [  180.273935] usb usb7: opened by process 6485: hald-addon-usb-
> 
> grepping for hald:
> dave@nimitz:~$ ps aux | grep hald
> 111       6407  0.5  0.1   6340  4352 ?        Ss   15:59   0:00 /usr/sbin/hald
> root      6411  0.0  0.0   3348  1152 ?        S    15:59   0:00 hald-runner
> root      6485  0.1  0.0   2996  1140 ?        S    15:59   0:00 hald-addon-usb-csr: listening on 'MX700 Optical Mouse'
> ...
> 
> If I kill off 'hald-addon-usb-csr', then the resets stop happening.
> Restart hal, and they come back.  

There's probably a setting for hal which will prevent this constant 
probing.

> Oct  3 16:01:59 nimitz kernel: [  180.273883] usb usb7: opened by process 6485: hald-addon-usb-
> Oct  3 16:01:59 nimitz kernel: [  180.273894] usb usb7: usbdev_ioctl: CONNECTINFO
> Oct  3 16:01:59 nimitz kernel: [  180.273935] usb usb7: opened by process 6485: hald-addon-usb-
> Oct  3 16:01:59 nimitz kernel: [  180.273940] usb usb7: usbdev_ioctl: IOCTL
> Oct  3 16:01:59 nimitz kernel: [  180.392126] usb 3-4: opened by process 6485: hald-addon-usb-
> Oct  3 16:01:59 nimitz kernel: [  180.393185] usb 3-4.3: USB disconnect, address 16
> Oct  3 16:01:59 nimitz kernel: [  180.393191] usb 3-4.3.4: USB disconnect, address 17
> Oct  3 16:01:59 nimitz kernel: [  180.437913] usb 3-4.3: new high speed USB device using ehci_hcd and address 18
> Oct  3 16:01:59 nimitz kernel: [  180.494705] usb 3-4.3: configuration #1 chosen from 1 choice
> Oct  3 16:01:59 nimitz kernel: [  180.495101] hub 3-4.3:1.0: USB hub found
> Oct  3 16:01:59 nimitz kernel: [  180.495409] hub 3-4.3:1.0: 4 ports detected
> Oct  3 16:01:59 nimitz kernel: [  180.600101] usb 3-4: usbdev_ioctl: CONNECTINFO
> Oct  3 16:01:59 nimitz kernel: [  180.600144] usb usb3: opened by process 6485: hald-addon-usb-
> Oct  3 16:01:59 nimitz kernel: [  180.600147] usb usb3: usbdev_ioctl: CONNECTINFO
> Oct  3 16:01:59 nimitz kernel: [  180.600167] usb 3-4: opened by process 6485: hald-addon-usb-
> Oct  3 16:01:59 nimitz kernel: [  180.600170] usb 3-4: usbdev_ioctl: IOCTL

Without a usbmon log, I can't tell what may still be going wrong.

Alan Stern

