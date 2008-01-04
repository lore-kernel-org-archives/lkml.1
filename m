Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbYADRjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbYADRjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 12:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYADRjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 12:39:09 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:20459 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYADRjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 12:39:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=MChCxtscDXpbW8lIv/aucwpp3o43RhkFl9ABIVP7uPUf5gdsOCG6TDkHM9ZXaetpXM6YlsJiDDLBmQlT3UzNND9AU9EXG3niehsxkPCvV4ff3Q91qCGLIq+za8Lvp45dDCZTX5qS2m26KmWwnc7JbkZReNDqmTHwxSKQ/b74l2I=
Date: Fri, 4 Jan 2008 21:38:12 +0400
From: Alexander Shaduri <ashaduri@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: unable to handle kernel paging request at virtual address
Message-ID: <20080104213812.20268840@linux.localdomain>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.0; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I got the following message, shortly followed by a system hang.
BUG: unable to handle kernel paging request at virtual address 48464443

(see the oops below).

I've been getting kernel oopses for quite some time now, ever since I
got a new computer (several months now).

The problem manifests when I use mplayer/mencoder to capture from
TV card (Avermedia 203, BT878 chipset). Doesn't matter if it's viewing
or encoding. Usually happens within first 2 hours of capturing, quite randomly.
Note that other system-intensive tasks (video encoding from file, 3D games,
heavy fs activity) don't cause any instabilities.

Reproduced with kernels 2.6.21, 2.6.22 and 2.6.23.12 (the first two
being on openSUSE 10.2, and the 2.6.23(.1 and .12) on openSUSE 10.3).
Unfortunately, I only have the oops output from 2.6.23.12.

Doesn't seem to be the memory problem (I tested it with memtest86),
and that other commercial OS seems to be working fine (well, at least
no hangs during capturing and no suspicious freezes).

The messages below indicate that I have a proprietary driver (nvidia)
loaded, but the kernel hangs without it too - using pure vesa framebuffer,
without running an X server.


mplayer command:
gmplayer -sws 2 tv:// -tv driver=v4l2:input=1:width=768:height=576\
:forceaudio:amode=1:adevice=/dev/dsp -mc 0


Hardware:
CPU: Athlon X2 5200+ (dual-core).
MB: Asus M2N-E SLI (nforce 500 chipset, latest BIOS update).
TV card: Avermedia 203 (BT878 chipset).
Ram: 2G Kingston
Video card: NVidia 8600GT (MSI)


The oops itself (from dmesg - I had its output logged every second, so it managed
to get saved before the real freeze several seconds later):


BUG: unable to handle kernel paging request at virtual address 48464443
 printing eip:
