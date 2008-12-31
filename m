Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbYLaSjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbYLaSjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYLaSjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:39:20 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:46731 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbYLaSjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=JLSN5MvS44JIJkceepbhRfE6c9GKwPu09jk+tV9IYbF/EMyLReCg1GbR/RN4uDmQ/8
         yQ9L7E8vwMlhwcaLaIL8+SS9yQQ+rjH1ml2LUjYf8De8DWInNV3Wl0Dqcaq1Bph2cb6J
         m1w43Pd5Mi4izYdjywASIkebWdDVusGzCiBgM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Bruno =?utf-8?q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Subject: Re: S3 with pata_via fails to resume, ide_via82Cxxx works
Date: Wed, 31 Dec 2008 19:19:14 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-next-20081229; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
References: <20081230185037.7ec94e94@neptune.home> <20081230215953.235ce1b4@neptune.home>
In-Reply-To: <20081230215953.235ce1b4@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200812311919.14579.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 December 2008, Bruno Prémont wrote:
> On Tue, 30 December 2008 Bruno Prémont wrote:
> > Secondary note, with ATA subsystem it is possible to discover
> > hot-plugged second SATA drive with issuing
> >   echo '- - -' > host0/scsi_host/host0/scan
> > though the same action causes the access to first SATA drive to fail
> > after removing second drive. (unfortunately BIOS does only allows
> > configuring the chipset in IDE mode - so not possible to use SATA_VIA
> > or AHCI). I guess this is caused by some incorrect detection of speed
> > settings.
> > 
> > What is the way to ask driver to rescan with IDE driver?
> I found:
>   Documentation/ide/warm-plug-howto.txt
> 
> 
> Doing just:
>   echo -n "1" > /sys/class/ide_port/idex/scan
> causes the following BUG():
> <<<< during boot
> Dec 30 18:19:50 venus [    3.909946] Uniform Multi-Platform E-IDE driver
> Dec 30 18:19:50 venus [    3.913075] via82cxxx 0000:00:0f.0: VIA cx700 (rev 00) IDE UDMA133
> Dec 30 18:19:50 venus [    3.916069] via82cxxx 0000:00:0f.0: IDE controller (0x1106:0x0581 rev 0x00)
> Dec 30 18:19:50 venus [    3.919138] via82cxxx 0000:00:0f.0: not 100% native mode: will probe irqs later
> Dec 30 18:19:50 venus [    3.924945]     ide0: BM-DMA at 0xff00-0xff07
> Dec 30 18:19:50 venus [    3.927990]     ide1: BM-DMA at 0xff08-0xff0f
> Dec 30 18:19:50 venus [    3.930901] Probing IDE interface ide0...
> Dec 30 18:19:50 venus [    4.050047] Marking TSC unstable due to cpufreq changes
> Dec 30 18:19:50 venus [    4.370099] hda: FUJITSU MHY2250BH, ATA DISK drive
> Dec 30 18:19:50 venus [    4.390026] Clocksource tsc unstable (delta = -215834270 ns)
> Dec 30 18:19:50 venus [    4.730309] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> Dec 30 18:19:50 venus [    4.730462] hda: UDMA/100 mode selected
> Dec 30 18:19:50 venus [    4.735541] Probing IDE interface ide1...
> Dec 30 18:19:50 venus [    5.420127] hdd: , ATA DISK drive
> Dec 30 18:19:50 venus [    5.480288] hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO2
> Dec 30 18:19:50 venus [    5.480330] hdd: UDMA/66 mode selected
> Dec 30 18:19:50 venus [    5.485099] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Dec 30 18:19:50 venus [    5.565605] ide1 at 0x170-0x177,0x376 on irq 15
> Dec 30 18:19:50 venus [    5.573072] ide-gd driver 1.18
> Dec 30 18:19:50 venus [    5.577684] hda: max request size: 512KiB
> Dec 30 18:19:50 venus [    5.582339] hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63
> Dec 30 18:19:50 venus [    5.592346] hda: cache flushes supported
> Dec 30 18:19:50 venus [    5.597500]  hda: hda1 hda2 hda3 hda4 hda5 hda6
> Dec 30 18:19:50 venus [    5.646208] hdd: max request size: 128KiB
> Dec 30 18:19:50 venus [    5.651361] hdd: 8043840 sectors (4118 MB) w/1KiB Cache, CHS=7980/16/63
> Dec 30 18:19:50 venus [    5.656901]  hdd: hdd1
> -- snip --
> <<<< some time later, triggering the scan
> Dec 30 21:35:55 venus [ 7866.335247] Probing IDE interface ide0...
> Dec 30 21:35:55 venus [ 7866.650105] hda: FUJITSU MHY2250BH, ATA DISK drive
> Dec 30 21:35:56 venus [ 7867.370055] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> Dec 30 21:35:56 venus [ 7867.370221] hda: UDMA/100 mode selected
> Dec 30 21:35:56 venus [ 7867.370375] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> Dec 30 21:35:56 venus [ 7867.370400] IP: [<c0248bf6>] elv_may_queue+0x6/0x20
> Dec 30 21:35:56 venus [ 7867.370440] *pde = 00000000 
> Dec 30 21:35:56 venus [ 7867.370459] Oops: 0000 [#1] 
> Dec 30 21:35:56 venus [ 7867.375572] last sysfs file: /sys/devices/pci0000:00/0000:00:0f.0/ide0/ide_port/ide0/scan
> Dec 30 21:35:56 venus [ 7867.380014] Modules linked in: snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc via_agp agpgart
> Dec 30 21:35:56 venus [ 7867.380014] 
> Dec 30 21:35:56 venus [ 7867.380014] Pid: 1855, comm: bash Not tainted (2.6.28-ide #3) CX700+W697HG
> Dec 30 21:35:56 venus [ 7867.380014] EIP: 0060:[<c0248bf6>] EFLAGS: 00010046 CPU: 0
> Dec 30 21:35:56 venus [ 7867.380014] EIP is at elv_may_queue+0x6/0x20
> Dec 30 21:35:56 venus [ 7867.380014] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
> Dec 30 21:35:56 venus [ 7867.380014] ESI: 00000000 EDI: 00000010 EBP: f6bb3e28 ESP: f6bb3e24
> Dec 30 21:35:56 venus [ 7867.380014]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Dec 30 21:35:56 venus [ 7867.380014] Process bash (pid: 1855, ti=f6bb3000 task=f7110d80 task.ti=f6bb3000)
> Dec 30 21:35:56 venus [ 7867.380014] Stack:
> Dec 30 21:35:56 venus [ 7867.380014]  00000000 f6bb3e50 c024b40b 00000000 000000e1 f7005890 00000078 00000282
> Dec 30 21:35:56 venus [ 7867.380014]  00000000 f73d0020 00000000 f6bb3e80 c024b82c 00000010 00000000 f6bb3e7c
> Dec 30 21:35:56 venus [ 7867.380014]  00000282 00000001 000000e1 000000e1 00000001 f73d0020 f6bb3ee4 f6bb3e8c
> Dec 30 21:35:56 venus [ 7867.380014] Call Trace:
> Dec 30 21:35:56 venus [ 7867.380014]  [<c024b40b>] ? get_request+0x1b/0x240
> Dec 30 21:35:56 venus [ 7867.380014]  [<c024b82c>] ? get_request_wait+0x1c/0xd0
> Dec 30 21:35:56 venus [ 7867.380014]  [<c024bc48>] ? blk_get_request+0x18/0x30
> Dec 30 21:35:56 venus [ 7867.380014]  [<c02e2d3a>] ? ide_raw_taskfile+0x2a/0x90
> Dec 30 21:35:56 venus [ 7867.380014]  [<c02e2e21>] ? taskfile_lib_get_identify+0x61/0x70
> Dec 30 21:35:56 venus [ 7867.380014]  [<c02e5ff0>] ? ide_acpi_port_init_devices+0x90/0xe0
> Dec 30 21:35:56 venus [ 7867.380014]  [<c02e2379>] ? ide_port_scan+0x39/0x50
> Dec 30 21:35:56 venus [ 7867.380014]  [<c02e23d1>] ? store_scan+0x41/0x60
> Dec 30 21:35:56 venus [ 7867.380014]  [<c02e2390>] ? store_scan+0x0/0x60
> Dec 30 21:35:56 venus [ 7867.380014]  [<c02cc03c>] ? dev_attr_store+0x2c/0x40
> Dec 30 21:35:56 venus [ 7867.380014]  [<c01a468d>] ? sysfs_write_file+0x9d/0x100
> Dec 30 21:35:56 venus [ 7867.380014]  [<c016b215>] ? vfs_write+0x95/0x120
> Dec 30 21:35:56 venus [ 7867.380014]  [<c01a45f0>] ? sysfs_write_file+0x0/0x100
> Dec 30 21:35:56 venus [ 7867.380014]  [<c016b34d>] ? sys_write+0x3d/0x70
> Dec 30 21:35:56 venus [ 7867.380014]  [<c0103b01>] ? sysenter_do_call+0x12/0x25
> Dec 30 21:35:56 venus [ 7867.380014] Code: bf 00 00 00 00 55 8b 40 0c 89 e5 8b 00 8b 48 34 85 c9 74 04 89 d0 ff d1 5d c3 8d 74 26 00 8d bc 27 00 00 00 00 55 89 e5 53 89 c3 <8b> 40 0c 8b 00 8b 48 38 31 c0 85 c9 74 04 89 d8 ff d1 5b 5d c3 
> Dec 30 21:35:56 venus [ 7867.380014] EIP: [<c0248bf6>] elv_may_queue+0x6/0x20 SS:ESP 0068:f6bb3e24
> Dec 30 21:35:56 venus [ 7867.380014] ---[ end trace b966cf347b1167e4 ]---
> Dec 30 21:36:15 venus [ 7886.330025] ide_timer_expiry: hwgroup->drive was NULL
> Dec 30 21:36:29 venus [ 7899.770239] Buffer I/O error on device hda3, logical block 115511
> Dec 30 21:36:29 venus [ 7899.777078] lost page write due to I/O error on hda3
> Dec 30 21:36:29 venus [ 7899.783856] Buffer I/O error on device hda3, logical block 115512
> Dec 30 21:36:29 venus [ 7899.790570] lost page write due to I/O error on hda3
> 
> Same effect with:
>   cd /sys/class/ide_port/ide0/
>   sync; sleep 1; echo -n 1 > delete_devices; sleep 1; echo -n 1 > scan

Thanks for the report, the following patch fixes the OOPS for me:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix ide_port_scan() to do ACPI setup after initializing request queues

This makes ide_port_scan()'s behavior match ide_host_register()'s
one and fixes OOPS in elv_may_queue() during port re-scan.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1694,8 +1694,8 @@ void ide_port_scan(ide_hwif_t *hwif)
 	hwif->present = 1;
 
 	ide_port_tune_devices(hwif);
-	ide_acpi_port_init_devices(hwif);
 	ide_port_setup_devices(hwif);
+	ide_acpi_port_init_devices(hwif);
 	hwif_register_devices(hwif);
 	ide_proc_port_register_devices(hwif);
 }
