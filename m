Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbXHBNa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbXHBNa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXHBNar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:30:47 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48292 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbXHBNao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:30:44 -0400
Date: Thu, 2 Aug 2007 15:30:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Michael Tokarev <mjt@tls.msk.ru>
cc: Herbert Rosmanith <kernel@wildsau.enemy.org>, linux-kernel@vger.kernel.org
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev
 numbering]
In-Reply-To: <46B1D46D.7080609@msgid.tls.msk.ru>
Message-ID: <Pine.LNX.4.64.0708021526310.24572@fbirervta.pbzchgretzou.qr>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
 <46B1BEB8.70104@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
 <46B1D46D.7080609@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 16:56, Michael Tokarev wrote:
>>> I already can see comments from udev/sysfs maintainers here: "naming
>>> is a policy which does not belong to kernel".  It's a bullshit, because
>>> kernel too has to use SOME way to name things,
>> 
>> (1) The kernel starts with ethX
>> (2) udev renames it to something else
>> (3) kernel uses new name too ("ni0: link down")
>
>And now tell me please how can I connect two messages from dmesg:
>
>eth0: Tigon3 [partno(BCM95721) rev 4201 PHY(5750)] (PCI Express) 10/100/1000Base-T Ethernet 00:14:5e:5d:18:26
>nic10: Link is up at 100 Mbps, full duplex.

Generally, the "link is xyz" message comes directly after loading the module,
so it should be eth0 before udev gets a chance to rename it. Or maybe not -
in which case, well, you're literally fubared, and your distro should put a
"renamed A to B" into syslog.

>What I wanted to say (here with network devices, and with disk names
>and everything else) is -- as long as the device is here (plugged in
>but not yet unplugged), I want it to have the same "primary" name in
>kernel and in userspace, so that everything

Oh I think it already has a "primary name" today --

$ readlink /sys/class/net/eth0/device
../../../../../devices/pci0000:00/0000:00:04.0

there is your primary name, and your secondary name is ethZ. :)


	Jan
-- 
