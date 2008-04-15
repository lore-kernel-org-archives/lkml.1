Return-Path: <linux-kernel-owner+w=401wt.eu-S1764857AbYDOM7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764857AbYDOM7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYDOM7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:59:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.112.145]:9424 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYDOM7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:59:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Tue, 15 Apr 2008 05:59:39 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: RE: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Tue, 15 Apr 2008 20:57:08 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B26E76A63@hkemmail01.nvidia.com>
In-Reply-To: <200804142312.32991.volker.armin.hemmann@tu-clausthal.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Thread-Index: AciedEczGQVIXcK0SM2cwFjaPGSN7wAZvQFA
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804140841.32477.volker.armin.hemmann@tu-clausthal.de> <15F501D1A78BD343BE8F4D8DB854566B26C12206@hkemmail01.nvidia.com> <200804142312.32991.volker.armin.hemmann@tu-clausthal.de>
From: "Peer Chen" <pchen@nvidia.com>
To: "Volker Armin Hemmann" <volker.armin.hemmann@tu-clausthal.de>
Cc: "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
       "Kuan Luo" <kluo@nvidia.com>
X-OriginalArrivalTime: 15 Apr 2008 12:57:09.0832 (UTC) FILETIME=[37623480:01C89EF8]
Content-class: urn:content-classes:message
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Yes, could you dump the IO port data from 0x2f00 to 0x2fff and send it to me, it record the base address BIOS trap?
Also, could you update the latest BIOS to try this issue again?

BRs
Peer Chen

-----Original Message-----
From: Volker Armin Hemmann [mailto:volker.armin.hemmann@tu-clausthal.de] 
Sent: Tuesday, April 15, 2008 5:13 AM
To: Peer Chen
Cc: Jeff Garzik; Tejun Heo; linux-kernel@vger.kernel.org; linux-ide@vger.kernel.org; Kuan Luo
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3

Hi,

On Montag, 14. April 2008, Peer Chen wrote:
> Volker,
> I mean add msleep(x) function between writel(HOST_AHCI_EN, mmio + HOST_CTL)
> and readl(mmio + HOST_CTL) cause we ever met a bug that writing data to the
> AHCI BAR5 but need a delay to get correct read back value. But forget it,
> looks like it's not the same case here. Which mode do you set(ahci or
> non-raid) when you encountered the issue that the AHCI_EN bit failed to
> set? I found we have workaround for AHCI_EN bit setting in our Bios
> programming guide for AHCI mode.

you mean this?

[    0.363828] ------------[ cut here ]------------
[    0.363828] WARNING: at drivers/ata/ahci.c:645 ahci_init_one+0x190/0xa3a()
[    0.363828] Modules linked in:
[    0.363828] Pid: 1, comm: swapper Not tainted 2.6.25-rc8 #2
[    0.363828]
[    0.363828] Call Trace:
[    0.363828]  [<ffffffff8022c5a5>] warn_on_slowpath+0x51/0x63
[    0.363832]  [<ffffffff80220061>] __ioremap+0x8/0x197
[    0.363872]  [<ffffffff803921f4>] pci_conf1_read+0xb2/0xbd
[    0.363911]  [<ffffffff802f3316>] pcim_iomap_release+0x0/0x2c
[    0.363950]  [<ffffffff802f3316>] pcim_iomap_release+0x0/0x2c
[    0.363989]  [<ffffffff803471a9>] devres_find+0x4b/0x65
[    0.364028]  [<ffffffff8036e4cd>] ahci_init_one+0x190/0xa3a
[    0.364067]  [<ffffffff802af837>] sysfs_addrm_finish+0x1d/0x209
[    0.364107]  [<ffffffff80284014>] ifind+0x34/0x8d
[    0.364145]  [<ffffffff802af54e>] sysfs_find_dirent+0x1b/0x2f
[    0.364184]  [<ffffffff802eb75d>] ida_get_new_above+0xf0/0x180
[    0.364223]  [<ffffffff802af837>] sysfs_addrm_finish+0x1d/0x209
[    0.364263]  [<ffffffff802b0378>] sysfs_create_link+0xb6/0x102
[    0.364303]  [<ffffffff802f8664>] pci_device_probe+0x4c/0x72
[    0.364342]  [<ffffffff80344c48>] driver_probe_device+0xb5/0x132
[    0.364381]  [<ffffffff80344ddb>] __driver_attach+0x6f/0xaf
[    0.364419]  [<ffffffff80344d6c>] __driver_attach+0x0/0xaf
[    0.364458]  [<ffffffff80344d6c>] __driver_attach+0x0/0xaf
[    0.364498]  [<ffffffff8034400a>] bus_for_each_dev+0x44/0x6f
[    0.364538]  [<ffffffff802a9b57>] proc_match+0x23/0x2d
[    0.364576]  [<ffffffff80344876>] bus_add_driver+0xae/0x1f4
[    0.364614]  [<ffffffff8034500a>] driver_register+0x59/0xce
[    0.364654]  [<ffffffff802f88a5>] __pci_register_driver+0x4a/0x7d
[    0.364701]  [<ffffffff804e56b8>] kernel_init+0x14f/0x2b9
[    0.364740]  [<ffffffff8020be98>] child_rip+0xa/0x12
[    0.364779]  [<ffffffff804e5569>] kernel_init+0x0/0x2b9
[    0.364817]  [<ffffffff8020be8e>] child_rip+0x0/0x12
[    0.364854]
[    0.364891] ---[ end trace ea9d541113ecaf1e ]---

this happened with AHCI mode set in bios, pci=nomsi as kernel boot parameter 
and kernel 2.6.25-rc8.

Something similar looking happened without pci=nomsi, but in that case I could 
not scroll back to even make a picture because of the kernel panic (rootfs 
not found).

Glück Auf
Volker
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
