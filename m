Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbXK1Fsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbXK1Fsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbXK1Fs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:48:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120AbXK1Fs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:48:26 -0500
Date: Tue, 27 Nov 2007 21:48:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas Tuttle" <linux-kernel@ttuttle.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Oops with 2.6.24 git when loading iwl3945
Message-Id: <20071127214820.0251bc66.akpm@linux-foundation.org>
In-Reply-To: <1196196237.19410.1223544787@webmail.messagingengine.com>
References: <1196196237.19410.1223544787@webmail.messagingengine.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 15:43:57 -0500 "Thomas Tuttle" <linux-kernel@ttuttle.net> wrote:

> Hey.
> 
> I'm using a git snapshot that gentoo distributed mere hours ago (so I'm
> fairly confident it's current), and I'm getting an Oops when I try to
> load the iwl3945 driver.  I've attached it as plain text.
> 

Let's cc linux-wireless.

> ieee80211_crypt: registered algorithm 'NULL'
> ieee80211_crypt: registered algorithm 'WEP'
> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.1.17kds
> iwl3945: Copyright(c) 2003-2007 Intel Corporation
> ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:0c:00.0 to 64
> iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
> iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
> general protection fault: 0000 [1] SMP 
> CPU 0 
> Modules linked in: iwl3945 ieee80211_crypt_wep ieee80211_crypt mac80211 cfg80211 i915 drm snd_seq_oss snd_seq_device snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc coretemp hwmon rtc rfcomm l2cap hci_usb bluetooth uhci_hcd ehci_hcd usbcore evdev b44 ssb psmouse
> Pid: 5230, comm: iwl3945/0 Not tainted 2.6.24-rc3-git2 #1
> RIP: 0010:[<ffffffff80300c56>]  [<ffffffff80300c56>] strcmp+0x0/0x1a
> RSP: 0018:ffff810074d93dd8  EFLAGS: 00010287
> RAX: ffffffff881c2e80 RBX: ffff8100752b84e0 RCX: ffff810074d92000
> RDX: ffff810074de2073 RSI: ffffffff881c086b RDI: 000200740000016b
> RBP: ffffffff881c8e80 R08: ffff810074d92000 R09: ffff810002bf77a0
> R10: 0000000000000000 R11: 0000000000000001 R12: ffffffff88197540
> R13: ffff810074de2060 R14: ffff810074de2030 R15: 0000000000000038
> FS:  0000000000000000(0000) GS:ffffffff8059d000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00002b313ecef000 CR3: 000000007d100000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process iwl3945/0 (pid: 5230, threadinfo ffff810074d92000, task ffff81007c812000)
> Stack:  ffffffff88183a0e ffff810074d52220 ffff810074d518c0 ffff810074de2000
>  ffffffff881a81e2 0000000000000000 0000000000000000 0000000074d93e30
>  0000000000000000 ffff81007c812000 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff88183a0e>] :mac80211:ieee80211_rate_control_register+0x3d/0xdd
>  [<ffffffff881a81e2>] :iwl3945:iwl_bg_alive_start+0xc96/0xef9
>  [<ffffffff80439984>] thread_return+0x3d/0x81
>  [<ffffffff881a754c>] :iwl3945:iwl_bg_alive_start+0x0/0xef9
>  [<ffffffff80242755>] run_workqueue+0x7f/0x10b
>  [<ffffffff80243071>] worker_thread+0x0/0xe4
>  [<ffffffff8024314b>] worker_thread+0xda/0xe4
>  [<ffffffff802460c0>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff80245fae>] kthread+0x47/0x75
>  [<ffffffff8020cc48>] child_rip+0xa/0x12
>  [<ffffffff80245f67>] kthread+0x0/0x75
>  [<ffffffff8020cc3e>] child_rip+0x0/0x12
> 
> 
> Code: 8a 17 89 d0 2a 06 48 ff c6 84 c0 75 09 84 d2 74 05 48 ff c7 
> RIP  [<ffffffff80300c56>] strcmp+0x0/0x1a
>  RSP <ffff810074d93dd8>
> 

I have a shiny new t61p which uses iwl3945.  It barely runs carefully
selected bits of the fc8 2.6.23-based kernel and heaven knows what 2.6.24
will do to it.  It will join my Vaio as a
tool-of-kernel-developer-tormenting.  This means that your wireless should
keep working ;)
