Return-Path: <linux-kernel-owner+w=401wt.eu-S935293AbXGUWLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935293AbXGUWLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764717AbXGUWK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:10:56 -0400
Received: from smtpa3.netcabo.pt ([212.113.174.18]:30153 "EHLO
	exch01smtp02.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934989AbXGUWKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:10:53 -0400
Message-ID: <46A283A1.6030005@rncbc.org>
Date: Sat, 21 Jul 2007 23:07:29 +0100
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>
Subject: 2.6.22.1-rt4 lockups
References: <1184325752.12353.312.camel@chaos>
In-Reply-To: <1184325752.12353.312.camel@chaos>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jul 2007 22:10:42.0848 (UTC) FILETIME=[FAC38200:01C7CBE3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As with -rt3, I was able to capture one more crash trace, via serial
console, with nmi_watchdog=1.

Yes, current 2.6.22.1-rt4 is still locking-up on my ix86 SMT/SMP boxes.
I'll have to wait for some hours of uptime and normal desktop use and
then it just locks-up without warning.

Last couple of occurrences were all while browsing with firefox
(2.0.0.5) or using openoffice.org (2.0.4) but in rare and
non-deterministic fashion I must say.

It looks very similar to the previous ones I've reported before for
-rt3, but I am no expert in these things.

...
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: tun appletalk ax25 ipx p8023 snd_rtctimer
snd_seq_dummy snd_pcm_oss snd_mixer_oss snd_seq_midi snd_seq_midi_event
snd_seq w83627hf hwmon_vid hwmon eeprom button battery ac loop dm_mod
wacom usbhid hid ff_memless ohci1394 ieee1394 nvidia(P) snd_cs46xx
gameport firewire_ohci snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
snd_cs8427 snd_i2c snd_mpu401_uart snd_rawmidi snd_seq_device
firewire_core sk98lin snd_intel8x0 crc_itu_t snd_ac97_codec ac97_bus
ide_cd snd_pcm cdrom snd_timer uhci_hcd ehci_hcd i2c_i801 snd rtc_cmos
shpchp iTCO_wdt i2c_core usbcore rtc_core pci_hotplug soundcore
intel_agp rtc_lib agpgart snd_page_alloc ext3 mbcache jbd edd fan piix
thermal processor ide_disk ide_core
CPU:    0
EIP:    0060:[<00000000>]    Tainted: P       VLI
EFLAGS: 00213006   (2.6.22.1-rt4.0 #1)
EIP is at _stext+0x3feff000/0x20
eax: c1812a80   ebx: c03bb540   ecx: 00000001   edx: c038e3c0
esi: c038e3c0   edi: 00000001   ebp: f6fe1d6c   esp: f6fe1d50
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068  preempt:00000003
Process Xorg (pid: 4101, ti=f6fe1000 task=f754ec30 task.ti=f6fe1000)
Stack: c011a94c 04882eab 00000ca9 c1812a80 c1812a80 04882eab 00000ca9
f6fe1d90
       c011b4af 04882eab 00000ca9 00000001 c038e3c0 00000000 00000000
c038e3c0
       f6fe1df4 c011e09d f6fe1dfc c011de3b 00000000 0000001f c1812a80
0000001f
Call Trace:
 [<c010622a>] show_trace_log_lvl+0x1a/0x30
 [<c01062f6>] show_stack_log_lvl+0xb6/0xe0
 [<c0106521>] show_registers+0x201/0x330
 [<c0106768>] die+0x118/0x260
 [<c0304233>] do_page_fault+0x193/0x600
 [<c030294a>] error_code+0x72/0x78
 [<c011b4af>] activate_task+0x4f/0xb0
 [<c011e09d>] try_to_wake_up+0x2bd/0x420
 [<c011e279>] wake_up_process_mutex+0x19/0x20
 [<c01425cc>] wakeup_next_waiter+0xec/0x1a0
 [<c030173c>] rt_spin_lock_slowunlock+0x4c/0x70
 [<c0301ff6>] rt_spin_unlock+0x26/0x30
 [<c015b3e4>] put_zone_pcp+0x14/0x20
 [<c015c265>] get_page_from_freelist+0x145/0x380
 [<c015c4f4>] __alloc_pages+0x54/0x2d0
 [<c01652bd>] __handle_mm_fault+0x7dd/0x9a0
 [<c0304398>] do_page_fault+0x2f8/0x600
 [<c030294a>] error_code+0x72/0x78
 =======================
Code:  Bad EIP value.
EIP: [<00000000>] _stext+0x3feff000/0x20 SS:ESP 0068:f6fe1d50
NMI watchdog detected lockup on CPU#1 (5000/5000)
...


Complete serial console capture:

  http://www.rncbc.org/datahub/console-2.6.22.1-rt4.0-1.log

.config evidence:

  http://www.rncbc.org/datahub/config-2.6.22.1-rt4.0

Cheers.
--
rncbc aka Rui Nuno Capela
