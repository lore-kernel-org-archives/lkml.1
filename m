Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYKHTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYKHTDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbYKHTDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:03:42 -0500
Received: from mout3.freenet.de ([195.4.92.93]:50227 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbYKHTDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:03:39 -0500
X-Greylist: delayed 617 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Nov 2008 14:03:39 EST
Message-ID: <4915EBB4.8020408@freenet.de>
Date: Sat, 08 Nov 2008 20:42:44 +0100
From: str1442 <lancerstr@freenet.de>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: BUG at mm/rmap.c:662
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At starting gnome evince, suddenly all freezed. After that, trying to 
reboot worked, but i got within minutes at resolving the logs another 
freeze. Booting a Knoppix CD helped in order to read the logs and of 
course writing this message. FSCK showed that my system partition have 
had multiply problems, mainly "Duplicate blocks found in two inodes" 
(Not shure if it was the exact message).

Running Kernel 2.6.27.2, with e1000e and iwl3945. The e1000e bug didnt 
affect me. Iwl3945 seems to be connected to the problem, as i got on the 
reboot try an segfault by trying to "rmmod iwl3945". Also, iwl3945 is 
mentioned in the BUG message below as the last unloaded module.

Messages in /var/log/syslog:

Nov  8 18:12:54 HDFARE1442 kernel: [22308.309873] kernel BUG at 
mm/rmap.c:662!
Nov  8 18:12:54 HDFARE1442 kernel: [22308.309878] invalid opcode: 0000 
[#1] SMP
Nov  8 18:12:54 HDFARE1442 kernel: [22308.309885] Modules linked in: 
i915 drm binfmt_misc iwl3945 ipv6 ppdev parport_pc lp parport 
acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_conservative 
cpufreq_stats cpufreq_ondemand freq_table loop joydev usbhid hid 
ff_memless snd_hda_intel snd_pcm snd_seq snd_timer snd_seq_device fan 
psmouse iTCO_wdt pcspkr snd serio_raw led_class video container 
soundcore ac wmi intel_agp snd_page_alloc thermal uhci_hcd battery 
output button ehci_hcd agpgart processor thermal_sys e1000e usbcore 
sr_mod cdrom evdev [last unloaded: iwl3945]
Nov  8 18:12:54 HDFARE1442 kernel: [22308.309969]
Nov  8 18:12:54 HDFARE1442 kernel: [22308.309974] Pid: 3070, comm: 
gnome-panel Not tainted (2.6.27.2 #1)
Nov  8 18:12:54 HDFARE1442 kernel: [22308.309980] EIP: 0060:[<c016a28c>] 
EFLAGS: 00010292 CPU: 0
Nov  8 18:12:54 HDFARE1442 kernel: [22308.309988] EIP is at 
page_remove_rmap+0xb5/0xd0
Nov  8 18:12:54 HDFARE1442 kernel: [22308.309993] EAX: 0000004a EBX: 
c1000000 ECX: f2a27c9c EDX: c0390b51
Nov  8 18:12:54 HDFARE1442 kernel: [22308.309998] ESI: f2bc0b00 EDI: 
b67e2000 EBP: 00000053 ESP: f2a27d8c
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310003]  DS: 007b ES: 007b FS: 
00d8 GS: 0000 SS: 0068
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310009] Process gnome-panel 
(pid: 3070, ti=f2a26000 task=f7bb1b00 task.ti=f2a26000)
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310014] Stack: 00000053 
c1000000 c0163f67 00000004 c04555b0 b689dfff 00000004 00000000
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310028]        f2bc0b00 
f2a27e34 00000001 00146d01 00000000 f7080740 b689e000 f6fceb64
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310042]        f6fceb64 
00000000 00000000 c1ffd5c0 c02a483f f7080740 00000000 f2a27e44
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310055] Call Trace:
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310059]  [<c0163f67>] 
unmap_vmas+0x375/0x648
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310068]  [<c02a483f>] 
skb_dequeue+0x42/0x48
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310078]  [<c0167203>] 
exit_mmap+0x76/0xe1
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310085]  [<c0122541>] 
mmput+0x1c/0x7f
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310094]  [<c012565b>] 
exit_mm+0xe5/0xec
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310101]  [<c0327945>] 
_spin_lock_irq+0x13/0x15
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310110]  [<c0126ee9>] 
do_exit+0x1ae/0x6ff
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310118]  [<c01274a2>] 
do_group_exit+0x68/0x8f
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310125]  [<c012eb7f>] 
get_signal_to_deliver+0x314/0x335
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310135]  [<c01057b8>] 
do_invalid_op+0x0/0x6b
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310144]  [<c0102c7b>] 
do_notify_resume+0x60/0x64c
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310151]  [<c012e4bd>] 
force_sig_info+0x95/0x9f
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310159]  [<c03265c3>] 
schedule+0x6f2/0x75c
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310166]  [<c012862f>] 
__do_softirq+0x78/0xe4
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310173]  [<c01057b8>] 
do_invalid_op+0x0/0x6b
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310181]  [<c0103a64>] 
work_notifysig+0x13/0x1b
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310188]  =======================
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310191] Code: c0 74 0d 8b 50 
08 b8 33 0b 39 c0 e8 0b 95 fd ff 8b 46 48 85 c0 74 14 8b 40 10 85 c0 74 
0d 8b 50 2c b8 51 0b 39 c0 e8 f0 94 fd ff <0f> 0b eb fe 8b 53 10 89 d8 
5b 5e 83 e2 01 f7 da 83 c2 04 e9 ad
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310263] EIP: [<c016a28c>] 
page_remove_rmap+0xb5/0xd0 SS:ESP 0068:f2a27d8c
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310276] ---[ end trace 
c2722fbf431fe891 ]---
Nov  8 18:12:54 HDFARE1442 kernel: [22308.310280] Fixing recursive fault 
but reboot is needed!
Nov  8 18:12:55 HDFARE1442 NetworkManager: <info>  Error getting 
killswitch power: org.freedesktop.Hal.Device.UnknownError - 
/usr/lib/hal/scripts/linux/hal-system-killswitch-get-power-linux: line 
124: 15836 Segmentation fault      hal-ipw-killswitch-linux getrfkill 
#012 org.freedesktop.Hal.Device.KillSwitch.NotSupported
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047690] kernel BUG at 
mm/rmap.c:662!
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047693] invalid opcode: 0000 
[#1] SMP
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047698] Modules linked in: 
i915 drm binfmt_misc iwl3945 ipv6 ppdev parport_pc lp parport 
acpi_cpufreq cpufreq_userspace cpufreq_powersave cpufreq_conservative 
cpufreq_stats cpufreq_ondemand freq_table loop usbhid hid ff_memless 
joydev snd_hda_intel snd_pcm snd_seq snd_timer snd_seq_device snd 
psmouse pcspkr iTCO_wdt serio_raw soundcore fan snd_page_alloc led_class 
container video output uhci_hcd ehci_hcd wmi battery e1000e usbcore 
thermal button ac processor thermal_sys intel_agp sr_mod agpgart cdrom 
evdev [last unloaded: iwl3945]
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047758]
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047760] Pid: 12388, comm: 
firefox-bin Not tainted (2.6.27.2 #1)
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047764] EIP: 0060:[<c016a28c>] 
EFLAGS: 00210246 CPU: 0
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047770] EIP is at 
page_remove_rmap+0xb5/0xd0
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047773] EAX: 00000000 EBX: 
c1000000 ECX: ee941c8c EDX: c0390b1c
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047776] ESI: f2bfaa58 EDI: 
b43e0000 EBP: 00000001 ESP: ee941d8c
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047779]  DS: 007b ES: 007b FS: 
00d8 GS: 0000 SS: 0068
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047783] Process firefox-bin 
(pid: 12388, ti=ee940000 task=eead0460 task.ti=ee940000)
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047786] Stack: 00000001 
c1000000 c0163f67 eead048c c04555b0 b4ba8fff f71ecd4c 00000000
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047796]        f2bfaa58 
ee941e34 00000001 0007ca88 00000000 f7103900 b4ba9000 eea53b40
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047806]        eea53b40 
f7103900 c0459080 c1ffd5c0 f7103900 eead0460 c03265c3 eea1c660
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047815] Call Trace:
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047818]  [<c0163f67>] 
unmap_vmas+0x375/0x648
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047823]  [<c03265c3>] 
schedule+0x6f2/0x75c
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047829]  [<c0167203>] 
exit_mmap+0x76/0xe1
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047833]  [<c0122541>] 
mmput+0x1c/0x7f
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047838]  [<c012565b>] 
exit_mm+0xe5/0xec
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047843]  [<c0126ee9>] 
do_exit+0x1ae/0x6ff
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047847]  [<c01274a2>] 
do_group_exit+0x68/0x8f
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047852]  [<c012eb7f>] 
get_signal_to_deliver+0x314/0x335
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047857]  [<c0102c7b>] 
do_notify_resume+0x60/0x64c
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047862]  [<c0138b52>] 
getnstimeofday+0x32/0xb5
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047868]  [<c0136bd5>] 
ktime_get_ts+0x1d/0x3f
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047872]  [<c013f0f5>] 
sys_futex+0xec/0x101
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047877]  [<c0103a64>] 
work_notifysig+0x13/0x1b
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047882]  =======================
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047884] Code: c0 74 0d 8b 50 
08 b8 33 0b 39 c0 e8 0b 95 fd ff 8b 46 48 85 c0 74 14 8b 40 10 85 c0 74 
0d 8b 50 2c b8 51 0b 39 c0 e8 f0 94 fd ff <0f> 0b eb fe 8b 53 10 89 d8 
5b 5e 83 e2 01 f7 da 83 c2 04 e9 ad
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047938] EIP: [<c016a28c>] 
page_remove_rmap+0xb5/0xd0 SS:ESP 0068:ee941d8c
Nov  8 18:29:27 HDFARE1442 kernel: [  531.047945] ---[ end trace 
ff8738cd93882f94 ]---


