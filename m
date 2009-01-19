Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZASWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZASWbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbZASWb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:31:26 -0500
Received: from mail-fx0-f26.google.com ([209.85.220.26]:39654 "EHLO
	mail-fx0-f26.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZASWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cpFTA+ceJiW4IEGJCjkKnPGY7/ZbrdMMODBfBJUeS7WShn0Hv1/XAsKCj7b2Ta9iLX
         nBtnIGZZAmth1syply8DEVuEuHpgEOPU1Q5wxJKJHTD1XtfjQVEJ/WVsNYTy5xeppG6b
         OeI0rQiiV9KLIjBLgGy4a7N7iRgV6VNC46pDk=
Message-ID: <c4e36d110901191431j62168b4yaf8a4ffdbbe38bea@mail.gmail.com>
Date: Mon, 19 Jan 2009 23:31:21 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
In-Reply-To: <200901192025.37711.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <b647ffbd0901190841j785172e5n24d29511a2e61332@mail.gmail.com>
	 <20090119164440.GA20754@elte.hu> <200901192025.37711.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday 19 January 2009, Ingo Molnar wrote:
>>
>> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>>
>> > 2009/1/19 Ingo Molnar <mingo@elte.hu>:
>> > >
>> > > * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>> > >
>> > >> 2009/1/19 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> > >> > 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> > >> >> 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> > >> >>> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
>> > >> >>>> On Monday 12 January 2009, Zdenek Kabelac wrote:
>> > >> >>>
>> > >> >>>> Sure, good idea.  I've been running with this reverted recently.
>> > >> >>>>
>> > >> >>>>> PS: I'll do the above 'echo' trace later (being busy right now).
>> > >> >>>>
>> > >> >>>> That shouldn't be necessary if you can suspend-resume with
>> > >> >>>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
>> > >> >>>> modules unloaded.
>> > >> >>>>
>> > >> >>>> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
>> > >> >>>> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
>> > >> >>>> and see if suspend-resume works in this configuration.
>> > >> >>>>
>> > >> >>>
>> > >> >>> Hi
>> > >> >>>
>> > >> >>> So I've check some   find /sys/device | grep usb | grep power/wakeup
>> > >> >>> and there was no difference.
>> > >> >>> I've updated to latest git to be in sync
>> > >> >>> (e0b325d310a6b11f1538413fd557d2eb98f2fae5)
>> > >> >>> I'm still keeping reverted commit: 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
>> > >> >>>
>> > >> >>> And I've figured out - the only  'modprobe -r ehci_hcd' is enough to
>> > >> >>> keep my suspend/resume sequence working. (Though I would have say,
>> > >> >>> that now it takes fairly noticable time to get keyboard and synaptics
>> > >> >>> usable - but it might be connected with my move to evdev and hal... :)
>> > >> >>> )
>> > >> >>>
>> > >> >>> So I'm adding cc: to David - maybe he has some suspected patches for
>> > >> >>> ehci_hcd ? (as doing a bisect in such a broken merge window is going
>> > >> >>> to give me probably a lot of unsable kernels nowdays....)
>> > >> >>>
>> > >> >>
>> > >> >> And I've forget to append trace from supend /resume with INFO trace:
>> > >> >> (which might be a part of problem??)
>> > >> >
>> > >> > Hi
>> > >> >
>> > >> >
>> > >> > Just an update for  2.6.29-rc2 (f3b8436ad9a8ad36b3c9fa1fe030c7f38e5d3d0b)
>> > >> >
>> > >> > With this kernel I still have to keep reverted patch commit:
>> > >> > 6fd9086a518d4f14213a32fe6c9ac17fabebbc1e.
>> > >> > (otherwise I see the auto-wake-up immediately after suspend)
>> > >> >
>> > >> > I also keep module ehci_hcd away from my kernel - so the
>> > >> > suspend-resume seems to be working.
>> > >> >
>> > >> > I've checked the ideas from thread: 2.6.29-rc1: [SOLVED] thinkpad
>> > >> > problems during resume
>> > >> > http://lkml.org/lkml/2009/1/17/181  and they seems to produce some
>> > >> > ugly Ooops with my configuration.
>> > >> > so for now I stay with my revert/ehci fix.
>> > >> >
>> > >> > Also I still get the INFO trace:
>> > >> > processor ACPI_CPU:01: legacy suspend
>> > >> > processor ACPI_CPU:00: legacy suspend
>> > >> > button LNXPWRBN:00: legacy suspend
>> > >> > acpi LNXSYSTM:00: legacy suspend
>> > >> > ACPI: Preparing to enter system sleep state S3
>> > >> > Disabling non-boot CPUs ...
>> > >> >
>> > >> > =======================================================
>> > >> > [ INFO: possible circular locking dependency detected ]
>> > >> > 2.6.29-rc2 #14
>> > >> > -------------------------------------------------------
>> > >> > pm-suspend/2873 is trying to acquire lock:
>> > >> >  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at: [<ffffffff8049a27b>]
>> > >> > lock_policy_rwsem_write+0x4b/0x90
>> > >> >
>> > >> > but task is already holding lock:
>> > >> >  (&cpu_hotplug.lock){--..}, at: [<ffffffff80246832>] cpu_hotplug_begin+0x22/0x60
>> > >> >
>> > >> > which lock already depends on the new lock.
>> > >> >
>> > >> >
>> > >> > the existing dependency chain (in reverse order) is:
>> > >> >
>> > >> > -> #1 (&cpu_hotplug.lock){--..}:
>> > >> >       [<ffffffff80270ce6>] __lock_acquire+0x1416/0x1db0
>> > >> >       [<ffffffff80271711>] lock_acquire+0x91/0xc0
>> > >> >       [<ffffffff8053d99c>] mutex_lock_nested+0xec/0x360
>> > >> >       [<ffffffff80246a4a>] get_online_cpus+0x3a/0x50
>> > >> >       [<ffffffff802594b7>] work_on_cpu+0x67/0xb0
>> > >> >       [<ffffffff8021e85e>] get_measured_perf+0x1e/0xb0
>> > >>
>> > >>
>> > >> Ingo,
>> > >>
>> > >>
>> > >> it looks like e39ad415ac15116df213dfa2aa2a4f1b0857af9c should have
>> > >> been reverted together with 7503bfbae89eba07b46441a5d1594647f6b8ab7d.
>> > >>
>> > >> In general, perhaps all "set_cpus_allowed_ptr() -> work_on_cpu()"
>> > >> conversions - if they involve any cpu-hotplug callback paths - may
>> > >> lead to similar reports (and possible lockups).
>> > >
>> > > Guys, could you please try the patch below? It improves work_on_cpu() to
>> > > not be dependent on the kevent workqueue.
>> >
>> > I guess, the following patch should also be applied (since
>> > get_online_cpus() is a culprit here):
>> >
>> > [PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in work_on_cpu
>> >
>> > the patch is available here:
>> >
>> > http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00375.html
>>
>> yeah - also attached below.
>
> In fact I believe all three patches in the series at
> http://lkml.org/lkml/2009/1/16/377
> are necessary.

So I've made so far 2 tests - I've removed revert of the USB commit
(6fd9086a518d) - obvisously this result
in immediate wakeup after resume.

The first Ingo's proposal patch resulted in this oops message (before suspend):

usb 1-1: uevent
general protection fault: 0000 [#1] SMP
last sysfs file: /sys/power/state
CPU 0
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc rfcomm sco l2cap
autofs4 sunrpc ipv6 binfmt_misc dm_snapshot dm_mirror dm_region_hash
dm_log dm_mod rtc_cmos rtc_core rtc_lib kvm_intel kvm i915 drm
i2c_algo_bit uinput arc4 ecb snd_hda_codec_analog cryptomgr aead
snd_hda_intel crypto_blkcipher btusb snd_hda_codec crypto_hash
crypto_algapi snd_seq_oss bluetooth iwl3945 sdhci_pci
snd_seq_midi_event sdhci mmc_core snd_seq snd_seq_device snd_pcm_oss
thinkpad_acpi snd_mixer_oss snd_pcm backlight snd_timer rfkill
led_class evdev snd i2c_i801 iTCO_wdt mac80211 button psmouse
soundcore e1000e i2c_core iTCO_vendor_support sr_mod battery serio_raw
nvram cdrom lib80211 ac intel_agp snd_page_alloc cfg80211 uhci_hcd
ohci_hcd usbcore [last unloaded: microcode]
Pid: 2244, comm: NetworkManager Not tainted 2.6.29-rc2 #15
RIP: 0010:[<ffffffff8053ccf1>]  [<ffffffff8053ccf1>] wait_for_common+0x131/0x190
RSP: 0018:ffff88006ae6b730  EFLAGS: 00010296
RAX: 7fffffffffffffff RBX: ffff88006ae6b748 RCX: 0000000000000003
RDX: ffffffff80a8b1f0 RSI: ffff88006f908728 RDI: ffff88006f908000
RBP: ffff88006ae6b738 R08: 0000000000000000 R09: 0000000000000000
R10: ffff88006f908728 R11: 0000000000000001 R12: ffff880079ca1d98
R13: 0000000000000000 R14: ffff880079d66000 R15: 0000000000000000
FS:  00007faf7fca9740(0000) GS:ffffffff80914040(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006c3444 CR3: 000000007c50d000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process NetworkManager (pid: 2244, threadinfo ffff88006ae6a000, task
ffff88006f908000)
Stack:
 7d6ddc008053cde8 ffff8800ffff8800 ffffffff8025a695 ffff88006b050e90
 ffffffff8025a580 0000000000000000 dead4ead00000303 ffffffffffffffff
 ffffffffffffffff ffffffff80970c08 0000000000000000 ffffffff805f9e8e
Call Trace:
 [<ffffffff8025a695>] synchronize_rcu+0x35/0x40
 [<ffffffff8025a580>] ? wakeme_after_rcu+0x0/0x10
 [<ffffffff8053cd2f>] ? wait_for_common+0x16f/0x190
 [<ffffffff8024b364>] ? local_bh_enable+0xa4/0x110
 [<ffffffff804c8c41>] ? dev_deactivate+0x151/0x1d0
 [<ffffffff804b746d>] ? dev_close+0x6d/0xd0
 [<ffffffffa0102042>] ? ieee80211_stop+0x562/0x570 [mac80211]
 [<ffffffffa0101b59>] ? ieee80211_stop+0x79/0x570 [mac80211]
 [<ffffffff8053fa4f>] ? _spin_unlock_bh+0x2f/0x40
 [<ffffffff804c8c9a>] ? dev_deactivate+0x1aa/0x1d0
 [<ffffffff804b747c>] ? dev_close+0x7c/0xd0
 [<ffffffff804b703d>] ? dev_change_flags+0x9d/0x1e0
 [<ffffffff804c0505>] ? do_setlink+0x2b5/0x440
 [<ffffffff8053fa16>] ? _read_unlock+0x26/0x30
 [<ffffffff804c0865>] ? rtnl_setlink+0x115/0x160
 [<ffffffff8053db44>] ? mutex_lock_nested+0x284/0x360
 [<ffffffff804c17da>] ? rtnetlink_rcv+0x1a/0x40
 [<ffffffff804c198d>] ? rtnetlink_rcv_msg+0x18d/0x240
 [<ffffffff804c1800>] ? rtnetlink_rcv_msg+0x0/0x240
 [<ffffffff804cc7d9>] ? netlink_rcv_skb+0x89/0xb0
 [<ffffffff804c17e9>] ? rtnetlink_rcv+0x29/0x40
 [<ffffffff804cc1d4>] ? netlink_unicast+0x2c4/0x2e0
 [<ffffffff804ae4de>] ? __alloc_skb+0x6e/0x150
 [<ffffffff804cc404>] ? netlink_sendmsg+0x214/0x310
 [<ffffffff804a5937>] ? sock_sendmsg+0x127/0x140
 [<ffffffff8025d150>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8027218b>] ? lock_release_non_nested+0x9b/0x2e0
 [<ffffffff802dbce6>] ? fget_light+0x106/0x110
 [<ffffffff804a6697>] ? move_addr_to_kernel+0x57/0x60
 [<ffffffff804af9af>] ? verify_iovec+0x3f/0xe0
 [<ffffffff804a5ad9>] ? sys_sendmsg+0x189/0x320
 [<ffffffff804a679f>] ? sys_sendto+0xff/0x120
 [<ffffffff802f49da>] ? mntput_no_expire+0x2a/0x170
 [<ffffffff802dbfba>] ? __fput+0x17a/0x1f0
 [<ffffffff8026edba>] ? trace_hardirqs_on_caller+0x16a/0x1d0
 [<ffffffff8029228e>] ? audit_syscall_entry+0x17e/0x1a0
 [<ffffffff8053f5ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020c51b>] ? system_call_fastpath+0x16/0x1b
Code: 04 24 b8 01 00 00 00 48 0f 44 d8 4c 89 ef e8 87 2d 00 00 48 89
d8 4c 8b 65 e0 48 8b 5d d8 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 <c3>
66 0f 1f 44 00 00 e8 83 43 d1 ff 85 c0 75 90 0f 1f 80 00 00
RIP  [<ffffffff8053ccf1>] wait_for_common+0x131/0x190
 RSP <ffff88006ae6b730>
---[ end trace a2c62d53604aab23 ]---
(elapsed 0.04 seconds) done.
Freezing remaining freezable tasks ... <7>hub 1-0:1.0: debounce: port
1: total 100ms stable 100ms status 0x100
(elapsed 0.10 seconds) done.
PM: Entering mem sleep

The second one  (From 68564a46976017496c2227660930d81240f82355)
creates the same fault.

Thus obviously  Rafael is probably right and some series of patches
are necessary  though I'd prefer to get a nice clean patch against the
current git which I should try to apply as both Ingo's patches
generated some reject (solvable by hand).

Also - any idea how to fix my  problem with 'ehci' (so far I'm simply
removing this module and no harm in the usability is visible) - and is
there a proposal fix for auto-resume regression or the patch revert is
the right solution for this moment ?

Zdenek
