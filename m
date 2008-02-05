Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbYBEXVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbYBEXVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbYBEXVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:21:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46710 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbYBEXVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:21:36 -0500
Date: Tue, 5 Feb 2008 15:21:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Hokenson <kernel+marvell@gozer.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Problem burning DVDs with Marvell 88SE6121 on pata_marvell
Message-Id: <20080205152131.065ca0b5.akpm@linux-foundation.org>
In-Reply-To: <20080202223004.GA24490@gozer.dminteractive.com>
References: <20080202223004.GA24490@gozer.dminteractive.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(added linux-ide)

On Sat, 2 Feb 2008 16:30:04 -0600
Mike Hokenson <kernel+marvell@gozer.org> wrote:

> I recently put together a new system with a MSI P35 PLATINUM and although
> reading from data CDs, DVDs, and watching DVD movies is working fine, DVD
> burning isn't. MSI's manual says "1 IDE port by Marvell 88SE6111", but
> lspci says it's a 88SE6121. I have two DVD burners, a SONY DRU-510A and
> a DRU-820A. They were both working fine with TDK DVD+R media on my ASUS
> K8V SE DELUXE (VIA IDE controller) prior to the upgrade.
> 
> Here's what I see with dvd+rw-tools version 7.0-9:
> 
> sh# dvd+rw-mediainfo /dev/dvd > /dev/null          # this is blank media
> :-[ GET CURRENT PERFORMACE failed with SK=5h/ASC=24h/ACQ=00h]: Input/output error
> :-[ READ TOC failed with SK=5h/ASC=24h/ACQ=00h]: Input/output error
> 
> sh# growisofs -dvd-compat -speed=2.4 -Z /dev/dvd -rJ -joliet-long -quiet "burn"
> Executing 'genisoimage -rJ -joliet-long -quiet burn | builtin_dd of=/dev/dvd obs=32k seek=0'
> /dev/dvd: "Current Write Speed" is 2.5x1352KBps.
> :-[ WRITE@LBA=70h failed with SK=3h/ASC=0Ch/ACQ=00h]: Input/output error
> :-( write failed: Input/output error
> /dev/dvd: flushing cache
> /dev/dvd: closing track
> :-[ CLOSE TRACK failed with SK=5h/ASC=30h/ACQ=05h]: Wrong medium type
> /dev/dvd: closing disc
> :-[ CLOSE DISC failed with SK=5h/ASC=30h/ACQ=05h]: Wrong medium type
> 
> sh# dvd+rw-mediainfo /dev/dvd > /dev/null
> :-[ READ TRACK INFORMATION failed with SK=3h/ASC=11h/ACQ=05h]: Input/output error

(this is 2.6.24)

If nothing happens with this report in the next few days, please create an
entry at bugzilla.kernel.org so we can keep an eye on it, thanks.

Trying older kernels might be interesting, find out if it's a regression or
if it was always this way.


> And from cdrecord version 1.1.6-1:
> 
> sh# mkisofs -rJ -joliet-long -quiet "burn" | cdrecord -v dev=/dev/dvd -
> wodim: No write mode specified.
> wodim: Asuming -tao mode.
> wodim: Future versions of wodim may have different drive dependent defaults.
> TOC Type: 1 = CD-ROM
> scsidev: '/dev/dvd'
> devname: '/dev/dvd'
> scsibus: -2 target: -2 lun: -2
> Linux sg driver version: 3.5.27
> Wodim version: 1.1.6
> SCSI buffer size: 64512
> Device type    : Removable CD-ROM
> Version        : 5
> Response Format: 2
> Capabilities   :
> Vendor_info    : 'SONY    '
> Identification : 'DVD RW DRU-820A '
> Revision       : '1.0c'
> Device seems to be: Generic mmc2 DVD-R/DVD-RW.
> Current: 0x0009 (CD-R)
> Profile: 0x002B (DVD+R/DL)
> Profile: 0x001B (DVD+R)
> Profile: 0x001A (DVD+RW)
> Profile: 0x0016 (DVD-R/DL layer jump recording)
> Profile: 0x0015 (DVD-R/DL sequential recording)
> Profile: 0x0014 (DVD-RW sequential recording)
> Profile: 0x0013 (DVD-RW restricted overwrite)
> Profile: 0x0012 (DVD-RAM)
> Profile: 0x0011 (DVD-R sequential recording)
> Profile: 0x0010 (DVD-ROM)
> Profile: 0x000A (CD-RW)
> Profile: 0x0009 (CD-R) (current)
> Profile: 0x0008 (CD-ROM)
> Profile: 0x0002 (Removable disk)
> Using generic SCSI-3/mmc   CD-R/CD-RW driver (mmc_cdr).
> Driver flags   : MMC-3 SWABAUDIO BURNFREE
> Supported modes: TAO PACKET SAO SAO/R96P SAO/R96R RAW/R16 RAW/R96P RAW/R96R
> Drive buf size : 1114112 = 1088 KB
> Beginning DMA speed test. Set CDR_NODMATEST environment variable if device
> communication breaks or freezes immediately after that.
> FIFO size      : 12582912 = 12288 KB
> Track 01: data  unknown length
> Total size:        0 MB (00:00.00) = 0 sectors
> Lout start:        0 MB (00:02/00) = 0 sectors
> Current Secsize: 2048
> ATIP info from disk:
>   Indicated writing power: 4
>   Is not unrestricted
>   Is not erasable
>   Disk sub type: Medium Type A, high Beta category (A+) (3)
>   ATIP start of lead in:  -11849 (97:24/01)
>   ATIP start of lead out: 359847 (79:59/72)
> Disk type:    Long strategy type (Cyanine, AZO or similar)
> Manuf. index: 25
> Manufacturer: Taiyo Yuden Company Limited
> wodim: WARNING: Total disk size unknown. Data may not fit on disk.
> Speed set to 7056 KB/s
> Starting to write CD/DVD at speed  40.0 in real TAO mode for single session.
> Last chance to quit, starting real write i   0 seconds. Operation starts.
> Waiting for reader process to fill input buffer ... input buffer ready.
> Performing OPC...
> Starting new track at sector: 0
> Track 01:    1 MB written (fifo 100%) [buf  97%]   5.4x.Errno: 5 (Input/output error), write_g1 scsi sendcmd: no error
> CDB:  2A 00 00 00 03 64 00 00 1F 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes: 70 00 04 00 00 00 00 0A CF DC 00 00 08 03 00 00
> Sense Key: 0x4 Hardware Error, Segment 0
> Sense Code: 0x08 Qual 0x03 (logical unit communication crc error (ultra-dma/32)) Fru 0x0
> Sense flags: Blk 0 (not valid)
> cmd finished after 30.186s timeout 40s
> 
> write track data: error after 1777664 bytes
> wodim: A write error occured.
> wodim: Please properly read the error message above.
> Writing  time:   46.572s
> Fixating...
> Errno: 5 (Input/output error), close track/session scsi sendcmd: no error
> CDB:  5B 00 02 00 00 00 00 00 00 00
> status: 0x2 (CHECK CONDITION)
> Sense Bytes: 70 00 05 00 00 00 00 0A 00 00 00 00 72 04 00 00
> Sense Key: 0x5 Illegal Request, Segment 0
> Sense Code: 0x72 Qual 0x04 (empty or partially written reserved track) Fru 0x0
> Sense flags: Blk 0 (not valid)
> cmd finished after 0.000s timeout 480s
> cmd finished after 0.000s timeout 480s
> wodim: Cannot fixate disk.
> Fixating time:    0.001s
> wodim: fifo had 220 puts and 29 gets.
> wodim: fifo was 0 times empty and 19 times full, min fill was 97%.
> 
> There's nothing in dmesg after any of these events.
> 
> sh# cat /proc/version
> Linux version 2.6.24 (root@jam) (gcc version 4.2.3 20080114 (prerelease) (Debian 4.2.2-7)) #14 SMP Sat Feb 2 14:20:01 CST 2008
> 
> # (bits from my vanilla 2.6.24 .config)
> # CONFIG_IDE is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_PROC_FS=y
> CONFIG_BLK_DEV_SD=y
> CONFIG_BLK_DEV_SR=y
> CONFIG_CHR_DEV_SG=y
> CONFIG_SCSI_MULTI_LUN=y
> CONFIG_SCSI_WAIT_SCAN=m
> CONFIG_ATA=y
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_AHCI=y
> CONFIG_ATA_PIIX=y
> CONFIG_PATA_MARVELL=y
> 
> # (from dmesg)
> scsi6 : pata_marvell
> scsi7 : pata_marvell
> ata7: PATA max UDMA/100 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 16
> ata8: PATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 16
> BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00
> ata7.00: ATAPI: SONY    DVD RW DRU-510A, 1.1a, max UDMA/33
> ata7.01: ATAPI: DVD RW DRU-820A, 1.0c, max UDMA/66
> ata7.01: limited to UDMA/33 due to 40-wire cable
> ata7.00: configured for UDMA/33
> ata7.01: configured for UDMA/33
> BAR5:00:02 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:07 0D:00 0E:00 0F:00
> scsi 6:0:0:0: CD-ROM            SONY     DVD RW DRU-510A  1.1a PQ: 0 ANSI: 5
> sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa/form2 cdda tray
> Uniform CD-ROM driver Revision: 3.20
> sr 6:0:0:0: Attached scsi CD-ROM sr0
> sr 6:0:0:0: Attached scsi generic sg2 type 5
> scsi 6:0:1:0: CD-ROM            SONY     DVD RW DRU-820A  1.0c PQ: 0 ANSI: 5
> sr1: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
> sr 6:0:1:0: Attached scsi CD-ROM sr1
> sr 6:0:1:0: Attached scsi generic sg3 type 5
> 
> # (from lspci -vvv)
> 03:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II Controller (rev b1) (prog-if 8f [Master SecP SecO PriP PriO])
>         Subsystem: Marvell Technology Group Ltd. 88SE6121 SATA II Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 16
>         Region 0: I/O ports at cc00 [size=8]
>         Region 1: I/O ports at c880 [size=4]
>         Region 2: I/O ports at c800 [size=8]
>         Region 3: I/O ports at c480 [size=4]
>         Region 4: I/O ports at c400 [size=16]
>         Region 5: Memory at fe9ffc00 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [48] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>         Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
>                 Address: 00000000  Data: 0000
>         Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
>                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 512 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <256ns, L1 unlimited
>                         ClockPM- Suprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>         Kernel driver in use: pata_marvell
> 
> Any ideas?
> 
> Thanks,
> 
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