c011d6f8
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: cdc_acm usb_storage libusual ppp_generic slhc iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq capability commoncap fuse nls_koi8_r nls_cp866 loop dm_mod binfmt_misc uhci_hcd it87 hwmon_vid eeprom bt878 tuner tvaudio nvidia(P) bttv snd_emu10k1 snd_rawmidi video_buf firmware_class snd_ac97_codec ir_common ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc compat_ioctl32 snd_util_mem i2c_algo_bit ide_cd ohci1394 emu10k1_gp snd_hwdep snd ieee1394 gameport k8temp cdrom thermal btcx_risc tveeprom videodev hwmon agpgart button rtc_cmos rtc_core rtc_lib soundcore v4l2_common v4l1_compat i2c_nforce2 i2c_core forcedeth sg ohci_hcd ehci_hcd usbcore edd fan processor pata_amd
CPU:    1
EIP:    0060:[<c011d6f8>]    Tainted: P        VLI
EFLAGS: 00010202   (2.6.23.12 #1)
EIP is at pgd_alloc+0x28/0x80
eax: c0564101   ebx: 48464443   ecx: f1403bc0   edx: c2019148
esi: 00000001   edi: fffffff4   ebp: edb16bc0   esp: cf517f5c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process sh (pid: 18310, ti=cf516000 task=f0b83aa0 task.ti=cf516000)
Stack: f7fc7240 e100c000 c0126ec6 d1063480 c01859df bf978390 00000011 d1063480
       e100c000 edb16bc0 d1063480 c0186f36 8009f7f0 800a0ef0 e100c000 e100c000
       b7e6fff4 cf516000 c010260f cf517fb8 800a0f98 800a0f98 c0104362 800a0f98
Call Trace:
 [<c0126ec6>] mm_init+0xb6/0xe0
 [<c01859df>] bprm_mm_init+0x1f/0x170
 [<c0186f36>] do_execve+0x66/0x1e0
 [<c010260f>] sys_execve+0x2f/0x80
 [<c0104362>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 74 26 00 56 53 89 e0 25 00 e0 ff ff ff 40 14 64 8b 15 84 30 56 c0 b8 48 41 56 c0 01 c2 8b 1a 85 db 0f 95 c0 0f b6 f0 85 f6 74 0d <8b> 03 89 02 c7 03 00 00 00 00 ff 4a 04 89 e0 25 00 e0 ff ff ff
EIP: [<c011d6f8>] pgd_alloc+0x28/0x80 SS:ESP 0068:cf517f5c
note: sh[18310] exited with preempt_count 1
BUG: scheduling while atomic: sh/0x10000002/18310
 [<c03e7ab2>] schedule+0x5c2/0x6c0
 [<c0121878>] __wake_up+0x38/0x50
 [<c01879a6>] pipe_release+0x86/0xb0
 [<c0192afc>] dput+0x1c/0x100
 [<c018273f>] __fput+0x10f/0x170
 [<c0124d08>] __cond_resched+0x18/0x30
 [<c03e806a>] cond_resched+0x2a/0x40
 [<c012b4ae>] put_files_struct+0x9e/0xb0
 [<c012c730>] do_exit+0x170/0x840
 [<c01059dd>] die+0x23d/0x250
 [<c011e1af>] do_page_fault+0x29f/0x670
 [<c018b97c>] do_path_lookup+0x7c/0x210
 [<c0279962>] __next_cpu+0x12/0x30
 [<c011df10>] do_page_fault+0x0/0x670
 [<c03e9b02>] error_code+0x72/0x78
 [<c011d6f8>] pgd_alloc+0x28/0x80
 [<c0126ec6>] mm_init+0xb6/0xe0
 [<c01859df>] bprm_mm_init+0x1f/0x170
 [<c0186f36>] do_execve+0x66/0x1e0
 [<c010260f>] sys_execve+0x2f/0x80
 [<c0104362>] sysenter_past_esp+0x5f/0x85
 =======================
BUG: unable to handle kernel paging request at virtual address 48464443
 printing eip:
c011d6f8
*pde = 00000000
Oops: 0000 [#2]
PREEMPT SMP
Modules linked in: cdc_acm usb_storage libusual ppp_generic slhc iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq capability commoncap fuse nls_koi8_r nls_cp866 loop dm_mod binfmt_misc uhci_hcd it87 hwmon_vid eeprom bt878 tuner tvaudio nvidia(P) bttv snd_emu10k1 snd_rawmidi video_buf firmware_class snd_ac97_codec ir_common ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc compat_ioctl32 snd_util_mem i2c_algo_bit ide_cd ohci1394 emu10k1_gp snd_hwdep snd ieee1394 gameport k8temp cdrom thermal btcx_risc tveeprom videodev hwmon agpgart button rtc_cmos rtc_core rtc_lib soundcore v4l2_common v4l1_compat i2c_nforce2 i2c_core forcedeth sg ohci_hcd ehci_hcd usbcore edd fan processor pata_amd
CPU:    1
EIP:    0060:[<c011d6f8>]    Tainted: P      D VLI
EFLAGS: 00010202   (2.6.23.12 #1)
EIP is at pgd_alloc+0x28/0x80
eax: c0564101   ebx: 48464443   ecx: f1403bc0   edx: c2019148
esi: 00000001   edi: fffffff4   ebp: edb16cc0   esp: cab69f5c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process amdpwrmon (pid: 18313, ti=cab68000 task=f7e74000 task.ti=cab68000)
Stack: f7fc7c40 caeec000 c0126ec6 cfacb500 c01859df 000000d8 00000011 cfacb500
       caeec000 edb16cc0 cfacb500 c0186f36 bfd5600c bfd54870 caeec000 caeec000
       b7725ff4 cab68000 c010260f cab69fb8 b7709eea 00000003 c0104362 b7709eea
Call Trace:
 [<c0126ec6>] mm_init+0xb6/0xe0
 [<c01859df>] bprm_mm_init+0x1f/0x170
 [<c0186f36>] do_execve+0x66/0x1e0
 [<c010260f>] sys_execve+0x2f/0x80
 [<c0104362>] sysenter_past_esp+0x5f/0x85
 =======================
Code: 74 26 00 56 53 89 e0 25 00 e0 ff ff ff 40 14 64 8b 15 84 30 56 c0 b8 48 41 56 c0 01 c2 8b 1a 85 db 0f 95 c0 0f b6 f0 85 f6 74 0d <8b> 03 89 02 c7 03 00 00 00 00 ff 4a 04 89 e0 25 00 e0 ff ff ff
EIP: [<c011d6f8>] pgd_alloc+0x28/0x80 SS:ESP 0068:cab69f5c
note: amdpwrmon[18313] exited with preempt_count 1

(several more BUG: sections like these follow).



Distro: openSUSE 10.3.

Version information (scripts/ver_linux):

Linux linux 2.6.23.12 #1 SMP PREEMPT Thu Jan 3 18:56:21 GST 2008 i686 athlon i386 GNU/Linux

Gnu C                  4.2.1
Gnu make               3.81
binutils               Binutils
util-linux             2.13-rc2
mount                  2.13-rc2
module-init-tools      3.3-pre11
e2fsprogs              1.40.2
jfsutils               1.1.11
reiserfsprogs          3.6.19
PPP                    2.4.4
Linux C Library        6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   114
wireless-tools         29
Modules Loaded         ppp_generic slhc iptable_filter ip_tables
ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative
cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8
freq_table snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth
snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul
snd_seq capability commoncap fuse nls_koi8_r nls_cp866 loop dm_mod
binfmt_misc uhci_hcd it87 hwmon_vid eeprom nvidia tuner tvaudio
snd_emu10k1 bttv snd_rawmidi snd_ac97_codec video_buf firmware_class
ir_common ac97_bus snd_pcm snd_seq_device compat_ioctl32 i2c_algo_bit
snd_timer snd_page_alloc emu10k1_gp snd_util_mem btcx_risc tveeprom
videodev gameport ohci1394 ieee1394 ide_cd snd_hwdep snd v4l2_common
v4l1_compat agpgart soundcore i2c_nforce2 thermal button rtc_cmos
rtc_core rtc_lib forcedeth k8temp i2c_core hwmon cdrom sg ohci_hcd
ehci_hcd usbcore edd fan processor pata_amd




Should I provide anything else (.config maybe)?


Thanks a lot,

Alexander

