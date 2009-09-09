Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZIIVVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZIIVVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZIIVU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:20:59 -0400
Received: from cardinal.lizella.net ([216.23.247.74]:38639 "EHLO
	cardinal.lizella.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZIIVU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:20:58 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 17:20:58 EDT
Date: Wed, 9 Sep 2009 16:12:42 -0500
From: Robby Workman <rworkman@slackbuilds.org>
To: Alex Bennee <kernel-hacker@bennee.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: r8169 ethernet hangs after a pm-suspend (and resume)
Message-ID: <20090909161242.4be7f0d6@liberty.rlwhome.lan>
In-Reply-To: <20090909205556.3FCBD591@cardinal.lizella.net>
References: <dipDf-1v7-5@gated-at.bofh.it>
	<20090909205556.3FCBD591@cardinal.lizella.net>
Organization: SlackBuilds.org
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-slackware-linux-gnu)
X-Operating-System: Slackware Linux
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying again to fix CC's - sorry for the extra noise.

On Wed, 9 Sep 2009 20:55:56 +0000
rworkman@cardinal.lizella.net (Robby Workman) wrote:

> In linux.kernel, you wrote:
> > I've just recently gotten suspend working on my system.
> > Unfortunately after the resume event I loose access to the network.
> > As far as the system is concerned the network is configured properly
> > but every attempt to ping local nodes fails with "Host not
> > reachable".
> >
> > If also seen an oops or two but I don't know id that is related:
> >
> > [  289.816066] ------------[ cut here ]------------
> > [  289.816077] WARNING: at net/sched/sch_generic.c:246
> > dev_watchdog+0x132/0x1da()
> > [  289.816080] Hardware name: System Product Name
> > [  289.816083] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed
> > out
> > [  289.816085] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat
> > joydev usb_storage usbhid usb_libusual bridge stp llc bnep rfcomm
> > l2cap bluetooth ipv6 snd_pcm_oss snd_mixer_oss snd_seq_oss
> > snd_seq_midi_event snd_seq snd_seq_device kvm_intel kvm acpi_cpufreq
> > snd_hda_codec_analog uhci_hcd usbcore snd_hda_intel snd_hda_codec
> > firewire_ohci snd_hwdep snd_pcm snd_timer snd firewire_core
> > crc_itu_t soundcore snd_page_alloc ide_cd_mod pcspkr evdev cdrom
> > thermal processor nls_base unix [last unloaded: ehci_hcd]
> > [  289.816135] Pid: 0, comm: swapper Not tainted
> > 2.6.31-rc9-ajb-00012-g3ff323f-dirty #84
> > [  289.816138] Call Trace:
> > [  289.816140]  <IRQ>  [<ffffffff812aef27>] ?
> > dev_watchdog+0x132/0x1da [  289.816152]  [<ffffffff8103eb72>]
> > warn_slowpath_common+0x7c/0xa9 [  289.816157]  [<ffffffff8103ec1e>]
> > warn_slowpath_fmt+0x69/0x6b [  289.816165]  [<ffffffffa0124cbb>] ?
> > uhci_scan_schedule+0x194/0x86a [uhci_hcd]
> > [  289.816169]  [<ffffffff81048fbc>] ? lock_timer_base+0x2b/0x4f
> > [  289.816174]  [<ffffffff81049699>] ? mod_timer+0x111/0x123
> > [  289.816180]  [<ffffffffa0125d9a>] ?
> > uhci_hub_status_data+0x16e/0x17d [uhci_hcd]
> > [  289.816185]  [<ffffffff8129d98d>] ? netdev_drivername+0x48/0x4f
> > [  289.816189]  [<ffffffff812aef27>] dev_watchdog+0x132/0x1da
> > [  289.816211]  [<ffffffffa00f0233>] ?
> > usb_hcd_poll_rh_status+0x144/0x153 [usbcore]
> > [  289.816215]  [<ffffffff812aedf5>] ? dev_watchdog+0x0/0x1da
> > [  289.816220]  [<ffffffff81048d76>] run_timer_softirq+0x198/0x20d
> > [  289.816226]  [<ffffffff8101d0c6>] ? lapic_next_event+0x1d/0x21
> > [  289.816231]  [<ffffffff8104464f>] __do_softirq+0xd6/0x19a
> > [  289.816235]  [<ffffffff8100c19c>] call_softirq+0x1c/0x28
> > [  289.816239]  [<ffffffff8100d51d>] do_softirq+0x39/0x77
> > [  289.816243]  [<ffffffff8104430c>] irq_exit+0x44/0x7e
> > [  289.816248]  [<ffffffff8130b164>]
> > smp_apic_timer_interrupt+0x8d/0x9b
> > [  289.816253]  [<ffffffff8100bb73>] apic_timer_interrupt+0x13/0x20
> > [  289.816256]  <EOI>  [<ffffffff810117ac>] ? mwait_idle+0xb9/0xf0
> > [  289.816264]  [<ffffffff81309645>] ?
> > atomic_notifier_call_chain+0x13/0x15
> > [  289.816268]  [<ffffffff8100a30a>] ? cpu_idle+0x57/0x98
> > [  289.816273]  [<ffffffff812f5422>] ? rest_init+0x66/0x68
> > [  289.816278]  [<ffffffff815319da>] ? start_kernel+0x343/0x34e
> > [  289.816283]  [<ffffffff8153103a>] ?
> > x86_64_start_reservations+0xaa/0xae
> > [  289.816287]  [<ffffffff8153111f>] ? x86_64_start_kernel+0xe1/0xe8
> > [  289.816290] ---[ end trace 01c3a2a7a5f34536 ]---
> > [  290.635368] r8169: eth0: link up
> > [  314.635844] r8169: eth0: link up
> >
> > I'm currently running 2.6.31-rc9-ajb-00012-g3ff323f-dirty and am
> > willing to test any patches that might be going.
> 
> 
> I recall experiencing something similar when I was on 2.6.27.x,
> but I thought it had gone away in 2.6.29.x; perhaps I forgot to 
> actually remove my workaround though...  
> 
> In case you aren't aware, the workaround (assuming your system
> uses the pm-utils stuff to suspend) is to do this:
> 
> Edit (or create) /etc/pm/defaults to add the following line:
>   SUSPEND_MODULES="r8169"
> 
> That will cause the r8169 module to be unloaded on sleep and
> reloaded on wakeup.  That being said, I agree that the *real*
> fix is in the kernel driver.
> 
> -RW
