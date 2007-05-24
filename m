Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbXEXWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbXEXWA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXEXWAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:00:13 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:47181 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbXEXWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:00:11 -0400
Message-ID: <46560AE6.10307@ribosome.natur.cuni.cz>
Date: Fri, 25 May 2007 00:00:06 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: e1000 in 2.6.21.2 and even older, like 2.6.13: eth0 does not exist
 but eth1 does
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  today I had to reinstall some machine because the xfs filesystem was broken,
because under heavy load I got kernel panic complaining that some internal kernel
structure are broken so the filesystem was unmounted. Sorry, I had no time to take
a snapshot. So I recreated the filesystem and copied the installtion from another
cluster node. Edited the /etc/conf.d/hostanme, /etc/conf.d/net to set correct IP
address and tried to boot.
   Mysteriously, after booting back I did not get my e1000 NIC detected
(ASUS P4C800E-Deluxe motherboard). First I thought it is a kernel problem and
recompiled again the freshly attempted 2.6.21.2 compiled just before I brought
the template machine down, but even having e1000 as a module did not help.
I tried the previously working kernel binary 2.6.19.1 and still, the driver got
loaded, dmesg(1) has shown the card, its IRQ managed through ACPI, it MAC address,
but Gentoo init.d scripts complained no eth0 device exists still. So that could not
be related to a newly introduced bug in 2.6.19.1 - 2.6.21.2 range.

 I tried even 2.6.13 kernel image laying a year or two on the bootable filesystem,
it also did not give me eth0 anymore. I tried to reload setup defaults in BIOS
(version 1019) but nothing helped me either.
  Let me emphasize ifconfig(1) does only show loopback device all the time.
Finally I found that in /proc/net/dev there is a row for "lo:" and "eth1".
Yes, the network card is recognized as eth1. Blindly running 'ifconfig eth1 $IP'
really succeeds and assigns the given IP address to my card and since then it is
shown by ifconfig(1) and dmesg(1) reported whih link speed was negotiated.
Even before that, the network switch had shown it does have a link to the network
card with its diode. I cannot say the status of the diode on the NIC itself,
I have hard access to the rear side, sorry.

 I think there is sometimes logged wrong device name to syslog, I do not know why.
But it always shows eth0 after inserting the e1000 module? Removing the module
disables the IRQ for the device, re-inserting the module again claims it is
eth0 ... but it is eth1, I know now. The network card is wired into the motherboard,
I have 12 same boxes and never saw such a problem.


Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
...some license stuff...
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency Timer of device 0000:02.01.0 to 64
e1000: 0000:02:01.0: e1000_probe (PCI:33MHz:32-bit) 00:13:d4:51.......
e1000:eth0: e1000_probe: Intel(R) PRO/1000 Network Connection


after removing the kernel module, I get

ACPI:PCI interrupt for device 0000:02:01.0 disabled


after assigning the IP address to eth1 I get:

e1000:eth1: e1000_watchdog: NIC link is up 100Mbps Full Duplex, .....


  Further to note, in /proc/interrupts I haven't seen the promised interrupt line 18
as used by the e1000 module, although at that very moment it should be used (according
to dmesg(1)). In lspci I haven't seen anything strange, and definitely I saw the NIC
device.


  The machine is now running via that eth1 on the network and I am ready to do some
more tests. Are there some debug switches for the e1000 module?

  I rebooted the machine maybe 20x, incl. cold starts, so I believe I can reproduce
it still.

Thanks for hints,
martin
