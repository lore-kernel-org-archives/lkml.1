Return-Path: <linux-kernel-owner+w=401wt.eu-S1751381AbZAXFsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbZAXFsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 00:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750762AbZAXFsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 00:48:33 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:33055 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZAXFsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 00:48:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=pkmWVfuq6F1ISHyfMaQZjSa1boNmQooMvFJdz1xe/8TWo6kr9g54/iT70uFHAE+yW8
         k4cWSRRJiCE9FIvzQHLRzXJSv9ZJLaqtbFLNXynJUZmCR+pt+jqdMfp1h8ma4Hmy4uX0
         YzOe2Nu6dyq4uyCoxAXfJeCIJ/ri9eKVCRPrc=
Date: Sat, 24 Jan 2009 06:48:19 +0100
From: Damjan <gdamjan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.28.1 Warning in i915_gem.c and BUG in
 journal_grab_journal_head ?
Message-ID: <497aaba3.Pd6yV0NXF0n7ZXkL%gdamjan@gmail.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone understand what happened here?
My kernel is 2.6.28.1 + some patches (thinkpad_acpi, tp_smapi and tuxonice).
My PC is a Thinkpad X60s (32bit CoreDuo, intel 945 video).
I'm running ArchLinux  with X server 1.5.3 and intel driver 1.6.1 (set to UXA).

I beleive this error happened when I switched to the console (ctrl-alt-f1) 
from KDE running it's compozitor. I then tried to logout the user, but a 
process called nepomukservices remained in the D state. 

/home couldn't be unmounted, and finally when I tried to reboot, the 
reboot process hanged at "swapoff -a". I had to hard-reboot. 
My /home is ext4, / is ext3.


Note there's one WARNING and one BUG in the following log:


------------[ cut here ]------------
WARNING: at /home/damjan/kernel/linux-2.6.28-git/drivers/gpu/drm/i915/i915_gem.c:2470 i915_gem_idle+0x166/0x2e8 [i915]()
Modules linked in: iwl3945 mac80211 button btusb i915 drm af_packet sco bridge rfcomm stp llc hid_dell hid_pl hid_cypress hid_zpff hid_gyration hid_bright hid_sony hid_samsung hid_microsoft hid_tmff hid_monterey hid_ezkey hid_apple hid_a4tech hid_logitech usbhid ff_memless hid_cherry bnep hid_sunplus hid_petalynx hid_belkin hid_chicony hidp hid l2cap bluetooth snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 ecb thinkpad_acpi irtty_sir pcmcia firmware_class snd_pcm_oss snd_mixer_oss ata_generic rfkill sdhci_pci sdhci sir_dev uhci_hcd firewire_ohci firewire_core crc_itu_t led_class nvram cfg80211 pcspkr mmc_core ehci_hcd yenta_socket rsrc_nonstatic sg usbcore pcmcia_core ata_piix iTCO_wdt snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc e1000e thermal fan battery ac ppp_async ppp_generic slhc tun kvm_intel kvm coretemp acpi_cpufreq joydev processor video backlight output fuse hdaps tp_smapi thinkpad_ec nsc_ircc irda crc_ccitt psmouse rtc_cmos rtc_core rtc_lib [last unloaded: i2c_i801]
Pid: 31863, comm: X Not tainted 2.6.28.1-dg #8
Call Trace:
 [<b012813d>] warn_on_slowpath+0x40/0x61
 [<b012ff00>] lock_timer_base+0x13/0x35
 [<b0326b52>] _spin_unlock_irqrestore+0x22/0x39
 [<b021f060>] __next_cpu+0x12/0x21
 [<b0135ab6>] __cancel_work_timer+0x106/0x144
 [<f02f7039>] i915_gem_retire_requests+0xeb/0x103 [i915]
 [<f02f7039>] i915_gem_retire_requests+0xeb/0x103 [i915]
 [<f02f7732>] i915_gem_idle+0x166/0x2e8 [i915]
 [<f02f78da>] i915_gem_leavevt_ioctl+0x9/0x17 [i915]
 [<f05a44c4>] drm_ioctl+0x1a3/0x21a [drm]
 [<f02f78d1>] i915_gem_leavevt_ioctl+0x0/0x17 [i915]
 [<b01958ca>] vfs_ioctl+0x49/0x5f
 [<b0195d5d>] do_vfs_ioctl+0x3ab/0x3d6
 [<b018bfa9>] vfs_write+0xe6/0x121
 [<b0195db4>] sys_ioctl+0x2c/0x42
 [<b01039c3>] sysenter_do_call+0x12/0x2f
