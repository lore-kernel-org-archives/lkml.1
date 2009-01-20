Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbZATLsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbZATLsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZATLsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:48:11 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:38785 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZATLsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=w4bk3UD+xr7PxzgfqG39o8xaf33TKuXDbCSVHVgVx7RamEwo2Vb8e6i8q6umMvF86a
         UOk141Y6AuUWXz6tI2p9+6dDSz9GaLXsLuQpB6j9+hUzFJLMFnK9styhauKRcsSMuwlQ
         Rvp/0KsS7Yn8tSjLE3Dp+3sXBsg0b+ckQXVkc=
Message-ID: <c4e36d110901200348n4009800dyebaf932039babf30@mail.gmail.com>
Date: Tue, 20 Jan 2009 12:48:04 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
In-Reply-To: <c4e36d110901200241x487092e9na0cda704de666d2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com>
	 <b647ffbd0901190841j785172e5n24d29511a2e61332@mail.gmail.com>
	 <20090119164440.GA20754@elte.hu> <200901192025.37711.rjw@sisk.pl>
	 <c4e36d110901191431j62168b4yaf8a4ffdbbe38bea@mail.gmail.com>
	 <20090119234905.GC452@elte.hu>
	 <c4e36d110901200241x487092e9na0cda704de666d2b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/20 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/1/20 Ingo Molnar <mingo@elte.hu>:
>>
>> * Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>>
>>> 2009/1/19 Rafael J. Wysocki <rjw@sisk.pl>:
>>> > On Monday 19 January 2009, Ingo Molnar wrote:
>>> >>
>>> >> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>>> >>
>>> >> > 2009/1/19 Ingo Molnar <mingo@elte.hu>:
>>> >> > >
>>> >> > > * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>>> >> > >
>>> >> > >> 2009/1/19 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>>> >> > >> > 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>>> >> > >> >> 2009/1/13 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>>> >> > >> >>> 2009/1/12 Rafael J. Wysocki <rjw@sisk.pl>:
>>> >> > >> >>>> On Monday 12 January 2009, Zdenek Kabelac wrote:
>>> >> > >> >>>
>>> >> > >> >>>> Sure, good idea.  I've been running with this reverted recently.
>>> >> > >> >>>>
>>> >> > >> >>>>> PS: I'll do the above 'echo' trace later (being busy right now).
>>> >> > >> >>>>
>>> >> > >> >>>> That shouldn't be necessary if you can suspend-resume with
>>> >> > >> >>>> 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted and the USB controller
>>> >> > >> >>>> modules unloaded.
>>> >> > >> >>>>
>>> >> > >> >>>> Instead, with 7503bfbae89eba07b46441a5d1594647f6b8ab7d reverted, please write
>>> >> > >> >>>> 'disabled' to the /sys/devices/.../power/wakeup files of all USB controllers
>>> >> > >> >>>> and see if suspend-resume works in this configuration.
>>> >> > >> >>>>
>>> >> > >> >>>
>>>
>>> The second one  (From 68564a46976017496c2227660930d81240f82355)
>>> creates the same fault.
>>>
>>> Thus obviously  Rafael is probably right and some series of patches
>>> are necessary  though I'd prefer to get a nice clean patch against the
>>> current git which I should try to apply as both Ingo's patches
>>> generated some reject (solvable by hand).
>>
>> You can pull the current set of patches/fixes in this area via:
>>
>> git pull git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus
>>
>> does that do the trick?
>>
>
> Ok - there are some changes - though I'll need to do more tests - thus
> I'll probably add few more post after checking what happens after
> couple suspend/resume cycles.
>
> But here is at least the first output from my log - seems to be
> related to my  USB EHCI problem:
> (Before the machine usually died without logging this traceback)
> Also - please note the message SPIN IRQ ALREADY DISABLED is from my
> own little patch.
> Usually when I keep ehci_hcd module in memory my machine dies after printing:
> Extended CMOS year: 2000 - but this time it survived
>
>
>
> I do not see now the previous workqueue backtrace.
>


Ok -  bad news - my previous supend-resume tests were done in the
runlevel 1 - without network.
With network enabled - the error is back - thus it might be a bug in
ieee80211 stack ??

