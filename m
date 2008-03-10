Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbYCJQ6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbYCJQ6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYCJQ6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:58:03 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:63226 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYCJQ6A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:58:00 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.X: SATA/AHCI related boot delay.
Date: Mon, 10 Mar 2008 17:57:55 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <200803091922.33083.volker.armin.hemmann@tu-clausthal.de> <47D5320E.8020107@gmail.com>
In-Reply-To: <47D5320E.8020107@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200803101757.55617.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag, 10. März 2008, Tejun Heo wrote:

> >
> > With 2.6.24 based kernels I get this on cold boot:
> >
> > [   50.808824] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > [   80.743754] ata1.00: qc timeout (cmd 0xec)
> > [   80.743792] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>
> Does "irqpoll" make any difference?  Also, does the attached patch help?

irqpoll doesn't make any difference on cold boot or reboot (just adding 
irqpoll to kernel boot line, right?).

The attached patch does not change anything (except this:
ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
 as you can see in the dmesg parts below).

Here are several dmesg-parts:

dmesg part of cold boot with irqpoll but no patch:

[   28.256323] Driver 'sd' needs updating - please use bus_type methods
[   28.256396] ahci 0000:00:0a.0: version 3.0
[   28.256570] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   28.256614] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   29.257150] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   29.257202] ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
[   29.257241] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   29.257442] scsi0 : ahci
[   29.257538] scsi1 : ahci
[   29.257604] scsi2 : ahci
[   29.257671] scsi3 : ahci
[   29.257760] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 315
[   29.257808] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 315
[   29.257855] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 315
[   29.257903] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 315
[   29.889103] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   59.824033] ata1.00: qc timeout (cmd 0xec)
[   59.824072] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   59.824111] ata1: failed to recover some devices, retrying in 5 secs
[   65.448472] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   65.449133] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   65.449176] ata1.00: 312581808 sectors, multi 16: LBA48
[   65.449814] ata1.00: configured for UDMA/133
[   66.080432] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   66.083950] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   66.083989] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   66.085988] ata2.00: configured for UDMA/133
[   66.403064] ata3: SATA link down (SStatus 0 SControl 300)
[   66.722369] ata4: SATA link down (SStatus 0 SControl 300)
[   66.722458] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   66.722566] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   66.722611] sd 0:0:0:0: [sda] Write Protect is off
[   66.722649] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   66.722657] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   66.722727] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   66.722771] sd 0:0:0:0: [sda] Write Protect is off
[   66.722808] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   66.722816] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   66.722865]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   66.748447] sd 0:0:0:0: [sda] Attached SCSI disk
[   66.748580] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   66.748688] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   66.748733] sd 1:0:0:0: [sdb] Write Protect is off
[   66.748771] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   66.748779] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   66.748849] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   66.748892] sd 1:0:0:0: [sdb] Write Protect is off
[   66.748930] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   66.748938] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   66.748987]  sdb: sdb1 sdb2
[   66.779349] sd 1:0:0:0: [sdb] Attached SCSI disk

--------------------------------------------------------------------------------

dmesg-part of reboot with patch and without irqpoll:

