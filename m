Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744AbYHLGw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbYHLGw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYHLGws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:52:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:54536 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYHLGwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ky1Gh63p4bT947xUcoeGMjLTJ61XrAIv1qL/Is3fz6Z7bBxbHkrWAfJS/sDGnJRohM
         FkelkPXFjBbH8dy1ElMfjP0l3z18Wl7fxCCfm25BFVMT6YVzPx9wn2Dbtq5r6XjOkBB9
         kMPkTiPdQicw5yY8iWqs/Sbf6fwxeAGpgwiWE=
Message-ID: <86802c440808112352j2175d2edlf421c44499f8c1c0@mail.gmail.com>
Date: Mon, 11 Aug 2008 23:52:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Cc: "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <20080811202731.GB2916@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	 <20080811202731.GB2916@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 1:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
>
>> A have problem with booting 2.6.26* and 2.6.27-rc* kernels. Very often
>> booting stops on this message:
>>
>> [...]
>> Uniform Multi-Platform E-IDE driver
>> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
>> ICH7: IDE controller (0x8086:0x27df rev 0x01) at  PCI slot 0000:00:1f.1
>> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
>> ICH7: not 100% native mode: will probe irqs later
>> ICH7: IDE port disabled
>>     ide0: BM-DMA at 0x60a0-0x60a7
>>
>> afer should be:
>> hda: MATSHITADVD-RAM UJ-840S, ATAPI CD/DVD-ROM drive
>> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
>> hda: MWDMA2 mode selected
>> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>> [...]
>>
>> Initially I was think, that is hardware problem. But XP and 2.6.25.8
>> work with _no_ problem (booting from xp, linux, knoppix, linux
>> firmware development kit - about 50 reboots).
>
>> http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.26.2.txt
>> dmesg: http://unixy.pl/maciek/download/kernel/dupa/dmesg-2.6.25.8.txt
>
> i had a look at diff -up dmesg-2.6.25.8.txt dmesg-2.6.26.2.txt, and
> these changes stood out:

> -Uniform Multi-Platform E-IDE driver
> -ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> -ICH7: IDE controller (0x8086:0x27df rev 0x01) at  PCI slot 0000:00:1f.1
> -ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
> -ICH7: not 100% native mode: will probe irqs later
> -ICH7: IDE port disabled
> -    ide0: BM-DMA at 0x60a0-0x60a7, BIOS settings: hda:DMA, hdb:PIO
> -Probing IDE interface ide0...
> -hda: MATSHITADVD-RAM UJ-840S, ATAPI CD/DVD-ROM drive
> -hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> -hda: MWDMA2 mode selected
> -ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> -hda: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
> -Uniform CD-ROM driver Revision: 3.20
>  Driver 'sd' needs updating - please use bus_type methods
> +Driver 'sr' needs updating - please use bus_type methods
>  ahci 0000:00:1f.2: version 3.0
>  ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
>  ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode

> @@ -329,13 +320,13 @@ ata1: SATA link up 1.5 Gbps (SStatus 113
>  ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
>  ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
>  ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
> -ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> +ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
>  ata1.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
>  ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
>  ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
>  ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
>  ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
> -ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
> +ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
>  ata1.00: configured for UDMA/133
>  ata1.00: configured for UDMA/133
>  ata1: EH complete
> @@ -350,6 +341,20 @@ sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 0
>  sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
>  sd 0:0:0:0: [sda] Attached SCSI disk
> +ata_piix 0000:00:1f.1: version 2.12
> +ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
> +PCI: Setting latency timer of device 0000:00:1f.1 to 64
> +scsi4 : ata_piix
> +scsi5 : ata_piix
> +ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
> +ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
> +ata5.00: ATAPI: MATSHITADVD-RAM UJ-840S, 1.11, max MWDMA2
> +ata5.00: configured for MWDMA2
> +ata6: port disabled. ignoring.
> +scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-840S  1.11 PQ: 0 ANSI: 5
> +sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> +Uniform CD-ROM driver Revision: 3.20
> +sr 4:0:0:0: Attached scsi CD-ROM sr0

looks like you are using ata driver for pata device instead of ide driver.

so could be caused by bug in ata_piix...

YH
