Return-Path: <linux-kernel-owner+w=401wt.eu-S1758045AbZJBSXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045AbZJBSXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbZJBSXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:23:46 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:47042 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZJBSXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:23:44 -0400
Message-ID: <4AC64531.5030909@mandriva.org>
Date: Fri, 02 Oct 2009 21:23:45 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090830)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: WARNING: at arch/x86/kernel/hpet.c:390
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Does this ring a bell for anyone ?

I see this on a 2.6.31.1 based kernel...
Arch is x86_64
Distro: Mandriva Cooker

It also happends if I patch in the full ACPICA 20090903 as of 2.6.32-rc1 
+ the ec fix

asus_atk0110 is not loaded...


System is a Core-i7 860 on a Asus P7P55D DeLuxe

input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
ACPI: Power Button [PWRB]
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:01: registered as cooling_device1
ACPI: CPU2 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:02: registered as cooling_device2
ACPI: CPU3 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:03: registered as cooling_device3
ACPI: CPU4 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:04: registered as cooling_device4
ACPI: CPU5 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:05: registered as cooling_device5
ACPI: CPU6 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:06: registered as cooling_device6

------------[ cut here ]------------
WARNING: at arch/x86/kernel/hpet.c:390 hpet_next_event+0x7a/0x90()
Hardware name: System Product Name
Modules linked in: button serio_raw processor(+) ieee1394 r8169 evdev 
thermal soundcore pcspkr mii i2c_i801 rtc_cmos wmi i2c_core 
snd_page_alloc ehci_hcd sr_mod(+) sg usbcore pata_jmicron dm_snapshot 
dm_zero dm_mirror dm_region_hash dm_log dm_mod ata_piix ahci libata 
sd_mod scsi_mod crc_t10dif ext4 jbd2 crc16
Pid: 0, comm: swapper Not tainted 2.6.31.1-desktop-2mnb #1
Call Trace:
  [<ffffffff810696d5>] warn_slowpath_common+0x85/0xd0
  [<ffffffff81069747>] warn_slowpath_null+0x27/0x50
  [<ffffffff81038f5a>] hpet_next_event+0x7a/0x90
  [<ffffffff81038fa0>] hpet_legacy_next_event+0x10/0x20
  [<ffffffff81098f77>] clockevents_program_event+0x67/0xc0
  [<ffffffff8109a9e8>] tick_dev_program_event+0x58/0x100
  [<ffffffff8109a18e>] tick_broadcast_oneshot_control+0x12e/0x140
  [<ffffffff81099705>] tick_notify+0x335/0x460
  [<ffffffff8101408e>] ? call_function_single_interrupt+0xe/0x20
  [<ffffffff8141bd17>] notifier_call_chain+0x57/0xb0
  [<ffffffff8108f979>] raw_notifier_call_chain+0x29/0x50
  [<ffffffff81098cf8>] clockevents_notify+0x48/0xd0
  [<ffffffffa02285a9>] lapic_timer_state_broadcast+0x59/0x6f [processor]
  [<ffffffffa0228bfd>] acpi_idle_enter_bm+0x199/0x2d6 [processor]
  [<ffffffff813443b1>] ? menu_select+0x51/0x120
  [<ffffffff8134300b>] cpuidle_idle_call+0xbb/0x120
  [<ffffffff8101206a>] cpu_idle+0xca/0x120
  [<ffffffff8141172f>] start_secondary+0x203/0x25c
---[ end trace ecec12ff1544d442 ]---
ACPI: CPU7 (power states: C1[C1] C2[C2] C3[C3])
processor LNXCPU:07: registered as cooling_device7
ohci1394 0000:07:03.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18] 
MMIO=[fbeff000-fbeff7ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0

lsmod output:
[root@thunder ~]# lsmod
Module                  Size  Used by
af_packet              25808  0
bonding               128916  0
ipv6                  357584  1 bonding
binfmt_misc            10556  1
loop                   20124  0
xfs                   601536  1
exportfs                5584  1 xfs
cpufreq_ondemand        9056  0
cpufreq_conservative     9504  0
cpufreq_powersave       2064  0
acpi_cpufreq           10464  0
freq_table              5744  2 cpufreq_ondemand,acpi_cpufreq
drm                   211584  0
usblp                  15856  0
joydev                 13664  0
hid_logitech           10448  0
ff_memless              9656  1 hid_logitech
usbhid                 58112  1 hid_logitech
hid                    83200  2 hid_logitech,usbhid
snd_hda_codec_atihdmi     4880  1
snd_hda_codec_via      36720  0
snd_hda_intel          32584  0
snd_hda_codec          97296  3 
snd_hda_codec_atihdmi,snd_hda_codec_via,snd_hda_intel
snd_hwdep              10456  1 snd_hda_codec
snd_seq_dummy           3636  0
snd_seq_oss            39616  0
snd_seq_midi_event      9776  1 snd_seq_oss
snd_seq                70048  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device          9412  3 snd_seq_dummy,snd_seq_oss,snd_seq
snd_pcm_oss            54208  0
snd_pcm               107672  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_timer              28288  2 snd_seq,snd_pcm
snd_mixer_oss          20496  1 snd_pcm_oss
snd                    85224  10 
snd_hda_intel,snd_hda_codec,snd_hwdep,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss
ohci1394               35396  0
button                  7440  0
serio_raw               7348  0
processor              44396  9 acpi_cpufreq
ieee1394              110144  1 ohci1394
r8169                  42196  0
evdev                  13472  9
thermal                18192  0
soundcore              10464  1 snd
pcspkr                  3504  0
mii                     6992  1 r8169
i2c_i801               14160  0
rtc_cmos               15740  0
wmi                     8864  0
i2c_core               36352  2 drm,i2c_i801
snd_page_alloc         11552  2 snd_hda_intel,snd_pcm
ehci_hcd               56896  0
sr_mod                 19780  0
sg                     37600  0
usbcore               234132  4 usblp,usbhid,ehci_hcd
pata_jmicron            4400  0
dm_snapshot            28636  0
dm_zero                 2448  0
dm_mirror              17688  2
dm_region_hash         14704  1 dm_mirror
dm_log                 12596  4 dm_mirror,dm_region_hash
dm_mod                 87880  43 dm_snapshot,dm_zero,dm_mirror,dm_log
ata_piix               28216  0
ahci                   44736  8
libata                216076  3 pata_jmicron,ata_piix,ahci
sd_mod                 42792  4
scsi_mod              197176  4 sr_mod,sg,libata,sd_mod
crc_t10dif              2256  1 sd_mod
ext4                  363704  2
jbd2                   97600  1 ext4
crc16                   2448  1 ext4

--
Thomas