[   28.104714] Driver 'sd' needs updating - please use bus_type methods
[   28.104787] ahci 0000:00:0a.0: version 3.0
[   28.104961] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   28.105004] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   28.105342] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
[   29.105540] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   29.105588] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio
[   29.105628] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   29.105828] scsi0 : ahci
[   29.105924] scsi1 : ahci
[   29.105990] scsi2 : ahci
[   29.106057] scsi3 : ahci
[   29.106145] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 315
[   29.106193] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 315
[   29.106240] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 315
[   29.106288] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 315
[   34.580304] ata1: port is slow to respond, please be patient (Status 0xd0)
[   39.423111] ata1: softreset failed (device not ready)
[   39.895423] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   39.896058] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   39.896101] ata1.00: 312581808 sectors, multi 16: LBA48
[   39.896737] ata1.00: configured for UDMA/133
[   40.367728] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   40.381404] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   40.381443] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   40.383449] ata2.00: configured for UDMA/133
[   40.693685] ata3: SATA link down (SStatus 0 SControl 300)
[   41.006339] ata4: SATA link down (SStatus 0 SControl 300)
[   41.006428] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   41.006536] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   41.006581] sd 0:0:0:0: [sda] Write Protect is off
[   41.006618] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   41.006626] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   41.006696] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   41.006739] sd 0:0:0:0: [sda] Write Protect is off
[   41.006777] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   41.006784] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   41.006833]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   41.040248] sd 0:0:0:0: [sda] Attached SCSI disk
[   41.040383] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   41.040491] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   41.040541] sd 1:0:0:0: [sdb] Write Protect is off
[   41.040579] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   41.040588] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   41.040658] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   41.040700] sd 1:0:0:0: [sdb] Write Protect is off
[   41.040738] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   41.040746] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   41.040795]  sdb: sdb1 sdb2
[   41.083031] sd 1:0:0:0: [sdb] Attached SCSI disk

---------------------------------------------------------------------------------

dmesg-part of cold boot with your patch and without irqpoll:

[   42.331101] Driver 'sd' needs updating - please use bus_type methods
[   42.331174] ahci 0000:00:0a.0: version 3.0
[   42.331348] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   42.331391] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   42.331728] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
[   43.331928] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   43.331976] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio
[   43.332015] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   43.332216] scsi0 : ahci
[   43.332312] scsi1 : ahci
[   43.332378] scsi2 : ahci
[   43.332444] scsi3 : ahci
[   43.332533] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 315
[   43.332581] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 315
[   43.332628] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 315
[   43.332675] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 315
[   43.804230] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   73.739161] ata1.00: qc timeout (cmd 0xec)
[   73.739200] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   73.739238] ata1: failed to recover some devices, retrying in 5 secs
[   79.203946] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   79.204575] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   79.204617] ata1.00: 312581808 sectors, multi 16: LBA48
[   79.205269] ata1.00: configured for UDMA/133
[   79.676252] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   79.696817] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   79.696857] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   79.698846] ata2.00: configured for UDMA/133
[   80.008861] ata3: SATA link down (SStatus 0 SControl 300)
[   80.321514] ata4: SATA link down (SStatus 0 SControl 300)
[   80.321604] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   80.321712] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   80.321756] sd 0:0:0:0: [sda] Write Protect is off
[   80.321794] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   80.321802] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   80.321872] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   80.321915] sd 0:0:0:0: [sda] Write Protect is off
[   80.321952] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   80.321959] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   80.322008]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   80.353592] sd 0:0:0:0: [sda] Attached SCSI disk
[   80.353724] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   80.353832] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   80.353877] sd 1:0:0:0: [sdb] Write Protect is off
[   80.353915] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   80.353923] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   80.353993] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   80.354036] sd 1:0:0:0: [sdb] Write Protect is off
[   80.354074] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   80.354081] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   80.354130]  sdb: sdb1 sdb2
[   80.360468] sd 1:0:0:0: [sdb] Attached SCSI disk

------------------------------------------------------------------------------------

dmesg part of cold boot with your patch and irqpoll:

