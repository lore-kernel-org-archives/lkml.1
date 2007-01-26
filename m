Return-Path: <linux-kernel-owner+w=401wt.eu-S1161170AbXAZSqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161170AbXAZSqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161165AbXAZSqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:46:18 -0500
Received: from keetweej.vanheusden.com ([213.84.46.114]:55605 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161167AbXAZSqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:46:13 -0500
X-Greylist: delayed 2025 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 13:46:12 EST
Date: Fri, 26 Jan 2007 19:11:21 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.19.1] panic in usb system
Message-ID: <20070126181121.GA1839@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Jan 27 18:57:10 CET 2007
X-Message-Flag: www.vanheusden.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Today my pc crashed suddenly after aprox 6 days of uptime with the
following panic:

[520678.065872] BUG: unable to handle kernel paging request at virtual address 00100100
[520678.065972]  printing eip:
[520678.066013] c1179b97
[520678.066055] *pde = 00000000
[520678.066098] Oops: 0000 [#1]
[520678.066139] SMP
[520678.066248] Modules linked in: wcfxo zaptel nfs pl2303 usbserial tuner tvaudio bttv video_buf ir_common i2c_algo_bit btcx_risc tveeprom pwc plusb usbnet w83627hf hwmon_vid snd_pcm_oss snd_mixer_oss eeprom i2c_isa i2c_core sd_mod scsi_mod ide_cd cdrom snd_intel8x0 snd_ac97_codec snd_pcm snd_timer snd soundcore snd_page_alloc snd_ac97_bus parport_pc parport microcode firmware_class netconsole nfsd exportfs lockd sunrpc ipt_owner ip6table_filter ip6_tables ipv6 ipt_recent xt_limit xt_state act_police sch_ingress cls_u32 sch_sfq sch_cbq ipt_REJECT ipt_MASQUERADE ipt_TOS xt_tcpudp iptable_mangle iptable_filter rtl8150 e1000 3c59x mii iptable_nat ip_nat ip_tables ip_conntrack nfnetlink x_tables capability commoncap ppp_deflate zlib_deflate zlib_inflate ppp_async crc_ccitt ppp_generic slip slhc genrtc rd
[520678.069257] CPU:    0
[520678.069259] EIP:    0060:[<c1179b97>]    Not tainted VLI
[520678.069260] EFLAGS: 00010046   (2.6.19.1 #3)
[520678.069389] EIP is at hiddev_send_event+0xa1/0xd3
[520678.069435] eax: 000ffaec   ebx: 000ffaec   ecx: 00020001   edx: 00100100
[520678.069482] esi: c133ee28   edi: c25e4918   ebp: c133ee20   esp: c133ee0c
[520678.069529] ds: 007b   es: 007b   ss: 0068
[520678.069575] Process php (pid: 14321, ti=c133e000 task=e2abd030 task.ti=e2f6b000)
[520678.069622] Stack: 00000000 c25e4900 c2537544 f7d5e000 c25374c0 c133ee50 c1179c25 00000001
[520678.069978]        00000000 00000000 00000003 ffa10003 00000061 c25e490c 00000001 f7d5e000
[520678.070329]        c2537544 c133ee68 c11777df 00000061 e4723be0 00000000 00000008 c133eecc
[520678.070682] Call Trace:
[520678.070765]  [<c1003caa>] show_trace_log_lvl+0x1a/0x30
[520678.070852]  [<c1003d61>] show_stack_log_lvl+0x8d/0xaa
[520678.070935]  [<c1003f73>] show_registers+0x1a2/0x240
[520678.071013]  [<c10041ed>] die+0x125/0x234
[520678.071090]  [<c11f5522>] do_page_fault+0x34b/0x5bb
[520678.071171]  [<c11f3b71>] error_code+0x39/0x40
[520678.071249]  [<c1179c25>] hiddev_hid_event+0x5c/0x63
[520678.071328]  [<c11777df>] hid_process_event+0x71/0x7e
[520678.071407]  [<c117797c>] hid_input_field+0x190/0x328
[520678.072300]  [<c1177bba>] hid_input_report+0xa6/0xed
[520678.072379]  [<c1177f3e>] hid_irq_in+0xe4/0x124
[520678.072459]  [<c115ff9f>] usb_hcd_giveback_urb+0x4d/0xb5
[520678.072539]  [<c11751f9>] uhci_giveback_urb+0x82/0x19d
[520678.072622]  [<c117538e>] uhci_scan_qh+0x7a/0x1ad
[520678.072703]  [<c1175617>] uhci_scan_schedule+0x75/0xee
[520678.072782]  [<c1176210>] uhci_irq+0xb4/0x14d
[520678.072864]  [<c116002c>] usb_hcd_irq+0x25/0x5d
[520678.072944]  [<c1044569>] handle_IRQ_event+0x2f/0x5d
[520678.073023]  [<c10455ef>] handle_fasteoi_irq+0x74/0xc0
[520678.073101]  [<c1004d31>] do_IRQ+0xa1/0x126
[520678.073182]  [<c1003932>] common_interrupt+0x1a/0x20
[520678.073262]  [<c105b2f3>] free_pages_and_swap_cache+0x57/0x80
[520678.073343]  [<c10531dd>] zap_pte_range+0x1e5/0x28a
[520678.073425]  [<c105331f>] unmap_page_range+0x9d/0x128
[520678.073504]  [<c1053478>] unmap_vmas+0xce/0x1cc
[520678.073585]  [<c1057b42>] exit_mmap+0x79/0xf0
[520678.073664]  [<c101a56d>] mmput+0x36/0x8c
[520678.073743]  [<c1068c57>] exec_mmap+0x102/0x26d
[520678.073822]  [<c10692bc>] flush_old_exec+0x59/0x23a
[520678.073904]  [<c1090e83>] load_elf_binary+0x33c/0xc19
[520678.073984]  [<c1069751>] search_binary_handler+0x9a/0x24c
[520678.074068]  [<c1069a66>] do_execve+0x163/0x1f1
[520678.074147]  [<c1001cfb>] sys_execve+0x32/0x84
[520678.074226]  [<c1002fab>] syscall_call+0x7/0xb
[520678.074304]  =======================
[520678.074348] Code: 00 06 00 00 b9 01 00 02 00 89 54 18 14 8d 83 0c 06 00 00 ba 1d 00 00 00 e8 e5 6c ef ff 8b 93 14 06 00 00 8d 82 ec f9 ff ff 89 c3 <8b> 80 14 06 00 00 0f 18 00 90 39 fa 75 80 8b 45 f0 b9 01 00 00
[520678.076750] EIP: [<c1179b97>] hiddev_send_event+0xa1/0xd3 SS:ESP 0068:c133ee0c
[520678.076869]  <0>Kernel panic - not syncing: Fatal exception in interrupt
[520678.076953]  BUG: warning at arch/i386/kernel/smp.c:549/smp_call_function()
[520678.077032]  [<c1003caa>] show_trace_log_lvl+0x1a/0x30
[520678.077109]  [<c1003cd2>] show_trace+0x12/0x14
[520678.077184]  [<c1003dcf>] dump_stack+0x19/0x1b
[520678.077265]  [<c100cfd2>] smp_call_function+0x113/0x118
[520678.077343]  [<c100d02b>] smp_send_stop+0x1e/0x27
[520678.077425]  [<c101ca5f>] panic+0x50/0xf0
[520678.077513]  [<c10042ed>] die+0x225/0x234
[520678.077595]  [<c11f5522>] do_page_fault+0x34b/0x5bb
[520678.077601]  [<c11f3b71>] error_code+0x39/0x40
[520678.077605]  [<c1179c25>] hiddev_hid_event+0x5c/0x63
[520678.077609]  [<c11777df>] hid_process_event+0x71/0x7e
[520678.077612]  [<c117797c>] hid_input_field+0x190/0x328
[520678.077617]  [<c1177bba>] hid_input_report+0xa6/0xed
[520678.077620]  [<c1177f3e>] hid_irq_in+0xe4/0x124
[520678.077623]  [<c115ff9f>] usb_hcd_giveback_urb+0x4d/0xb5
[520678.077627]  [<c11751f9>] uhci_giveback_urb+0x82/0x19d


ssor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping        : 9
cpu MHz         : 3198.682
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 6400.37

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 3.20GHz
stepping        : 9
cpu MHz         : 3198.682
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 1
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid
xtpr
bogomips        : 6397.15


folkert@muur:~$ cat /proc/modules  | more
tuner 62248 0 - Live 0xf8b4e000
tvaudio 22940 0 - Live 0xf8b73000
bttv 169652 0 - Live 0xf8c52000
video_buf 21508 1 bttv, Live 0xf8b1d000
ir_common 26372 1 bttv, Live 0xf8b15000
i2c_algo_bit 8072 1 bttv, Live 0xf8b12000
btcx_risc 4744 1 bttv, Live 0xf8b0f000
tveeprom 14224 1 bttv, Live 0xf8b0a000
pwc 84640 0 - Live 0xf8af4000
wcfxo 12064 0 - Live 0xf8abf000
nfs 259180 1 - Live 0xf8a7e000
zaptel 189572 7 wcfxo, Live 0xf8ac4000
pl2303 20100 0 - Live 0xf8a66000
usbserial 28648 1 pl2303, Live 0xf8a5e000
plusb 2816 0 - Live 0xf8a5c000
usbnet 15240 1 plusb, Live 0xf8a57000
w83627hf 26512 0 - Live 0xf8a48000
hwmon_vid 3456 1 w83627hf, Live 0xf8a43000
eeprom 6288 0 - Live 0xf8a45000
snd_pcm_oss 44960 0 - Live 0xf8a37000
snd_mixer_oss 16256 1 snd_pcm_oss, Live 0xf8a32000
i2c_isa 4480 1 w83627hf, Live 0xf89c3000
i2c_core 19072 8
tuner,tvaudio,bttv,i2c_algo_bit,tveeprom,w83627hf,eeprom,i2c_isa, Live
0xf8a51000
sd_mod 17536 0 - Live 0xf8a0c000
scsi_mod 82820 1 sd_mod, Live 0xf8a1c000
snd_intel8x0 30620 0 - Live 0xf8a01000
ide_cd 38532 0 - Live 0xf89f6000
cdrom 39328 1 ide_cd, Live 0xf89eb000
snd_ac97_codec 97316 1 snd_intel8x0, Live 0xf89d2000
snd_pcm 76932 3 snd_pcm_oss,snd_intel8x0,snd_ac97_codec, Live 0xf89af000
snd_timer 21636 1 snd_pcm, Live 0xf89a8000
snd 48612 6
snd_pcm_oss,snd_mixer_oss,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer,
Live 0xf8999000
soundcore 7008 1 snd, Live 0xf8996000
snd_page_alloc 8840 2 snd_intel8x0,snd_pcm, Live 0xf8992000
snd_ac97_bus 2688 1 snd_ac97_codec, Live 0xf89a6000
parport_pc 33220 0 - Live 0xf89c8000
parport 33352 1 parport_pc, Live 0xf8a12000
microcode 8756 0 - Live 0xf894b000
firmware_class 8576 2 bttv,microcode, Live 0xf8947000
netconsole 3360 0 - Live 0xf8936000
nfsd 227056 13 - Live 0xf8959000
exportfs 5632 1 nfsd, Live 0xf892b000
lockd 65160 3 nfs,nfsd, Live 0xf8a6d000
sunrpc 151100 10 nfs,nfsd,lockd, Live 0xf8b24000
ipt_owner 2432 9 - Live 0xf8934000
ip6table_filter 2816 1 - Live 0xf8929000
ip6_tables 13276 1 ip6table_filter, Live 0xf8924000
ipv6 242208 32 - Live 0xf8cf3000
ipt_recent 8600 2 - Live 0xf88f7000
xt_limit 2944 4 - Live 0xf88ef000
xt_state 2432 4 - Live 0xf88ed000
act_police 5700 1 - Live 0xf8921000
sch_ingress 3840 1 - Live 0xf88f5000
cls_u32 8068 5 - Live 0xf88fc000
sch_sfq 6016 3 - Live 0xf88f2000
sch_cbq 16128 1 - Live 0xf88e8000
ipt_REJECT 4224 54 - Live 0xf88e5000
ipt_MASQUERADE 3328 1 - Live 0xf88c0000
ipt_TOS 2432 4 - Live 0xf88be000
xt_tcpudp 3712 143 - Live 0xf88bc000
iptable_mangle 2816 1 - Live 0xf88ba000
iptable_filter 2944 1 - Live 0xf88b8000
rtl8150 12288 0 - Live 0xf88b4000
e1000 125120 0 - Live 0xf88c5000
3c59x 40744 0 - Live 0xf88a3000
mii 5504 2 usbnet,3c59x, Live 0xf88c2000
iptable_nat 6916 1 - Live 0xf8882000
ip_nat 16428 2 ipt_MASQUERADE,iptable_nat, Live 0xf8938000
ip_tables 12252 3 iptable_mangle,iptable_filter,iptable_nat, Live 0xf887e000
ip_conntrack 48056 4 xt_state,ipt_MASQUERADE,iptable_nat,ip_nat, Live 0xf8871000
nfnetlink 5912 2 ip_nat,ip_conntrack, Live 0xf886e000
x_tables 13060 11
ipt_owner,ip6_tables,ipt_recent,xt_limit,xt_state,ipt_REJECT,ipt_MASQUERADE,ipt_TOS,xt_tcpudp,iptable_nat,ip_tables, Live 0xf8869000
capability 3720 0 - Live 0xf8885000
commoncap 6272 1 capability, Live 0xf8888000
ppp_deflate 5632 0 - Live 0xf8826000
zlib_deflate 20888 1 ppp_deflate, Live 0xf888b000
zlib_inflate 14720 1 ppp_deflate, Live 0xf8821000
ppp_async 10112 0 - Live 0xf881d000
crc_ccitt 2432 2 zaptel,ppp_async, Live 0xf881b000
ppp_generic 24084 2 ppp_deflate,ppp_async, Live 0xf8814000
slip 11872 4 - Live 0xf8810000
slhc 6400 2 ppp_generic,slip, Live 0xf880d000
genrtc 5644 0 - Live 0xf8829000
rd 5952 1 - Live 0xf882d000

folkert@muur:~$ /sbin/lsusb
Bus 008 Device 003: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
Bus 008 Device 002: ID 0471:0311 Philips PCVC740K ToUcam Pro [pwc]
Bus 008 Device 001: ID 0000:0000
Bus 007 Device 002: ID 0463:ffff MGE UPS Systems UPS
Bus 007 Device 001: ID 0000:0000
Bus 006 Device 001: ID 0000:0000
Bus 005 Device 001: ID 0000:0000
Bus 004 Device 003: ID 0d50:0010 Cleware GmbH
Bus 004 Device 002: ID 0d50:0010 Cleware GmbH
Bus 004 Device 001: ID 0000:0000
Bus 003 Device 003: ID 067b:0000 Prolific Technology, Inc. PL2301 USB-USB Bridge
Bus 003 Device 002: ID 0bda:8150 Realtek Semiconductor Corp. RTL8150 Fast Ethernet Adapter
Bus 003 Device 001: ID 0000:0000
Bus 002 Device 001: ID 0000:0000
Bus 001 Device 001: ID 0000:0000


00:00.0 Host bridge: Intel Corp. 82875P Memory Controller Hub (rev 02)
	Subsystem: Asustek Computer, Inc.: Unknown device 80f6
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: <available only to root>

00:01.0 PCI bridge: Intel Corp. 82875P Processor to AGP Controller (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fe800000-fe8fffff
	Prefetchable memory behind bridge: efe00000-f7dfffff
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-

00:03.0 PCI bridge: Intel Corp. 82875P Processor to PCI to CSA Bridge (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fe900000-fe9fffff
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB UHCI #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Asustek Computer, Inc. P4P800 Mainboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 4: I/O ports at eec0 [size=32]

00:1d.1 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB UHCI #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Asustek Computer, Inc. P4P800 Mainboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 20
	Region 4: I/O ports at ef00 [size=32]

00:1d.2 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB UHCI #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Asustek Computer, Inc. P4P800 Mainboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 16
	Region 4: I/O ports at ef20 [size=32]

00:1d.3 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB UHCI #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Asustek Computer, Inc. P4P800 Mainboard
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 4: I/O ports at ef40 [size=32]

00:1d.7 USB Controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Asustek Computer, Inc. P4P800 Mainboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 17
	Region 0: Memory at febfbc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <available only to root>

00:1e.0 PCI bridge: Intel Corp. 82801BA/CA/DB/EB/ER Hub interface to PCI Bridge (rev c2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fea00000-feafffff
	Prefetchable memory behind bridge: f7e00000-f7efffff
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corp. 82801EB/ER (ICH5/ICH5R) LPC Bridge (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corp. 82801EB/ER (ICH5/ICH5R) Ultra ATA 100 Storage Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Asustek Computer, Inc. P4P800 Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at <unassigned>
	Region 1: I/O ports at <unassigned>
	Region 2: I/O ports at <unassigned>
	Region 3: I/O ports at <unassigned>
	Region 4: I/O ports at fc00 [size=16]
	Region 5: Memory at 88000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corp. 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 02)
	Subsystem: Asustek Computer, Inc. P4P800 Mainboard
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 11
	Region 4: I/O ports at 0400 [size=32]

00:1f.5 Multimedia audio controller: Intel Corp. 82801EB/ER (ICH5/ICH5R) AC'97 Audio Controller (rev 02)
	Subsystem: Asustek Computer, Inc. P4P800 Mainboard
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 23
	Region 0: I/O ports at e800 [size=256]
	Region 1: I/O ports at ee80 [size=64]
	Region 2: Memory at febfb800 (32-bit, non-prefetchable) [size=512]
	Region 3: Memory at febfb400 (32-bit, non-prefetchable) [size=256]
	Capabilities: <available only to root>

01:00.0 VGA compatible controller: ATI Technologies Inc Rage 128 Pro Ultra TF (prog-if 00 [VGA])
	Subsystem: ATI Technologies Inc Rage Fury Pro/Xpert 2000 Pro
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2000ns min), cache line size 04
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=64M]
	Region 1: I/O ports at b000 [size=256]
	Region 2: Memory at fe8fc000 (32-bit, non-prefetchable) [size=16K]
	Expansion ROM at fe8c0000 [disabled] [size=128K]
	Capabilities: <available only to root>

02:01.0 Ethernet controller: Intel Corp. 82547EI Gigabit Ethernet Controller (LOM)
	Subsystem: Asustek Computer, Inc.: Unknown device 80f7
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (63750ns min), cache line size 04
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fe9e0000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at cf80 [size=32]
	Capabilities: <available only to root>

03:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80) (prog-if 10 [OHCI])
	Subsystem: Asustek Computer, Inc.: Unknown device 808a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns max), cache line size 04
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at feaff800 (32-bit, non-prefetchable) [size=2K]
	Region 1: I/O ports at dc00 [size=128]
	Capabilities: <available only to root>

03:09.0 Ethernet controller: National Semiconductor Corporation DP83820 10/100/1000 Ethernet Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2750ns min, 13000ns max), cache line size 04
	Interrupt: pin A routed to IRQ 5
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at feafe000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at f7e20000 [disabled] [size=64K]