The following information is all from the Knoppix boot:

lspci -vvv:

cpuinfo:

processor    : 0
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz
stepping    : 13
cpu MHz        : 1801.000
cache size    : 2048 KB
physical id    : 0
siblings    : 2
core id        : 0
cpu cores    : 2
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pni monitor ds_cpl est tm2 ssse3 cx16 xtpr lahf_lm
bogomips    : 3595.10

processor    : 1
vendor_id    : GenuineIntel
cpu family    : 6
model        : 15
model name    : Intel(R) Core(TM)2 Duo CPU     T5670  @ 1.80GHz
stepping    : 13
cpu MHz        : 1801.000
cache size    : 2048 KB
physical id    : 0
siblings    : 2
core id        : 1
cpu cores    : 2
fdiv_bug    : no
hlt_bug        : no
f00f_bug    : no
coma_bug    : no
fpu        : yes
fpu_exception    : yes
cpuid level    : 10
wp        : yes
flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pni monitor ds_cpl est tm2 ssse3 cx16 xtpr lahf_lm
bogomips    : 3591.06

lspci -vvv:
00:00.0 Host bridge: Intel Corporation Unknown device 2a10 (rev 0c)
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
    Latency: 0
    Capabilities: <access denied>

00:02.0 VGA compatible controller: Intel Corporation Unknown device 2a12 
(rev 0c) (prog-if 00 [VGA])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at e4400000 (64-bit, non-prefetchable) [size=1M]
    Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
    Region 4: I/O ports at 4000 [size=8]
    Capabilities: <access denied>