[   38.535559] Driver 'sd' needs updating - please use bus_type methods
[   38.535632] ahci 0000:00:0a.0: version 3.0
[   38.535806] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   38.535850] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 
(level, low) -> IRQ 23
[   38.536187] ahci 0000:00:0a.0: controller can't do PMP, turning off CAP_PMP
[   39.536386] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf 
impl IDE mode
[   39.536435] ahci 0000:00:0a.0: flags: 64bit sntf led clo pio
[   39.536474] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   39.536675] scsi0 : ahci
[   39.536771] scsi1 : ahci
[   39.536838] scsi2 : ahci
[   39.536904] scsi3 : ahci
[   39.536993] ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 
irq 315
[   39.537041] ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 
irq 315
[   39.537088] ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 
irq 315
[   39.537135] ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 
irq 315
[   40.008689] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   69.943620] ata1.00: qc timeout (cmd 0xec)
[   69.943658] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[   69.943697] ata1: failed to recover some devices, retrying in 5 secs
[   75.408405] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   75.409006] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   75.409049] ata1.00: 312581808 sectors, multi 16: LBA48
[   75.409721] ata1.00: configured for UDMA/133
[   75.880711] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   75.901259] ata2.00: ATA-8: SAMSUNG HD501LJ, CR100-12, max UDMA7
[   75.901298] ata2.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[   75.903294] ata2.00: configured for UDMA/133
[   76.213320] ata3: SATA link down (SStatus 0 SControl 300)
[   76.525973] ata4: SATA link down (SStatus 0 SControl 300)
[   76.526062] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10.0 
PQ: 0 ANSI: 5
[   76.526170] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   76.526215] sd 0:0:0:0: [sda] Write Protect is off
[   76.526252] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   76.526261] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   76.526330] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 
MB)
[   76.526374] sd 0:0:0:0: [sda] Write Protect is off
[   76.526411] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   76.526418] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   76.526467]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   76.555492] sd 0:0:0:0: [sda] Attached SCSI disk
[   76.555626] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[   76.555735] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   76.555779] sd 1:0:0:0: [sdb] Write Protect is off
[   76.555817] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   76.555826] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   76.555895] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 
MB)
[   76.555944] sd 1:0:0:0: [sdb] Write Protect is off
[   76.555981] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   76.555989] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[   76.556038]  sdb: sdb1 sdb2
[   76.616249] sd 1:0:0:0: [sdb] Attached SCSI disk

-----------------------------------------------------------------------------------------------

If you want me to try more things, just drop a note - or the complete dmesgs.


>
> > and this on reboots:
> >
> > [   36.619135] ata1: port is slow to respond, please be patient (Status
> > 0xd0) [   40.982984] ata1: softreset failed (device not ready)
>
> Is this consistent?  Do you always get IDENTIFY timeout on cold boots
> and softreset failure on reboots?

yes. I don't watch every (re)boot. But evertime I look into dmesg I see the 
IDENTIFY timeout or the softreset failure.

Cold-boot, entering bios, change something, save changes, reboot on exit 
counts as 'cold boot'.

> > If I change from 'non raid' to AHCI (because the handbook says that is
> > the way to get NCQ working) boot hangs for looong time and no harddisks
> > are found: (dmesg from systemrescuecd 1.0)
> > ahci 0000:00:0a.0: version 3.0
> > ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
> > ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23 (level, low)
> > -> IRQ 18
> > ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA
> > mode ahci 0000:00:0a.0: flags: 64bit sntf led clo pmp pio
> > PCI: Setting latency timer of device 0000:00:0a.0 to 64
> > scsi3 : ahci
> > scsi4 : ahci
> > scsi5 : ahci
> > scsi6 : ahci
> > ata1: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc100 irq 218
> > ata2: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc180 irq 218
> > ata3: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc200 irq 218
> > ata4: SATA max UDMA/133 abar m8192@0xf9dfc000 port 0xf9dfc280 irq 218
> > ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > APIC error on CPU0: 00(40)
> > scsi_scan_2 used greatest stack depth: 2868 bytes left
> > ata1.00: qc timeout (cmd 0xec)
> > ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> > ata1: failed to recover some devices, retrying in 5 secs
>
> This one definitely looks like a misrouted IRQ.  irqpoll should help.
> This failure is the same for 2.6.23 and 24, right?

yes. This failure has been with all kernels and bios versions I ever tried. I 
only added it to show that I tried different bios settings.

With irqpoll the Interrupt reported changes from 218 to 315 (but this 
might be caused by the different kernels). But irqpoll does not help - and 
with the appropriate kernel-panic because no root-fs found. I can do some 
more (re)boots to check that.

Thanks for looking into this.

Glück Auf,
Volker

