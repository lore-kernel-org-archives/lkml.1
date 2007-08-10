Return-Path: <linux-kernel-owner+w=401wt.eu-S941328AbXHJTua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941328AbXHJTua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 15:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935409AbXHJTuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 15:50:19 -0400
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:35524 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511AbXHJTuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 15:50:17 -0400
Date: Fri, 10 Aug 2007 22:50:10 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: early boot lockup with 2.6.23-rc1
Message-ID: <20070810195010.GB2298@nalle>
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com> <20070809182316.GA2289@nalle> <20070809194348.GA2287@nalle> <46BB94B1.9020307@zytor.com> <20070810163324.GA1916@nalle> <46BC962B.9030209@zytor.com> <20070810192030.GB1916@nalle> <46BCBD57.3030406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BCBD57.3030406@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 12:32:39PM -0700, H. Peter Anvin wrote:
> Could you please describe your hardware configuration, in particular: 

In http://marc.info/?l=linux-kernel&m=118661306932149&w=2 but here
again:

> - what BIOS are you using;

      *-firmware
           description: BIOS
           vendor: Award Software, Inc.
           physical id: 0
           version: #401A0-0106xl (06/16/97)
           size: 64KB
           capacity: 64KB
           capabilities: isa pci pnp apm upgrade shadowing escd cdboot 
		bootselec socketedrom edd int13floppynec int13floppy360 
		int13floppy1200 int13floppy720 \
                int13floppy2880 int5printscreen int9keyboard int14serial int17p
                int10video
 
> - what disks, floppies, CD-ROMs, USB drives, etc are in your system;

       *-ide
             description: IDE interface
             product: 82371AB/EB/MB PIIX4 IDE
             vendor: Intel Corporation
             physical id: 1.1
             bus info: pci@00:01.1
             version: 01
             width: 32 bits
             clock: 33MHz
             capabilities: ide bus_master
             configuration: driver=PIIX_IDE latency=32
             resources: ioport:e000-e00f
           *-ide:0
                description: IDE Channel 0
                physical id: 0
                bus info: ide@0
                logical name: ide0
                clock: 33MHz
               *-disk
                   description: ATA Disk
                   product: IBM-DJNA-351520
                   vendor: IBM
                   physical id: 0
                   bus info: ide@0.0
                   logical name: /dev/hda
                   version: J56OA30K
                   serial: G80GLT9A589
                   size: 2016MB
                   capacity: 2016MB
                   capabilities: ata dma lba iordy smart security pm
partitioned
 partitioned:dos
                   configuration: mode=udma2 smart=on
                  *-volume:0
                      description: Linux swap / Solaris partition
                      physical id: 1
                      bus info: ide@0.0,1
                      logical name: /dev/hda1
                      capacity: 486MB
                      capabilities: primary nofs
                *-volume:1
                      description: Linux filesystem partition
                      physical id: 2
                      bus info: ide@0.0,2
                      logical name: /dev/hda2
                      capacity: 964MB
                      capabilities: primary bootable
                 *-volume:2
                      description: Linux filesystem partition
                      physical id: 3
                      bus info: ide@0.0,3
                      logical name: /dev/hda3
                      capacity: 564MB
                      capabilities: primary
           *-ide:1
                description: IDE Channel 1
                physical id: 1
                bus info: ide@1
                logical name: ide1
                clock: 33MHz
              *-disk
                   description: ATA Disk
                   product: ST340823A
                   vendor: Seagate
                   physical id: 1
                   bus info: ide@1.1
                   logical name: /dev/hdd
                   version: 3.07
                   serial: 7EF1EYYG
                   size: 37GB
                   capacity: 37GB
                   capabilities: ata dma lba iordy smart security pm
partitioned
 partitioned:dos
                   configuration: mode=udma2 smart=on
                 *-volume:0
                      description: Linux LVM Physical Volume partition
                      physical id: 1
                      bus info: ide@1.1,1
                      logical name: /dev/hdd1
                      serial: YwheMf-s0pv-97XS-sAOB-oGSk-WcHA-ZEo8Ag
                      size: 9601MB
                      capacity: 9601MB
                      capabilities: primary multi lvm2
                  *-volume:1
                      description: Linux LVM Physical Volume partition
                      physical id: 2
                      bus info: ide@1.1,2
                      logical name: /dev/hdd2
                      serial: TEN6QM-MVlA-LDlO-Moiu-O7mU-VTfZ-pinLz6
                      size: 15GB
                      capacity: 15GB
                      capabilities: primary multi lvm2
                 *-volume:2
                      description: Linux LVM Physical Volume partition
                      physical id: 3
                      bus info: ide@1.1,3
                      logical name: /dev/hdd3
                      serial: b9Xviu-XSOP-9lz4-4gcY-tE9W-fqxA-k2amBh
                      size: 12GB
                      capacity: 12GB
                      capabilities: primary multi lvm2 

> - are any of them RAIDed;

No.

> - what device and bootloader are you using for boot.

The first disk, IBM-DJNA-351520, and grub 0.97-27 from Debian:

title		Debian GNU/Linux, kernel 2.6.23-rc2
root		(hd0,1)
kernel		/boot/vmlinuz-2.6.23-rc2 root=/dev/hda2 ro 
initrd		/boot/initrd.img-2.6.23-rc2
savedefault
