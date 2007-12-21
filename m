Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbXLUKPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbXLUKPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 05:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbXLUKPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 05:15:14 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57081 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbXLUKPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 05:15:12 -0500
Date: Fri, 21 Dec 2007 11:15:10 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Frans Pop <elendil@planet.nl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andy Whitcroft <apw@shadowen.org>, Joe Perches <joe@perches.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
In-Reply-To: <20071220181532.f31cdcaa.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712211111550.21721@fbirervta.pbzchgretzou.qr>
References: <474E6BD0.20103@cn.fujitsu.com> <20071220162923.GB27885@shadowen.org>
 <20071220210741.6dc3caf5@the-village.bc.nu> <200712210243.35240.elendil@planet.nl>
 <20071220181532.f31cdcaa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 20 2007 18:15, Andrew Morton wrote:
>
>No-period is a kernel idiom, produces perfectly readable output, I have
>never ever heard of anyone expressing the least concern over a lack of dots
>at the end of their printks and 91% of kernel code agrees.

Let's check out some real-world messages, i.e. the ones you actually see:

11:12 ichi:~/Coding/linux-2.6_nosov > dmesg | grep '\.$' 

[   16.520364] Total of 1 processors activated (3334.94 BogoMIPS).
[   16.746692] Completing Region/Field/Buffer/Package initialization:.............................................................................
[   16.751681] Initializing Device/Processor/Thermal objects by executing _INI methods:.
[   16.761402] Enabling SiS 96x SMBus.
[   16.765700] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[   16.768126] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[   16.812932] Time: tsc clocksource has been installed.
[   16.863799]   IO window: disabled.
[   16.993286] Machine check exception polling timer started.
[   17.023249] isapnp: Scanning for PnP cards...
[   17.484975] libata version 2.21 loaded.
[   23.684850] 0000:00:04.0: Realtek RTL8201 PHY transceiver found at address 1.
[   23.695501] eth0: SiS 900 PCI Fast Ethernet at 0xdc00, IRQ 19, 00:0a:e6:98:ed:d7.
[   25.341019] nvidia: module license 'NVIDIA' taints kernel.
[   63.215338] Netfilter messages via NETLINK v0.30.
[  151.770648] /dev/vmmon[2792]: VMCI: Driver initialized.
[  152.906489] /dev/vmnet: hub 0 does not exist, allocating memory.
[  153.325793] /dev/vmnet: hub 1 does not exist, allocating memory.
[  164.114371] agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
[  164.114405] agpgart: SiS delay workaround: giving bridge time to recover.
[  165.319145] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).

# vmware fills up dmesg. Shrug.
11:14 ichi:~/Coding/linux-2.6_nosov > dmesg|grep -v vmmon|wc -l
297
11:14 ichi:~/Coding/linux-2.6_nosov > dmesg|grep -v vmmon|grep '\.$' | wc -l
18

So yeah 91% is a good call.
