Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbYBMMo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbYBMMo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYBMMoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:44:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41472 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYBMMoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:44:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.24-mm1 and 2.6.24-git13 kernel panic's while bootup at ide_device_add_all
Date: Wed, 13 Feb 2008 13:42:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ananth@in.ibm.com,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
References: <47A81865.9000506@linux.vnet.ibm.com>
In-Reply-To: <47A81865.9000506@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802131342.39803.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 5 of February 2008, Kamalesh Babulal wrote:
> Hi,
> 
> The kernel bootup panics with the 2.6.24-mm1 and 2.6.24-git13 kernel
> while defconfig compiled in for x86_64 (Intel(R) Xeon) box

Is that still happening or has it been fixed?

Rafael


> BUG: unable to handle kernel paging request at ffffffffffffffb0
> IP: [<ffffffff80413642>] init_irq+0x188/0x444
> PGD 203067 PUD 204067 PMD 0 
> Oops: 0000 [1] SMP 
> CPU 2 
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.24 #1
> RIP: 0010:[<ffffffff80413642>]  [<ffffffff80413642>] init_irq+0x188/0x444
> RSP: 0018:ffff81022f093e00  EFLAGS: 00010287
> RAX: ffffffffffffff90 RBX: ffffffff808a9100 RCX: 0000000000000000
> RDX: 00000000ffffffff RSI: ffff81022fc039c0 RDI: ffffffff8074dd00
> RBP: ffff81022f093e30 R08: ffffffff808af880 R09: 0000000000000002
> R10: 0000000000000001 R11: ffff8100000bed60 R12: ffffffff808b0400
> R13: ffffffff808b0410 R14: 0000000000000000 R15: ffffffffffffffff
> FS:  0000000000000000(0000) GS:ffff81022f0883c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: ffffffffffffffb0 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff81022f092000, task ffff81022f0797d0)
> Stack:  ffff81022f093e30 0000000000000000 ffffffff808a9100 ffffffff808a9120
>  00000000ffffffed 0000000000000000 ffff81022f093eb0 ffffffff80414425
>  ffff81022f093ec0 0000000000000000 000000008074e920 0000000000000246
> Call Trace:
>  [<ffffffff80414425>] ide_device_add_all+0xb27/0xe1b
>  [<ffffffff807d2884>] ide_generic_init+0x3a/0x3e
>  [<ffffffff807b473b>] kernel_init+0x175/0x2e7
>  [<ffffffff8020bff8>] child_rip+0xa/0x12
>  [<ffffffff80372350>] ? acpi_ds_init_one_object+0x0/0x88
>  [<ffffffff807b45c6>] ? kernel_init+0x0/0x2e7
>  [<ffffffff8020bfee>] ? child_rip+0x0/0x12
> 
> 
> Code: 89 03 49 8b 45 18 48 89 18 48 39 1b 75 04 0f 0b eb fe fe 05 51 51 38 00 fb eb 5b 48 8b 83 28 07 00 00 83 ca ff 48 83 e8 70 74 0e <48> 8b 40 20 48 8b 80 88 00 00 00 8b 50 04 48 8b 3d 79 ff 2f 00 
> RIP  [<ffffffff80413642>] init_irq+0x188/0x444
>  RSP <ffff81022f093e00>
> CR2: ffffffffffffffb0
> ---[ end trace 9010a4c8c4ba608a ]---
> 
> (gdb) p init_irq
> $1 = {int (ide_hwif_t *)} 0xffffffff804134ba <init_irq>
> (gdb) p/x 0xffffffff804134ba+0x188
> $2 = 0xffffffff80413642
> (gdb) l *0xffffffff80413642
> 0xffffffff80413642 is in init_irq (include/linux/ide.h:1311).
> 1306            print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 2, id, 512, 0);
> 1307    }
> 1308
> 1309    static inline int hwif_to_node(ide_hwif_t *hwif)
> 1310    {
> 1311            struct pci_dev *dev = to_pci_dev(hwif->dev);
> 1312            return dev ? pcibus_to_node(dev->bus) : -1;
> 1313    }
> 1314
> 1315    static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
> (gdb) 
> 
> (gdb) p ide_device_add_all
> $1 = {int (u8 *, const struct ide_port_info *)} 0xffffffff804138fe <ide_device_add_all>
> (gdb) p/x 0xffffffff804138fe
> $2 = 0xffffffff804138fe
> (gdb) l *0xffffffff804138fe
> 0xffffffff804138fe is in ide_device_add_all (drivers/ide/ide-probe.c:1372).
> 1367                            hwif->cbl = hwif->cable_detect(hwif);
> 1368            }
> 1369    }
> 1370
> 1371    int ide_device_add_all(u8 *idx, const struct ide_port_info *d)
> 1372    {
> 1373            ide_hwif_t *hwif, *mate = NULL;
> 1374            int i, rc = 0;
> 1375
> 1376            for (i = 0; i < MAX_HWIFS; i++) {
> (gdb) 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
