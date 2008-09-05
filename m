Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYIEA2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYIEA2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 20:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYIEA2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 20:28:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbYIEA2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 20:28:33 -0400
Date: Thu, 4 Sep 2008 17:28:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Edgar Kalkowski <eMail@edgar-kalkowski.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: PROBLEM: Kernel 2.6.26 oops if I unplug my Logitech USB 1.1
 headset
Message-Id: <20080904172822.e5390a59.akpm@linux-foundation.org>
In-Reply-To: <48C069B1.3000201@edgar-kalkowski.de>
References: <48C069B1.3000201@edgar-kalkowski.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 05 Sep 2008 01:05:21 +0200
Edgar Kalkowski <eMail@edgar-kalkowski.de> wrote:

> Dear kernel hackers. ;)
> 
> [1.] One line summary of the problem: If I unplug my USB-Headset the kernel oopses.

cc's added.

Might be USB, might be ALSA.

> [2.] Full description of the problem/report:
> If I unplug the Logitech Headset, the kernel prints the following message to
> /var/log/dmesg.log. I can unload the ehci module by executing "sudo rmmod
> ehci_hcd" but "sudo rmmod uhci_hcd" blocks infinitely and thus I suppose the
> Headset uses USB 1.1. "lsusb" shows the headset as
> 
> Bus 002 Device 004: ID 046d:0a01 Logitech, Inc. USB Headset
> 
> and I have no further information about the brand name or something. If I replug
> the headset or any other usb device it is no longer recognized by the system.
> I'm using a current arch linux install with KDE 4.1.1 on my Samsung R50 laptop.
> The above data (except the oops message) was collected after a reboot with a
> plugged in again and working headset.
> 
> The oops does not occur every time I unplug the headset but so far I have not
> been able to determine how to trigger the oops. I have tried to plug and unplug
> it a few times after a fresh reboot with no programs running but KDE and after
> four or five plugs and unplugs the kernel oopsed.
> 
> I hope this bug report helps you guys a little and this bug get's fixed at some
> time as it's quite annoying. ;)
> 
> [3.] Keywords (i.e., modules, networking, kernel): usb, usbcore, uhci_hcd,
> kernel, module, oops, crash
> 
> [4.] Kernel version (from /proc/version): Linux version 2.6.26-ARCH
> (root@T-POWA-LX) (gcc version 4.3.1 20080724 (prerelease) (GCC) ) #1 SMP PREEMPT
> Tue Aug 26 21:15:43 UTC 2008
> 
> [5.] Output of Oops.. message (if applicable) with symbolic information
>      resolved (see Documentation/oops-tracing.txt)
> 
> usb 3-1: USB disconnect, address 2
> BUG: unable to handle kernel paging request at 00100100
> IP: [<f895f89d>] :snd:snd_ctl_dev_disconnect+0x5d/0x90
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: udf crc_itu_t michael_mic arc4 ecb ieee80211_crypt_tkip ipv6
> radeon drm ntfs sdhci mmc_core pcspkr yenta_socket rsrc_nonstatic serio_raw
> psmouse ohci1394 ieee1394 i2c_i801 i2c_core snd_usb_audio snd_usb_lib
> snd_rawmidi snd_hwdep usb_storage video output intel_agp agpgart sg thermal fan
> button battery ac cpufreq_ondemand acpi_cpufreq freq_table processor
> snd_intel8x0m joydev snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device evdev
> usblp snd_intel8x0 usbhid hid ff_memless snd_ac97_codec snd_pcm_oss snd_pcm
> snd_timer snd_page_alloc snd_mixer_oss snd soundcore ac97_bus ipw2200 ieee80211
> ieee80211_crypt b44 ssb pcmcia pcmcia_core firmware_class mii rtc_cmos rtc_core
> rtc_lib ext3 jbd mbcache sr_mod sd_mod cdrom uhci_hcd ehci_hcd usbcore ata_piix
> ata_generic pata_acpi libata scsi_mod dock
> 
> Pid: 764, comm: khubd Not tainted (2.6.26-ARCH #1)
> EIP: 0060:[<f895f89d>] EFLAGS: 00010282 CPU: 0
> EIP is at snd_ctl_dev_disconnect+0x5d/0x90 [snd]
> EAX: 00000000 EBX: 00100100 ECX: 00020004 EDX: 0000001d
> ESI: f70f0b70 EDI: f70f0a00 EBP: f70f0b4c ESP: f7063e30
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process khubd (pid: 764, ti=f7062000 task=f7bf87e0 task.ti=f7062000)
> Stack: 00000000 f7b6a020 00000000 f70f0a00 f70f0b40 f8961e96 22222222 f7b6a020
>        f8961eea 00000000 f70f0a00 f70f0b8c 00000000 f895e1b8 22222222 f7b5de00
>        f7b5de00 f8b148c0 f7b952c0 f8b03c48 f70f0a00 f7b5de00 f8b148c0 f7b5de1c
> Call Trace:
>  [<f8961e96>] snd_device_disconnect+0x66/0x90 [snd]
>  [<f8961eea>] snd_device_disconnect_all+0x2a/0x50 [snd]
>  [<f895e1b8>] snd_card_disconnect+0x148/0x1a0 [snd]
>  [<f8b03c48>] usb_audio_disconnect+0x58/0x140 [snd_usb_audio]
>  [<f88c1470>] usb_unbind_interface+0x50/0xa0 [usbcore]
>  [<c026a5b5>] __device_release_driver+0x75/0xc0
>  [<c026a6c0>] device_release_driver+0x20/0x40
>  [<c0269c2a>] bus_remove_device+0x8a/0xc0
>  [<c026868f>] device_del+0xef/0x150
>  [<f88be644>] usb_disable_device+0x84/0xf0 [usbcore]
>  [<f88ba180>] usb_disconnect+0xa0/0x140 [usbcore]
>  [<f88bad03>] hub_thread+0x313/0x1170 [usbcore]
>  [<c013f430>] autoremove_wake_function+0x0/0x50
>  [<f88ba9f0>] hub_thread+0x0/0x1170 [usbcore]
>  [<c013f149>] kthread+0x39/0x70
>  [<c013f110>] kthread+0x0/0x70
>  [<c0104c23>] kernel_thread_helper+0x7/0x14
>  =======================
> Code: 18 b9 01 00 00 00 ba 03 00 00 00 c7 04 24 00 00 00 00 e8 c7 30 7c c7 8d 43
> 28 b9 04 0002 00 ba 1d 00 00 00 e8 a5 44 83 c7 8b 1b <8b> 03 0f 18 00 90 39 f3
> 75 c9 89 e8 e8 d2 3c 7e c7 89 fa 31 c0
> EIP: [<f895f89d>] snd_ctl_dev_disconnect+0x5d/0x90 [snd] SS:ESP 0068:f7063e30
> - ---[ end trace 05aa0b5534340422 ]---
> 
> [6.] A small shell script or example program which triggers the
>      problem (if possible)
> 
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
> 
> If some fields are empty or look unusual you may have an old version.
> 
> Compare to the current minimal requirements in Documentation/Changes.
> 
> 
> 
> Linux HEX 2.6.26-ARCH #1 SMP PREEMPT Tue Aug 26 21:15:43 UTC 2008 i686 Intel(R)
> Pentium(R) M processor 1.73GHz GenuineIntel GNU/Linux
> 
> 
> 
> Gnu C                  4.3.1
> 
> Gnu make               3.81
> 
> binutils               2.18.0.20080610
> 
> util-linux             2.14
> 
> mount                  support
> 
> module-init-tools      3.4
> 
> e2fsprogs              1.40.8
> 
> jfsutils               1.1.12
> 
> reiserfsprogs          3.6.20
> 
> xfsprogs               2.9.8
> 
> pcmciautils            014
> 
> PPP                    2.4.4
> 
> Linux C Library        2.8
> 
> Dynamic linker (ldd)   2.8
> 
> Linux C++ Library      so.6.0
> 
> Procps                 3.2.7
> 
> Net-tools              1.60
> 
> Kbd                    1.13
> 
> Sh-utils               6.12
> 
> udev                   119
> 
> wireless-tools         29
> 
> Modules Loaded         michael_mic arc4 ecb ieee80211_crypt_tkip
> cpufreq_ondemand snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep ipv6 radeon drm
> ntfs joydev pcspkr serio_raw psmouse i2c_i801 i2c_core usblp sdhci ohci1394
> mmc_core ieee1394 yenta_socket rsrc_nonstatic usb_storage usbhid hid ff_memless
> video output intel_agp agpgart sg thermal evdev fan button battery ac
> acpi_cpufreq freq_table processor snd_intel8x0m snd_intel8x0 snd_ac97_codec
> snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_pcm
> snd_timer snd_page_alloc snd_mixer_oss snd soundcore ac97_bus ipw2200 ieee80211
> ieee80211_crypt b44 ssb pcmcia pcmcia_core firmware_class mii rtc_cmos rtc_core
> rtc_lib ext3 jbd mbcache sr_mod cdrom sd_mod ehci_hcd uhci_hcd usbcore ata_piix
> ata_generic pata_acpi libata scsi_mod dock
> 
> [7.2.] Processor information (from /proc/cpuinfo):
> 
> processor       : 0
> 
> vendor_id       : GenuineIntel
> 
> cpu family      : 6
> model           : 13
> model name      : Intel(R) Pentium(R) M processor 1.73GHz
> stepping        : 8
> cpu MHz         : 1733.000
> cache size      : 2048 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 2
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
> pat clflush dts acpi mmx fxsr sse sse2 ss tm pbe bts est tm2
> bogomips        : 3462.30
> clflush size    : 64
> power management:
> 
> [7.3.] Module information (from /proc/modules):
> 
> michael_mic 4224 4 - Live 0xf8c4d000
> arc4 3712 4 - Live 0xf8849000
> ecb 4608 4 - Live 0xf8b65000
> ieee80211_crypt_tkip 10752 2 - Live 0xf8c49000
> cpufreq_ondemand 8716 1 - Live 0xf8c3c000
> snd_usb_audio 81152 1 - Live 0xf94a0000
> snd_usb_lib 17024 1 snd_usb_audio, Live 0xf8c50000
> snd_rawmidi 21504 1 snd_usb_lib, Live 0xf8b16000
> snd_hwdep 8964 1 snd_usb_audio, Live 0xf8b39000
> ipv6 259684 63 - Live 0xf94d2000
> radeon 137248 2 - Live 0xf8c60000
> drm 73896 3 radeon, Live 0xf8b51000
> ntfs 221664 1 - Live 0xf8b6a000
> joydev 11584 0 - Live 0xf8b04000
> pcspkr 4352 0 - Live 0xf8b01000
> serio_raw 7044 0 - Live 0xf8acc000
> psmouse 38288 0 - Live 0xf8b1d000
> i2c_i801 10384 0 - Live 0xf8a93000
> i2c_core 21140 1 i2c_i801, Live 0xf8b09000
> usblp 13824 0 - Live 0xf8af0000
> sdhci 16388 0 - Live 0xf8a8d000
> ohci1394 30128 0 - Live 0xf8ae7000
> mmc_core 43036 1 sdhci, Live 0xf8af5000
> ieee1394 80696 1 ohci1394, Live 0xf8ab7000
> yenta_socket 24972 1 - Live 0xf8aaf000
> rsrc_nonstatic 12800 1 yenta_socket, Live 0xf8a88000
> usb_storage 90560 1 - Live 0xf8acf000
> usbhid 46016 0 - Live 0xf8aa2000
> hid 40960 1 usbhid, Live 0xf8a97000
> ff_memless 6664 1 usbhid, Live 0xf8a2b000
> video 18064 0 - Live 0xf8a82000
> output 4608 1 video, Live 0xf8a51000
> intel_agp 26428 0 - Live 0xf8a67000
> agpgart 29652 2 drm,intel_agp, Live 0xf8a79000
> sg 28596 0 - Live 0xf8a71000
> thermal 16796 0 - Live 0xf8a61000
> evdev 10880 10 - Live 0xf8a56000
> fan 6020 0 - Live 0xf8a2e000
> button 7824 0 - Live 0xf8a1c000
> battery 12036 0 - Live 0xf8a4d000
> ac 6020 0 - Live 0xf8a22000
> acpi_cpufreq 9228 0 - Live 0xf8a27000
> freq_table 5568 2 cpufreq_ondemand,acpi_cpufreq, Live 0xf8a1f000
> processor 33836 3 thermal,acpi_cpufreq, Live 0xf89a6000
> snd_intel8x0m 15500 0 - Live 0xf89cf000
> snd_intel8x0 30748 1 - Live 0xf8a13000
> snd_ac97_codec 99748 2 snd_intel8x0m,snd_intel8x0, Live 0xf8a33000
> snd_seq_oss 31872 0 - Live 0xf89b1000
> snd_seq_midi_event 8192 1 snd_seq_oss, Live 0xf897d000
> snd_seq 49968 4 snd_seq_oss,snd_seq_midi_event, Live 0xf8a05000
> snd_seq_device 8332 3 snd_rawmidi,snd_seq_oss,snd_seq, Live 0xf8979000
> snd_pcm_oss 40192 0 - Live 0xf895b000
> snd_pcm 69636 5
> snd_usb_audio,snd_intel8x0m,snd_intel8x0,snd_ac97_codec,snd_pcm_oss, Live
> 0xf89bc000
> 
> snd_timer 21384 2 snd_seq,snd_pcm, Live 0xf8947000
> 
> snd_page_alloc 9608 3 snd_intel8x0m,snd_intel8x0,snd_pcm, Live 0xf8957000
> 
> snd_mixer_oss 16512 1 snd_pcm_oss, Live 0xf8916000
> 
> snd 50724 17
> snd_usb_audio,snd_rawmidi,snd_hwdep,snd_intel8x0m,snd_intel8x0,snd_ac97_codec,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss,
> Live 0xf8967000
> soundcore 8032 1 snd, Live 0xf8944000
> 
> ac97_bus 3584 1 snd_ac97_codec, Live 0xf8822000
> 
> ipw2200 142408 0 - Live 0xf8982000
> 
> ieee80211 31176 1 ipw2200, Live 0xf894e000
> 
> ieee80211_crypt 6532 2 ieee80211_crypt_tkip,ieee80211, Live 0xf88e4000
> 
> b44 26512 0 - Live 0xf893c000
> 
> ssb 39684 1 b44, Live 0xf88f6000
> 
> pcmcia 34476 1 ssb, Live 0xf890c000
> 
> pcmcia_core 34708 4 yenta_socket,rsrc_nonstatic,ssb,pcmcia, Live 0xf8902000
> 
> firmware_class 9088 2 ipw2200,pcmcia, Live 0xf88dc000
> 
> mii 6528 1 b44, Live 0xf88d9000
> rtc_cmos 11424 0 - Live 0xf888c000
> rtc_core 17436 1 rtc_cmos, Live 0xf887c000
> rtc_lib 4480 1 rtc_core, Live 0xf8846000
> ext3 125704 3 - Live 0xf891c000
> jbd 45716 1 ext3, Live 0xf88e9000
> mbcache 8708 1 ext3, Live 0xf8842000
> sr_mod 16836 0 - Live 0xf8876000
> cdrom 36128 1 sr_mod, Live 0xf8882000
> sd_mod 25240 7 - Live 0xf886e000
> ehci_hcd 35596 0 - Live 0xf8864000
> uhci_hcd 23952 0 - Live 0xf8831000
> usbcore 132080 8
> snd_usb_audio,snd_usb_lib,usblp,usb_storage,usbhid,ehci_hcd,uhci_hcd, Live
> 0xf88b7000
> ata_piix 17924 4 - Live 0xf8839000
> ata_generic 6788 0 - Live 0xf882e000
> pata_acpi 6016 0 - Live 0xf882b000
> libata 150048 3 ata_piix,ata_generic,pata_acpi, Live 0xf8891000
> scsi_mod 95692 5 usb_storage,sg,sr_mod,sd_mod,libata, Live 0xf884b000
> dock 9488 1 libata, Live 0xf8827000
> 
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
> 
> $ cat /proc/ioports
> 
> 0000-001f : dma1
> 
> 0020-0021 : pic1
> 
> 0040-0043 : timer0
> 
> 0050-0053 : timer1
> 
> 0060-0060 : keyboard
> 
> 0064-0064 : keyboard
> 
> 0070-0077 : rtc0
> 
> 0080-008f : dma page reg
> 
> 00a0-00a1 : pic2
> 
> 00c0-00df : dma2
> 
> 00f0-00ff : fpu
> 
> 0170-0177 : 0000:00:1f.1
> 
>   0170-0177 : ata_piix
> 
> 01f0-01f7 : 0000:00:1f.1
> 
>   01f0-01f7 : ata_piix
> 
> 0376-0376 : 0000:00:1f.1
> 
>   0376-0376 : ata_piix
> 
> 03c0-03df : vga+
> 
> 03f6-03f6 : 0000:00:1f.1
> 
>   03f6-03f6 : ata_piix
> 
> 0680-06ff : pnp 00:06
> 
> 0800-080f : pnp 00:06
> 
> 0900-090f : pnp 00:06
> 
> 0cf8-0cff : PCI conf1
> 
> 1000-107f : 0000:00:1f.0
> 
>   1000-107f : pnp 00:06
> 
>     1000-1003 : ACPI PM1a_EVT_BLK
> 
>     1004-1005 : ACPI PM1a_CNT_BLK
> 
>     1008-100b : ACPI PM_TMR
> 
>     1010-1015 : ACPI CPU throttle
> 
>     1020-1020 : ACPI PM2_CNT_BLK
> 
>     1028-102f : ACPI GPE0_BLK
> 
> 1180-11bf : 0000:00:1f.0
> 
>   1180-11bf : pnp 00:06
> 
> 1640-164f : pnp 00:06
> 
> 1800-181f : 0000:00:1d.0
> 
>   1800-181f : uhci_hcd
> 
> 1820-183f : 0000:00:1d.1
> 
>   1820-183f : uhci_hcd
> 
> 1840-185f : 0000:00:1d.2
> 
>   1840-185f : uhci_hcd
> 
> 1860-187f : 0000:00:1d.3
>   1860-187f : uhci_hcd
> 1880-18bf : 0000:00:1e.2
>   1880-18bf : Intel ICH6
> 18c0-18cf : 0000:00:1f.1
>   18c0-18cf : ata_piix
> 18e0-18ff : 0000:00:1f.3
>   18e0-18ff : i801_smbus
> 1c00-1cff : 0000:00:1e.2
>   1c00-1cff : Intel ICH6
> 2000-207f : 0000:00:1e.3
>   2000-207f : Intel ICH6 Modem
> 2400-24ff : 0000:00:1e.3
>   2400-24ff : Intel ICH6 Modem
> 3000-3fff : PCI Bus 0000:01
>   3000-30ff : 0000:01:00.0
> 4000-4fff : PCI Bus 0000:02
> 5000-5fff : PCI Bus 0000:06
>   5000-50ff : PCI CardBus 0000:07
>   5400-54ff : PCI CardBus 0000:07
> 
> $ cat /proc/iomem
> 
> 00000000-0009f7ff : System RAM
> 0009f800-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000ce1ff : Video ROM
> 000d0000-000d3fff : Adapter ROM
> 000d4000-000d4fff : Adapter ROM
> 000f0000-000fffff : System ROM
> 00100000-3fe9ffff : System RAM
>   00100000-0031211d : Kernel code
>   0031211e-003cc37f : Kernel data
>   00415000-004e527f : Kernel bss
> 3fea0000-3feb0fff : ACPI Tables
> 3feb1000-3fefffff : ACPI Non-volatile Storage
> 3ff00000-3fffffff : reserved
> 50000000-53ffffff : PCI CardBus 0000:07
> 54000000-543fffff : PCI CardBus 0000:07
> c0000000-c00003ff : 0000:00:1d.7
>   c0000000-c00003ff : ehci_hcd
> c0000400-c00004ff : 0000:00:1e.2
>   c0000400-c00004ff : Intel ICH6
> c0000800-c00009ff : 0000:00:1e.2
>   c0000800-c00009ff : Intel ICH6
> c0100000-c01fffff : PCI Bus 0000:01
>   c0100000-c010ffff : 0000:01:00.0
>   c0120000-c013ffff : 0000:01:00.0
> c4000000-c7ffffff : PCI Bus 0000:02
> c8000000-c80fffff : PCI Bus 0000:06
>   c8000000-c8000fff : 0000:06:07.0
>     c8000000-c8000fff : ipw2200
>   c8001000-c80017ff : 0000:06:09.1
>     c8001000-c80017ff : ohci1394
>   c8001800-c80018ff : 0000:06:09.2
>     c8001800-c80018ff : mmc0
>   c8001c00-c8001cff : 0000:06:09.3
>   c8002000-c80020ff : 0000:06:09.4
>   c8003000-c8003fff : 0000:06:09.0
>     c8003000-c8003fff : yenta_socket
>   c8004000-c8005fff : 0000:06:05.0
>     c8004000-c8005fff : 0000:06:05.0
> d0000000-d7ffffff : PCI Bus 0000:01
>   d0000000-d7ffffff : 0000:01:00.0
> d8000000-dbffffff : PCI Bus 0000:02
> e0000000-f0005fff : reserved
>   e0000000-efffffff : PCI MMCONFIG 0
> f0008000-f000bfff : reserved
> fed00000-fed003ff : HPET 0
>   fed00000-fed003ff : reserved
> fed20000-fed8ffff : reserved
> ff000000-ffffffff : reserved
> 
> [7.5.] PCI information ('lspci -vvv' as root)
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express
> Processor to DRAM Controller (rev 03)
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Capabilities: [e0] Vendor Specific Information <?>
> 
>         Kernel modules: intel-agp
> 
> 
> 00:01.0 PCI bridge: Intel Corporation Mobile 915GM/PM Express PCI Express Root
> Port (rev 03) (prog-if 00 [Normal decode])
> 
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0, Cache Line Size: 32 bytes
> 
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
> 
>         I/O behind bridge: 00003000-00003fff
> 
>         Memory behind bridge: c0100000-c01fffff
> 
>         Prefetchable memory behind bridge: d0000000-d7ffffff
> 
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ <SERR- <PERR-
> 
>         BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
> 
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 
>         Capabilities: [88] Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Capabilities: [80] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
>         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000
> 
>         Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
> 
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1
> <1us
>                         ExtTag- RBE- FLReset-
> 
>                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
> Unsupported+
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
> 
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> TransPend-
>                 LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency
> L0 <256ns, L1 <4us
> 
>                         ClockPM- Suprise- LLActRep- BwNot-
> 
>                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 
>                 LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
> 
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
> Surpise-
>                         Slot #  1, PowerLimit 75.000000; Interlock- NoCompl-
> 
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
> LinkChg-
>                         Control: AttnInd Off, PwrInd On, Power- Interlock-
> 
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
> Interlock-
>                         Changed: MRL- PresDet+ LinkState-
> 
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                 RootCap: CRSVisible-
> 
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> 
>         Capabilities: [100] Virtual Channel <?>
> 
>         Capabilities: [140] Root Complex Link <?>
> 
>         Kernel driver in use: pcieport-driver
> 
>         Kernel modules: shpchp
> 
> 
> 00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI
> Express Port 1 (rev 03) (prog-if 00 [Normal decode])
> 
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0, Cache Line Size: 32 bytes
> 
>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> 
>         I/O behind bridge: 00004000-00004fff
> 
>         Memory behind bridge: c4000000-c7ffffff
> 
>         Prefetchable memory behind bridge: 00000000d8000000-00000000dbffffff
> 
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- <SERR- <PERR-
> 
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 
>         Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
> 
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
> unlimited, L1 unlimited
> 
>                         ExtTag+ RBE- FLReset-
> 
>                 DevCtl: Report errors: Correctable+ Non-Fatal+ Fatal+
> Unsupported+
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
> 
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> TransPend-
>                 LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency
> L0 <1us, L1 <4us
> 
>                         ClockPM- Suprise- LLActRep- BwNot-
> 
>                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
> 
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 
>                 LnkSta: Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
> 
>                 SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+
> Surpise+
>                         Slot #  2, PowerLimit 6.500000; Interlock- NoCompl-
> 
>                 SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
> LinkChg-
>                         Control: AttnInd Unknown, PwrInd Unknown, Power-
> Interlock-
>                 SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
> Interlock-
>                         Changed: MRL- PresDet- LinkState-
> 
>                 RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> CRSVisible-
>                 RootCap: CRSVisible-
> 
>                 RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> 
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
> Enable-
>                 Address: 00000000  Data: 0000
> 
>         Capabilities: [90] Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Capabilities: [a0] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
>         Capabilities: [100] Virtual Channel <?>
> 
>         Capabilities: [180] Root Complex Link <?>
> 
>         Kernel driver in use: pcieport-driver
> 
>         Kernel modules: shpchp
> 
> 
> 00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> USB UHCI #1 (rev 03) (prog-if 00 [UHCI])
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Interrupt: pin A routed to IRQ 23
> 
>         Region 4: I/O ports at 1800 [size=32]
> 
>         Kernel driver in use: uhci_hcd
> 
>         Kernel modules: uhci-hcd
> 
> 
> 00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> USB UHCI #2 (rev 03) (prog-if 00 [UHCI])
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Interrupt: pin B routed to IRQ 19
> 
>         Region 4: I/O ports at 1820 [size=32]
> 
>         Kernel driver in use: uhci_hcd
> 
>         Kernel modules: uhci-hcd
> 
> 
> 00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> USB UHCI #3 (rev 03) (prog-if 00 [UHCI])
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Interrupt: pin C routed to IRQ 18
> 
>         Region 4: I/O ports at 1840 [size=32]
> 
>         Kernel driver in use: uhci_hcd
> 
>         Kernel modules: uhci-hcd
> 
> 
> 00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> USB UHCI #4 (rev 03) (prog-if 00 [UHCI])
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Interrupt: pin D routed to IRQ 16
> 
>         Region 4: I/O ports at 1860 [size=32]
> 
>         Kernel driver in use: uhci_hcd
> 
>         Kernel modules: uhci-hcd
> 
> 
> 00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
> USB2 EHCI Controller (rev 03) (prog-if 20 [EHCI])
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Interrupt: pin A routed to IRQ 23
> 
>         Region 0: Memory at c0000000 (32-bit, non-prefetchable) [size=1K]
> 
>         Capabilities: [50] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
> 
>         Kernel driver in use: ehci_hcd
> 
>         Kernel modules: ehci-hcd
> 
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3) (prog-if
> 01 [Subtractive decode])
> 
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Bus: primary=00, secondary=06, subordinate=0a, sec-latency=32
> 
>         I/O behind bridge: 00005000-00005fff
> 
>         Memory behind bridge: c8000000-c80fffff
> 
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> 
>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> 
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 
>         Capabilities: [50] Subsystem: Gammagraphx, Inc. Device 0000
> 
> 
> 00:1e.2 Multimedia audio controller: Intel Corporation 82801FB/FBM/FR/FW/FRW
> (ICH6 Family) AC'97 Audio Controller (rev 03)
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Interrupt: pin A routed to IRQ 17
> 
>         Region 0: I/O ports at 1c00 [size=256]
> 
>         Region 1: I/O ports at 1880 [size=64]
> 
>         Region 2: Memory at c0000800 (32-bit, non-prefetchable) [size=512]
> 
>         Region 3: Memory at c0000400 (32-bit, non-prefetchable) [size=256]
> 
>         Capabilities: [50] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
>         Kernel driver in use: Intel ICH
> 
>         Kernel modules: snd-intel8x0
> 
> 
> 00:1e.3 Modem: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Modem
> Controller (rev 03) (prog-if 00 [Generic])
> 
>         Subsystem: Samsung Electronics Co Ltd Device 2115
> 
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Interrupt: pin B routed to IRQ 20
> 
>         Region 0: I/O ports at 2400 [size=256]
> 
>         Region 1: I/O ports at 2000 [size=128]
> 
>         Capabilities: [50] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
>         Kernel driver in use: Intel ICH Modem
> 
>         Kernel modules: snd-intel8x0m
> 
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge (rev 03)
>         Subsystem: Samsung Electronics Co Ltd Device b035
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Kernel modules: intel-rng
> 
> 
> 00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) IDE
> Controller (rev 03) (prog-if 8a [Master SecP PriP])
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0
> 
>         Interrupt: pin A routed to IRQ 18
> 
>         Region 0: I/O ports at 01f0 [size=8]
> 
>         Region 1: I/O ports at 03f4 [size=1]
> 
>         Region 2: I/O ports at 0170 [size=8]
> 
>         Region 3: I/O ports at 0374 [size=1]
> 
>         Region 4: I/O ports at 18c0 [size=16]
> 
>         Kernel driver in use: ata_piix
> 
>         Kernel modules: ata_piix, piix
> 
> 
> 00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus
> Controller (rev 03)
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Interrupt: pin B routed to IRQ 19
> 
>         Region 4: I/O ports at 18e0 [size=32]
> 
>         Kernel driver in use: i801_smbus
> 
>         Kernel modules: i2c-i801
> 
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility X700
> (PCIE) (prog-if 00 [VGA controller])
> 
>         Subsystem: Samsung Electronics Co Ltd Device e003
> 
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 0, Cache Line Size: 32 bytes
> 
>         Interrupt: pin A routed to IRQ 16
> 
>         Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
> 
>         Region 1: I/O ports at 3000 [size=256]
> 
>         Region 2: Memory at c0100000 (32-bit, non-prefetchable) [size=64K]
> 
>         [virtual] Expansion ROM at c0120000 [disabled] [size=128K]
> 
>         Capabilities: [50] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
>         Capabilities: [58] Express (v1) Endpoint, MSI 00
> 
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <256ns,
> L1 <4us
>                         ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
> 
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> Unsupported-
>                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> 
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
> 
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> TransPend-
>                 LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency
> L0 <256ns, L1 <2us
> 
>                         ClockPM- Suprise- LLActRep- BwNot-
> 
>                 LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
> CommClk+
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 
>                 LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
> DLActive- BWMgmt- ABWMgmt-
> 
>         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
> Enable-
>                 Address: 0000000000000000  Data: 0000
> 
>         Capabilities: [100] Advanced Error Reporting <?>
> 
> 
> 06:05.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
>         Subsystem: Samsung Electronics Co Ltd Device b035
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 32
> 
>         Interrupt: pin A routed to IRQ 22
> 
>         Region 0: Memory at c8004000 (32-bit, non-prefetchable) [size=8K]
> 
>         Capabilities: [40] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-
> 
>         Kernel driver in use: b44
> 
>         Kernel modules: b44
> 
> 
> 06:07.0 Network controller: Intel Corporation PRO/Wireless 2200BG Network
> Connection (rev 05)
>         Subsystem: Intel Corporation Samsung P35 integrated WLAN
> 
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 32 (750ns min, 6000ns max), Cache Line Size: 32 bytes
> 
>         Interrupt: pin A routed to IRQ 20
> 
>         Region 0: Memory at c8000000 (32-bit, non-prefetchable) [size=4K]
> 
>         Capabilities: [dc] Power Management version 2
> 
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 
>         Kernel driver in use: ipw2200
> 
>         Kernel modules: ipw2200
> 
> 
> 06:09.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
>         Subsystem: Samsung Electronics Co Ltd Device b035
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 168
> 
>         Interrupt: pin A routed to IRQ 16
> 
>         Region 0: Memory at c8003000 (32-bit, non-prefetchable) [size=4K]
> 
>         Bus: primary=06, secondary=07, subordinate=0a, sec-latency=176
> 
>         Memory window 0: 54000000-543ff000 (prefetchable)
> 
>         Memory window 1: 50000000-53fff000
> 
>         I/O window 0: 00005000-000050ff
> 
>         I/O window 1: 00005400-000054ff
> 
>         BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
> 
>         16-bit legacy interface ports at 0001
> 
>         Kernel driver in use: yenta_cardbus
> 
>         Kernel modules: yenta_socket
> 
> 
> 06:09.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 08)
> (prog-if 10 [OHCI])
> 
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 64 (500ns min, 1000ns max)
> 
>         Interrupt: pin B routed to IRQ 17
> 
>         Region 0: Memory at c8001000 (32-bit, non-prefetchable) [size=2K]
> 
>         Capabilities: [dc] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=2 PME+
> 
>         Kernel driver in use: ohci1394
> 
>         Kernel modules: ohci1394
> 
> 
> 06:09.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host
> Adapter (rev 17)
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
>         Latency: 32
> 
>         Interrupt: pin C routed to IRQ 18
> 
>         Region 0: Memory at c8001800 (32-bit, non-prefetchable) [size=256]
> 
>         Capabilities: [80] Power Management version 2
> 
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-
> 
>         Kernel driver in use: sdhci
> 
>         Kernel modules: sdhci
> 
> 
> 06:09.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter
> (rev 08)
>         Subsystem: Samsung Electronics Co Ltd Device b035
> 
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin C routed to IRQ 255
>         Region 0: Memory at c8001c00 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-
> 
> 06:09.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 03)
>         Subsystem: Samsung Electronics Co Ltd Device b035
>         Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Interrupt: pin C routed to IRQ 255
>         Region 0: Memory at c8002000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=2 PME-
> 
> [7.6.] SCSI information (from /proc/scsi/scsi)
> 
> Attached devices:
> Host: scsi0 Channel: 00 Id: 00 Lun: 00
>   Vendor: ATA      Model: SAMSUNG HM120JC  Rev: YL10
>   Type:   Direct-Access                    ANSI  SCSI revision: 05
> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>   Vendor: TEAC     Model: DV-W28EA         Rev: S.0A
>   Type:   CD-ROM                           ANSI  SCSI revision: 05
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>   Vendor: WDC WD25 Model: 00BB-00GUC0      Rev: 0811
>   Type:   Direct-Access                    ANSI  SCSI revision: 00
> Host: scsi3 Channel: 00 Id: 00 Lun: 00
>   Vendor: HDT72252 Model: 5DLAT80          Rev: V44O
>   Type:   Direct-Access                    ANSI  SCSI revision: 00
> 
> [7.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):
> 
> I hope this helps you fix my problem. :)
> 

