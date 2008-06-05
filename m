Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbYFEQFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbYFEQFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758158AbYFEQEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:04:39 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:5836 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbYFEQEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:04:37 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: "caglar@pardus.org.tr" <caglar@pardus.org.tr>,
       "wim@iguana.be" <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 5 Jun 2008 16:03:39 +0000
Subject: RE: [hpwdt] BUG: unable to handle kernel paging request
Thread-Topic: [hpwdt] BUG: unable to handle kernel paging request
Thread-Index: AcjHCQF27hRgte78TeG8ZIbzHESRBQAHGrJQ
Message-ID: <E14D1C2A44812C4F9C3ED321127EDF6505A43845C9@G3W0854.americas.hpqcorp.net>
References: <200806051537.28651.caglar@pardus.org.tr>
In-Reply-To: <200806051537.28651.caglar@pardus.org.tr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-9"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please turn off the kernel's nmi watchdog by placing nmi_watchdog=0 in your menu.lst file. Let me know if this solves your problem.


Tom

-----Original Message-----
From: S.Çaðlar Onur [mailto:caglar@pardus.org.tr]
Sent: Thursday, June 05, 2008 7:37 AM
To: wim@iguana.be
Cc: Mingarelli, Thomas; linux-kernel@vger.kernel.org
Subject: [hpwdt] BUG: unable to handle kernel paging request

Hi;

One of our buildfarm servers (HP Proliant DL380g5) gaves following BUG output
and fails to boot while trying to "modprobe hpwdt" module with 2.6.25.4 +
current stable-queue patchset + and some distro specific patches (but none of
the patches touches drivers/watchdog/hpwdt.c)

[...]
hpwdt: New timer passed in is 30 seconds.
BUG: unable to handle kernel paging request at 003ac122
IP: [<c0100009>]
*pde = 00000000·
Oops: 0000 [#1] SMP·
Modules linked in: bnx2(+) joydev ipmi_si(+) thermal container processor
ipmi_msghandler button shpchp(+) iTCO_wdt i5000_edac(+) hpwdt(+)
iTCO_vendor_support e1000e(+) pci_hotplug
edac_core sg ext3 jbd mbcache sr_mod cdrom usbhid hid ff_memless ata_piix
cciss uhci_hcd pata_acpi ata_generic libata scsi_mod dock ehci_hcd usbcore

Pid: 1079, comm: modprobe Not tainted (2.6.25.4-96 #1)
EIP: 0060:[<c0100009>] EFLAGS: 00210246 CPU: 1
EIP is at 0xc0100009
EAX: c00f0000 EBX: c00ffee0 ECX: 00000000 EDX: 00002000
ESI: f90a4d4c EDI: f7511000 EBP: f7bd7dcc ESP: f7bd7dac
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 1079, ti=f7bd6000 task=f7b60e60 task.ti=f7bd6000)
Stack: f7511000 c00f0000 f7bd7dcc c00f0000 c00ffee0 f90a4cc0 f90a4c90
f7511000·
       f7bd7de0 c01e553f f7511054 00000000 f90a4cc0 f7bd7df4 c024106f
f751110c·
       f7511054 f90a4cc0 f7bd7e08 c0241160 f7bd7e14 00000000 c03baf10
f7bd7e2c·
Call Trace:
 [<c01e553f>] ? pci_device_probe+0x39/0x59
 [<c024106f>] ? driver_probe_device+0xa0/0x136
 [<c0241160>] ? __driver_attach+0x5b/0x91
 [<c0240a4c>] ? bus_for_each_dev+0x3b/0x63
 [<c0240f14>] ? driver_attach+0x14/0x16
 [<c0241105>] ? __driver_attach+0x0/0x91
 [<c024044a>] ? bus_add_driver+0x9d/0x1ba
 [<c02412d4>] ? driver_register+0x47/0xa7
 [<c0168441>] ? __vunmap+0x93/0x9b
 [<c01e56f4>] ? __pci_register_driver+0x35/0x61
 [<f882a017>] ? hpwdt_init+0x17/0x19 [hpwdt]
 [<c0141e8e>] ? sys_init_module+0x18ab/0x19c8
 [<f909e000>] ? i5000_put_devices+0x0/0x33 [i5000_edac]
 [<c0132199>] ? param_get_int+0x0/0x15
 [<c01bfdf6>] ? security_file_permission+0xf/0x11
 [<c017598d>] ? sys_read+0x3b/0x60
 [<c01049b0>] ? sysenter_past_esp+0x6d/0xa5
 [<c02d0000>] ? calibrate_delay+0x3f/0x277
 =======================
Code: 00 00 2a 80 32 80 50 20 20 38 30 33 43 4f 4d 50 41 51 ea 00 50 00 f0 31
32 2f 33 31 2f 39 39 20 fc 00 f6 86 11 02 00 00 40 75 14 <0f> 01 15 22 c1 3a
00 b8 18 00 00 00 8e d8 8e c0 8e e0 8e e8 fc·
EIP: [<c0100009>] 0xc0100009 SS:ESP 0068:f7bd7dac
---[ end trace b5fae4656daaaae4 ]---
[...]

Removing hpwdt.ko and rebooting solves this problem, you can find .config/full
dmesg and lspci -vv outputs from [1]

I didn't try 2.6.26-rc4 on that machine cause the only relevant change seems
following

git log v2.6.25..HEAD ./drivers/watchdog/hpwdt.c

commit 7f7f894c6d3285407b2493d1575500fb25e3d495
Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Tue Mar 25 17:17:30 2008 +0000

    [WATCHDOG] hpwdt: Fix NMI handling.


[1] http://cekirdek.pardus.org.tr/~caglar/watchdog/

If anything else is needed please just tell...

Cheers
--
S.Çaðlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