03:0a.0 USB Controller: VIA Technologies, Inc. VT6202 [USB 2.0 controller] (rev 50) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, cache line size 04
	Interrupt: pin A routed to IRQ 21
	Region 4: I/O ports at df40 [size=32]
	Capabilities: <available only to root>

03:0a.1 USB Controller: VIA Technologies, Inc. VT6202 [USB 2.0 controller] (rev 50) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, cache line size 04
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at df80 [size=32]
	Capabilities: <available only to root>

03:0a.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 51) (prog-if 20 [EHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID): Unknown device 1234
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, cache line size 20
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at feaff400 (32-bit, non-prefetchable) [size=256]
	Capabilities: <available only to root>

03:0b.0 Communication controller: Individual Computers - Jens Schoenfeld Intel 537
	Subsystem: Intel Corp.: Unknown device 0003
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (250ns min, 32000ns max)
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at d400 [size=256]
	Region 1: Memory at feafd000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <available only to root>

03:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (4000ns min, 10000ns max)
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f7efe000 (32-bit, prefetchable) [size=4K]
	Capabilities: <available only to root>

03:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
	Subsystem: Hauppauge computer works Inc. WinTV Series
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (1000ns min, 63750ns max)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at f7eff000 (32-bit, prefetchable) [size=4K]
	Capabilities: <available only to root>

03:0d.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone] (rev 24)
	Subsystem: 3Com Corporation 3C905B Fast Etherlink XL 10/100
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2500ns min, 2500ns max), cache line size 04
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at d080 [size=128]
	Region 1: Memory at feaff000 (32-bit, non-prefetchable) [size=128]
	Expansion ROM at f7e00000 [disabled] [size=128K]
	Capabilities: <available only to root>


Folkert van Heusden

p.s. maybe we should change the console to white on blue after a panic?
that's a little more consistent with other crashing computers

-- 
Feeling generous? -> http://www.vanheusden.com/wishlist.php
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
