Return-Path: <linux-kernel-owner+w=401wt.eu-S1761143AbXFJQqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143AbXFJQqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbXFJQqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:46:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:16711 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbXFJQqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FePZT2UpNUvjMr7ZKrbhCS6lK6tdoHSGvQI08fc3V8VcmkmjCI+RPuc8uz7syMkLaKpPHAZT83kvM/iTDwLsfHHSwDDbAU1xgpouWLdBulKNT0EhA4m5WaXJ16gJRrMu+tlDFUii57mI/N4vsINbJaMysxvOq1KogP/kCqyYRB0=
Message-ID: <5bdc1c8b0706100946k3acd6374uac8248e78f97433d@mail.gmail.com>
Date: Sun, 10 Jun 2007 09:46:31 -0700
From: "Mark Knecht" <markknecht@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rt9 - IRQ23 consuming a steady 2.7% of CPU
Cc: "Ingo Molnar" <mingo@elte.hu>, "Lee Revell" <rlrevell@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I've been running 2.6.21.3-rt9 and a couple of -rc predecessors for
a few weeks and this minor problem has been consistent on all versions
I've run. On this AMD64 machine I still have 2.6.17-rt8 and 2.6.18-rt7
and neither of those versions cause the problem. I am currently
building the matching vanilla kernel as well as the 2.6.22-rc3 kernel
to see if it's in those versions.

   I see today that the same problem has been reported by another
AMD64 user on a distribution mail list so I think the problem isn't
specific to my hardware anymore. I had previously thought so and
therefore didn't report this right away thinking I'd do more debug.

http://search.gmane.org/?query=IRQ+23&group=gmane.linux.distributions.64studio

   Since my IRQ23 is shared on my machine by Ethernet and USB I have
tried detaching all network cables and turning off all USB devices but
the problem persists.

   I'll report back what happens with the vanilla-kernels. If a binary
regression search is required of everything between 2.6.18 and 2.6.21
to look for where the problem crept in that will take some time so any
guidance on where to start would be helpful.

   If more info is desired please don't hesitate to ask.

Cheers,
Mark


mark@lightning ~ $ uname -a
Linux lightning 2.6.21.3-rt9 #1 PREEMPT RT Sat Jun 9 09:49:32 PDT 2007
x86_64 AMD Athlon(tm) 64 Processor 3000+ AuthenticAMD GNU/Linux
mark@lightning ~ $


mark@lightning ~ $ top

top - 10:02:17 up 3 min,  2 users,  load average: 0.00, 0.00, 0.00
Tasks:  88 total,   2 running,  86 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.3%us,  0.0%sy,  0.0%ni, 95.7%id,  0.0%wa,  3.0%hi,  0.0%si,  0.0%st
Mem:   1026612k total,   190316k used,   836296k free,     8124k buffers
Swap:  2008084k total,        0k used,  2008084k free,    74616k cached

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 947 root     -76  -5     0    0    0 S  2.7  0.0   0:05.58 IRQ-23
 9533 root      15   0  324m  13m 7420 S  1.3  1.4   0:03.24 X
   1 root      15   0  2668  588  500 S  0.0  0.1   0:00.27 init
   2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 posix_cpu_timer
   3 root     -51   0     0    0    0 S  0.0  0.0   0:00.00 softirq-high/0



mark@lightning ~ $ cat /proc/interrupts
          CPU0
 0:        212   IO-APIC-edge      timer
 1:        296   IO-APIC-edge      i8042
 6:          3   IO-APIC-edge      floppy
 7:          0   IO-APIC-edge      lpptest
 8:          0   IO-APIC-edge      rtc
 9:          0   IO-APIC-fasteoi   acpi
 12:       8690   IO-APIC-edge      i8042
 14:         62   IO-APIC-edge      ide0
 16:          0   IO-APIC-fasteoi   hdsp
 18:      14496   IO-APIC-fasteoi   ohci1394, radeon@pci:0000:01:00.0
 20:          2   IO-APIC-fasteoi   ehci_hcd:usb1
 21:       7724   IO-APIC-fasteoi   libata
 22:          0   IO-APIC-fasteoi   libata, NVidia CK804
 23:    1739277   IO-APIC-fasteoi   ohci_hcd:usb2, eth0
NMI:          0
LOC:      59688
ERR:          0
mark@lightning ~ $


mark@lightning ~ $ uname -a
Linux lightning 2.6.18-rt7 #4 PREEMPT Sun Apr 8 17:32:31 PDT 2007
x86_64 AMD Athlon(tm) 64 Processor 3000+ AuthenticAMD GNU/Linux
mark@lightning ~ $


mark@lightning ~ $ top

top - 10:09:51 up 1 min,  2 users,  load average: 0.00, 0.00, 0.00
Tasks:  83 total,   1 running,  82 sleeping,   0 stopped,   0 zombie
Cpu(s):  1.7%us,  0.3%sy,  0.0%ni, 95.4%id,  2.6%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   1026840k total,   185688k used,   841152k free,     7904k buffers
Swap:  2008084k total,        0k used,  2008084k free,    74172k cached

 PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 9024 root      15   0  324m  13m 7072 S  1.7  1.3   0:01.00 X
   7 root      -2   0     0    0    0 S  0.3  0.0   0:01.02 softirq-block/0
 9912 mark      15   0 10600 1304  960 R  0.3  0.1   0:00.01 top
   1 root      15   0  2676  588  500 S  0.0  0.1   0:00.31 init
   2 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 posix_cpu_timer
   3 root      -2   0     0    0    0 S  0.0  0.0   0:00.00 softirq-high/0


lightning ~ # lspci
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97
Audio Controller (rev a2)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60
[Radeon X300 (PCIE)]
01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
05:06.0 Multimedia audio controller: Xilinx Corporation RME Hammerfall
DSP (rev 68)
05:08.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2 IEEE-1394b
Link Layer Controller (rev 01)
lightning ~ #

lightning ~ # lsmod
Module                  Size  Used by
it87                   22032  0
hwmon_vid               2880  1 it87
i2c_isa                 6144  1 it87
eeprom                  7248  0
snd_seq_midi            7296  0
snd_pcm_oss            40160  0
snd_mixer_oss          15168  1 snd_pcm_oss
snd_seq_dummy           3460  0
snd_seq_oss            29696  0
snd_seq_midi_event      7040  2 snd_seq_midi,snd_seq_oss
snd_seq                48000  6
snd_seq_midi,snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
realtime                9416  0
sbp2                   22084  0
radeon                115488  2
drm                    84392  3 radeon
snd_hdsp               47812  0
snd_rawmidi            21216  2 snd_seq_midi,snd_hdsp
snd_seq_device          7252  5
snd_seq_midi,snd_seq_dummy,snd_seq_oss,snd_seq,snd_rawmidi
snd_hwdep               8456  1 snd_hdsp
ohci1394               31368  0
ieee1394               91024  2 sbp2,ohci1394
snd_intel8x0           32296  1
snd_ac97_codec        107288  1 snd_intel8x0
ac97_bus                3712  1 snd_ac97_codec
snd_pcm                74440  4 snd_pcm_oss,snd_hdsp,snd_intel8x0,snd_ac97_codec
snd_timer              20424  2 snd_seq,snd_pcm
snd                    52264  14
snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_seq,snd_hdsp,snd_rawmidi,snd_seq_device,snd_hwdep,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
snd_page_alloc          8208  3 snd_hdsp,snd_intel8x0,snd_pcm
k8temp                  5888  0
i2c_nforce2             6016  0
i2c_core               21056  4 it87,i2c_isa,eeprom,i2c_nforce2
lightning ~ #