NetworkManager: <info>  (wlan0): now unmanaged
NetworkManager: <info>  (wlan0): device state change: 3 -> 1
NetworkManager: <info>  (wlan0): cleaning up...
NetworkManager: <info>  (wlan0): taking down device.
PM: Syncing filesystems ... done.
Freezing user space processes ... <3>iwl3945: Error: Response NULL in
'REPLY_ADD_STA'
general protection fault: 0000 [#1] SMP
last sysfs file: /sys/power/state
CPU 0
Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc sco l2cap bluetooth
autofs4 sunrpc ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod
rtc_cmos rtc_core rtc_lib kvm_intel kvm i915 drm i2c_algo_bit uinput
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_seq_oss arc4 ecb
snd_seq_midi_event snd_seq cryptomgr snd_seq_device snd_pcm_oss aead
crypto_blkcipher crypto_hash snd_mixer_oss snd_pcm crypto_algapi
iwl3945 e1000e mac80211 snd_timer snd thinkpad_acpi soundcore i2c_i801
snd_page_alloc lib80211 psmouse rfkill evdev sdhci_pci sdhci mmc_core
button usbhid hid iTCO_wdt iTCO_vendor_support backlight nvram
led_class sr_mod cdrom intel_agp battery ac i2c_core cfg80211
serio_raw uhci_hcd ohci_hcd usbcore [last unloaded: microcode]
Pid: 2265, comm: NetworkManager Not tainted 2.6.29-rc2 #17
RIP: 0010:[<ffffffff8053ce01>]  [<ffffffff8053ce01>] wait_for_common+0x131/0x190
RSP: 0018:ffff88006b509730  EFLAGS: 00010296
RAX: 7fffffffffffffff RBX: ffff88006b509748 RCX: 0000000000000003
RDX: ffffffff80a8d1f0 RSI: ffff88006b504b48 RDI: ffff88006b504420
RBP: ffff88006b509738 R08: 0000000000000000 R09: 0000000000000000
R10: ffff88006b504b48 R11: 0000000000000001 R12: ffff88007ca52598
R13: 0000000000000000 R14: ffff88007a008000 R15: 0000000000000000
FS:  00007fcbe961f740(0000) GS:ffffffff80916040(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f172f1f9000 CR3: 000000006b6f3000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process NetworkManager (pid: 2265, threadinfo ffff88006b508000, task
ffff88006b504420)
Stack:
 6a2b5d008053cef8 ffff8800ffff8800 ffffffff8025a735 0000000000000000
 ffffffff8025a620 0000000000000000 dead4ead00000303 ffffffffffffffff
 ffffffffffffffff ffffffff80972c08 0000000000000000 ffffffff805faed6
Call Trace:
 [<ffffffff8025a735>] synchronize_rcu+0x35/0x40
 [<ffffffff8025a620>] ? wakeme_after_rcu+0x0/0x10
 [<ffffffff8053ce3f>] ? wait_for_common+0x16f/0x190
 [<ffffffff8024b424>] ? local_bh_enable+0xa4/0x110
 [<ffffffff804c8ce1>] ? dev_deactivate+0x151/0x1d0
 [<ffffffff804b750d>] ? dev_close+0x6d/0xd0
 [<ffffffffa016b042>] ? ieee80211_stop+0x562/0x570 [mac80211]
 [<ffffffffa016ab59>] ? ieee80211_stop+0x79/0x570 [mac80211]
 [<ffffffff8053fb5f>] ? _spin_unlock_bh+0x2f/0x40
 [<ffffffff804c8d3a>] ? dev_deactivate+0x1aa/0x1d0
 [<ffffffff804b751c>] ? dev_close+0x7c/0xd0
 [<ffffffff804b70dd>] ? dev_change_flags+0x9d/0x1e0
 [<ffffffff804c05a5>] ? do_setlink+0x2b5/0x440
 [<ffffffff8053fb26>] ? _read_unlock+0x26/0x30
 [<ffffffff804c0905>] ? rtnl_setlink+0x115/0x160
 [<ffffffff8053dc54>] ? mutex_lock_nested+0x284/0x360
 [<ffffffff804c187a>] ? rtnetlink_rcv+0x1a/0x40
 [<ffffffff804c1a2d>] ? rtnetlink_rcv_msg+0x18d/0x240
 [<ffffffff804c18a0>] ? rtnetlink_rcv_msg+0x0/0x240
 [<ffffffff804cc879>] ? netlink_rcv_skb+0x89/0xb0
 [<ffffffff804c1889>] ? rtnetlink_rcv+0x29/0x40
 [<ffffffff804cc274>] ? netlink_unicast+0x2c4/0x2e0
 [<ffffffff804ae57e>] ? __alloc_skb+0x6e/0x150
 [<ffffffff804cc4a4>] ? netlink_sendmsg+0x214/0x310
 [<ffffffff804a59d7>] ? sock_sendmsg+0x127/0x140
 [<ffffffff8025d1f0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8027222b>] ? lock_release_non_nested+0x9b/0x2e0
 [<ffffffff802dbd96>] ? fget_light+0x106/0x110
 [<ffffffff804a6737>] ? move_addr_to_kernel+0x57/0x60
 [<ffffffff804afa4f>] ? verify_iovec+0x3f/0xe0
 [<ffffffff804a5b79>] ? sys_sendmsg+0x189/0x320
 [<ffffffff804a683f>] ? sys_sendto+0xff/0x120
 [<ffffffff802f4a8a>] ? mntput_no_expire+0x2a/0x170
 [<ffffffff802dc06a>] ? __fput+0x17a/0x1f0
 [<ffffffff8026ee5a>] ? trace_hardirqs_on_caller+0x16a/0x1d0
 [<ffffffff8029232e>] ? audit_syscall_entry+0x17e/0x1a0
 [<ffffffff8053f6de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020c51b>] ? system_call_fastpath+0x16/0x1b
Code: 04 24 b8 01 00 00 00 48 0f 44 d8 4c 89 ef e8 87 2d 00 00 48 89
d8 4c 8b 65 e0 48 8b 5d d8 4c 8b 6d e8 4c 8b 75 f0 4c 8b 7d f8 c9 <c3>
66 0f 1f 44 00 00 e8 33 43 d1 ff 85 c0 75 90 0f 1f 80 00 00
RIP  [<ffffffff8053ce01>] wait_for_common+0x131/0x190
 RSP <ffff88006b509730>
---[ end trace c1a25abf9f5fc6e6 ]---
(elapsed 0.03 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.


Zdenek
