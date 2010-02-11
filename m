Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab0BKUi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:38:58 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37310 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab0BKUiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ltOyKQtVZdPoTBoLV9UpfM+SF4CfFS6DSQ2LXq65TF0mIvDy5Pmd3UlPDfidO+Dfkj
         SoOZjfsNEtzSbvnSUBe8wiUsrozaeA2mSbXdXZ8b9HV7D+x5/WhI8vjD4fdb2PsKxSON
         C5IH6xHDYf9EZ1a8KaU5Jq4JKMjc8cxmQQGf0=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Axel Uhl <axel.uhl@gmx.de>, linux-ide@vger.kernel.org
Subject: Re: Kernel Bug in ATA or SMART area
Date: Thu, 11 Feb 2010 21:21:22 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7; KDE/4.3.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4B72941A.7060704@gmx.de>
In-Reply-To: <4B72941A.7060704@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002112121.22399.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCs added)

Is older kernels work fine?

Dnia środa, 10 lutego 2010 o 12:10:18 Axel Uhl napisał(a):
> I get intermittent kernel exceptions, probably related to an issue with
> the ATA or SMART code in the kernel / modules. I have a cron job that
> every so many hours captures the disk temperatures. I "hdparm -y" my
> disks when they are not used. It seems that when the cron job runs that
> spins up the disks to access their temperature using smartctl, if during
> this time certain other interactions happen, the kernel raises an
>  exception.
> 
> The smartctl command I'm using is:
> 
> 	/usr/sbin/smartctl -a $devfull >/var/local/snmp/smart-$dev.TMP
> 
> Here is one such exception from the syslog:
> 
> Feb 10 06:57:01 homemp3 /USR/SBIN/CRON[18271]: (root) CMD
> (/etc/snmp/local-snmp-cronjob-spinup)
> Feb 10 06:57:06 homemp3 vdr: [3293] connect from 127.0.0.1, port 59975 -
> accepted
> Feb 10 06:57:06 homemp3 vdr: [3293] closing SVDRP connection
> Feb 10 06:57:09 homemp3 kernel: ata5.00: exception Emask 0x0 SAct 0x0
> SErr 0x0 action 0x6 frozen
> Feb 10 06:57:09 homemp3 kernel: ata5.00: failed command: SMART
> Feb 10 06:57:09 homemp3 kernel: ata5.00: cmd
> b0/da:00:00:4f:c2/00:00:00:00:00/00
>   tag 0
> Feb 10 06:57:09 homemp3 kernel:          res
> 40/00:01:00:00:00/00:00:00:00:00/00
>   Emask 0x4 (timeout)
> Feb 10 06:57:09 homemp3 kernel: ata5.00: status: { DRDY }
> Feb 10 06:57:10 homemp3 kernel: irq 10: nobody cared (try booting with
> the "irqpoll" option)
> Feb 10 06:57:10 homemp3 kernel: Pid: 17050, comm: hadam3p_um_6.14 Not
> tainted 2.6.32.7 #1
> Feb 10 06:57:10 homemp3 kernel: Call Trace:
> Feb 10 06:57:10 homemp3 kernel:  [<c128a221>] ? printk+0x18/0x1a
> Feb 10 06:57:10 homemp3 kernel:  [<c103aaf8>] __report_bad_irq+0x27/0x85
> Feb 10 06:57:10 homemp3 kernel:  [<c103ac9e>] note_interrupt+0x148/0x186
> Feb 10 06:57:10 homemp3 kernel:  [<c103b292>] handle_level_irq+0x86/0xb1
> Feb 10 06:57:10 homemp3 kernel:  [<c1004722>] handle_irq+0x1a/0x28
> Feb 10 06:57:10 homemp3 kernel:  [<c100434c>] do_IRQ+0x33/0x80
> Feb 10 06:57:10 homemp3 kernel:  [<c11d73fb>] ? pdc_interrupt+0x150/0x3a5
> Feb 10 06:57:10 homemp3 kernel:  [<c1003229>] common_interrupt+0x29/0x30
> Feb 10 06:57:10 homemp3 kernel:  [<c101cd72>] ? __do_softirq+0x33/0xec
> Feb 10 06:57:10 homemp3 kernel:  [<c1039e00>] ? handle_IRQ_event+0x31/0xc1
> Feb 10 06:57:10 homemp3 kernel:  [<c101ce55>] do_softirq+0x2a/0x2f
> Feb 10 06:57:10 homemp3 kernel:  [<c101cf34>] irq_exit+0x2a/0x2f
> Feb 10 06:57:10 homemp3 kernel:  [<c1004355>] do_IRQ+0x3c/0x80
> Feb 10 06:57:10 homemp3 kernel:  [<c1003b81>] ?
> do_device_not_available+0x0/0x48
> Feb 10 06:57:10 homemp3 kernel:  [<c1003229>] common_interrupt+0x29/0x30
> Feb 10 06:57:10 homemp3 kernel: handlers:
> Feb 10 06:57:10 homemp3 kernel: [<c11d72ab>] (pdc_interrupt+0x0/0x3a5)
> Feb 10 06:57:10 homemp3 kernel: [<c11d3504>] (ata_sff_interrupt+0x0/0xc4)
> Feb 10 06:57:10 homemp3 kernel: [<f83a6767>] (azx_interrupt+0x0/0x11b
> [snd_hda_intel])
> Feb 10 06:57:10 homemp3 kernel: [<f8106471>] (usb_hcd_irq+0x0/0x5e
> [usbcore])
> Feb 10 06:57:10 homemp3 kernel: [<f8062bf9>] (e1000_intr+0x0/0xf2 [e1000])
> Feb 10 06:57:10 homemp3 kernel: Disabling IRQ #10
> Feb 10 06:57:10 homemp3 kernel: ata5: soft resetting link
> Feb 10 06:57:11 homemp3 kernel: ata5.00: configured for UDMA/133
> Feb 10 06:57:11 homemp3 kernel: ata5: EH complete
> 
> 
> I suppose the hadam3p_um_6.14 command is part of my BOINC installation,
> doing a climate simulation. However, the problem has also occurred with
> this program not running.
> 
> Here's the output of scripts/ver_linux:
> 
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
> 
> Linux homemp3 2.6.32.7 #1 Sat Feb 6 10:50:05 CET 2010 i686 GNU/Linux
> 
> Gnu C                  4.3.2
> Gnu make               3.81
> binutils               2.18.0.20080103
> util-linux             2.13.1.1
> mount                  2.13.1.1
> module-init-tools      found
> Linux C Library        2.7
> Dynamic linker (ldd)   2.7
> Procps                 3.2.7
> Console-tools          0.2.3
> Sh-utils               6.10
> udev                   125
> Modules Loaded         ipv6 bsd_comp usb_storage ppp_deflate
> zlib_deflate ppp_ge
> neric slhc w83627hf hwmon_vid hwmon i2c_dev saa7134_alsa
> snd_hda_codec_realtek tuner_simple tuner_types mt352 snd_hda_intel
> saa7134_dvb snd_hda_codec videobuf_dvb snd_pcm_oss snd_mixer_oss
> dvb_core snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> 8250_pnp snd_seq 8250 serial_core snd_timer snd_seq_device
>   saa7134 ehci_hcd ir_common snd v4l2_common videodev v4l1_compat
> soundcore snd_page_alloc videobuf_dma_sg videobuf_core tveeprom usbcore
> via_rhine i2c_core e1000
> 
> 
> As a result of the exception, the system becomes very unresponsive. Any
> sort of I/O seems to have very poor response time. Ping times in the
> gigabit network suddenly take several tens of milliseconds. It seems
> this may have to do with the IRQ10 being somehow affected, but I'm not
>  sure.
> 
> /proc/version:
> 
> Linux version 2.6.32.7 (root@homemp3) (gcc version 4.3.2 (Debian
> 4.3.2-1.1) ) #1 Sat Feb 6 10:50:05 CET 2010
> 
> /proc/cpuinfo:
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 4
> model name      : Intel(R) Celeron(R) CPU 2.80GHz
> stepping        : 9
> cpu MHz         : 2799.930
> cache size      : 256 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
> mca cmovpat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe lm
> constant_tsc pebs bts pni dtes64 monitor ds_cpl tm2 cid cx16 xtpr lahf_lm
> bogomips        : 5623.13
> clflush size    : 64
> cache_alignment : 128
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> 
> Output of lcpsi -vvv:
> 
> 00:00.0 Host bridge: VIA Technologies, Inc. PT880 Ultra/PT894 Host Bridge
>          Subsystem: ASRock Incorporation Device 0308
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort+ >SERR- <PERR+ INTx-
>          Latency: 8, Cache Line Size: 32 bytes
>          Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
>          Capabilities: [80] AGP version 3.5
>                  Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
> HTrans- 64
> bit- FW- AGP3- Rate=x1,x2,x4
>                  Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
> FW- Rate=<n
> one>
>          Capabilities: [50] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Kernel driver in use: agpgart-via
> 
> 00:00.1 Host bridge: VIA Technologies, Inc. PT894 Host Bridge
>          Subsystem: ASRock Incorporation Device 1308
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 0, Cache Line Size: 32 bytes
> 
> 00:00.2 Host bridge: VIA Technologies, Inc. PT894 Host Bridge
>          Subsystem: ASRock Incorporation Device 2308
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 0, Cache Line Size: 32 bytes
> 
> 00:00.3 Host bridge: VIA Technologies, Inc. PT890 Host Bridge
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 0
> 
> 00:00.4 Host bridge: VIA Technologies, Inc. PT894 Host Bridge
>          Subsystem: ASRock Incorporation Device 4308
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 0, Cache Line Size: 32 bytes
> 
> 00:00.5 PIC: VIA Technologies, Inc. PT894 I/O APIC Interrupt Controller
> (prog-if
>   20 [IO(X)-APIC])
>          Subsystem: ASRock Incorporation Device 5308
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>          Latency: 0, Cache Line Size: 32 bytes
> 
> 00:00.7 Host bridge: VIA Technologies, Inc. PT894 Host Bridge
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 0, Cache Line Size: 32 bytes
> 
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237/VX700 PCI Bridge
> (prog-if 00 [
> Normal decode])
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 0
>          Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>          I/O behind bridge: 0000f000-00000fff
>          Memory behind bridge: fc700000-fe7fffff
>          Prefetchable memory behind bridge: cff00000-dfefffff
>          Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- <SERR- <PERR-
>          BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>                  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>          Capabilities: [70] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:02.0 PCI bridge: VIA Technologies, Inc. PT890 PCI to PCI Bridge
> Controller (p
> rog-if 00 [Normal decode])
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>          Latency: 0, Cache Line Size: 32 bytes
>          Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>          I/O behind bridge: 00001000-00001fff
>          Memory behind bridge: fe800000-fe8fffff
>          Prefetchable memory behind bridge: 40000000-401fffff
>          Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- <SERR- <PERR-
>          BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>                  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>          Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
>                  DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
> <64ns, L1
>   unlimited
>                          ExtTag- RBE- FLReset-
>                  DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupporte
> d-
>                          RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                          MaxPayload 128 bytes, MaxReadReq 128 bytes
>                  DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr+ TransPe
> nd-
>                  LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s L1,
> Latency L
> 0 <64ns, L1 <1us
>                          ClockPM- Suprise- LLActRep+ BwNot-
>                  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> CommClk-
>                          ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                  LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk-
> DLActive
> - BWMgmt- ABWMgmt-
>                  SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
> HotPlug+ Surpise
> +
>                          Slot # 10, PowerLimit 75.000000; Interlock-
> NoCompl-
>                  SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
> HPIrq- L
> inkChg-
>                          Control: AttnInd Unknown, PwrInd Unknown,
> Power- Interlo
> ck-
>                  SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
> PresDet- Interl
> ock-
>                          Changed: MRL- PresDet- LinkState-
>                  RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
> PMEIntEna- CRSV
> isible-
>                  RootCap: CRSVisible-
>                  RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>          Capabilities: [68] Power Management version 2
>                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot
> +,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Capabilities: [70] Message Signalled Interrupts: Mask+ 64bit+
> Queue=0/0
> Enable-
>                  Address: 0000000000000000  Data: 0000
>                  Masking: 00000000  Pending: 00000000
>          Capabilities: [100] Advanced Error Reporting <?>
>          Capabilities: [140] Virtual Channel <?>
> 
> 00:09.0 Ethernet controller: Intel Corporation 82541PI Gigabit Ethernet
> Controll
> er (rev 05)
>          Subsystem: Intel Corporation PRO/1000 GT Desktop Adapter
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Step
> ping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32 (63750ns min), Cache Line Size: 32 bytes
>          Interrupt: pin A routed to IRQ 10
>          Region 0: Memory at feba0000 (32-bit, non-prefetchable)
>  [size=128K] Region 1: Memory at feb80000 (32-bit, non-prefetchable)
>  [size=128K] Region 2: I/O ports at cc00 [size=64]
>          Expansion ROM at feb60000 [disabled] [size=128K]
>          Capabilities: [dc] Power Management version 2
>                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot
> +,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>          Capabilities: [e4] PCI-X non-bridge device
>                  Command: DPERE- ERO+ RBC=512 OST=1
>                  Status: Dev=00:00.0 64bit- 133MHz- SCD- USC- DC=simple
> DMMRBC=20
> 48 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
>          Kernel driver in use: e1000
>          Kernel modules: e1000
> 
> 00:0a.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA
> 300 TX4
> ) (rev 02)
>          Subsystem: Promise Technology, Inc. PDC40718 (SATA 300 TX4)
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Step
> ping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 72 (1000ns min, 4500ns max), Cache Line Size: 4 bytes
>          Interrupt: pin A routed to IRQ 10
>          Region 0: I/O ports at d400 [size=128]
>          Region 2: I/O ports at c800 [size=256]
>          Region 3: Memory at febfe000 (32-bit, non-prefetchable) [size=4K]
>          Region 4: Memory at febc0000 (32-bit, non-prefetchable)
>  [size=128K] Expansion ROM at febe0000 [disabled] [size=32K]
>          Capabilities: [60] Power Management version 2
>                  Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Kernel driver in use: sata_promise
> 
> 00:0c.0 Multimedia controller: Philips Semiconductors
> SAA7131/SAA7133/SAA7135 Vi
> deo Broadcast Decoder (rev d1)
>          Subsystem: Avermedia Technologies Inc Device 2c05
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32
>          Interrupt: pin A routed to IRQ 11
>          Region 0: Memory at febff000 (32-bit, non-prefetchable) [size=2K]
>          Capabilities: [40] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Kernel driver in use: saa7134
>          Kernel modules: saa7134
> 
> 00:0f.0 IDE interface: VIA Technologies, Inc. VT8237A SATA 2-Port
> Controller (re
> v 80) (prog-if 8f [Master SecP SecO PriP PriO])
>          Subsystem: ASRock Incorporation Device 0591
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32
>          Interrupt: pin B routed to IRQ 10
>          Region 0: I/O ports at e000 [size=8]
>          Region 1: I/O ports at dc00 [size=4]
>          Region 2: I/O ports at d880 [size=8]
>          Region 3: I/O ports at d800 [size=4]
>          Region 4: I/O ports at d480 [size=16]
>          Region 5: I/O ports at d000 [size=256]
>          Capabilities: [c0] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Kernel driver in use: sata_via
> 
> 00:0f.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/
> C PIPC Bus Master IDE (rev 07) (prog-if 8a [Master SecP PriP])
>          Subsystem: ASRock Incorporation K7VT2/K7VT6 motherboard
>          Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32
>          Region 0: [virtual] Memory at 000001f0 (32-bit,
> non-prefetchable) [disab
> led] [size=8]
>          Region 1: [virtual] Memory at 000003f0 (type 3,
> non-prefetchable) [disab
> led] [size=1]
>          Region 2: [virtual] Memory at 00000170 (32-bit,
> non-prefetchable) [disab
> led] [size=8]
>          Region 3: [virtual] Memory at 00000370 (type 3,
> non-prefetchable) [disab
> led] [size=1]
>          Region 4: I/O ports at fc00 [size=16]
>          Capabilities: [c0] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Kernel driver in use: VIA_IDE
> 
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller
>   (rev a0) (prog-if 00 [UHCI])
>          Subsystem: ASRock Incorporation K7VT6
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32, Cache Line Size: 32 bytes
>          Interrupt: pin A routed to IRQ 11
>          Region 4: I/O ports at e080 [size=32]
>          Capabilities: [80] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0+,D1+,D2+,D3h
> ot+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller
>   (rev a0) (prog-if 00 [UHCI])
>          Subsystem: ASRock Incorporation K7VT6
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32, Cache Line Size: 32 bytes
>          Interrupt: pin B routed to IRQ 10
>          Region 4: I/O ports at e400 [size=32]
>          Capabilities: [80] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0+,D1+,D2+,D3h
> ot+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller
>   (rev a0) (prog-if 00 [UHCI])
>          Subsystem: ASRock Incorporation K7VT6
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32, Cache Line Size: 32 bytes
>          Interrupt: pin C routed to IRQ 10
>          Region 4: I/O ports at e480 [size=32]
>          Capabilities: [80] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0+,D1+,D2+,D3h
> ot+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller
>   (rev a0) (prog-if 00 [UHCI])
>          Subsystem: ASRock Incorporation K7VT6
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32, Cache Line Size: 32 bytes
>          Interrupt: pin D routed to IRQ 10
>          Region 4: I/O ports at ec00 [size=32]
>          Capabilities: [80] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0+,D1+,D2+,D3h
> ot+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86) (prog-if
> 20 [EHC
> I])
>          Subsystem: ASRock Incorporation K7VT6 motherboard
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32, Cache Line Size: 128 bytes
>          Interrupt: pin C routed to IRQ 10
>          Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=256]
>          Capabilities: [80] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> PME(D0+,D1+,D2+,D3h
> ot+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Kernel driver in use: ehci_hcd
>          Kernel modules: ehci-hcd
> 
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237A PCI to ISA Bridge
>          Subsystem: ASRock Incorporation Device 3337
>          Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Capabilities: [c0] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:11.7 Host bridge: VIA Technologies, Inc. VT8251 Ultra VLINK Controller
>          Subsystem: VIA Technologies, Inc. Device 337e
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort+ >SERR- <PERR+ INTx-
>          Latency: 32
>          Capabilities: [58] HyperTransport: Interrupt Discovery and
> Configuration
> 
> 
> 00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II]
> (rev 7c)
>          Subsystem: ASRock Incorporation K7VT6 motherboard
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Step
> ping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32 (750ns min, 2000ns max), Cache Line Size: 32 bytes
>          Interrupt: pin A routed to IRQ 11
>          Region 0: I/O ports at e800 [size=256]
>          Region 1: Memory at febffc00 (32-bit, non-prefetchable) [size=256]
>          Capabilities: [40] Power Management version 2
>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot
> +,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Kernel driver in use: via-rhine
>          Kernel modules: via-rhine
> 
> 00:13.0 Host bridge: VIA Technologies, Inc. VT8237A Host Bridge
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR+ FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort+ >SERR- <PERR- INTx-
>          Latency: 0
>          Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed+
> 
> 01:00.0 VGA compatible controller: nVidia Corporation NV11DDR [GeForce2
> MX200] (
> rev b2) (prog-if 00 [VGA controller])
>          Subsystem: ABIT Computer Corp. Device 6107
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
> 
>  >TAbort- <TAbort
> 
> - <MAbort- >SERR- <PERR- INTx-
>          Latency: 32 (1250ns min, 250ns max)
>          Interrupt: pin A routed to IRQ 11
>          Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
>          Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
>          Expansion ROM at fe7f0000 [disabled] [size=64K]
>          Capabilities: [60] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot
> -,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Capabilities: [44] AGP version 2.0
>                  Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh- GART64-
> HTrans- 64
> bit- FW+ AGP3- Rate=x1,x2,x4
>                  Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
> FW- Rate=<n
> one>
>          Kernel modules: nvidiafb
> 
> 80:01.0 Audio device: VIA Technologies, Inc. VT1708/A [Azalia HDAC] (VIA
> High De
> finition Audio Controller) (rev 10)
>          Subsystem: ASRock Incorporation Device 0888
>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Step
> ping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>          Latency: 0, Cache Line Size: 32 bytes
>          Interrupt: pin A routed to IRQ 10
>          Region 0: Memory at fe9fc000 (64-bit, non-prefetchable) [size=16K]
>          Capabilities: [50] Power Management version 2
>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
> PME(D0+,D1-,D2-,D3ho
> t+,D3cold+)
>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>          Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0
> Enable-
>                  Address: 0000000000000000  Data: 0000
>          Capabilities: [70] Express (v1) Root Complex Integrated
> Endpoint, MSI 00
> 
>                  DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> <64ns, L1
>   <1us
>                          ExtTag- RBE- FLReset-
>                  DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupporte
> d-
>                          RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                          MaxPayload 128 bytes, MaxReadReq 128 bytes
>                  DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
> AuxPwr+ TransPe
> nd+
>                  LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown,
> Latency
> L0 <64ns, L1 <1us
>                          ClockPM- Suprise- LLActRep- BwNot-
>                  LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                          ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                  LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk-
> DLActive
> - BWMgmt- ABWMgmt-
>          Capabilities: [100] #1106
>          Kernel driver in use: HDA Intel
>          Kernel modules: snd-hda-intel
> 
> 
> /proc/ioports:
> 
> 0000-001f : dma1
> 0020-0021 : pic1
> 0040-0043 : timer0
> 0050-0053 : timer1
> 0060-0060 : keyboard
> 0064-0064 : keyboard
> 0070-0077 : rtc
> 0080-008f : dma page reg
> 00a0-00a1 : pic2
> 00c0-00df : dma2
> 00f0-00ff : fpu
> 0170-0177 : 0000:00:0f.1
>    0170-0177 : via82cxxx
> 01f0-01f7 : 0000:00:0f.1
>    01f0-01f7 : via82cxxx
> 0295-0296 : w83627hf
>    0295-0296 : pnp 00:09
>      0295-0296 : w83627hf
> 02f8-02ff : serial
> 0376-0376 : 0000:00:0f.1
>    0376-0376 : via82cxxx
> 03c0-03df : vga+
> 03e0-03e7 : pnp 00:09
> 03f2-03f2 : floppy
> 03f4-03f5 : floppy
> 03f6-03f6 : 0000:00:0f.1
>    03f6-03f6 : via82cxxx
> 03f7-03f7 : floppy
> 03f8-03ff : serial
> 0400-041f : pnp 00:09
> 04d0-04d1 : pnp 00:09
> 0800-087f : pnp 00:09
>    0800-0803 : ACPI PM1a_EVT_BLK
>    0804-0805 : ACPI PM1a_CNT_BLK
>    0808-080b : ACPI PM_TMR
>    0810-0815 : ACPI CPU throttle
>    0820-0823 : ACPI GPE0_BLK
> 0cf8-0cff : PCI conf1
> 1000-1fff : PCI Bus 0000:02
> c800-c8ff : 0000:00:0a.0
> cc00-cc3f : 0000:00:09.0
>    cc00-cc3f : e1000
> d000-d0ff : 0000:00:0f.0
>    d000-d0ff : sata_via
> d400-d47f : 0000:00:0a.0
> d480-d48f : 0000:00:0f.0
>    d480-d48f : sata_via
> d800-d803 : 0000:00:0f.0
>    d800-d803 : sata_via
> d880-d887 : 0000:00:0f.0
>    d880-d887 : sata_via
> dc00-dc03 : 0000:00:0f.0
>    dc00-dc03 : sata_via
> e000-e007 : 0000:00:0f.0
>    e000-e007 : sata_via
> e080-e09f : 0000:00:10.0
> e400-e41f : 0000:00:10.1
> e480-e49f : 0000:00:10.2
> e800-e8ff : 0000:00:12.0
>    e800-e8ff : via-rhine
> ec00-ec1f : 0000:00:10.3
> fc00-fc0f : 0000:00:0f.1
>    fc00-fc0f : via82cxxx
> 
> /proc/iomem:
> 
> 00000000-0000ffff : reserved
> 00010000-0009fbff : System RAM
> 0009fc00-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000cc7ff : Video ROM
> 000cc800-000d17ff : Adapter ROM
> 000d1800-000d27ff : Adapter ROM
> 000e6000-000fffff : reserved
>    000f0000-000fffff : System ROM
> 00100000-3ffaffff : System RAM
>    01000000-0128c677 : Kernel code
>    0128c678-0138f533 : Kernel data
>    013e0000-014131ff : Kernel bss
> 3ffb0000-3ffbffff : ACPI Tables
> 3ffc0000-3ffeffff : ACPI Non-volatile Storage
> 3fff0000-3fffffff : reserved
> 40000000-401fffff : PCI Bus 0000:02
> cff00000-dfefffff : PCI Bus 0000:01
>    d0000000-d7ffffff : 0000:01:00.0
> e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
>    e0000000-efffffff : pnp 00:0e
> f8000000-fbffffff : 0000:00:00.0
> fc700000-fe7fffff : PCI Bus 0000:01
>    fd000000-fdffffff : 0000:01:00.0
>    fe7f0000-fe7fffff : 0000:01:00.0
> fe800000-fe8fffff : PCI Bus 0000:02
> fe9fc000-fe9fffff : 0000:80:01.0
>    fe9fc000-fe9fffff : pnp 00:09
>      fe9fc000-fe9fffff : ICH HD audio
> feb60000-feb7ffff : 0000:00:09.0
> feb80000-feb9ffff : 0000:00:09.0
>    feb80000-feb9ffff : e1000
> feba0000-febbffff : 0000:00:09.0
>    feba0000-febbffff : e1000
> febc0000-febdffff : 0000:00:0a.0
> febe0000-febe7fff : 0000:00:0a.0
> febfe000-febfefff : 0000:00:0a.0
>    febfe000-febfefff : sata_promise
> febff000-febff7ff : 0000:00:0c.0
>    febff000-febff7ff : saa7133[0]
> febff800-febff8ff : 0000:00:10.4
>    febff800-febff8ff : ehci_hcd
> febffc00-febffcff : 0000:00:12.0
>    febffc00-febffcff : via-rhine
> fec00000-fec00fff : pnp 00:0a
> fee00000-fee00fff : reserved
>    fee00000-fee00fff : pnp 00:0a
> ff780000-ffffffff : reserved
>    ffb80000-ffbfffff : pnp 00:09
>    fff80000-ffffffff : pnp 00:0f
> 
> /proc/scsi/scsi:
> 
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>    Vendor: ATA      Model: ST31500341AS     Rev: CC1H
>    Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi4 Channel: 00 Id: 00 Lun: 00
>    Vendor: ATA      Model: ST3500630AS      Rev: 3.AA
>    Type:   Direct-Access                    ANSI  SCSI revision: 05
> 
> 
> 
> Thanks for any hints and best regards,
> -- Axel
> 

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