---[ end trace b858a7be60ae0a82 ]---
mtrr: no MTRR for d0000000,10000000 found
mtrr: no MTRR for d0000000,10000000 found
mtrr: no MTRR for d0000000,10000000 found
wlan0: authenticate with AP 00:11:2f:d9:a6:40
wlan0: authenticate with AP 00:11:2f:d9:a6:40
wlan0: authenticated
wlan0: associate with AP 00:11:2f:d9:a6:40
wlan0: RX ReassocResp from 00:11:2f:d9:a6:40 (capab=0x401 status=0 aid=2)
wlan0: associated
noseguy[1141]: segfault at 4 ip 0804a25b sp affd10b0 error 4 in noseguy[8048000+d000]
BUG: unable to handle kernel NULL pointer dereference at 00000081
IP: [<b01faab9>] journal_grab_journal_head+0x41/0x89
*pde = 00000000 
Oops: 0002 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/virtual/backlight/acpi_video0/brightness
Modules linked in: iwl3945 mac80211 button btusb i915 drm af_packet sco bridge rfcomm stp llc hid_dell hid_pl hid_cypress hid_zpff hid_gyration hid_bright hid_sony hid_samsung hid_microsoft hid_tmff hid_monterey hid_ezkey hid_apple hid_a4tech hid_logitech usbhid ff_memless hid_cherry bnep hid_sunplus hid_petalynx hid_belkin hid_chicony hidp hid l2cap bluetooth snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device arc4 ecb thinkpad_acpi irtty_sir pcmcia firmware_class snd_pcm_oss snd_mixer_oss ata_generic rfkill sdhci_pci sdhci sir_dev uhci_hcd firewire_ohci firewire_core crc_itu_t led_class nvram cfg80211 pcspkr mmc_core ehci_hcd yenta_socket rsrc_nonstatic sg usbcore pcmcia_core ata_piix iTCO_wdt snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc e1000e thermal fan battery ac ppp_async ppp_generic slhc tun kvm_intel kvm coretemp acpi_cpufreq joydev processor video backlight output fuse hdaps tp_smapi thinkpad_ec nsc_ircc irda crc_ccitt psmouse rtc_cmos rtc_core rtc_lib [last unloaded: i2c_i801]

Pid: 565, comm: nepomukservices Tainted: G        W  (2.6.28.1-dg #8) 17045UG
EIP: 0060:[<b01faab9>] EFLAGS: 00210213 CPU: 1
EIP is at journal_grab_journal_head+0x41/0x89
EAX: eb14a000 EBX: 00000081 ECX: 00000001 EDX: eb14a000
ESI: 00000081 EDI: ef375800 EBP: b1018de0 ESP: eb14bb48
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process nepomukservices (pid: 565, ti=eb14a000 task=e732e880 task.ti=eb14a000)
Stack:
 b1018de0 00000081 b01f6f3f 001280d2 b0fdf0c0 00000000 ef3758b8 b1018de0
 001280d2 00000001 b1018df8 b0167fbb b1018de0 e9b57bf0 b0171670 00000000
 eb14bd60 eb14bca4 0016fb5e 00000000 00000003 eb14bbfc 00000003 00000001
Call Trace:
 [<b01f6f3f>] journal_try_to_free_buffers+0x3d/0x1ac
 [<b0167fbb>] try_to_release_page+0x2f/0x3d
 [<b0171670>] shrink_page_list+0x463/0x5d2
 [<b01705c1>] isolate_pages_global+0x91/0x1d0
 [<b01103dd>] smp_invalidate_interrupt+0x89/0x95
 [<b0171a30>] shrink_list+0x251/0x576
 [<b016e581>] get_dirty_limits+0x16/0x2bc
 [<b0171f7c>] shrink_zone+0x227/0x2a2
 [<b0138236>] autoremove_wake_function+0x0/0x2d
 [<b0172bbe>] do_try_to_free_pages+0x21f/0x367
 [<b013da70>] getnstimeofday+0x4a/0xcd
 [<b0172de7>] try_to_free_pages+0x71/0x79
 [<b0170530>] isolate_pages_global+0x0/0x1d0
 [<b016d758>] __alloc_pages_internal+0x1ff/0x388
 [<b017654f>] handle_mm_fault+0x14d/0x762
 [<b013a48d>] __remove_hrtimer+0x63/0x6b
 [<b0326b52>] _spin_unlock_irqrestore+0x22/0x39
 [<b013ac94>] hrtimer_try_to_cancel+0x63/0x6b
 [<b013aca6>] hrtimer_cancel+0xa/0x14
 [<b0141d9f>] futex_wait+0x321/0x3ce
 [<b0117ca7>] do_page_fault+0x307/0x668
 [<b013a814>] hrtimer_wakeup+0x0/0x18
 [<b013da70>] getnstimeofday+0x4a/0xcd
 [<b01241bf>] update_curr+0x94/0x1c6
 [<b013da70>] getnstimeofday+0x4a/0xcd
 [<b01107e5>] lapic_next_event+0x10/0x13
 [<b013f985>] clockevents_program_event+0xbb/0xc9
 [<b013aa41>] hrtimer_run_pending+0x20/0xfa
 [<b0326b1d>] _spin_unlock_irq+0x1a/0x2d
 [<b012fa5d>] run_timer_softirq+0x198/0x1a0
 [<b012c7b8>] __do_softirq+0xc2/0x10a
 [<b0165ed4>] rcu_irq_exit+0xc/0x6e
 [<b012c9f5>] irq_exit+0x6e/0x79
 [<b01179a0>] do_page_fault+0x0/0x668
 [<b0326e42>] error_code+0x72/0x78
 [<b0320000>] init_thread_xstate+0x9/0x2d
Code: db 95 f2 ff 89 e0 25 00 e0 ff ff f6 40 08 08 74 05 e8 61 aa 12 00 f3 90 b8 01 00 00 00 e8 1c 96 f2 ff 8b 03 a9 00 00 40 00 75 cf <f0> 0f ba 2b 16 19 c0 85 c0 75 ec 8b 03 31 f6 25 00 80 ff ff 66 
EIP: [<b01faab9>] journal_grab_journal_head+0x41/0x89 SS:ESP 0068:eb14bb48
---[ end trace b858a7be60ae0a82 ]---
note: nepomukservices[565] exited with preempt_count 1