00:02.1 Display controller: Intel Corporation Unknown device 2a13 (rev 0c)
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Region 0: Memory at e4500000 (64-bit, non-prefetchable) [size=1M]
    Capabilities: <access denied>

00:19.0 Ethernet controller: Intel Corporation Unknown device 10c4 (rev 03)
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin A routed to IRQ 5
    Region 0: Memory at e4600000 (32-bit, non-prefetchable) [size=128K]
    Region 1: Memory at e4620000 (32-bit, non-prefetchable) [size=4K]
    Region 2: I/O ports at 4020 [size=32]
    Capabilities: <access denied>

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
#4 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 4: I/O ports at 4040 [size=32]

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
#2 (rev 03) (prog-if 20 [EHCI])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 0: Memory at e4621000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 03)
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at e4624000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: <access denied>

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 1 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
    Capabilities: <access denied>

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 2 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=10, subordinate=10, sec-latency=0
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: e4000000-e40fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
    Capabilities: <access denied>

00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 5 (rev 03) (prog-if 00 [Normal decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0, Cache Line Size: 64 bytes
    Bus: primary=00, secondary=28, subordinate=28, sec-latency=0
    I/O behind bridge: 00002000-00003fff
    Memory behind bridge: e0000000-e3ffffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
    BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
    Capabilities: <access denied>

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
#1 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin A routed to IRQ 19
    Region 4: I/O ports at 4060 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
#2 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin B routed to IRQ 20
    Region 4: I/O ports at 4080 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
#3 (rev 03) (prog-if 00 [UHCI])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin C routed to IRQ 18
    Region 4: I/O ports at 40a0 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
#1 (rev 03) (prog-if 20 [EHCI])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin A routed to IRQ 19
    Region 0: Memory at e4628000 (32-bit, non-prefetchable) [size=1K]
    Capabilities: <access denied>

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) 
(prog-if 01 [Subtractive decode])
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
    I/O behind bridge: 0000f000-00000fff
    Memory behind bridge: fff00000-000fffff
    Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
    Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
    BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
    Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation Mobile LPC Interface Controller 
(rev 03)
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Capabilities: <access denied>

00:1f.1 IDE interface: Intel Corporation Mobile IDE Controller (rev 03) 
(prog-if 8a [Master SecP PriP])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin A routed to IRQ 16
    Region 0: I/O ports at <unassigned>
    Region 1: I/O ports at <unassigned>
    Region 2: I/O ports at <unassigned>
    Region 3: I/O ports at <unassigned>
    Region 4: I/O ports at 40c0 [size=16]

00:1f.2 SATA controller: Intel Corporation Mobile SATA AHCI Controller 
(rev 03) (prog-if 01 [AHCI 1.0])
    Subsystem: Hewlett-Packard Company Unknown device 30d8
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin B routed to IRQ 17
    Region 0: I/O ports at 13f0 [size=8]
    Region 1: I/O ports at 15f4 [size=4]
    Region 2: I/O ports at 1370 [size=8]
    Region 3: I/O ports at 1574 [size=4]
    Region 4: I/O ports at 4100 [size=32]
    Region 5: Memory at e4629000 (32-bit, non-prefetchable) [size=2K]
    Capabilities: <access denied>

10:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
Network Connection (rev 02)
    Subsystem: Hewlett-Packard Company Unknown device 135c
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0, Cache Line Size: 64 bytes
    Interrupt: pin A routed to IRQ 10
    Region 0: Memory at e4000000 (32-bit, non-prefetchable) [size=4K]
    Capabilities: <access denied>

scsi/scsi:

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: FUJITSU MHZ2160B Rev: 8909
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: Sony     Model: Storage Media    Rev: 0100
  Type:   Direct-Access                    ANSI SCSI revision: 02


iomem (dont know if this is useful, its from the knoppix boot):
00000000-0009fbff : System RAM
  00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000d0000-000d0fff : Adapter ROM
000d1000-000d1fff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7f7affff : System RAM
  00100000-003aef9b : Kernel code
  003aef9c-0049e7b3 : Kernel data
7f7b0000-7f7c53ff : reserved
7f7c5400-7f7e7fb7 : ACPI Non-volatile Storage
7f7e7fb8-7fffffff : reserved
d0000000-dfffffff : 0000:00:02.0
  d0000000-d076ffff : vesafb
e0000000-e3ffffff : PCI Bus #28
e4000000-e40fffff : PCI Bus #10
  e4000000-e4000fff : 0000:10:00.0
e4400000-e44fffff : 0000:00:02.0
e4500000-e45fffff : 0000:00:02.1
e4600000-e461ffff : 0000:00:19.0
e4620000-e4620fff : 0000:00:19.0
e4621000-e46213ff : 0000:00:1a.7
  e4621000-e46213ff : ehci_hcd
e4624000-e4627fff : 0000:00:1b.0
e4628000-e46283ff : 0000:00:1d.7
  e4628000-e46283ff : ehci_hcd
e4629000-e46297ff : 0000:00:1f.2
  e4629000-e46297ff : ahci
fec00000-fec00fff : reserved
fed00000-fed003ff : HPET 0
fed20000-fed99fff : reserved
feda0000-fedbffff : reserved
fee00000-fee00fff : reserved
ffb00000-ffbfffff : reserved
fff00000-ffffffff : reserved


regards
