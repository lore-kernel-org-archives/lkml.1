Return-Path: <linux-kernel-owner+w=401wt.eu-S1762190AbXH3Umz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190AbXH3Umz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759412AbXH3Ums
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:42:48 -0400
Received: from lilly.ping.de ([83.97.42.2]:4791 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759262AbXH3Umr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:42:47 -0400
Date: 30 Aug 2007 22:42:46 +0200
Message-ID: <46D72BC6.3020809@edge.ping.de>
From: "Tim Teulings" <rael@edge.ping.de>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@gmail.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com> <6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com> <20070827065246.GA21220@ime.usp.br> <46D279E8.10001@edge.ping.de>
In-Reply-To: <46D279E8.10001@edge.ping.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> I don't have traces at hand and due to lack of time cannot reproduce it 
> up to tomorrow. However this hint may speed up your analysis!

Sorry for the delay, but my desktop PC had an urgent hard disk problem I 
had to fix ASASP.

So here is the output from dmesg that suggested to me that firewire 
might be a problem:

> usb_endpoint usbdev2.2_ep81: PM: suspend 0->2, parent 2-1:1.0 already 2
> usb_device usbdev1.1: PM: suspend 0->2, parent usb1 already 2
> usb_endpoint usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
> hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
> usb_endpoint usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
> eth2: Airport entering sleep mode
> eth0: suspending, WakeOnLan disabled
> pci_set_power_state(): 0002:20:0e.0: state=3, current state=5
> firewire_ohci: pci_set_power_state failed with -22<3>pci_device_suspend(): pci_suspend+0x0/0x9c [firewire_ohci]() returns -22
> suspend_device(): pci_device_suspend+0x0/0x98() returns -22
> Could not suspend device 0002:20:0e.0: error -22
> eth0: resuming
> PHY ID: 4061e4, addr: 0
> eth2: Airport waking up
> eth2: New link status: Connected (0001)
> hda: Enabling Ultra DMA 2
> eth0: Link is up at 100 Mbps, full-duplex.
> eth0: Pause is disabled
> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> hdb: Enabling Ultra DMA 2
> usb_endpoint usbdev1.1_ep00: PM: resume from 0, parent usb1 still 2
> usb_endpoint usbdev1.1_ep81: PM: resume from 0, parent 1-0:1.0 still 2
> usb_device usbdev1.1: PM: resume from 0, parent usb1 still 2
> Driver sleep failed
> Sleep rejected by devices
> adb: starting probe task...
> adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
> ADB keyboard at 2, handler 1
> ADB mouse at 3, handler set to 4 (trackpad)
> adb: finished probe task...
> usb_device usbdev1.1: PM: suspend 0->2, parent usb1 already 2
> usb_endpoint usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
> hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
> usb_endpoint usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
> eth2: Airport entering sleep mode
> eth0: suspending, WakeOnLan disabled
> Trying to free already-free IRQ 40
> pci_set_power_state(): 0002:20:0e.0: state=3, current state=5
> firewire_ohci: pci_set_power_state failed with -22<3>pci_device_suspend(): pci_suspend+0x0/0x9c [firewire_ohci]() returns -22
> suspend_device(): pci_device_suspend+0x0/0x98() returns -22
> Could not suspend device 0002:20:0e.0: error -22
> eth0: resuming
> PHY ID: 4061e4, addr: 0
> eth2: Airport waking up
> eth2: New link status: Connected (0001)
> hda: Enabling Ultra DMA 2
> hdb: Enabling Ultra DMA 2
> eth0: Link is up at 100 Mbps, full-duplex.
> eth0: Pause is disabled

The problem wa sinitiated by closing the lid. The iBook then seems to 
permanetly try to go to sleep (I can hear the cd-rom drive get 
periodically initialized). So above contains more than one iteration.

The kernel is:
> Linux kismet 2.6.22-1-powerpc #1 Sun Jul 29 13:58:06 CEST 2007 ppc GNU/Linux

The relveant debian package:
> linux-image-2.6.22-1-powerpc_2.6.22-3_powerpc.deb

I'm running a mixture of debian testing/unstable.

The firewire and the USB connector were unused, the network connector 
was used.

If there are questions regarding other packages, or somebody wants me to 
test a fix (I would prever a debian package), don't hesitate - I would 
like to get the bug fixed :-)

-- 
Gruﬂ...
        Tim

