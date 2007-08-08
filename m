Return-Path: <linux-kernel-owner+w=401wt.eu-S932418AbXHHIQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbXHHIQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXHHIQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:16:07 -0400
Received: from smtp27.orange.fr ([80.12.242.95]:24424 "EHLO smtp27.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbXHHIQA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:16:00 -0400
X-ME-UUID: 20070808081558137.2177A1C00093@mwinf2707.orange.fr
From: paul <paul.pinault@disk91.com>
Reply-To: paul.pinault@disk91.com
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: Data corruption
Date: Wed, 8 Aug 2007 10:15:55 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200708072007.27343.paul.pinault@disk91.com> <46B8ECA7.3000300@garzik.org>
In-Reply-To: <46B8ECA7.3000300@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708081015.56262.paul.pinault@disk91.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 8 août 2007 00:05, Jeff Garzik a écrit :
> paul wrote:
> > Since 2-3 month I have some random data corruption on my Linux server,
> > after checking disks independently (i'm using raid1on 2 sata disk, the
> > problem is the same w/o raid) and memory, hardware simce to be out of
> > cause...
> >
> > Here is my problem:
> > => head --bytes=300m  /dev/urandom > test
> > => for i in `seq 0 9` ; do cp test test$i ; done
> > => md5sum test*
> > I got :
> > 014666c728c9e3b8299579fae499864a  test
> > 014666c728c9e3b8299579fae499864a  test0
> > 333fd93d093ac612cd8d5f65628f734e  test1
> > 1ab6ee68c6a7d9ff5a05f9d63f0f6df6  test2
> > 96e96483e3175a59c9c05b6720514e1e  test3
> > 014666c728c9e3b8299579fae499864a  test4
> > b24dbccc9f4831f8825ab4a55a3be4aa  test5
> > 8493efc9c14e4b5c162ac23696fbc16a  test6
> > 6a5f4301f66d0379049d79d0e14e2a87  test7
> > 2c81cfa1c3a03aba134574922ee5d75c  test8
> > 2ea15c8392bfd0123472a80125bb3abe  test9
> >
> > ^^^ that sounds really bad for my data :(
> >
> > ===================================================================
> > I did some tests :
> > * badblocks on the two disk with ro and rw tests => report no error
> > * memtest during 6 hours => report no error
> >
> > * I reproduces the error
> >   - under xen client host (first time issue)
> >   - under xen hypervisor
> >   - under basic kernel with raid mirroring + ext3 and raiserfs
> >   - under basic kernel w/o raid but ext3 ans reiserfs
> >
> > My configuration
> >  * Asus P5B-VM
> >  * 4 Gb [try with and w/o options memory remaping]
> >  * Intel Core 2 Duo [normal speed and underclocked(233 bus speed)]
> >  * Hd SATA WD 80Gb
>
> Corruption with which controller?  pata_jmicron? ata_piix? ahci?
>
> Can you reproduce with 2.6.23-rc2?  If not, please report the bug to
> OpenSuSE, since we only support unmodified vanilla kernels here.
>
> 	Jeff

Should be ahci => standard sata port, not jmicron extensions....
I can try to reproduce with 2.6.23-rc2 ... now with 2GB I'm able compile 
something corrcetly ;)

result of the test with 2.6.23 with 2Gb memory : OK

result with  2.6.23 rc2 @ 4GB : KO =>
2eb9b0f7c7d773170dca5cb304b71d7d  test
c85546b6ed3b10a0354af101a61ee27f  test0
b4879a2af789a731889c578af8adce75  test1
a606258dcc42542034026bf8e0918a15  test2
68d53650a7852cd8e93faa86cded4aae  test3
^^ system crashed after....


----------------------------------------------------------------
uname -a
 Linux xen-prod 2.6.23-rc2-default #1 SMP Wed Aug 8 09:08:54 CEST 2007 x86_64 
x86_64 x86_64 GNU/Linux

-----------------------------------------------------------------
# ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux xen-prod 2.6.23-rc2-default #1 SMP Wed Aug 8 09:08:54 CEST 2007 x86_64 
x86_64 x86_64 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.5
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.11
PPP                    2.4.4
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.4
udev                   103
wireless-tools         29
Modules Loaded         ipt_LOG xt_limit xt_pkttype snd_pcm_oss snd_mixer_oss 
snd_seq snd_seq_device af_packet cpufreq_conservative cpufreq_ondemand 
cpufreq_userspace cpufreq_powersave acpi_cpufreq freq_table button battery ac 
ip6t_REJECT xt_tcpudp ipt_REJECT iptable_mangle iptable_filter 
ip6table_mangle ip_tables ip6table_filter ip6_tables x_tables ipv6 ext3 jbd 
mbcache loop raid1 dm_mod sr_mod cdrom pata_jmicron generic ide_core ohci1394 
ieee1394 snd_hda_intel snd_pcm snd_timer snd soundcore uhci_hcd ehci_hcd 
r8169 i2c_i801 i2c_core intel_agp snd_page_alloc usbcore parport_pc lp 
parport reiserfs edd fan sg ata_piix ahci libata thermal processor sd_mod 
scsi_mod

---------------------------------------------------------------------------

# lspci -vvv
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 
02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ea
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port (rev 
02) (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000bfd00000-00000000bfdfffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [88] Subsystem: Intel Corporation Unknown device 277d
        Capabilities: [80] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee0300c  Data: 4159
        Capabilities: [a0] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 2
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:02.0 VGA compatible controller: Intel Corporation 82G965 Integrated 
Graphics Controller (rev 02) (prog-if 00 [VGA])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ea
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at ffa00000 (32-bit, non-prefetchable) [size=1M]
        Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 4: I/O ports at ec00 [size=8]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #4 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at e800 [size=32]

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #5 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at e880 [size=32]

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #2 
(rev 02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at ff9fb800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at ff9f4000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000bfe00000-00000000bfefffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee0300c  Data: 4161
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 
81ec
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: ff600000-ff6fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 5
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee0300c  Data: 4169
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 
81ec
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 
(rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: ff500000-ff5fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 6
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 0, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- 
Queue=0/0 Enable+
                Address: fee0300c  Data: 4171
        Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 
81ec
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #1 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at e080 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #2 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at e400 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI #3 
(rev 02) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at e480 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI #1 
(rev 02) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at ff9fb400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2) (prog-if 01 
[Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: ff700000-ff7fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Unknown device 
81ec

00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface 
Controller (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port SATA IDE 
Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at ff90 [size=16]
        Region 5: I/O ports at ffa0 [size=16]
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 
02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at 80000000 (32-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 0400 [size=32]

00:1f.5 IDE interface: Intel Corporation 82801H (ICH8 Family) 2 port SATA IDE 
Controller (rev 02) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81ec
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at e000 [size=8]
        Region 1: I/O ports at dc00 [size=4]
        Region 2: I/O ports at d880 [size=8]
        Region 3: I/O ports at d800 [size=4]
        Region 4: I/O ports at d480 [size=16]
        Region 5: I/O ports at d400 [size=16]
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI 
Express Gigabit Ethernet controller (rev 01)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81aa
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at b800 [size=256]
        Region 2: Memory at ff5ff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at ff5c0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA 
PME(D0-,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 1024 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s <1us, L1 unlimited
                Device: AtnBtn+ AtnInd+ PwrInd+
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [84] Vendor Specific Information

03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller (rev 02) (prog-if 01 [AHCI 1.0])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81e4
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 5: Memory at ff6fe000 (32-bit, non-prefetchable) [size=8K]
        Expansion ROM at ff6e0000 [disabled] [size=64K]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Express Legacy Endpoint IRQ 1
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 1
                Link: Latency L0s <1us, L1 <16us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
Controller (rev 02) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81e4
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at cc00 [size=8]
        Region 1: I/O ports at c880 [size=4]
        Region 2: I/O ports at c800 [size=8]
        Region 3: I/O ports at c480 [size=4]
        Region 4: I/O ports at c400 [size=16]
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:01.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 
Controller (PHY/Link) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (500ns min, 1000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at ff7ff800 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at ff7f8000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+



-------------------------------------------------------------------------------
lsmod
Module                  Size  Used by
ipt_LOG                23040  8
xt_limit               19968  8
xt_pkttype             18688  3
snd_pcm_oss            67584  0
snd_mixer_oss          34176  1 snd_pcm_oss
snd_seq                75296  0
snd_seq_device         25620  1 snd_seq
af_packet              56844  2
cpufreq_conservative    24712  0
cpufreq_ondemand       25616  2
cpufreq_userspace      23812  0
cpufreq_powersave      18560  0
acpi_cpufreq           28168  0
freq_table             22656  2 cpufreq_ondemand,acpi_cpufreq
button                 26144  0
battery                30224  0
ac                     22792  0
ip6t_REJECT            22272  3
xt_tcpudp              20224  4
ipt_REJECT             21376  3
iptable_mangle         19712  0
iptable_filter         19968  1
ip6table_mangle        19584  0
ip_tables              37864  2 iptable_mangle,iptable_filter
ip6table_filter        19712  1
ip6_tables             32072  2 ip6table_mangle,ip6table_filter
x_tables               36872  8 
ipt_LOG,xt_limit,xt_pkttype,ip6t_REJECT,xt_tcpudp,ipt_REJECT,ip_tables,ip6_tables
ipv6                  356200  30 ip6t_REJECT,ip6table_mangle
ext3                  153104  1
jbd                    89336  1 ext3
mbcache                26240  1 ext3
loop                   35588  0
raid1                  39808  1
dm_mod                 76784  0
sr_mod                 33572  0
cdrom                  51752  1 sr_mod
pata_jmicron           24192  0
generic                22660  0 [permanent]
ide_core              162192  1 generic
ohci1394               49204  0
ieee1394              114648  1 ohci1394
snd_hda_intel         373668  0
snd_pcm               108808  2 snd_pcm_oss,snd_hda_intel
snd_timer              42120  2 snd_seq,snd_pcm
snd                    84904  7 
snd_pcm_oss,snd_mixer_oss,snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer
soundcore              25376  1 snd
uhci_hcd               42272  0
ehci_hcd               52108  0
r8169                  48260  0
i2c_i801               26140  0
i2c_core               43264  1 i2c_i801
intel_agp              44192  1
snd_page_alloc         27152  2 snd_hda_intel,snd_pcm
usbcore               148200  2 uhci_hcd,ehci_hcd
parport_pc             58984  1
lp                     29768  0
parport                56972  2 parport_pc,lp
reiserfs              244992  1
edd                    27016  0
fan                    22408  0
sg                     53160  0
ata_piix               35460  4
ahci                   41988  0
libata                141840  3 pata_jmicron,ata_piix,ahci
thermal                32016  0
processor              56680  2 acpi_cpufreq,thermal
sd_mod                 45568  6
scsi_mod              176824  4 sr_mod,sg,libata,sd_mod




