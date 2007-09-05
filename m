Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbXIERtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbXIERtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbXIERtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:49:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44866 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbXIERtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:49:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46DEEBBE.4070201@s5r6.in-berlin.de>
Date: Wed, 05 Sep 2007 19:47:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Tim Teulings <rael@edge.ping.de>, michal.k.k.piotrowski@gmail.com,
       rbrito@gmail.com, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       debian-powerpc@lists.debian.org, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org,
       =?ISO-8859-1?Q?Kristian_H=F8gsber?= =?ISO-8859-1?Q?g?= 
	<krh@redhat.com>
Subject: Re: Sleep problems with kernels >= 2.6.21 on powerpc
References: <6540c930708251937o2a9a23efv72a0f2b8947067bd@mail.gmail.com>	<6bffcb0e0708261621q25316becqce7b3ae2176f45a8@mail.gmail.com>	<20070827065246.GA21220@ime.usp.br>	<46D279E8.10001@edge.ping.de>	<46D72BC6.3020809@edge.ping.de> <20070905100754.57ab4e3e.akpm@linux-foundation.org>
In-Reply-To: <20070905100754.57ab4e3e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On 30 Aug 2007 22:42:46 +0200 "Tim Teulings" <rael@edge.ping.de> wrote:
>> Hello!
>>
>>> I don't have traces at hand and due to lack of time cannot reproduce it 
>>> up to tomorrow. However this hint may speed up your analysis!
>> Sorry for the delay, but my desktop PC had an urgent hard disk problem I 
>> had to fix ASASP.
>>
>> So here is the output from dmesg that suggested to me that firewire 
>> might be a problem:
> 
> Straightforward regression, two reporters, nothing happening.

Thanks for CCing me.  I'm also adding the CC of Kristian, author and
other maintainer of the code in question.

>>> usb_endpoint usbdev2.2_ep81: PM: suspend 0->2, parent 2-1:1.0 already 2
>>> usb_device usbdev1.1: PM: suspend 0->2, parent usb1 already 2
>>> usb_endpoint usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
>>> hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
>>> usb_endpoint usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
>>> eth2: Airport entering sleep mode
>>> eth0: suspending, WakeOnLan disabled
>>> pci_set_power_state(): 0002:20:0e.0: state=3, current state=5
>>> firewire_ohci: pci_set_power_state failed with -22<3>pci_device_suspend(): pci_suspend+0x0/0x9c [firewire_ohci]() returns -22
>>> suspend_device(): pci_device_suspend+0x0/0x98() returns -22
>>> Could not suspend device 0002:20:0e.0: error -22
>>> eth0: resuming
>>> PHY ID: 4061e4, addr: 0
>>> eth2: Airport waking up
>>> eth2: New link status: Connected (0001)
>>> hda: Enabling Ultra DMA 2
>>> eth0: Link is up at 100 Mbps, full-duplex.
>>> eth0: Pause is disabled
>>> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>>> hdb: Enabling Ultra DMA 2
>>> usb_endpoint usbdev1.1_ep00: PM: resume from 0, parent usb1 still 2
>>> usb_endpoint usbdev1.1_ep81: PM: resume from 0, parent 1-0:1.0 still 2
>>> usb_device usbdev1.1: PM: resume from 0, parent usb1 still 2
>>> Driver sleep failed
>>> Sleep rejected by devices
>>> adb: starting probe task...
>>> adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
>>> ADB keyboard at 2, handler 1
>>> ADB mouse at 3, handler set to 4 (trackpad)
>>> adb: finished probe task...
>>> usb_device usbdev1.1: PM: suspend 0->2, parent usb1 already 2
>>> usb_endpoint usbdev1.1_ep81: PM: suspend 0->2, parent 1-0:1.0 already 2
>>> hub 1-0:1.0: PM: suspend 2->2, parent usb1 already 2
>>> usb_endpoint usbdev1.1_ep00: PM: suspend 0->2, parent usb1 already 2
>>> eth2: Airport entering sleep mode
>>> eth0: suspending, WakeOnLan disabled
>>> Trying to free already-free IRQ 40
>>> pci_set_power_state(): 0002:20:0e.0: state=3, current state=5
>>> firewire_ohci: pci_set_power_state failed with -22<3>pci_device_suspend(): pci_suspend+0x0/0x9c [firewire_ohci]() returns -22
> 
> I grepped the whole tree for firewire_ohci and came up blank.  What is it?

drivers/firewire/fw-ohci.c -> fw-ohci.o -> firewire-ohci.o ->
firewire-ohci.ko

> But yes, a failed pci_set_power_state() will hurt.  Perhaps this is
> a result of some recently-added return-value checking fix but as I
> cannot find the dang code I cannot tell.

The old ohci1394.c used to ignore pci_set_power_state's return value.
In the pre 2.6.19-rc1 commit ea6104c22468239083857fa07425c312b1ecb424, I
added a fail-on-error.  This was toned down to a printk-on-err by pre
2.6.19-rc4 commit 346f5c7ee7fa4ebee0e4c96415a7e59716bfa1d0.

This was because of Benjamin Herrenschmidt's regression report:
http://lkml.org/lkml/2006/10/24/13

So, we went into the same trap again with fw-ohci.  I should have
noticed how fw-ohci treats pci_set_power_state when I signed off the
commit which added the suspend/resume methods to fw-ohci --- but somehow
I didn't.

>>> suspend_device(): pci_device_suspend+0x0/0x98() returns -22
>>> Could not suspend device 0002:20:0e.0: error -22
>>> eth0: resuming
>>> PHY ID: 4061e4, addr: 0
>>> eth2: Airport waking up
>>> eth2: New link status: Connected (0001)
>>> hda: Enabling Ultra DMA 2
>>> hdb: Enabling Ultra DMA 2
>>> eth0: Link is up at 100 Mbps, full-duplex.
>>> eth0: Pause is disabled
>> The problem wa sinitiated by closing the lid. The iBook then seems to 
>> permanetly try to go to sleep (I can hear the cd-rom drive get 
>> periodically initialized). So above contains more than one iteration.
>>
>> The kernel is:
>>> Linux kismet 2.6.22-1-powerpc #1 Sun Jul 29 13:58:06 CEST 2007 ppc GNU/Linux
>> The relveant debian package:
>>> linux-image-2.6.22-1-powerpc_2.6.22-3_powerpc.deb
>> I'm running a mixture of debian testing/unstable.
>>
>> The firewire and the USB connector were unused, the network connector 
>> was used.
>>
>> If there are questions regarding other packages, or somebody wants me to 
>> test a fix (I would prever a debian package), don't hesitate - I would 
>> like to get the bug fixed :-)
>>

A trivial post -rc1 compatible fix is coming in a minute.
-- 
Stefan Richter
-=====-=-=== =--= --=-=
http://arcgraph.de/sr/
