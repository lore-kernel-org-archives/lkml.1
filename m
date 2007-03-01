Return-Path: <linux-kernel-owner+w=401wt.eu-S965555AbXCAUMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965555AbXCAUMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 15:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965558AbXCAUMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 15:12:51 -0500
Received: from mailin1.k-net.dk ([82.211.192.11]:3579 "EHLO mailin1.k-net.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965555AbXCAUMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 15:12:49 -0500
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
From: Kristian =?ISO-8859-1?Q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <200703010036.28166.dtor@insightbb.com>
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <1172622441.4587.14.camel@localhost.localdomain>
	 <200702281345.15098.rjw@sisk.pl>  <200703010036.28166.dtor@insightbb.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Mar 2007 21:04:52 +0100
Message-Id: <1172779492.7396.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 00:36 -0500, Dmitry Torokhov wrote:
> On Wednesday 28 February 2007 07:45, Rafael J. Wysocki wrote:
> > 
> > > This gives:
> > > 
> > > (gdb) l *evdev_disconnect+0xb1
> > > 0xa81 is in evdev_disconnect (include/asm/processor.h:716).
> > > 711        However we don't do prefetches for pre XP Athlons currently
> > > 712        That should be fixed. */
> > > 713     #define ARCH_HAS_PREFETCH
> > > 714     static inline void prefetch(const void *x)
> > > 715     {
> > > 716             alternative_input(ASM_NOP4,
> > > 717                               "prefetchnta (%1)",
> > > 718                               X86_FEATURE_XMM,
> > > 719                               "r" (x));
> > > 720     }
> > 
> > Hm, interesting.  Looks like a pointer points to nowhere in
> > input_unregister_device(), but I don't know which one.  This may be
> > an evdev problem ...
> > 
> 
> Please try the patch below.

Hmmm.

Now i get this BUG:

BUG: unable to handle kernel paging request at virtual address 6b6b6b6b
 printing eip:
f884aa91
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: tg3 i915 drm binfmt_misc rfcomm l2cap ipv6 fuse
capability commoncap cpufreq_performance aoe af_packet nls_utf8 ntfs
nls_iso8859_1 nls_cp437 vfat fat dm_snapshot dm_mirror dm_mod
ieee80211_crypt_tkip ieee80211_crypt pd6729 snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_seq_device
sermouse hci_vhci hci_uart wbsd mmc_block mmc_core tun msr cpuid
cpufreq_stats container video backlight fan button speedstep_lib thermal
battery ac speedstep_centrino processor sr_mod sbp2 scsi_mod ide_cd
cdrom eth1394 hci_usb snd_intel8x0 pcmcia firmware_class snd_intel8x0m
bluetooth snd_ac97_codec snd_pcm_oss snd_mixer_oss ac97_bus irda snd_pcm
snd_timer i2c_i801 pcspkr crc_ccitt ohci1394 ieee1394 rtc yenta_socket
rsrc_nonstatic pcmcia_core serio_raw i2c_core snd soundcore
snd_page_alloc iTCO_wdt ehci_hcd uhci_hcd usbcore intel_agp agpgart
evdev mousedev
CPU:    0
EIP:    0060:[<f884aa91>]    Not tainted VLI
EFLAGS: 00010202   (2.6.21-rc2-x300 #2)
EIP is at evdev_disconnect+0xc1/0xe0 [evdev]
eax: 00000000   ebx: 6b6b675b   ecx: 10000000   edx: 00000000
esi: f6db01a8   edi: f6db021c   ebp: e0e5dea4   esp: e0e5de94
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process modprobe (pid: 5968, ti=e0e5c000 task=c1a5cac0 task.ti=e0e5c000)
Stack: 00000000 f884c728 f6db01d8 f713832c e0e5dec4 c02aa9ff 00000000
f7138a58
       f7138a58 f6d6d808 c1a1202c c1a12238 e0e5ded4 f8e9e0c5 c1a1202c
f8e9fde0
       e0e5dee8 c025f6d4 c1a12238 f8e9feb0 f8e9feb0 e0e5def8 c028d84a
c1a12238
Call Trace:
 [<c010520a>] show_trace_log_lvl+0x1a/0x30
 [<c01052c9>] show_stack_log_lvl+0xa9/0xd0
 [<c010550c>] show_registers+0x21c/0x3a0
 [<c0105794>] die+0x104/0x240
 [<c0115bb5>] do_page_fault+0x2b5/0x5c0
 [<c03384ac>] error_code+0x74/0x7c
 [<c02aa9ff>] input_unregister_device+0xaf/0x140
 [<f8e9e0c5>] acpi_button_remove+0x2b/0x3f [button]
 [<c025f6d4>] acpi_device_remove+0x40/0x62
 [<c028d84a>] __device_release_driver+0x6a/0xa0
 [<c028df65>] driver_detach+0xf5/0x100
 [<c028cc67>] bus_remove_driver+0x97/0xc0
 [<c028df9b>] driver_unregister+0xb/0x20
 [<c0260aa2>] acpi_bus_unregister_driver+0xd/0xf
 [<f8e9e7d9>] acpi_button_exit+0xd/0x6a [button]
 [<c013feb2>] sys_delete_module+0x142/0x1b0
 [<c0104240>] syscall_call+0x7/0xb
 =======================
Code: f8 74 a4 8d b4 26 00 00 00 00 8d 83 08 04 00 00 b9 06 00 02 00 ba
1d 00 00 00 e8 8b 24 93 c7 8b 9b 10 04 00 00 81 eb 10 04 00 00 <8b> 83
10 04 00 00 0f 18 00 9
EIP: [<f884aa91>] evdev_disconnect+0xc1/0xe0 [evdev] SS:ESP
0068:e0e5de94

gdb points me in the same direction as before:

(gdb) l *evdev_disconnect+0xc1
0xa91 is in evdev_disconnect (include/asm/processor.h:716).
711        However we don't do prefetches for pre XP Athlons currently
712        That should be fixed. */
713     #define ARCH_HAS_PREFETCH
714     static inline void prefetch(const void *x)
715     {
716             alternative_input(ASM_NOP4,
717                               "prefetchnta (%1)",
718                               X86_FEATURE_XMM,
719                               "r" (x));
720     }

/Kristian
