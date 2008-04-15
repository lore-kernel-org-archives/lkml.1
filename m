Return-Path: <linux-kernel-owner+w=401wt.eu-S1765611AbYDOQU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765611AbYDOQU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 12:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbYDOQUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 12:20:10 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:58868 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbYDOQUI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 12:20:08 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: "Peer Chen" <pchen@nvidia.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
Date: Tue, 15 Apr 2008 18:20:03 +0200
User-Agent: KMail/1.9.9
Cc: "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       "Kuan Luo" <kluo@nvidia.com>
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <200804142312.32991.volker.armin.hemmann@tu-clausthal.de> <15F501D1A78BD343BE8F4D8DB854566B26E76A63@hkemmail01.nvidia.com>
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B26E76A63@hkemmail01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804151820.03530.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Dienstag, 15. April 2008, Peer Chen wrote:
> Yes, could you dump the IO port data from 0x2f00 to 0x2fff and send it to
> me, it record the base address BIOS trap? 

how do I do that?
Also, I can't see anything resembling this two adresses(?) in /proc/ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:09.0
01f0-01f7 : 0000:00:09.0
0290-029f : pnp 00:0a
  0295-0296 : w83627ehf
    0295-0296 : w83627ehf
0376-0376 : 0000:00:09.0
03c0-03df : vga+
03f6-03f6 : 0000:00:09.0
04d0-04d1 : pnp 00:05
0800-080f : pnp 00:05
0cf8-0cff : PCI conf1
0e00-0e07 : 0000:00:0a.0
  0e00-0e07 : ahci
0e20-0e23 : 0000:00:0a.0
  0e20-0e23 : ahci
0e40-0e47 : 0000:00:0a.0
  0e40-0e47 : ahci
0e60-0e63 : 0000:00:0a.0
  0e60-0e63 : ahci
2000-207f : pnp 00:05
  2000-2003 : ACPI PM1a_EVT_BLK
  2004-2005 : ACPI PM1a_CNT_BLK
  2008-200b : ACPI PM_TMR
  2010-2015 : ACPI CPU throttle
  2020-2027 : ACPI GPE0_BLK
2080-20ff : pnp 00:05
2400-247f : pnp 00:05
2480-24ff : pnp 00:05
  24a0-24af : ACPI GPE1_BLK
2800-287f : pnp 00:05
2880-28ff : pnp 00:05
2c00-2c7f : pnp 00:05
2c80-2cff : pnp 00:05
2d00-2d3f : 0000:00:01.1
  2d00-2d3f : nForce2_smbus
2e00-2e3f : 0000:00:01.1
  2e00-2e3f : nForce2_smbus
a800-a80f : 0000:00:0a.0
  a800-a80f : ahci
bc00-bc3f : 0000:00:01.1
c000-cfff : PCI Bus #01
  c800-c8ff : 0000:01:00.0
    c800-c8ff : r8169
d000-dfff : PCI Bus #02
  d800-d8ff : 0000:02:08.0
  dc00-dc3f : 0000:02:09.0
    dc00-dc3f : EMU10K1
e000-efff : PCI Bus #04
  ec00-ec7f : 0000:04:00.0
ffa0-ffaf : 0000:00:09.0


> Also, could you update the latest BIOS to try this issue again?

there was a new bios from today - and nothing changed:
with 2.6.25-rc8:

[    0.360518] ------------[ cut here ]------------
[    0.360518] WARNING: at drivers/ata/ahci.c:645 ahci_init_one+0x190/0xa3a()
[    0.360518] Modules linked in:
[    0.360518] Pid: 1, comm: swapper Not tainted 2.6.25-rc8 #2
[    0.360518]
[    0.360518] Call Trace:
[    0.360518]  [<ffffffff8022c5a5>] warn_on_slowpath+0x51/0x63
[    0.360522]  [<ffffffff80220061>] __ioremap+0x8/0x197
[    0.360561]  [<ffffffff803921f4>] pci_conf1_read+0xb2/0xbd
[    0.360600]  [<ffffffff802f3316>] pcim_iomap_release+0x0/0x2c
[    0.360639]  [<ffffffff802f3316>] pcim_iomap_release+0x0/0x2c
[    0.360679]  [<ffffffff803471a9>] devres_find+0x4b/0x65
[    0.360718]  [<ffffffff8036e4cd>] ahci_init_one+0x190/0xa3a
[    0.360757]  [<ffffffff802af837>] sysfs_addrm_finish+0x1d/0x209
[    0.360796]  [<ffffffff80284014>] ifind+0x34/0x8d
[    0.360834]  [<ffffffff802af54e>] sysfs_find_dirent+0x1b/0x2f
[    0.360873]  [<ffffffff802eb75d>] ida_get_new_above+0xf0/0x180
[    0.360912]  [<ffffffff802af837>] sysfs_addrm_finish+0x1d/0x209
[    0.360951]  [<ffffffff802b0378>] sysfs_create_link+0xb6/0x102
[    0.360992]  [<ffffffff802f8664>] pci_device_probe+0x4c/0x72
[    0.361030]  [<ffffffff80344c48>] driver_probe_device+0xb5/0x132
[    0.361069]  [<ffffffff80344ddb>] __driver_attach+0x6f/0xaf
[    0.361108]  [<ffffffff80344d6c>] __driver_attach+0x0/0xaf
[    0.361146]  [<ffffffff80344d6c>] __driver_attach+0x0/0xaf
[    0.361185]  [<ffffffff8034400a>] bus_for_each_dev+0x44/0x6f
[    0.361225]  [<ffffffff802a9b57>] proc_match+0x23/0x2d
[    0.361263]  [<ffffffff80344876>] bus_add_driver+0xae/0x1f4
[    0.361302]  [<ffffffff8034500a>] driver_register+0x59/0xce
[    0.361341]  [<ffffffff802f88a5>] __pci_register_driver+0x4a/0x7d
[    0.361388]  [<ffffffff804e56b8>] kernel_init+0x14f/0x2b9
[    0.361427]  [<ffffffff8020be98>] child_rip+0xa/0x12
[    0.361465]  [<ffffffff804e5569>] kernel_init+0x0/0x2b9
[    0.361503]  [<ffffffff8020be8e>] child_rip+0x0/0x12
[    0.361540]
[    0.361577] ---[ end trace 78236403fd67c90f ]-

Glück Auf,
Volker
