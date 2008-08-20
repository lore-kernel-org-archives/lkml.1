Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYHTFk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYHTFk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 01:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYHTFks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 01:40:48 -0400
Received: from dzilna.latnet.lv ([92.240.66.75]:55051 "EHLO dzilna.latnet.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbYHTFkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 01:40:41 -0400
From: Aivils Stoss <aivils@latnet.lv>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
Date: Wed, 20 Aug 2008 11:10:21 +0530
User-Agent: KMail/1.9.7
Cc: Randy Dunlap <rdunlap@xenotime.net>, stern@rowland.harvard.edu,
       lud <linux-usb@vger.kernel.org>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxconsole-dev@lists.sourceforge.net
References: <200808080702.24969.aivils@latnet.lv> <20080819081936.37fef673.rdunlap@xenotime.net> <alpine.LNX.1.10.0808191721560.18058@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0808191721560.18058@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808201110.21863.aivils@latnet.lv>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 8:53:07 pm Jiri Kosina wrote:
> On Tue, 19 Aug 2008, Randy Dunlap wrote:
> > > 2.6.22-1-mepis-smp
> > > Quite stable. Have oops sometime inside evdev. Support up to 16
> > > USB keyboards, where 4 hubs are plugged into PC and 4 keyboards on
> > > each hub. Any hub cascade support only 4 keyboards, where 5th or more
> > > is registered but don't send input events. Oops inside evdev , when
> > > USB keyboard unplugged. No slow down even all USB keyboards does
> > > not work properly. My be this one support more than 16 keyboards, but
> > > i don't have PC USB ports enough.
> >
> > Has the evdev oops been reported and/or fixed? I think that we would
> > prefer to fix that soonish.
>
> We haven't seen the respective oops yet, or have I missed it?
>
> I'd bet it is fixed in newer kernels by patches that introduce proper
> locking into evdev code.

I don't know exists this one in the 2.6.26 and above :o(

Aivils Stoss

# cat /proc/version
Linux version 2.6.22-1-mepis-smp (root@mepis-pro) (gcc version 4.1.2 20061115 
(prerelease) (Debian 4.1.1-21)) #1 SMP PREEMPT Sun Dec 2 19:15:40 EST 2007

# dmesg
input: CHESEN USB Keyboard as /class/input/input41
input: USB HID v1.10 Device [CHESEN USB Keyboard] on usb-0000:00:1d.3-2.4.4
hub 5-0:1.0: port 2 disabled by hub (EMI?), re-enabling...
usb 5-2: USB disconnect, address 8
usb 5-2.1: USB disconnect, address 14
usb 5-2.1.2: USB disconnect, address 23
BUG: unable to handle kernel paging request at virtual address 00100100
 printing eip:
f8832664
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: i915 drm evdev binfmt_misc cpufreq_ondemand 
cpufreq_userspace cpufreq_powersave acpi_cpufreq speedstep_lib freq_table 
rfcomm hidp l2cap bluetooth ppdev lp thermal fan button processor ac battery 
ipv6 snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul 
snd_emu10k1 snd_util_mem snd_hwdep piix ide_core fuse ndiswrapper dm_crypt 
dm_snapshot dm_mirror dm_mod usbhid hid sworks_agp amd_k7_agp ali_agp sis_agp 
ati_agp nvidia_agp via_agp wlan_scan_sta ath_rate_sample snd_emu10k1x 
snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq snd_rawmidi 
snd_seq_device snd_ac97_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd 
soundcore intel_agp agpgart ac97_bus i2c_i801 i2c_core snd_page_alloc 
parport_pc parport floppy ath_pci wlan ath_hal(P) serio_raw psmouse uhci_hcd 
atl2 pcspkr
CPU:    0
EIP:    0060:[<f8832664>]    Tainted: P       VLI
EFLAGS: 00010206   (2.6.22-1-mepis-smp #1)
EIP is at evdev_disconnect+0x73/0xb1 [evdev]
eax: 00000000   ebx: 000ffcf0   ecx: f73d5540   edx: 01329000
esi: f6c31340   edi: cf00c000   ebp: d2a56800   esp: c1a59e48
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process khubd (pid: 168, ti=c1a58000 task=c1aaf030 task.ti=c1a58000)
Stack: c368c800 c368c800 c368cecc c0321be7 00000000 c048f02c c18de420 d2a56800
       f6f98ba0 cf00cc58 f8a51354 caf8501c caf85000 cf00c000 f8a4129d d2a56800
       d2a56818 f8a45dc0 e4ef2800 c030715f 00000000 d2a56818 f8a45df4 00000000
Call Trace:
 [<c0321be7>] input_unregister_device+0x67/0xfc
 [<f8a51354>] hidinput_disconnect+0x2e/0x47 [hid]
 [<f8a4129d>] hid_disconnect+0x70/0xc1 [usbhid]
 [<c030715f>] usb_unbind_interface+0x44/0x85
 [<c02b16a4>] __device_release_driver+0x71/0x8e
 [<c02b1a2c>] device_release_driver+0x1e/0x34
 [<c02b108e>] bus_remove_device+0x5e/0x6c
 [<c02afb7d>] device_del+0x1a4/0x218
 [<c0304c75>] usb_disable_device+0x5c/0xbb
 [<c0301773>] usb_disconnect+0x83/0x11b
 [<c0301761>] usb_disconnect+0x71/0x11b
 [<c0301761>] usb_disconnect+0x71/0x11b
 [<c0301e5e>] hub_thread+0x365/0xa67
 [<c0392677>] __sched_text_start+0x6f7/0x793
 [<c0133e60>] autoremove_wake_function+0x0/0x35
 [<c0301af9>] hub_thread+0x0/0xa67
 [<c0133d93>] kthread+0x38/0x5d
 [<c0133d5b>] kthread+0x0/0x5d
 [<c01049d7>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 07 e4 ae c7 8b 5e 54 eb 1b 8d 83 08 04 00 00 b9 06 00 02 00 ba 1d 00 
00 00 e8 40 11 94 c7 8b 9b 10 04 00 00 81 eb 10 04 00 00 <8b> 83 10 04 00 00 
0f 18 00 90 8d 93 10 04 00 00 8d 46 54 39 c2
EIP: [<f8832664>] evdev_disconnect+0x73/0xb1 [evdev] SS:ESP 0068:c1a59e48
hid-debug: input LED.CapsLock = 1
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 1
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 1
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 1
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 1
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 0
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 0
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 0
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 0
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
hid-debug: input LED.CapsLock = 0
/home/aivils/works/kernel/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed


# cat /proc/modules
i915 21120 2 - Live 0xf8d13000
drm 67092 3 i915, Live 0xf8d21000
evdev 7936 5 - Live 0xf8832000
binfmt_misc 9224 1 - Live 0xf8cc5000
cpufreq_ondemand 7436 2 - Live 0xf8cb0000
cpufreq_userspace 4256 0 - Live 0xf8cb3000
cpufreq_powersave 2560 0 - Live 0xf8c10000
acpi_cpufreq 7624 0 - Live 0xf8c92000
speedstep_lib 4740 0 - Live 0xf8cad000
freq_table 4512 2 cpufreq_ondemand,acpi_cpufreq, Live 0xf8c95000
rfcomm 31256 0 - Live 0xf8cb8000
hidp 15232 2 - Live 0xf8c86000
l2cap 19712 10 rfcomm,hidp, Live 0xf8c9a000
bluetooth 42724 5 rfcomm,hidp,l2cap, Live 0xf8ca1000
ppdev 7684 0 - Live 0xf8c8f000
lp 9476 0 - Live 0xf8c8b000
thermal 11784 0 - Live 0xf8c1a000
fan 4612 0 - Live 0xf8c21000
button 7056 0 - Live 0xf8c1e000
processor 25928 2 acpi_cpufreq,thermal, Live 0xf8c12000
ac 4740 0 - Live 0xf8bfc000
battery 9220 0 - Live 0xf8bf8000
ipv6 217380 12 - Live 0xf8cc9000
snd_emu10k1_synth 6784 0 - Live 0xf8bf5000
snd_emux_synth 29568 1 snd_emu10k1_synth, Live 0xf8bff000
snd_seq_virmidi 6144 1 snd_emux_synth, Live 0xf8bf2000
snd_seq_midi_emul 6016 1 snd_emux_synth, Live 0xf8a7d000
snd_emu10k1 119232 1 snd_emu10k1_synth, Live 0xf8c67000
snd_util_mem 4352 2 snd_emux_synth,snd_emu10k1, Live 0xf8a7a000
snd_hwdep 7556 2 snd_emux_synth,snd_emu10k1, Live 0xf8a77000
piix 8708 0 [permanent], Live 0xf8a66000
ide_core 100036 1 piix, Live 0xf8c4d000
fuse 36756 1 - Live 0xf89f6000
ndiswrapper 162396 0 - Live 0xf8c24000
dm_crypt 11272 0 - Live 0xf884f000
dm_snapshot 14888 0 - Live 0xf8a5c000
dm_mirror 18304 0 - Live 0xf8a48000
dm_mod 43840 3 dm_crypt,dm_snapshot,dm_mirror, Live 0xf8a6b000
usbhid 22240 0 - Live 0xf8a41000
hid 41344 2 hidp,usbhid, Live 0xf8a50000
sworks_agp 8096 0 - Live 0xf89f3000
amd_k7_agp 7436 0 - Live 0xf89f0000
ali_agp 6144 0 - Live 0xf89d3000
sis_agp 7556 0 - Live 0xf89d0000
ati_agp 7564 0 - Live 0xf89cd000
nvidia_agp 7068 0 - Live 0xf89ca000
via_agp 8960 0 - Live 0xf882e000
wlan_scan_sta 11776 1 - Live 0xf89c6000
ath_rate_sample 11776 1 - Live 0xf8959000
snd_emu10k1x 15268 0 - Live 0xf8991000
snd_seq_dummy 3844 0 - Live 0xf8960000
snd_seq_oss 28800 0 - Live 0xf8996000
snd_seq_midi 6944 0 - Live 0xf897c000
snd_seq_midi_event 6656 3 snd_seq_virmidi,snd_seq_oss,snd_seq_midi, Live 
0xf895d000
snd_seq 42576 9 
snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, 
Live 0xf89ba000
snd_rawmidi 18208 4 snd_seq_virmidi,snd_emu10k1,snd_emu10k1x,snd_seq_midi, 
Live 0xf8856000
snd_seq_device 7308 8 
snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq,snd_rawmidi, 
Live 0xf88f1000
snd_ac97_codec 90788 2 snd_emu10k1,snd_emu10k1x, Live 0xf89d8000
snd_pcm_oss 34976 0 - Live 0xf89b0000
snd_mixer_oss 14592 1 snd_pcm_oss, Live 0xf8977000
snd_pcm 62084 4 snd_emu10k1,snd_emu10k1x,snd_ac97_codec,snd_pcm_oss, Live 
0xf899f000
snd_timer 17668 3 snd_emu10k1,snd_seq,snd_pcm, Live 0xf8971000
snd 41316 15 
snd_emux_synth,snd_seq_virmidi,snd_emu10k1,snd_hwdep,snd_emu10k1x,snd_seq_dummy,snd_seq_oss,snd_seq,snd_rawmidi,snd_seq_device,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer, 
Live 0xf897f000
soundcore 6880 1 snd, Live 0xf887d000
intel_agp 21012 1 - Live 0xf896a000
agpgart 25804 10 
drm,sworks_agp,amd_k7_agp,ali_agp,sis_agp,ati_agp,nvidia_agp,via_agp,intel_agp, 
Live 0xf8962000
ac97_bus 3072 1 snd_ac97_codec, Live 0xf8866000
i2c_i801 8208 0 - Live 0xf8860000
i2c_core 19456 1 i2c_i801, Live 0xf8877000
snd_page_alloc 8328 3 snd_emu10k1,snd_emu10k1x,snd_pcm, Live 0xf885c000
parport_pc 30116 1 - Live 0xf8950000
parport 29512 3 ppdev,lp,parport_pc, Live 0xf88d6000
floppy 50052 0 - Live 0xf8869000
ath_pci 81440 0 - Live 0xf88c1000
wlan 170180 4 wlan_scan_sta,ath_rate_sample,ath_pci, Live 0xf8925000
ath_hal 190544 3 ath_rate_sample,ath_pci, Live 0xf88f5000 (P)
serio_raw 6020 0 - Live 0xf8853000
psmouse 34320 0 - Live 0xf8837000
uhci_hcd 20364 0 - Live 0xf8849000
atl2 24216 0 - Live 0xf8842000
pcspkr 3456 0 - Live 0xf8835000


# objdump -D evdev.ko

evdev.ko:     file format elf32-i386

Disassembly of section .text:

00000000 <evdev_poll>:
   0:	57                   	push   %edi
   1:	56                   	push   %esi
   2:	53                   	push   %ebx
   3:	89 d3                	mov    %edx,%ebx
   5:	8b b0 80 00 00 00    	mov    0x80(%eax),%esi
   b:	85 db                	test   %ebx,%ebx
   d:	8b be 0c 04 00 00    	mov    0x40c(%esi),%edi
  13:	8d 57 40             	lea    0x40(%edi),%edx
  16:	74 08                	je     20 <evdev_poll+0x20>
  18:	85 d2                	test   %edx,%edx
  1a:	74 04                	je     20 <evdev_poll+0x20>
  1c:	89 d9                	mov    %ebx,%ecx
  1e:	ff 13                	call   *(%ebx)
  20:	8b 96 00 04 00 00    	mov    0x400(%esi),%edx
  26:	31 c0                	xor    %eax,%eax
  28:	3b 96 04 04 00 00    	cmp    0x404(%esi),%edx
  2e:	ba 41 00 00 00       	mov    $0x41,%edx
  33:	5b                   	pop    %ebx
  34:	0f 45 c2             	cmovne %edx,%eax
  37:	83 3f 01             	cmpl   $0x1,(%edi)
  3a:	5e                   	pop    %esi
  3b:	19 d2                	sbb    %edx,%edx
  3d:	5f                   	pop    %edi
  3e:	83 e2 18             	and    $0x18,%edx
  41:	09 d0                	or     %edx,%eax
  43:	c3                   	ret    

00000044 <evdev_fasync>:
  44:	53                   	push   %ebx
  45:	83 ec 04             	sub    $0x4,%esp
  48:	8b 9a 80 00 00 00    	mov    0x80(%edx),%ebx
  4e:	81 c3 08 04 00 00    	add    $0x408,%ebx
  54:	89 1c 24             	mov    %ebx,(%esp)
  57:	e8 fc ff ff ff       	call   58 <evdev_fasync+0x14>
  5c:	89 c2                	mov    %eax,%edx
  5e:	31 c0                	xor    %eax,%eax
  60:	85 d2                	test   %edx,%edx
  62:	0f 4e c2             	cmovle %edx,%eax
  65:	5a                   	pop    %edx
  66:	5b                   	pop    %ebx
  67:	c3                   	ret    

00000068 <evdev_free>:
  68:	8b 50 08             	mov    0x8(%eax),%edx
  6b:	c7 04 95 00 00 00 00 	movl   $0x0,0x0(,%edx,4)
  72:	00 00 00 00 
  76:	e9 fc ff ff ff       	jmp    77 <evdev_free+0xf>

0000007b <evdev_flush>:
  7b:	89 c2                	mov    %eax,%edx
  7d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  83:	8b 80 0c 04 00 00    	mov    0x40c(%eax),%eax
  89:	83 38 00             	cmpl   $0x0,(%eax)
  8c:	74 08                	je     96 <evdev_flush+0x1b>
  8e:	83 c0 1c             	add    $0x1c,%eax
  91:	e9 fc ff ff ff       	jmp    92 <evdev_flush+0x17>
  96:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
  9b:	c3                   	ret    

0000009c <str_to_user>:
  9c:	57                   	push   %edi
  9d:	85 c0                	test   %eax,%eax
  9f:	56                   	push   %esi
  a0:	bf fe ff ff ff       	mov    $0xfffffffe,%edi
  a5:	53                   	push   %ebx
  a6:	89 ce                	mov    %ecx,%esi
  a8:	89 c3                	mov    %eax,%ebx
  aa:	74 29                	je     d5 <str_to_user+0x39>
  ac:	31 c0                	xor    %eax,%eax
  ae:	83 c9 ff             	or     $0xffffffff,%ecx
  b1:	89 df                	mov    %ebx,%edi
  b3:	f2 ae                	repnz scas %es:(%edi),%al
  b5:	f7 d1                	not    %ecx
  b7:	49                   	dec    %ecx
  b8:	8d 79 01             	lea    0x1(%ecx),%edi
  bb:	89 f0                	mov    %esi,%eax
  bd:	39 d7                	cmp    %edx,%edi
  bf:	0f 47 fa             	cmova  %edx,%edi
  c2:	89 da                	mov    %ebx,%edx
  c4:	89 f9                	mov    %edi,%ecx
  c6:	e8 fc ff ff ff       	call   c7 <str_to_user+0x2b>
  cb:	85 c0                	test   %eax,%eax
  cd:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  d2:	0f 45 f8             	cmovne %eax,%edi
  d5:	5b                   	pop    %ebx
  d6:	89 f8                	mov    %edi,%eax
  d8:	5e                   	pop    %esi
  d9:	5f                   	pop    %edi
  da:	c3                   	ret    

000000db <bits_to_user>:
  db:	53                   	push   %ebx
  dc:	c1 ea 05             	shr    $0x5,%edx
  df:	8d 1c 95 04 00 00 00 	lea    0x4(,%edx,4),%ebx
  e6:	89 c2                	mov    %eax,%edx
  e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  ec:	39 cb                	cmp    %ecx,%ebx
  ee:	0f 47 d9             	cmova  %ecx,%ebx
  f1:	89 d9                	mov    %ebx,%ecx
  f3:	e8 fc ff ff ff       	call   f4 <bits_to_user+0x19>
  f8:	85 c0                	test   %eax,%eax
  fa:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  ff:	0f 45 d8             	cmovne %eax,%ebx
 102:	89 d8                	mov    %ebx,%eax
 104:	5b                   	pop    %ebx
 105:	c3                   	ret    

00000106 <evdev_ioctl>:
 106:	55                   	push   %ebp
 107:	57                   	push   %edi
 108:	89 cf                	mov    %ecx,%edi
 10a:	56                   	push   %esi
 10b:	53                   	push   %ebx
 10c:	89 d3                	mov    %edx,%ebx
 10e:	83 ec 54             	sub    $0x54,%esp
 111:	89 44 24 08          	mov    %eax,0x8(%esp)
 115:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 11b:	89 44 24 0c          	mov    %eax,0xc(%esp)
 11f:	8b a8 0c 04 00 00    	mov    0x40c(%eax),%ebp
 125:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
 12a:	83 7d 00 00          	cmpl   $0x0,0x0(%ebp)
 12e:	8b 75 28             	mov    0x28(%ebp),%esi
 131:	0f 84 b2 04 00 00    	je     5e9 <evdev_ioctl+0x4e3>
 137:	81 fa 80 45 2c 40    	cmp    $0x402c4580,%edx
 13d:	0f 84 98 01 00 00    	je     2db <evdev_ioctl+0x1d5>
 143:	77 3c                	ja     181 <evdev_ioctl+0x7b>
 145:	81 fa 90 45 04 40    	cmp    $0x40044590,%edx
 14b:	0f 84 08 02 00 00    	je     359 <evdev_ioctl+0x253>
 151:	77 11                	ja     164 <evdev_ioctl+0x5e>
 153:	81 fa 81 45 04 40    	cmp    $0x40044581,%edx
 159:	0f 85 42 02 00 00    	jne    3a1 <evdev_ioctl+0x29b>
 15f:	e9 c0 01 00 00       	jmp    324 <evdev_ioctl+0x21e>
 164:	81 fa 03 45 08 40    	cmp    $0x40084503,%edx
 16a:	0f 84 9d 00 00 00    	je     20d <evdev_ioctl+0x107>
 170:	81 fa 04 45 08 40    	cmp    $0x40084504,%edx
 176:	0f 85 25 02 00 00    	jne    3a1 <evdev_ioctl+0x29b>
 17c:	e9 24 01 00 00       	jmp    2a5 <evdev_ioctl+0x19f>
 181:	81 fa 02 45 08 80    	cmp    $0x80084502,%edx
 187:	74 43                	je     1cc <evdev_ioctl+0xc6>
 189:	77 19                	ja     1a4 <evdev_ioctl+0x9e>
 18b:	81 fa 01 45 04 80    	cmp    $0x80044501,%edx
 191:	74 2a                	je     1bd <evdev_ioctl+0xb7>
 193:	81 fa 84 45 04 80    	cmp    $0x80044584,%edx
 199:	0f 85 02 02 00 00    	jne    3a1 <evdev_ioctl+0x29b>
 19f:	e9 92 01 00 00       	jmp    336 <evdev_ioctl+0x230>
 1a4:	81 fa 03 45 08 80    	cmp    $0x80084503,%edx
 1aa:	74 2d                	je     1d9 <evdev_ioctl+0xd3>
 1ac:	81 fa 04 45 08 80    	cmp    $0x80084504,%edx
 1b2:	0f 85 e9 01 00 00    	jne    3a1 <evdev_ioctl+0x29b>
 1b8:	e9 b4 00 00 00       	jmp    271 <evdev_ioctl+0x16b>
 1bd:	b8 00 00 01 00       	mov    $0x10000,%eax
 1c2:	e8 fc ff ff ff       	call   1c3 <evdev_ioctl+0xbd>
 1c7:	e9 1d 04 00 00       	jmp    5e9 <evdev_ioctl+0x4e3>
 1cc:	8d 56 10             	lea    0x10(%esi),%edx
 1cf:	b9 08 00 00 00       	mov    $0x8,%ecx
 1d4:	e9 7f 03 00 00       	jmp    558 <evdev_ioctl+0x452>
 1d9:	8b 46 18             	mov    0x18(%esi),%eax
 1dc:	a9 00 00 10 00       	test   $0x100000,%eax
 1e1:	0f 84 ef 03 00 00    	je     5d6 <evdev_ioctl+0x4d0>
 1e7:	8b 86 c4 01 00 00    	mov    0x1c4(%esi),%eax
 1ed:	e8 fc ff ff ff       	call   1ee <evdev_ioctl+0xe8>
 1f2:	85 c0                	test   %eax,%eax
 1f4:	0f 85 d5 03 00 00    	jne    5cf <evdev_ioctl+0x4c9>
 1fa:	8b 86 c8 01 00 00    	mov    0x1c8(%esi),%eax
 200:	8d 4f 04             	lea    0x4(%edi),%ecx
 203:	e8 fc ff ff ff       	call   204 <evdev_ioctl+0xfe>
 208:	e9 52 03 00 00       	jmp    55f <evdev_ioctl+0x459>
 20d:	8b 46 18             	mov    0x18(%esi),%eax
 210:	a9 00 00 10 00       	test   $0x100000,%eax
 215:	0f 84 bb 03 00 00    	je     5d6 <evdev_ioctl+0x4d0>
 21b:	89 c8                	mov    %ecx,%eax
 21d:	e8 fc ff ff ff       	call   21e <evdev_ioctl+0x118>
 222:	85 c0                	test   %eax,%eax
 224:	89 d1                	mov    %edx,%ecx
 226:	0f 85 a3 03 00 00    	jne    5cf <evdev_ioctl+0x4c9>
 22c:	8d 47 04             	lea    0x4(%edi),%eax
 22f:	e8 fc ff ff ff       	call   230 <evdev_ioctl+0x12a>
 234:	85 c0                	test   %eax,%eax
 236:	0f 85 93 03 00 00    	jne    5cf <evdev_ioctl+0x4c9>
 23c:	8d 5d 1c             	lea    0x1c(%ebp),%ebx
 23f:	89 d8                	mov    %ebx,%eax
 241:	89 54 24 50          	mov    %edx,0x50(%esp)
 245:	ba 14 00 00 00       	mov    $0x14,%edx
 24a:	89 0c 24             	mov    %ecx,(%esp)
 24d:	31 c9                	xor    %ecx,%ecx
 24f:	e8 fc ff ff ff       	call   250 <evdev_ioctl+0x14a>
 254:	b9 01 00 00 00       	mov    $0x1,%ecx
 259:	ba 14 00 00 00       	mov    $0x14,%edx
 25e:	8b 44 24 50          	mov    0x50(%esp),%eax
 262:	89 04 24             	mov    %eax,(%esp)
 265:	89 d8                	mov    %ebx,%eax
 267:	e8 fc ff ff ff       	call   268 <evdev_ioctl+0x162>
 26c:	e9 0e 01 00 00       	jmp    37f <evdev_ioctl+0x279>
 271:	89 c8                	mov    %ecx,%eax
 273:	e8 fc ff ff ff       	call   274 <evdev_ioctl+0x16e>
 278:	85 c0                	test   %eax,%eax
 27a:	0f 85 4f 03 00 00    	jne    5cf <evdev_ioctl+0x4c9>
 280:	8d 4c 24 50          	lea    0x50(%esp),%ecx
 284:	89 f0                	mov    %esi,%eax
 286:	ff 96 98 00 00 00    	call   *0x98(%esi)
 28c:	85 c0                	test   %eax,%eax
 28e:	0f 85 55 03 00 00    	jne    5e9 <evdev_ioctl+0x4e3>
 294:	8b 44 24 50          	mov    0x50(%esp),%eax
 298:	8d 4f 04             	lea    0x4(%edi),%ecx
 29b:	e8 fc ff ff ff       	call   29c <evdev_ioctl+0x196>
 2a0:	e9 ba 02 00 00       	jmp    55f <evdev_ioctl+0x459>
 2a5:	89 c8                	mov    %ecx,%eax
 2a7:	e8 fc ff ff ff       	call   2a8 <evdev_ioctl+0x1a2>
 2ac:	85 c0                	test   %eax,%eax
 2ae:	89 d3                	mov    %edx,%ebx
 2b0:	0f 85 19 03 00 00    	jne    5cf <evdev_ioctl+0x4c9>
 2b6:	8d 41 04             	lea    0x4(%ecx),%eax
 2b9:	e8 fc ff ff ff       	call   2ba <evdev_ioctl+0x1b4>
 2be:	85 c0                	test   %eax,%eax
 2c0:	0f 85 09 03 00 00    	jne    5cf <evdev_ioctl+0x4c9>
 2c6:	89 d1                	mov    %edx,%ecx
 2c8:	89 f0                	mov    %esi,%eax
 2ca:	89 54 24 50          	mov    %edx,0x50(%esp)
 2ce:	89 da                	mov    %ebx,%edx
 2d0:	ff 96 94 00 00 00    	call   *0x94(%esi)
 2d6:	e9 0e 03 00 00       	jmp    5e9 <evdev_ioctl+0x4e3>
 2db:	8d 5c 24 10          	lea    0x10(%esp),%ebx
 2df:	b9 2c 00 00 00       	mov    $0x2c,%ecx
 2e4:	89 fa                	mov    %edi,%edx
 2e6:	89 d8                	mov    %ebx,%eax
 2e8:	e8 fc ff ff ff       	call   2e9 <evdev_ioctl+0x1e3>
 2ed:	85 c0                	test   %eax,%eax
 2ef:	0f 85 da 02 00 00    	jne    5cf <evdev_ioctl+0x4c9>
 2f5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
 2f9:	89 da                	mov    %ebx,%edx
 2fb:	89 f0                	mov    %esi,%eax
 2fd:	e8 fc ff ff ff       	call   2fe <evdev_ioctl+0x1f8>
 302:	8d 4f 02             	lea    0x2(%edi),%ecx
 305:	66 8b 54 24 12       	mov    0x12(%esp),%dx
 30a:	89 c3                	mov    %eax,%ebx
 30c:	89 d0                	mov    %edx,%eax
 30e:	e8 fc ff ff ff       	call   30f <evdev_ioctl+0x209>
 313:	89 c2                	mov    %eax,%edx
 315:	89 d8                	mov    %ebx,%eax
 317:	85 d2                	test   %edx,%edx
 319:	0f 84 ca 02 00 00    	je     5e9 <evdev_ioctl+0x4e3>
 31f:	e9 ab 02 00 00       	jmp    5cf <evdev_ioctl+0x4c9>
 324:	8b 4c 24 08          	mov    0x8(%esp),%ecx
 328:	89 fa                	mov    %edi,%edx
 32a:	89 f0                	mov    %esi,%eax
 32c:	e8 fc ff ff ff       	call   32d <evdev_ioctl+0x227>
 331:	e9 b3 02 00 00       	jmp    5e9 <evdev_ioctl+0x4e3>
 336:	8b 46 18             	mov    0x18(%esi),%eax
 339:	31 d2                	xor    %edx,%edx
 33b:	a9 00 00 20 00       	test   $0x200000,%eax
 340:	74 09                	je     34b <evdev_ioctl+0x245>
 342:	8b 86 9c 00 00 00    	mov    0x9c(%esi),%eax
 348:	8b 50 40             	mov    0x40(%eax),%edx
 34b:	89 d0                	mov    %edx,%eax
 34d:	89 f9                	mov    %edi,%ecx
 34f:	e8 fc ff ff ff       	call   350 <evdev_ioctl+0x24a>
 354:	e9 06 02 00 00       	jmp    55f <evdev_ioctl+0x459>
 359:	85 c9                	test   %ecx,%ecx
 35b:	8b 45 50             	mov    0x50(%ebp),%eax
 35e:	74 26                	je     386 <evdev_ioctl+0x280>
 360:	85 c0                	test   %eax,%eax
 362:	0f 85 75 02 00 00    	jne    5dd <evdev_ioctl+0x4d7>
 368:	8d 45 1c             	lea    0x1c(%ebp),%eax
 36b:	e8 fc ff ff ff       	call   36c <evdev_ioctl+0x266>
 370:	85 c0                	test   %eax,%eax
 372:	0f 85 65 02 00 00    	jne    5dd <evdev_ioctl+0x4d7>
 378:	8b 44 24 0c          	mov    0xc(%esp),%eax
 37c:	89 45 50             	mov    %eax,0x50(%ebp)
 37f:	31 c0                	xor    %eax,%eax
 381:	e9 63 02 00 00       	jmp    5e9 <evdev_ioctl+0x4e3>
 386:	3b 44 24 0c          	cmp    0xc(%esp),%eax
 38a:	0f 85 54 02 00 00    	jne    5e4 <evdev_ioctl+0x4de>
 390:	8d 45 1c             	lea    0x1c(%ebp),%eax
 393:	e8 fc ff ff ff       	call   394 <evdev_ioctl+0x28e>
 398:	c7 45 50 00 00 00 00 	movl   $0x0,0x50(%ebp)
 39f:	eb de                	jmp    37f <evdev_ioctl+0x279>
 3a1:	0f b6 c7             	movzbl %bh,%eax
 3a4:	83 f8 45             	cmp    $0x45,%eax
 3a7:	0f 85 37 02 00 00    	jne    5e4 <evdev_ioctl+0x4de>
 3ad:	89 d8                	mov    %ebx,%eax
 3af:	c1 e8 1e             	shr    $0x1e,%eax
 3b2:	83 f8 02             	cmp    $0x2,%eax
 3b5:	0f 85 ae 01 00 00    	jne    569 <evdev_ioctl+0x463>
 3bb:	89 d8                	mov    %ebx,%eax
 3bd:	25 e0 00 00 00       	and    $0xe0,%eax
 3c2:	83 f8 20             	cmp    $0x20,%eax
 3c5:	75 79                	jne    440 <evdev_ioctl+0x33a>
 3c7:	89 d8                	mov    %ebx,%eax
 3c9:	83 e0 1f             	and    $0x1f,%eax
 3cc:	83 f8 15             	cmp    $0x15,%eax
 3cf:	0f 87 0f 02 00 00    	ja     5e4 <evdev_ioctl+0x4de>
 3d5:	ff 24 85 00 00 00 00 	jmp    *0x0(,%eax,4)
 3dc:	8d 46 18             	lea    0x18(%esi),%eax
 3df:	ba 1f 00 00 00       	mov    $0x1f,%edx
 3e4:	eb 42                	jmp    428 <evdev_ioctl+0x322>
 3e6:	8d 46 1c             	lea    0x1c(%esi),%eax
 3e9:	ba ff 01 00 00       	mov    $0x1ff,%edx
 3ee:	eb 38                	jmp    428 <evdev_ioctl+0x322>
 3f0:	8d 46 5c             	lea    0x5c(%esi),%eax
 3f3:	eb 2e                	jmp    423 <evdev_ioctl+0x31d>
 3f5:	8d 46 60             	lea    0x60(%esi),%eax
 3f8:	ba 3f 00 00 00       	mov    $0x3f,%edx
 3fd:	eb 29                	jmp    428 <evdev_ioctl+0x322>
 3ff:	8d 46 68             	lea    0x68(%esi),%eax
 402:	eb 08                	jmp    40c <evdev_ioctl+0x306>
 404:	8d 46 6c             	lea    0x6c(%esi),%eax
 407:	eb 1a                	jmp    423 <evdev_ioctl+0x31d>
 409:	8d 46 70             	lea    0x70(%esi),%eax
 40c:	ba 07 00 00 00       	mov    $0x7,%edx
 411:	eb 15                	jmp    428 <evdev_ioctl+0x322>
 413:	8d 46 74             	lea    0x74(%esi),%eax
 416:	ba 7f 00 00 00       	mov    $0x7f,%edx
 41b:	eb 0b                	jmp    428 <evdev_ioctl+0x322>
 41d:	8d 86 84 00 00 00    	lea    0x84(%esi),%eax
 423:	ba 0f 00 00 00       	mov    $0xf,%edx
 428:	c1 eb 10             	shr    $0x10,%ebx
 42b:	81 e3 ff 3f 00 00    	and    $0x3fff,%ebx
 431:	89 d9                	mov    %ebx,%ecx
 433:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 43a:	00 
 43b:	89 3c 24             	mov    %edi,(%esp)
 43e:	eb 29                	jmp    469 <evdev_ioctl+0x363>
 440:	0f b6 c3             	movzbl %bl,%eax
 443:	83 f8 18             	cmp    $0x18,%eax
 446:	75 2b                	jne    473 <evdev_ioctl+0x36d>
 448:	c1 eb 10             	shr    $0x10,%ebx
 44b:	ba ff 01 00 00       	mov    $0x1ff,%edx
 450:	81 e3 ff 3f 00 00    	and    $0x3fff,%ebx
 456:	8d 86 cc 01 00 00    	lea    0x1cc(%esi),%eax
 45c:	89 d9                	mov    %ebx,%ecx
 45e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 465:	00 
 466:	89 3c 24             	mov    %edi,(%esp)
 469:	e8 6d fc ff ff       	call   db <bits_to_user>
 46e:	e9 76 01 00 00       	jmp    5e9 <evdev_ioctl+0x4e3>
 473:	83 f8 19             	cmp    $0x19,%eax
 476:	75 08                	jne    480 <evdev_ioctl+0x37a>
 478:	8d 86 0c 02 00 00    	lea    0x20c(%esi),%eax
 47e:	eb 33                	jmp    4b3 <evdev_ioctl+0x3ad>
 480:	83 f8 1a             	cmp    $0x1a,%eax
 483:	75 23                	jne    4a8 <evdev_ioctl+0x3a2>
 485:	c1 eb 10             	shr    $0x10,%ebx
 488:	ba 07 00 00 00       	mov    $0x7,%edx
 48d:	81 e3 ff 3f 00 00    	and    $0x3fff,%ebx
 493:	8d 86 10 02 00 00    	lea    0x210(%esi),%eax
 499:	89 d9                	mov    %ebx,%ecx
 49b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4a2:	00 
 4a3:	89 3c 24             	mov    %edi,(%esp)
 4a6:	eb c1                	jmp    469 <evdev_ioctl+0x363>
 4a8:	83 f8 1b             	cmp    $0x1b,%eax
 4ab:	75 23                	jne    4d0 <evdev_ioctl+0x3ca>
 4ad:	8d 86 14 02 00 00    	lea    0x214(%esi),%eax
 4b3:	c1 eb 10             	shr    $0x10,%ebx
 4b6:	ba 0f 00 00 00       	mov    $0xf,%edx
 4bb:	81 e3 ff 3f 00 00    	and    $0x3fff,%ebx
 4c1:	89 d9                	mov    %ebx,%ecx
 4c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4ca:	00 
 4cb:	89 3c 24             	mov    %edi,(%esp)
 4ce:	eb 99                	jmp    469 <evdev_ioctl+0x363>
 4d0:	83 f8 06             	cmp    $0x6,%eax
 4d3:	75 05                	jne    4da <evdev_ioctl+0x3d4>
 4d5:	8b 46 04             	mov    0x4(%esi),%eax
 4d8:	eb 12                	jmp    4ec <evdev_ioctl+0x3e6>
 4da:	83 f8 07             	cmp    $0x7,%eax
 4dd:	75 05                	jne    4e4 <evdev_ioctl+0x3de>
 4df:	8b 46 08             	mov    0x8(%esi),%eax
 4e2:	eb 08                	jmp    4ec <evdev_ioctl+0x3e6>
 4e4:	83 f8 08             	cmp    $0x8,%eax
 4e7:	75 1a                	jne    503 <evdev_ioctl+0x3fd>
 4e9:	8b 46 0c             	mov    0xc(%esi),%eax
 4ec:	c1 eb 10             	shr    $0x10,%ebx
 4ef:	89 f9                	mov    %edi,%ecx
 4f1:	81 e3 ff 3f 00 00    	and    $0x3fff,%ebx
 4f7:	89 da                	mov    %ebx,%edx
 4f9:	e8 9e fb ff ff       	call   9c <str_to_user>
 4fe:	e9 e6 00 00 00       	jmp    5e9 <evdev_ioctl+0x4e3>
 503:	89 d8                	mov    %ebx,%eax
 505:	25 c0 00 00 00       	and    $0xc0,%eax
 50a:	83 f8 40             	cmp    $0x40,%eax
 50d:	0f 85 d1 00 00 00    	jne    5e4 <evdev_ioctl+0x4de>
 513:	89 da                	mov    %ebx,%edx
 515:	b9 14 00 00 00       	mov    $0x14,%ecx
 51a:	83 e2 3f             	and    $0x3f,%edx
 51d:	8b 84 96 c4 00 00 00 	mov    0xc4(%esi,%edx,4),%eax
 524:	89 44 24 3c          	mov    %eax,0x3c(%esp)
 528:	8b 84 96 18 03 00 00 	mov    0x318(%esi,%edx,4),%eax
 52f:	89 44 24 40          	mov    %eax,0x40(%esp)
 533:	8b 84 96 18 02 00 00 	mov    0x218(%esi,%edx,4),%eax
 53a:	89 44 24 44          	mov    %eax,0x44(%esp)
 53e:	8b 84 96 18 04 00 00 	mov    0x418(%esi,%edx,4),%eax
 545:	89 44 24 48          	mov    %eax,0x48(%esp)
 549:	8b 84 96 18 05 00 00 	mov    0x518(%esi,%edx,4),%eax
 550:	8d 54 24 3c          	lea    0x3c(%esp),%edx
 554:	89 44 24 4c          	mov    %eax,0x4c(%esp)
 558:	89 f8                	mov    %edi,%eax
 55a:	e8 fc ff ff ff       	call   55b <evdev_ioctl+0x455>
 55f:	85 c0                	test   %eax,%eax
 561:	0f 84 18 fe ff ff    	je     37f <evdev_ioctl+0x279>
 567:	eb 66                	jmp    5cf <evdev_ioctl+0x4c9>
 569:	48                   	dec    %eax
 56a:	75 78                	jne    5e4 <evdev_ioctl+0x4de>
 56c:	89 d8                	mov    %ebx,%eax
 56e:	25 c0 00 00 00       	and    $0xc0,%eax
 573:	3d c0 00 00 00       	cmp    $0xc0,%eax
 578:	75 6a                	jne    5e4 <evdev_ioctl+0x4de>
 57a:	8d 44 24 3c          	lea    0x3c(%esp),%eax
 57e:	b9 14 00 00 00       	mov    $0x14,%ecx
 583:	89 fa                	mov    %edi,%edx
 585:	e8 fc ff ff ff       	call   586 <evdev_ioctl+0x480>
 58a:	85 c0                	test   %eax,%eax
 58c:	75 41                	jne    5cf <evdev_ioctl+0x4c9>
 58e:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 592:	89 da                	mov    %ebx,%edx
 594:	83 e2 3f             	and    $0x3f,%edx
 597:	89 84 96 c4 00 00 00 	mov    %eax,0xc4(%esi,%edx,4)
 59e:	8b 44 24 40          	mov    0x40(%esp),%eax
 5a2:	89 84 96 18 03 00 00 	mov    %eax,0x318(%esi,%edx,4)
 5a9:	8b 44 24 44          	mov    0x44(%esp),%eax
 5ad:	89 84 96 18 02 00 00 	mov    %eax,0x218(%esi,%edx,4)
 5b4:	8b 44 24 48          	mov    0x48(%esp),%eax
 5b8:	89 84 96 18 04 00 00 	mov    %eax,0x418(%esi,%edx,4)
 5bf:	8b 44 24 4c          	mov    0x4c(%esp),%eax
 5c3:	89 84 96 18 05 00 00 	mov    %eax,0x518(%esi,%edx,4)
 5ca:	e9 b0 fd ff ff       	jmp    37f <evdev_ioctl+0x279>
 5cf:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
 5d4:	eb 13                	jmp    5e9 <evdev_ioctl+0x4e3>
 5d6:	b8 da ff ff ff       	mov    $0xffffffda,%eax
 5db:	eb 0c                	jmp    5e9 <evdev_ioctl+0x4e3>
 5dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
 5e2:	eb 05                	jmp    5e9 <evdev_ioctl+0x4e3>
 5e4:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
 5e9:	83 c4 54             	add    $0x54,%esp
 5ec:	5b                   	pop    %ebx
 5ed:	5e                   	pop    %esi
 5ee:	5f                   	pop    %edi
 5ef:	5d                   	pop    %ebp
 5f0:	c3                   	ret    

000005f1 <evdev_disconnect>:
 5f1:	56                   	push   %esi
 5f2:	53                   	push   %ebx
 5f3:	89 c3                	mov    %eax,%ebx
 5f5:	83 ec 04             	sub    $0x4,%esp
 5f8:	8b 30                	mov    (%eax),%esi
 5fa:	e8 fc ff ff ff       	call   5fb <evdev_disconnect+0xa>
 5ff:	b8 1c 00 00 00       	mov    $0x1c,%eax
 604:	8d 56 0c             	lea    0xc(%esi),%edx
 607:	e8 fc ff ff ff       	call   608 <evdev_disconnect+0x17>
 60c:	8b 56 08             	mov    0x8(%esi),%edx
 60f:	b8 00 00 00 00       	mov    $0x0,%eax
 614:	83 c2 40             	add    $0x40,%edx
 617:	81 ca 00 00 d0 00    	or     $0xd00000,%edx
 61d:	e8 fc ff ff ff       	call   61e <evdev_disconnect+0x2d>
 622:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
 626:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
 62c:	74 6a                	je     698 <evdev_disconnect+0xa7>
 62e:	31 d2                	xor    %edx,%edx
 630:	89 d8                	mov    %ebx,%eax
 632:	e8 fc ff ff ff       	call   633 <evdev_disconnect+0x42>
 637:	89 d8                	mov    %ebx,%eax
 639:	e8 fc ff ff ff       	call   63a <evdev_disconnect+0x49>
 63e:	8b 5e 54             	mov    0x54(%esi),%ebx
 641:	eb 1b                	jmp    65e <evdev_disconnect+0x6d>
 643:	8d 83 08 04 00 00    	lea    0x408(%ebx),%eax
 649:	b9 06 00 02 00       	mov    $0x20006,%ecx
 64e:	ba 1d 00 00 00       	mov    $0x1d,%edx
 653:	e8 fc ff ff ff       	call   654 <evdev_disconnect+0x63>
 658:	8b 9b 10 04 00 00    	mov    0x410(%ebx),%ebx
 65e:	81 eb 10 04 00 00    	sub    $0x410,%ebx
 664:	8b 83 10 04 00 00    	mov    0x410(%ebx),%eax
 66a:	8d 74 26 00          	lea    0x0(%esi),%esi
 66e:	8d 93 10 04 00 00    	lea    0x410(%ebx),%edx
 674:	8d 46 54             	lea    0x54(%esi),%eax
 677:	39 c2                	cmp    %eax,%edx
 679:	75 c8                	jne    643 <evdev_disconnect+0x52>
 67b:	8d 46 40             	lea    0x40(%esi),%eax
 67e:	b9 01 00 00 00       	mov    $0x1,%ecx
 683:	ba 01 00 00 00       	mov    $0x1,%edx
 688:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 68f:	e8 fc ff ff ff       	call   690 <evdev_disconnect+0x9f>
 694:	5b                   	pop    %ebx
 695:	5b                   	pop    %ebx
 696:	5e                   	pop    %esi
 697:	c3                   	ret    
 698:	59                   	pop    %ecx
 699:	89 f0                	mov    %esi,%eax
 69b:	5b                   	pop    %ebx
 69c:	5e                   	pop    %esi
 69d:	e9 c6 f9 ff ff       	jmp    68 <evdev_free>

000006a2 <evdev_connect>:
 6a2:	55                   	push   %ebp
 6a3:	89 c5                	mov    %eax,%ebp
 6a5:	57                   	push   %edi
 6a6:	56                   	push   %esi
 6a7:	53                   	push   %ebx
 6a8:	83 ec 1c             	sub    $0x1c,%esp
 6ab:	89 54 24 14          	mov    %edx,0x14(%esp)
 6af:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
 6b6:	00 
 6b7:	eb 0b                	jmp    6c4 <evdev_connect+0x22>
 6b9:	ff 44 24 18          	incl   0x18(%esp)
 6bd:	83 7c 24 18 20       	cmpl   $0x20,0x18(%esp)
 6c2:	74 10                	je     6d4 <evdev_connect+0x32>
 6c4:	8b 44 24 18          	mov    0x18(%esp),%eax
 6c8:	83 3c 85 00 00 00 00 	cmpl   $0x0,0x0(,%eax,4)
 6cf:	00 
 6d0:	75 e7                	jne    6b9 <evdev_connect+0x17>
 6d2:	eb 16                	jmp    6ea <evdev_connect+0x48>
 6d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6db:	be e9 ff ff ff       	mov    $0xffffffe9,%esi
 6e0:	e8 fc ff ff ff       	call   6e1 <evdev_connect+0x3f>
 6e5:	e9 00 01 00 00       	jmp    7ea <evdev_connect+0x148>
 6ea:	a1 1c 00 00 00       	mov    0x1c,%eax
 6ef:	ba d0 00 00 00       	mov    $0xd0,%edx
 6f4:	be f4 ff ff ff       	mov    $0xfffffff4,%esi
 6f9:	e8 fc ff ff ff       	call   6fa <evdev_connect+0x58>
 6fe:	85 c0                	test   %eax,%eax
 700:	89 c3                	mov    %eax,%ebx
 702:	0f 84 e2 00 00 00    	je     7ea <evdev_connect+0x148>
 708:	8d 40 54             	lea    0x54(%eax),%eax
 70b:	89 43 54             	mov    %eax,0x54(%ebx)
 70e:	8d 7b 0c             	lea    0xc(%ebx),%edi
 711:	89 40 04             	mov    %eax,0x4(%eax)
 714:	8d 43 40             	lea    0x40(%ebx),%eax
 717:	e8 fc ff ff ff       	call   718 <evdev_connect+0x76>
 71c:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
 722:	8b 54 24 18          	mov    0x18(%esp),%edx
 726:	89 53 08             	mov    %edx,0x8(%ebx)
 729:	8b 44 24 14          	mov    0x14(%esp),%eax
 72d:	89 6b 2c             	mov    %ebp,0x2c(%ebx)
 730:	89 7b 24             	mov    %edi,0x24(%ebx)
 733:	89 5b 1c             	mov    %ebx,0x1c(%ebx)
 736:	89 43 28             	mov    %eax,0x28(%ebx)
 739:	89 54 24 08          	mov    %edx,0x8(%esp)
 73d:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
 744:	00 
 745:	89 3c 24             	mov    %edi,(%esp)
 748:	e8 fc ff ff ff       	call   749 <evdev_connect+0xa7>
 74d:	8b 54 24 18          	mov    0x18(%esp),%edx
 751:	89 7c 24 10          	mov    %edi,0x10(%esp)
 755:	89 1c 95 00 00 00 00 	mov    %ebx,0x0(,%edx,4)
 75c:	89 d5                	mov    %edx,%ebp
 75e:	8b 54 24 14          	mov    0x14(%esp),%edx
 762:	83 c5 40             	add    $0x40,%ebp
 765:	81 cd 00 00 d0 00    	or     $0xd00000,%ebp
 76b:	8b 82 b0 06 00 00    	mov    0x6b0(%edx),%eax
 771:	89 6c 24 08          	mov    %ebp,0x8(%esp)
 775:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 77c:	89 44 24 0c          	mov    %eax,0xc(%esp)
 780:	89 d0                	mov    %edx,%eax
 782:	05 44 06 00 00       	add    $0x644,%eax
 787:	89 44 24 04          	mov    %eax,0x4(%esp)
 78b:	e8 fc ff ff ff       	call   78c <evdev_connect+0xea>
 790:	3d 00 f0 ff ff       	cmp    $0xfffff000,%eax
 795:	89 c6                	mov    %eax,%esi
 797:	77 3b                	ja     7d4 <evdev_connect+0x132>
 799:	8d 50 08             	lea    0x8(%eax),%edx
 79c:	89 f9                	mov    %edi,%ecx
 79e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 7a3:	e8 fc ff ff ff       	call   7a4 <evdev_connect+0x102>
 7a8:	85 c0                	test   %eax,%eax
 7aa:	89 c6                	mov    %eax,%esi
 7ac:	75 1a                	jne    7c8 <evdev_connect+0x126>
 7ae:	8d 43 1c             	lea    0x1c(%ebx),%eax
 7b1:	e8 fc ff ff ff       	call   7b2 <evdev_connect+0x110>
 7b6:	85 c0                	test   %eax,%eax
 7b8:	89 c6                	mov    %eax,%esi
 7ba:	74 2e                	je     7ea <evdev_connect+0x148>
 7bc:	89 fa                	mov    %edi,%edx
 7be:	b8 1c 00 00 00       	mov    $0x1c,%eax
 7c3:	e8 fc ff ff ff       	call   7c4 <evdev_connect+0x122>
 7c8:	89 ea                	mov    %ebp,%edx
 7ca:	b8 00 00 00 00       	mov    $0x0,%eax
 7cf:	e8 fc ff ff ff       	call   7d0 <evdev_connect+0x12e>
 7d4:	89 d8                	mov    %ebx,%eax
 7d6:	e8 fc ff ff ff       	call   7d7 <evdev_connect+0x135>
 7db:	8b 44 24 18          	mov    0x18(%esp),%eax
 7df:	c7 04 85 00 00 00 00 	movl   $0x0,0x0(,%eax,4)
 7e6:	00 00 00 00 
 7ea:	83 c4 1c             	add    $0x1c,%esp
 7ed:	89 f0                	mov    %esi,%eax
 7ef:	5b                   	pop    %ebx
 7f0:	5e                   	pop    %esi
 7f1:	5f                   	pop    %edi
 7f2:	5d                   	pop    %ebp
 7f3:	c3                   	ret    

000007f4 <evdev_event>:
 7f4:	55                   	push   %ebp
 7f5:	89 cd                	mov    %ecx,%ebp
 7f7:	57                   	push   %edi
 7f8:	89 d7                	mov    %edx,%edi
 7fa:	56                   	push   %esi
 7fb:	53                   	push   %ebx
 7fc:	83 ec 04             	sub    $0x4,%esp
 7ff:	8b 54 24 18          	mov    0x18(%esp),%edx
 803:	89 14 24             	mov    %edx,(%esp)
 806:	8b 30                	mov    (%eax),%esi
 808:	8b 5e 50             	mov    0x50(%esi),%ebx
 80b:	85 db                	test   %ebx,%ebx
 80d:	74 67                	je     876 <evdev_event+0x82>
 80f:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 815:	c1 e0 04             	shl    $0x4,%eax
 818:	8d 04 03             	lea    (%ebx,%eax,1),%eax
 81b:	e8 fc ff ff ff       	call   81c <evdev_event+0x28>
 820:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 826:	b9 01 00 02 00       	mov    $0x20001,%ecx
 82b:	c1 e0 04             	shl    $0x4,%eax
 82e:	66 89 7c 18 08       	mov    %di,0x8(%eax,%ebx,1)
 833:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 839:	c1 e0 04             	shl    $0x4,%eax
 83c:	66 89 6c 18 0a       	mov    %bp,0xa(%eax,%ebx,1)
 841:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 847:	8b 14 24             	mov    (%esp),%edx
 84a:	c1 e0 04             	shl    $0x4,%eax
 84d:	89 54 18 0c          	mov    %edx,0xc(%eax,%ebx,1)
 851:	ba 1d 00 00 00       	mov    $0x1d,%edx
 856:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 85c:	40                   	inc    %eax
 85d:	83 e0 3f             	and    $0x3f,%eax
 860:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)
 866:	8d 83 08 04 00 00    	lea    0x408(%ebx),%eax
 86c:	e8 fc ff ff ff       	call   86d <evdev_event+0x79>
 871:	e9 8e 00 00 00       	jmp    904 <evdev_event+0x110>
 876:	8b 5e 54             	mov    0x54(%esi),%ebx
 879:	eb 68                	jmp    8e3 <evdev_event+0xef>
 87b:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 881:	c1 e0 04             	shl    $0x4,%eax
 884:	8d 04 03             	lea    (%ebx,%eax,1),%eax
 887:	e8 fc ff ff ff       	call   888 <evdev_event+0x94>
 88c:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 892:	b9 01 00 02 00       	mov    $0x20001,%ecx
 897:	c1 e0 04             	shl    $0x4,%eax
 89a:	66 89 7c 18 08       	mov    %di,0x8(%eax,%ebx,1)
 89f:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 8a5:	c1 e0 04             	shl    $0x4,%eax
 8a8:	66 89 6c 18 0a       	mov    %bp,0xa(%eax,%ebx,1)
 8ad:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 8b3:	8b 14 24             	mov    (%esp),%edx
 8b6:	c1 e0 04             	shl    $0x4,%eax
 8b9:	89 54 18 0c          	mov    %edx,0xc(%eax,%ebx,1)
 8bd:	ba 1d 00 00 00       	mov    $0x1d,%edx
 8c2:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
 8c8:	40                   	inc    %eax
 8c9:	83 e0 3f             	and    $0x3f,%eax
 8cc:	89 83 00 04 00 00    	mov    %eax,0x400(%ebx)
 8d2:	8d 83 08 04 00 00    	lea    0x408(%ebx),%eax
 8d8:	e8 fc ff ff ff       	call   8d9 <evdev_event+0xe5>
 8dd:	8b 9b 10 04 00 00    	mov    0x410(%ebx),%ebx
 8e3:	81 eb 10 04 00 00    	sub    $0x410,%ebx
 8e9:	8b 83 10 04 00 00    	mov    0x410(%ebx),%eax
 8ef:	8d 74 26 00          	lea    0x0(%esi),%esi
 8f3:	8d 93 10 04 00 00    	lea    0x410(%ebx),%edx
 8f9:	8d 46 54             	lea    0x54(%esi),%eax
 8fc:	39 c2                	cmp    %eax,%edx
 8fe:	0f 85 77 ff ff ff    	jne    87b <evdev_event+0x87>
 904:	8d 46 40             	lea    0x40(%esi),%eax
 907:	b9 01 00 00 00       	mov    $0x1,%ecx
 90c:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
 913:	00 
 914:	ba 01 00 00 00       	mov    $0x1,%edx
 919:	5e                   	pop    %esi
 91a:	5b                   	pop    %ebx
 91b:	5e                   	pop    %esi
 91c:	5f                   	pop    %edi
 91d:	5d                   	pop    %ebp
 91e:	e9 fc ff ff ff       	jmp    91f <evdev_event+0x12b>

00000923 <evdev_release>:
 923:	57                   	push   %edi
 924:	89 d7                	mov    %edx,%edi
 926:	56                   	push   %esi
 927:	53                   	push   %ebx
 928:	8b b2 80 00 00 00    	mov    0x80(%edx),%esi
 92e:	8b 9e 0c 04 00 00    	mov    0x40c(%esi),%ebx
 934:	39 73 50             	cmp    %esi,0x50(%ebx)
 937:	75 0f                	jne    948 <evdev_release+0x25>
 939:	8d 43 1c             	lea    0x1c(%ebx),%eax
 93c:	e8 fc ff ff ff       	call   93d <evdev_release+0x1a>
 941:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
 948:	31 c9                	xor    %ecx,%ecx
 94a:	89 fa                	mov    %edi,%edx
 94c:	83 c8 ff             	or     $0xffffffff,%eax
 94f:	e8 f0 f6 ff ff       	call   44 <evdev_fasync>
 954:	8d 8e 10 04 00 00    	lea    0x410(%esi),%ecx
 95a:	8b 96 10 04 00 00    	mov    0x410(%esi),%edx
 960:	8b 41 04             	mov    0x4(%ecx),%eax
 963:	89 42 04             	mov    %eax,0x4(%edx)
 966:	89 10                	mov    %edx,(%eax)
 968:	89 f0                	mov    %esi,%eax
 96a:	c7 86 10 04 00 00 00 	movl   $0x100100,0x410(%esi)
 971:	01 10 00 
 974:	c7 41 04 00 02 20 00 	movl   $0x200200,0x4(%ecx)
 97b:	e8 fc ff ff ff       	call   97c <evdev_release+0x59>
 980:	8b 43 04             	mov    0x4(%ebx),%eax
 983:	48                   	dec    %eax
 984:	85 c0                	test   %eax,%eax
 986:	89 43 04             	mov    %eax,0x4(%ebx)
 989:	75 16                	jne    9a1 <evdev_release+0x7e>
 98b:	83 3b 00             	cmpl   $0x0,(%ebx)
 98e:	74 0a                	je     99a <evdev_release+0x77>
 990:	8d 43 1c             	lea    0x1c(%ebx),%eax
 993:	e8 fc ff ff ff       	call   994 <evdev_release+0x71>
 998:	eb 07                	jmp    9a1 <evdev_release+0x7e>
 99a:	89 d8                	mov    %ebx,%eax
 99c:	e8 c7 f6 ff ff       	call   68 <evdev_free>
 9a1:	5b                   	pop    %ebx
 9a2:	31 c0                	xor    %eax,%eax
 9a4:	5e                   	pop    %esi
 9a5:	5f                   	pop    %edi
 9a6:	c3                   	ret    

000009a7 <evdev_write>:
 9a7:	55                   	push   %ebp
 9a8:	89 cd                	mov    %ecx,%ebp
 9aa:	57                   	push   %edi
 9ab:	56                   	push   %esi
 9ac:	be ed ff ff ff       	mov    $0xffffffed,%esi
 9b1:	53                   	push   %ebx
 9b2:	83 ec 18             	sub    $0x18,%esp
 9b5:	89 54 24 04          	mov    %edx,0x4(%esp)
 9b9:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
 9bf:	8b b8 0c 04 00 00    	mov    0x40c(%eax),%edi
 9c5:	83 3f 00             	cmpl   $0x0,(%edi)
 9c8:	74 47                	je     a11 <evdev_write+0x6a>
 9ca:	eb 1f                	jmp    9eb <evdev_write+0x44>
 9cc:	8b 54 24 04          	mov    0x4(%esp),%edx
 9d0:	8d 44 24 08          	lea    0x8(%esp),%eax
 9d4:	b9 10 00 00 00       	mov    $0x10,%ecx
 9d9:	01 f2                	add    %esi,%edx
 9db:	e8 fc ff ff ff       	call   9dc <evdev_write+0x35>
 9e0:	85 c0                	test   %eax,%eax
 9e2:	74 0f                	je     9f3 <evdev_write+0x4c>
 9e4:	be f2 ff ff ff       	mov    $0xfffffff2,%esi
 9e9:	eb 26                	jmp    a11 <evdev_write+0x6a>
 9eb:	31 f6                	xor    %esi,%esi
 9ed:	39 ee                	cmp    %ebp,%esi
 9ef:	72 db                	jb     9cc <evdev_write+0x25>
 9f1:	eb 1e                	jmp    a11 <evdev_write+0x6a>
 9f3:	8b 5c 24 14          	mov    0x14(%esp),%ebx
 9f7:	8d 47 1c             	lea    0x1c(%edi),%eax
 9fa:	83 c6 10             	add    $0x10,%esi
 9fd:	0f b7 4c 24 12       	movzwl 0x12(%esp),%ecx
 a02:	0f b7 54 24 10       	movzwl 0x10(%esp),%edx
 a07:	89 1c 24             	mov    %ebx,(%esp)
 a0a:	e8 fc ff ff ff       	call   a0b <evdev_write+0x64>
 a0f:	eb dc                	jmp    9ed <evdev_write+0x46>
 a11:	83 c4 18             	add    $0x18,%esp
 a14:	89 f0                	mov    %esi,%eax
 a16:	5b                   	pop    %ebx
 a17:	5e                   	pop    %esi
 a18:	5f                   	pop    %edi
 a19:	5d                   	pop    %ebp
 a1a:	c3                   	ret    

00000a1b <evdev_read>:
 a1b:	55                   	push   %ebp
 a1c:	89 cd                	mov    %ecx,%ebp
 a1e:	57                   	push   %edi
 a1f:	89 c7                	mov    %eax,%edi
 a21:	56                   	push   %esi
 a22:	53                   	push   %ebx
 a23:	83 ec 18             	sub    $0x18,%esp
 a26:	83 f9 0f             	cmp    $0xf,%ecx
 a29:	89 14 24             	mov    %edx,(%esp)
 a2c:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
 a32:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
 a37:	8b b3 0c 04 00 00    	mov    0x40c(%ebx),%esi
 a3d:	0f 86 0e 01 00 00    	jbe    b51 <evdev_read+0x136>
 a43:	8b 83 04 04 00 00    	mov    0x404(%ebx),%eax
 a49:	39 83 00 04 00 00    	cmp    %eax,0x400(%ebx)
 a4f:	75 14                	jne    a65 <evdev_read+0x4a>
 a51:	83 3e 00             	cmpl   $0x0,(%esi)
 a54:	74 0f                	je     a65 <evdev_read+0x4a>
 a56:	f6 47 19 08          	testb  $0x8,0x19(%edi)
 a5a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
 a5f:	0f 85 ec 00 00 00    	jne    b51 <evdev_read+0x136>
 a65:	8b 83 04 04 00 00    	mov    0x404(%ebx),%eax
 a6b:	39 83 00 04 00 00    	cmp    %eax,0x400(%ebx)
 a71:	75 76                	jne    ae9 <evdev_read+0xce>
 a73:	83 3e 00             	cmpl   $0x0,(%esi)
 a76:	74 71                	je     ae9 <evdev_read+0xce>
 a78:	fc                   	cld    
 a79:	31 c0                	xor    %eax,%eax
 a7b:	8d 7c 24 04          	lea    0x4(%esp),%edi
 a7f:	ab                   	stos   %eax,%es:(%edi)
 a80:	ab                   	stos   %eax,%es:(%edi)
 a81:	ab                   	stos   %eax,%es:(%edi)
 a82:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a89:	00 
 a8a:	ab                   	stos   %eax,%es:(%edi)
 a8b:	ab                   	stos   %eax,%es:(%edi)
 a8c:	64 a1 00 00 00 00    	mov    %fs:0x0,%eax
 a92:	89 44 24 08          	mov    %eax,0x8(%esp)
 a96:	8d 44 24 10          	lea    0x10(%esp),%eax
 a9a:	89 44 24 10          	mov    %eax,0x10(%esp)
 a9e:	89 44 24 14          	mov    %eax,0x14(%esp)
 aa2:	8d 46 40             	lea    0x40(%esi),%eax
 aa5:	b9 01 00 00 00       	mov    $0x1,%ecx
 aaa:	8d 54 24 04          	lea    0x4(%esp),%edx
 aae:	e8 fc ff ff ff       	call   aaf <evdev_read+0x94>
 ab3:	8b 83 04 04 00 00    	mov    0x404(%ebx),%eax
 ab9:	39 83 00 04 00 00    	cmp    %eax,0x400(%ebx)
 abf:	75 1c                	jne    add <evdev_read+0xc2>
 ac1:	83 3e 00             	cmpl   $0x0,(%esi)
 ac4:	74 17                	je     add <evdev_read+0xc2>
 ac6:	64 a1 00 00 00 00    	mov    %fs:0x0,%eax
 acc:	8b 40 04             	mov    0x4(%eax),%eax
 acf:	8b 40 08             	mov    0x8(%eax),%eax
 ad2:	a8 04                	test   $0x4,%al
 ad4:	75 6a                	jne    b40 <evdev_read+0x125>
 ad6:	e8 fc ff ff ff       	call   ad7 <evdev_read+0xbc>
 adb:	eb c5                	jmp    aa2 <evdev_read+0x87>
 add:	8d 46 40             	lea    0x40(%esi),%eax
 ae0:	8d 54 24 04          	lea    0x4(%esp),%edx
 ae4:	e8 fc ff ff ff       	call   ae5 <evdev_read+0xca>
 ae9:	83 3e 00             	cmpl   $0x0,(%esi)
 aec:	b8 ed ff ff ff       	mov    $0xffffffed,%eax
 af1:	74 5e                	je     b51 <evdev_read+0x136>
 af3:	eb 1e                	jmp    b13 <evdev_read+0xf8>
 af5:	03 04 24             	add    (%esp),%eax
 af8:	b9 10 00 00 00       	mov    $0x10,%ecx
 afd:	c1 e2 04             	shl    $0x4,%edx
 b00:	8d 14 13             	lea    (%ebx,%edx,1),%edx
 b03:	e8 fc ff ff ff       	call   b04 <evdev_read+0xe9>
 b08:	85 c0                	test   %eax,%eax
 b0a:	74 20                	je     b2c <evdev_read+0x111>
 b0c:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
 b11:	eb 3e                	jmp    b51 <evdev_read+0x136>
 b13:	31 c0                	xor    %eax,%eax
 b15:	8b 93 04 04 00 00    	mov    0x404(%ebx),%edx
 b1b:	39 93 00 04 00 00    	cmp    %edx,0x400(%ebx)
 b21:	74 2e                	je     b51 <evdev_read+0x136>
 b23:	8d 70 10             	lea    0x10(%eax),%esi
 b26:	39 ee                	cmp    %ebp,%esi
 b28:	76 cb                	jbe    af5 <evdev_read+0xda>
 b2a:	eb 25                	jmp    b51 <evdev_read+0x136>
 b2c:	8b 83 04 04 00 00    	mov    0x404(%ebx),%eax
 b32:	40                   	inc    %eax
 b33:	83 e0 3f             	and    $0x3f,%eax
 b36:	89 83 04 04 00 00    	mov    %eax,0x404(%ebx)
 b3c:	89 f0                	mov    %esi,%eax
 b3e:	eb d5                	jmp    b15 <evdev_read+0xfa>
 b40:	8d 46 40             	lea    0x40(%esi),%eax
 b43:	8d 54 24 04          	lea    0x4(%esp),%edx
 b47:	e8 fc ff ff ff       	call   b48 <evdev_read+0x12d>
 b4c:	b8 00 fe ff ff       	mov    $0xfffffe00,%eax
 b51:	83 c4 18             	add    $0x18,%esp
 b54:	5b                   	pop    %ebx
 b55:	5e                   	pop    %esi
 b56:	5f                   	pop    %edi
 b57:	5d                   	pop    %ebp
 b58:	c3                   	ret    

00000b59 <evdev_open>:
 b59:	55                   	push   %ebp
 b5a:	57                   	push   %edi
 b5b:	56                   	push   %esi
 b5c:	53                   	push   %ebx
 b5d:	83 ec 04             	sub    $0x4,%esp
 b60:	89 14 24             	mov    %edx,(%esp)
 b63:	8b 40 34             	mov    0x34(%eax),%eax
 b66:	25 ff ff 0f 00       	and    $0xfffff,%eax
 b6b:	83 e8 40             	sub    $0x40,%eax
 b6e:	83 f8 1f             	cmp    $0x1f,%eax
 b71:	0f 8f a4 00 00 00    	jg     c1b <evdev_open+0xc2>
 b77:	8b 1c 85 00 00 00 00 	mov    0x0(,%eax,4),%ebx
 b7e:	85 db                	test   %ebx,%ebx
 b80:	0f 84 95 00 00 00    	je     c1b <evdev_open+0xc2>
 b86:	83 3b 00             	cmpl   $0x0,(%ebx)
 b89:	0f 84 8c 00 00 00    	je     c1b <evdev_open+0xc2>
 b8f:	a1 4c 00 00 00       	mov    0x4c,%eax
 b94:	ba d0 00 00 00       	mov    $0xd0,%edx
 b99:	bd f4 ff ff ff       	mov    $0xfffffff4,%ebp
 b9e:	e8 fc ff ff ff       	call   b9f <evdev_open+0x46>
 ba3:	85 c0                	test   %eax,%eax
 ba5:	89 c6                	mov    %eax,%esi
 ba7:	74 77                	je     c20 <evdev_open+0xc7>
 ba9:	89 98 0c 04 00 00    	mov    %ebx,0x40c(%eax)
 baf:	8d b8 10 04 00 00    	lea    0x410(%eax),%edi
 bb5:	8d 43 54             	lea    0x54(%ebx),%eax
 bb8:	8b 50 04             	mov    0x4(%eax),%edx
 bbb:	89 86 10 04 00 00    	mov    %eax,0x410(%esi)
 bc1:	89 78 04             	mov    %edi,0x4(%eax)
 bc4:	89 3a                	mov    %edi,(%edx)
 bc6:	89 57 04             	mov    %edx,0x4(%edi)
 bc9:	8b 43 04             	mov    0x4(%ebx),%eax
 bcc:	40                   	inc    %eax
 bcd:	89 43 04             	mov    %eax,0x4(%ebx)
 bd0:	48                   	dec    %eax
 bd1:	75 3b                	jne    c0e <evdev_open+0xb5>
 bd3:	83 3b 00             	cmpl   $0x0,(%ebx)
 bd6:	74 36                	je     c0e <evdev_open+0xb5>
 bd8:	8d 43 1c             	lea    0x1c(%ebx),%eax
 bdb:	e8 fc ff ff ff       	call   bdc <evdev_open+0x83>
 be0:	85 c0                	test   %eax,%eax
 be2:	89 c5                	mov    %eax,%ebp
 be4:	74 28                	je     c0e <evdev_open+0xb5>
 be6:	8b 47 04             	mov    0x4(%edi),%eax
 be9:	8b 96 10 04 00 00    	mov    0x410(%esi),%edx
 bef:	89 42 04             	mov    %eax,0x4(%edx)
 bf2:	89 10                	mov    %edx,(%eax)
 bf4:	89 f0                	mov    %esi,%eax
 bf6:	c7 86 10 04 00 00 00 	movl   $0x100100,0x410(%esi)
 bfd:	01 10 00 
 c00:	c7 47 04 00 02 20 00 	movl   $0x200200,0x4(%edi)
 c07:	e8 fc ff ff ff       	call   c08 <evdev_open+0xaf>
 c0c:	eb 12                	jmp    c20 <evdev_open+0xc7>
 c0e:	8b 04 24             	mov    (%esp),%eax
 c11:	31 ed                	xor    %ebp,%ebp
 c13:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
 c19:	eb 05                	jmp    c20 <evdev_open+0xc7>
 c1b:	bd ed ff ff ff       	mov    $0xffffffed,%ebp
 c20:	5f                   	pop    %edi
 c21:	89 e8                	mov    %ebp,%eax
 c23:	5b                   	pop    %ebx
 c24:	5e                   	pop    %esi
 c25:	5f                   	pop    %edi
 c26:	5d                   	pop    %ebp
 c27:	c3                   	ret    
Disassembly of section .exit.text:

00000000 <cleanup_module>:
   0:	b8 00 00 00 00       	mov    $0x0,%eax
   5:	e9 fc ff ff ff       	jmp    6 <cleanup_module+0x6>
Disassembly of section .altinstr_replacement:

00000000 <.altinstr_replacement>:
   0:	0f 18 00             	prefetchnta (%eax)
   3:	0f 18 00             	prefetchnta (%eax)
Disassembly of section .init.text:

00000000 <init_module>:
   0:	b8 00 00 00 00       	mov    $0x0,%eax
   5:	e9 fc ff ff ff       	jmp    6 <init_module+0x6>
Disassembly of section .rodata:

00000000 <__mod_input_device_table-0x60>:
   0:	dc 03                	faddl  (%ebx)
   2:	00 00                	add    %al,(%eax)
   4:	e6 03                	out    %al,$0x3
   6:	00 00                	add    %al,(%eax)
   8:	f0 03 00             	lock add (%eax),%eax
   b:	00 f5                	add    %dh,%ch
   d:	03 00                	add    (%eax),%eax
   f:	00 ff                	add    %bh,%bh
  11:	03 00                	add    (%eax),%eax
  13:	00 1d 04 00 00 e4    	add    %bl,0xe4000004
  19:	05 00 00 e4 05       	add    $0x5e40000,%eax
  1e:	00 00                	add    %al,(%eax)
  20:	e4 05                	in     $0x5,%al
  22:	00 00                	add    %al,(%eax)
  24:	e4 05                	in     $0x5,%al
  26:	00 00                	add    %al,(%eax)
  28:	e4 05                	in     $0x5,%al
  2a:	00 00                	add    %al,(%eax)
  2c:	e4 05                	in     $0x5,%al
  2e:	00 00                	add    %al,(%eax)
  30:	e4 05                	in     $0x5,%al
  32:	00 00                	add    %al,(%eax)
  34:	e4 05                	in     $0x5,%al
  36:	00 00                	add    %al,(%eax)
  38:	e4 05                	in     $0x5,%al
  3a:	00 00                	add    %al,(%eax)
  3c:	e4 05                	in     $0x5,%al
  3e:	00 00                	add    %al,(%eax)
  40:	e4 05                	in     $0x5,%al
  42:	00 00                	add    %al,(%eax)
  44:	04 04                	add    $0x4,%al
  46:	00 00                	add    %al,(%eax)
  48:	09 04 00             	or     %eax,(%eax,%eax,1)
  4b:	00 e4                	add    %ah,%ah
  4d:	05 00 00 e4 05       	add    $0x5e40000,%eax
  52:	00 00                	add    %al,(%eax)
  54:	13 04 00             	adc    (%eax,%eax,1),%eax
	...

00000060 <__mod_input_device_table>:
	...
  dc:	01 00                	add    %eax,(%eax)
	...

00000160 <evdev_fops>:
	...
 168:	1b 0a                	sbb    (%edx),%ecx
 16a:	00 00                	add    %al,(%eax)
 16c:	a7                   	cmpsl  %es:(%edi),%ds:(%esi)
 16d:	09 00                	or     %eax,(%eax)
	...
 183:	00 06                	add    %al,(%esi)
 185:	01 00                	add    %eax,(%eax)
	...
 18f:	00 59 0b             	add    %bl,0xb(%ecx)
 192:	00 00                	add    %al,(%eax)
 194:	7b 00                	jnp    196 <evdev_fops+0x36>
 196:	00 00                	add    %al,(%eax)
 198:	23 09                	and    (%ecx),%ecx
	...
 1a2:	00 00                	add    %al,(%eax)
 1a4:	44                   	inc    %esp
	...
Disassembly of section .altinstructions:

00000000 <.altinstructions>:
   0:	6a 06                	push   $0x6
   2:	00 00                	add    %al,(%eax)
   4:	00 00                	add    %al,(%eax)
   6:	00 00                	add    %al,(%eax)
   8:	19 04 03             	sbb    %eax,(%ebx,%eax,1)
   b:	00 ef                	add    %ch,%bh
   d:	08 00                	or     %al,(%eax)
   f:	00 03                	add    %al,(%ebx)
  11:	00 00                	add    %al,(%eax)
  13:	00 19                	add    %bl,(%ecx)
  15:	04 03                	add    $0x3,%al
Disassembly of section .rodata.str1.1:

00000000 <.rodata.str1.1>:
   0:	3c 33                	cmp    $0x33,%al
   2:	3e                   	ds
   3:	65                   	gs
   4:	76 64                	jbe    6a <evdev_free+0x2>
   6:	65                   	gs
   7:	76 3a                	jbe    43 <__mod_description740+0x3>
   9:	20 6e 6f             	and    %ch,0x6f(%esi)
   c:	20 6d 6f             	and    %ch,0x6f(%ebp)
   f:	72 65                	jb     76 <__mod_license741+0xa>
  11:	20 66 72             	and    %ah,0x72(%esi)
  14:	65 65 20 65 76       	and    %ah,%gs:0x76(%ebp)
  19:	64                   	fs
  1a:	65                   	gs
  1b:	76 20                	jbe    3d <evdev_poll+0x3d>
  1d:	64                   	fs
  1e:	65                   	gs
  1f:	76 69                	jbe    8a <__mod_vermagic5+0xa>
  21:	63 65 73             	arpl   %sp,0x73(%ebp)
  24:	0a 00                	or     (%eax),%al
  26:	65                   	gs
  27:	76 65                	jbe    8e <__mod_vermagic5+0xe>
  29:	6e                   	outsb  %ds:(%esi),(%dx)
  2a:	74 25                	je     51 <evdev_fasync+0xd>
  2c:	64 00 65 76          	add    %ah,%fs:0x76(%ebp)
  30:	64                   	fs
  31:	65                   	gs
  32:	76 00                	jbe    34 <evdev_poll+0x34>
Disassembly of section .modinfo:

00000000 <__mod_author739>:
   0:	61                   	popa   
   1:	75 74                	jne    77 <__mod_license741+0xb>
   3:	68 6f 72 3d 56       	push   $0x563d726f
   8:	6f                   	outsl  %ds:(%esi),(%dx)
   9:	6a 74                	push   $0x74
   b:	65 63 68 20          	arpl   %bp,%gs:0x20(%eax)
   f:	50                   	push   %eax
  10:	61                   	popa   
  11:	76 6c                	jbe    7f <__mod_license741+0x13>
  13:	69 6b 20 3c 76 6f 6a 	imul   $0x6a6f763c,0x20(%ebx),%ebp
  1a:	74 65                	je     81 <__mod_vermagic5+0x1>
  1c:	63 68 40             	arpl   %bp,0x40(%eax)
  1f:	75 63                	jne    84 <__mod_vermagic5+0x4>
  21:	77 2e                	ja     51 <__mod_description740+0x11>
  23:	63 7a 3e             	arpl   %di,0x3e(%edx)
	...

00000040 <__mod_description740>:
  40:	64                   	fs
  41:	65                   	gs
  42:	73 63                	jae    a7 <__mod_vermagic5+0x27>
  44:	72 69                	jb     af <__mod_vermagic5+0x2f>
  46:	70 74                	jo     bc <__module_depends+0x4>
  48:	69 6f 6e 3d 49 6e 70 	imul   $0x706e493d,0x6e(%edi),%ebp
  4f:	75 74                	jne    c5 <__module_depends+0xd>
  51:	20 64 72 69          	and    %ah,0x69(%edx,%esi,2)
  55:	76 65                	jbe    bc <__module_depends+0x4>
  57:	72 20                	jb     79 <__mod_license741+0xd>
  59:	65                   	gs
  5a:	76 65                	jbe    c1 <__module_depends+0x9>
  5c:	6e                   	outsb  %ds:(%esi),(%dx)
  5d:	74 20                	je     7f <__mod_license741+0x13>
  5f:	63 68 61             	arpl   %bp,0x61(%eax)
  62:	72 20                	jb     84 <__mod_vermagic5+0x4>
  64:	64                   	fs
  65:	65                   	gs
  66:	76 69                	jbe    d1 <__module_depends+0x19>
  68:	63 65 73             	arpl   %sp,0x73(%ebp)
	...

0000006c <__mod_license741>:
  6c:	6c                   	insb   (%dx),%es:(%edi)
  6d:	69 63 65 6e 73 65 3d 	imul   $0x3d65736e,0x65(%ebx),%esp
  74:	47                   	inc    %edi
  75:	50                   	push   %eax
  76:	4c                   	dec    %esp
	...

00000080 <__mod_vermagic5>:
  80:	76 65                	jbe    e7 <__mod_alias22+0x7>
  82:	72 6d                	jb     f1 <__mod_alias22+0x11>
  84:	61                   	popa   
  85:	67 69 63 3d 32 2e 36 	addr16 imul $0x2e362e32,61(%bp,%di),%esp
  8c:	2e 
  8d:	32 32                	xor    (%edx),%dh
  8f:	2d 31 2d 6d 65       	sub    $0x656d2d31,%eax
  94:	70 69                	jo     ff <__mod_alias22+0x1f>
  96:	73 2d                	jae    c5 <__module_depends+0xd>
  98:	73 6d                	jae    107 <__mod_alias22+0x27>
  9a:	70 20                	jo     bc <__module_depends+0x4>
  9c:	53                   	push   %ebx
  9d:	4d                   	dec    %ebp
  9e:	50                   	push   %eax
  9f:	20 70 72             	and    %dh,0x72(%eax)
  a2:	65                   	gs
  a3:	65                   	gs
  a4:	6d                   	insl   (%dx),%es:(%edi)
  a5:	70 74                	jo     11b <evdev_ioctl+0x15>
  a7:	20 6d 6f             	and    %ch,0x6f(%ebp)
  aa:	64                   	fs
  ab:	5f                   	pop    %edi
  ac:	75 6e                	jne    11c <evdev_ioctl+0x16>
  ae:	6c                   	insb   (%dx),%es:(%edi)
  af:	6f                   	outsl  %ds:(%esi),(%dx)
  b0:	61                   	popa   
  b1:	64 20 36             	and    %dh,%fs:(%esi)
  b4:	38 36                	cmp    %dh,(%esi)
  b6:	20 00                	and    %al,(%eax)

000000b8 <__module_depends>:
  b8:	64                   	fs
  b9:	65                   	gs
  ba:	70 65                	jo     121 <evdev_ioctl+0x1b>
  bc:	6e                   	outsb  %ds:(%esi),(%dx)
  bd:	64                   	fs
  be:	73 3d                	jae    fd <__mod_alias22+0x1d>
	...

000000e0 <__mod_alias22>:
  e0:	61                   	popa   
  e1:	6c                   	insb   (%dx),%es:(%edi)
  e2:	69 61 73 3d 69 6e 70 	imul   $0x706e693d,0x73(%ecx),%esp
  e9:	75 74                	jne    15f <evdev_ioctl+0x59>
  eb:	3a 62 2a             	cmp    0x2a(%edx),%ah
  ee:	76 2a                	jbe    11a <evdev_ioctl+0x14>
  f0:	70 2a                	jo     11c <evdev_ioctl+0x16>
  f2:	65 2a 2d 65 2a 6b 2a 	sub    %gs:0x2a6b2a65,%ch
  f9:	72 2a                	jb     125 <evdev_ioctl+0x1f>
  fb:	61                   	popa   
  fc:	2a 6d 2a             	sub    0x2a(%ebp),%ch
  ff:	6c                   	insb   (%dx),%es:(%edi)
 100:	2a 73 2a             	sub    0x2a(%ebx),%dh
 103:	66                   	data16
 104:	2a 77 2a             	sub    0x2a(%edi),%dh
	...
Disassembly of section .data:

00000000 <evdev_handler>:
   0:	00 00                	add    %al,(%eax)
   2:	00 00                	add    %al,(%eax)
   4:	f4                   	hlt    
   5:	07                   	pop    %es
   6:	00 00                	add    %al,(%eax)
   8:	a2 06 00 00 f1       	mov    %al,0xf1000006
   d:	05 00 00 00 00       	add    $0x0,%eax
  12:	00 00                	add    %al,(%eax)
  14:	60                   	pusha  
  15:	01 00                	add    %eax,(%eax)
  17:	00 40 00             	add    %al,0x0(%eax)
  1a:	00 00                	add    %al,(%eax)
  1c:	2e 00 00             	add    %al,%cs:(%eax)
  1f:	00 60 00             	add    %ah,0x0(%eax)
	...
Disassembly of section .gnu.linkonce.this_module:

00000000 <__this_module>:
	...
   c:	65                   	gs
   d:	76 64                	jbe    73 <__this_module+0x73>
   f:	65                   	gs
  10:	76 00                	jbe    12 <__this_module+0x12>
	...
Disassembly of section .bss:

00000000 <evdev_table>:
	...
Disassembly of section .comment:

00000000 <.comment>:
   0:	00 47 43             	add    %al,0x43(%edi)
   3:	43                   	inc    %ebx
   4:	3a 20                	cmp    (%eax),%ah
   6:	28 47 4e             	sub    %al,0x4e(%edi)
   9:	55                   	push   %ebp
   a:	29 20                	sub    %esp,(%eax)
   c:	34 2e                	xor    $0x2e,%al
   e:	31 2e                	xor    %ebp,(%esi)
  10:	32 20                	xor    (%eax),%ah
  12:	32 30                	xor    (%eax),%dh
  14:	30 36                	xor    %dh,(%esi)
  16:	31 31                	xor    %esi,(%ecx)
  18:	31 35 20 28 70 72    	xor    %esi,0x72702820
  1e:	65                   	gs
  1f:	72 65                	jb     86 <__mod_vermagic5+0x6>
  21:	6c                   	insb   (%dx),%es:(%edi)
  22:	65                   	gs
  23:	61                   	popa   
  24:	73 65                	jae    8b <__mod_vermagic5+0xb>
  26:	29 20                	sub    %esp,(%eax)
  28:	28 44 65 62          	sub    %al,0x62(%ebp)
  2c:	69 61 6e 20 34 2e 31 	imul   $0x312e3420,0x6e(%ecx),%esp
  33:	2e 31 2d 32 31 29 00 	xor    %ebp,%cs:0x293132
  3a:	00 47 43             	add    %al,0x43(%edi)
  3d:	43                   	inc    %ebx
  3e:	3a 20                	cmp    (%eax),%ah
  40:	28 47 4e             	sub    %al,0x4e(%edi)
  43:	55                   	push   %ebp
  44:	29 20                	sub    %esp,(%eax)
  46:	34 2e                	xor    $0x2e,%al
  48:	31 2e                	xor    %ebp,(%esi)
  4a:	32 20                	xor    (%eax),%ah
  4c:	32 30                	xor    (%eax),%dh
  4e:	30 36                	xor    %dh,(%esi)
  50:	31 31                	xor    %esi,(%ecx)
  52:	31 35 20 28 70 72    	xor    %esi,0x72702820
  58:	65                   	gs
  59:	72 65                	jb     c0 <__module_depends+0x8>
  5b:	6c                   	insb   (%dx),%es:(%edi)
  5c:	65                   	gs
  5d:	61                   	popa   
  5e:	73 65                	jae    c5 <__module_depends+0xd>
  60:	29 20                	sub    %esp,(%eax)
  62:	28 44 65 62          	sub    %al,0x62(%ebp)
  66:	69 61 6e 20 34 2e 31 	imul   $0x312e3420,0x6e(%ecx),%esp
  6d:	2e 31 2d 32 31 29 00 	xor    %ebp,%cs:0x293132
