Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZGaQCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZGaQCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 12:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZGaQCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 12:02:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbZGaQCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 12:02:31 -0400
Date: Fri, 31 Jul 2009 09:01:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Paris <eparis@redhat.com>,
       Christoph Thielecke <christoph.thielecke@gmx.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel bug
In-Reply-To: <200907311139.55095.christoph.thielecke@gmx.de>
Message-ID: <alpine.LFD.2.01.0907310853270.3161@localhost.localdomain>
References: <200907311139.55095.christoph.thielecke@gmx.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm. We have some fsnotify fixes since -rc4 (and I'm planning on doing 
-rc5 today), so it's worth checking if this problem is perhaps already ok.

But looking at the fixes, I don't think any of them affect this particular 
BUG_ON, though, so I'm adding Eric to the email participants list, and 
lkml to keep it archived and google-ready.

This seems to also be

	http://bugzilla.kernel.org/show_bug.cgi?id=13729
	http://lkml.org/lkml/2009/7/4/12

with only slight variations.

		Linus

On Fri, 31 Jul 2009, Christoph Thielecke wrote:
>
> Hello Linus,
> 
> today my machine stops rapidly (running 2.6.31-rc4). After revisited the log I 
> found 2 kernel bug entries which maybe could useful:
> 
> Jul 31 11:23:05 develop kernel: ------------[ cut here ]------------
> Jul 31 11:23:05 develop kernel: kernel BUG at fs/notify/notification.c:93!
> Jul 31 11:23:05 develop kernel: invalid opcode: 0000 [#1] PREEMPT SMP
> Jul 31 11:23:05 develop kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4.1/product
> Jul 31 11:23:05 develop kernel: Modules linked in: b44 nvidia(P) binfmt_misc ppdev parport_pc lp parport rfcomm l2cap bluetooth tun vboxnetadp vboxnetflt vboxdrv pppol2tp pppox ppp_generic slhc ipv6 capifs acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_stats freq_table cpufreq_userspace cpufreq_conservative nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish cast5 des_generic cbc aes_i586 aes_generic xcbc rmd160 sha256_generic sha1_generic crypto_null af_key nls_iso8859_1 nls_cp437 vfat fat fuse loop asix pl2303 dm9601 usbnet usbserial usbhid hid snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi firewire_ohci firewire_core arc4 snd_seq_midi_event snd_seq crc_itu_t ecb snd_timer snd_seq_device ssb ohci1394 iwl3945 sdhci_pci sdhci iTCO_wdt iTCO_vendor_support snd pcmcia pcmcia_core iwlcore mmc_core uhci_hc!
 d joydev intel_agp i2c_i801 soundcore ieee1394 mii ehci_hcd mac80211 led_class ricoh_mmc agpgart i2c_core snd_page_alloc cfg80211 usbcore psmouse rtc_cmos rtc_core rtc_lib video output serio_raw wmi dell_laptop button battery ac processor rfkill evdev dcdbas sg sr_mod cdrom dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal fan sd_mod crc_t10dif [last unloaded: b44]
> Jul 31 11:23:05 develop kernel:
> Jul 31 11:23:05 develop kernel: Pid: 8207, comm: kdevelop Tainted: P           (2.6.31-rc4 #2) MP061
> Jul 31 11:23:05 develop kernel: EIP: 0060:[<c10db67b>] EFLAGS: 00210283 CPU: 0
> Jul 31 11:23:05 develop kernel: EIP is at fsnotify_put_event+0x46/0x4a
> Jul 31 11:23:05 develop kernel: EAX: f6865d04 EBX: f6865cd0 ECX: 00000000 EDX: bffd8f01
> Jul 31 11:23:05 develop kernel: ESI: bffd8f72 EDI: f6865cd0 EBP: f15abf0c ESP: f15abf08
> Jul 31 11:23:05 develop kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Jul 31 11:23:05 develop kernel: Process kdevelop (pid: 8207, ti=f15aa000 task=f1571130 task.ti=f15aa000)
> Jul 31 11:23:05 develop kernel: Stack:
> Jul 31 11:23:05 develop kernel: 00000020 f15abf64 c10dd775 000000b0 bffd8f14 f46488c0 f1fcc174 f1fcc158
> Jul 31 11:23:05 develop kernel: <0> f1fcc140 bffd8f54 0000000e 00000000 f1571130 c104699f f1fcc178 f1fcc178
> Jul 31 11:23:05 develop kernel: <0> 00000152 00000002 00000000 00000010 f46488c0 bffd8f14 000000f0 f15abf8c
> Jul 31 11:23:05 develop kernel: Call Trace:
> Jul 31 11:23:05 develop kernel: [<c10dd775>] ? inotify_read+0x24a/0x269
> Jul 31 11:23:05 develop kernel: [<c104699f>] ? autoremove_wake_function+0x0/0x3a
> Jul 31 11:23:05 develop kernel: [<c10b3206>] ? vfs_read+0x8b/0x142
> Jul 31 11:23:05 develop kernel: [<c10dd52b>] ? inotify_read+0x0/0x269
> Jul 31 11:23:05 develop kernel: [<c10b3366>] ? sys_read+0x3d/0x6b
> Jul 31 11:23:05 develop kernel: [<c1003610>] ? sysenter_do_call+0x12/0x2c
> Jul 31 11:23:05 develop kernel: Code: 74 1f 8d 43 34 39 43 34 75 21 8b 43 2c e8 ba fe fc ff 89 da a1 c4 23 54 c1 e8 79 ff fc ff 5b 5d c3 8d 43 14 e8 b3 e6 fd ff eb d7 <0f> 0b eb fe 55 89 e5 57 56 53 83 ec 0c 89 c6 8d 40 18 89 45 e8
> Jul 31 11:23:05 develop kernel: EIP: [<c10db67b>] fsnotify_put_event+0x46/0x4a SS:ESP 0068:f15abf08
> Jul 31 11:23:05 develop kernel: ---[ end trace 1290e7d176f2655e ]---
> 
> Jul 31 11:23:17 develop kernel: ------------[ cut here ]------------
> Jul 31 11:23:17 develop kernel: kernel BUG at fs/notify/notification.c:93!
> Jul 31 11:23:17 develop kernel: invalid opcode: 0000 [#2] PREEMPT SMP
> Jul 31 11:23:17 develop kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1d.7/usb1/1-4/1-4.1/product
> Jul 31 11:23:17 develop kernel: Modules linked in: b44 nvidia(P) binfmt_misc ppdev parport_pc lp parport rfcomm l2cap bluetooth tun vboxnetadp vboxnetflt vboxdrv pppol2tp pppox ppp_generic slhc ipv6 capifs acpi_cpufreq cpufreq_ondemand cpufreq_powersave cpufreq_stats freq_table cpufreq_userspace cpufreq_conservative nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc deflate zlib_deflate ctr twofish twofish_common camellia serpent blowfish cast5 des_generic cbc aes_i586 aes_generic xcbc rmd160 sha256_generic sha1_generic crypto_null af_key nls_iso8859_1 nls_cp437 vfat fat fuse loop asix pl2303 dm9601 usbnet usbserial usbhid hid snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi firewire_ohci firewire_core arc4 snd_seq_midi_event snd_seq crc_itu_t ecb snd_timer snd_seq_device ssb ohci1394 iwl3945 sdhci_pci sdhci iTCO_wdt iTCO_vendor_support snd pcmcia pcmcia_core iwlcore mmc_core uhci_hc!
 d joydev intel_agp i2c_i801 soundcore ieee1394 mii ehci_hcd mac80211 led_class ricoh_mmc agpgart i2c_core snd_page_alloc cfg80211 usbcore psmouse rtc_cmos rtc_core rtc_lib video output serio_raw wmi dell_laptop button battery ac processor rfkill evdev dcdbas sg sr_mod cdrom dm_mirror dm_region_hash dm_log dm_snapshot dm_mod thermal fan sd_mod crc_t10dif [last unloaded: b44]
> Jul 31 11:23:17 develop kernel:
> Jul 31 11:23:17 develop kernel: Pid: 2462, comm: firefox-bin Tainted: P      D    (2.6.31-rc4 #2) MP061
> Jul 31 11:23:17 develop kernel: EIP: 0060:[<c10db67b>] EFLAGS: 00010283 CPU: 0
> Jul 31 11:23:17 develop kernel: EIP is at fsnotify_put_event+0x46/0x4a
> Jul 31 11:23:17 develop kernel: EAX: f68656b0 EBX: f686567c ECX: 00000000 EDX: 092aa801
> Jul 31 11:23:17 develop kernel: ESI: 092aa818 EDI: f686567c EBP: f3f23f0c ESP: f3f23f08
> Jul 31 11:23:17 develop kernel: DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Jul 31 11:23:17 develop kernel: Process firefox-bin (pid: 2462, ti=f3f22000 task=f06c8b90 task.ti=f3f22000)
> Jul 31 11:23:17 develop kernel: Stack:
> Jul 31 11:23:17 develop kernel: 00000030 f3f23f64 c10dd775 00000400 092aa7f0 f1662c40 f29cfef4 f29cfed8
> Jul 31 11:23:17 develop kernel: <0> f29cfec0 092aa7f0 00000018 00000000 f06c8b90 c104699f f29cfef8 f29cfef8
> Jul 31 11:23:17 develop kernel: <0> 00000002 00000100 00000000 00000020 f1662c40 092aa7f0 00000400 f3f23f8c
> Jul 31 11:23:17 develop kernel: Call Trace:
> Jul 31 11:23:17 develop kernel: [<c10dd775>] ? inotify_read+0x24a/0x269
> Jul 31 11:23:17 develop kernel: [<c104699f>] ? autoremove_wake_function+0x0/0x3a
> Jul 31 11:23:17 develop kernel: [<c10b3206>] ? vfs_read+0x8b/0x142
> Jul 31 11:23:17 develop kernel: [<c10dd52b>] ? inotify_read+0x0/0x269
> Jul 31 11:23:17 develop kernel: [<c10b3366>] ? sys_read+0x3d/0x6b
> Jul 31 11:23:17 develop kernel: [<c1003610>] ? sysenter_do_call+0x12/0x2c
> Jul 31 11:23:17 develop kernel: Code: 74 1f 8d 43 34 39 43 34 75 21 8b 43 2c e8 ba fe fc ff 89 da a1 c4 23 54 c1 e8 79 ff fc ff 5b 5d c3 8d 43 14 e8 b3 e6 fd ff eb d7 <0f> 0b eb fe 55 89 e5 57 56 53 83 ec 0c 89 c6 8d 40 18 89 45 e8
> Jul 31 11:23:17 develop kernel: EIP: [<c10db67b>] fsnotify_put_event+0x46/0x4a SS:ESP 0068:f3f23f08
> Jul 31 11:23:17 develop kernel: ---[ end trace 1290e7d176f2655f ]---
> 
> crissi@develop:~$ uname -a
> Linux develop 2.6.31-rc4 #2 SMP PREEMPT Mon Jul 27 11:47:00 CEST 2009 i686 
> GNU/Linux
> 
> crissi@develop:~$ cat /proc/cpuinfo
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 14
> model name      : Intel(R) Pentium(R) M CPU        000  @ 2.00GHz
> stepping        : 4
> cpu MHz         : 2000.000
> cache size      : 2048 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> apicid          : 0
> initial apicid  : 0
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr pdcm
> bogomips        : 3990.57
> clflush size    : 64
> power management:
> 
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 14
> model name      : Intel(R) Pentium(R) M CPU        000  @ 2.00GHz
> stepping        : 4
> cpu MHz         : 2000.000
> cache size      : 2048 KB
> physical id     : 0
> siblings        : 2
> core id         : 1
> cpu cores       : 2
> apicid          : 1
> initial apicid  : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 10
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr pdcm
> bogomips        : 3990.06
> clflush size    : 64
> power management:
> 
> 
> Its a debian lenny machine with self compiled kernel from kernel.org.
> 
> 
> Best regards
> -- 
> Linux User Group Wernigerode
> http://www.lug-wr.de/
> 
