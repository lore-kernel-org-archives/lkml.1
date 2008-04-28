Return-Path: <linux-kernel-owner+w=401wt.eu-S935620AbYD1Q0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935620AbYD1Q0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935043AbYD1QZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:25:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932545AbYD1QZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:25:51 -0400
Date: Mon, 28 Apr 2008 09:25:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Bernhard Walle <bwalle@suse.de>
Subject: Re: Solid freezes with 2.6.25
Message-Id: <20080428092513.495378af.akpm@linux-foundation.org>
In-Reply-To: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
References: <20080428142935.GQ14074@boogie.lpds.sztaki.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 16:29:35 +0200 Gabor Gombas <gombasg@sztaki.hu> wrote:

> Hi,
> 
> I'm seeing solid freezes with 2.6.25. 2.6.24.x works fine, 2.6.25 never
> had an uptime longer than 4-6 hours so far. netconsole captured the
> following:
> 
> NMI Watchdog detected LOCKUP on CPU 1
> CPU 1 
> Modules linked in: edd netconsole configfs i915 radeon drm rfcomm l2cap bluetooth xfrm_user xfrm4_tunnel tunnel4 ipcomp esp4 aead ah4 nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs ipt_ULOG microcode ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp ipt_LOG xt_limit iptable_filter ip_tables x_tables deflate zlib_deflate zlib_inflate ctr twofish twofish_common camellia serpent blowfish des_generic cbc aes_x86_64 aes_generic xcbc sha256_generic sha1_generic md5 crypto_null af_key fuse dm_crypt crypto_blkcipher dm_snapshot dm_mirror dm_mod coretemp w83627ehf hwmon_vid snd_hda_intel snd_pcm 8250_pnp snd_timer 8250 sg snd 8139too serial_core video r8169 snd_page_alloc usbhid i2c_i801 sr_mod iTCO_wdt floppy cdrom [last unloaded: netconsole]
> Pid: 2535, comm: postgres Not tainted 2.6.25 #11
> RIP: 0010:[<ffffffff8021aa54>]  [<ffffffff8021aa54>] hpet_rtc_interrupt+0x11a/0x2fd
> RSP: 0000:ffff81012fc77ec8  EFLAGS: 00200097
> RAX: 0000000000000000 RBX: 0000000000200002 RCX: 0000000000000000
> RDX: 000000000000c6c6 RSI: 0000000000200002 RDI: ffffffff80655ef8
> RBP: 000000010011144c R08: ffffffffff5fc128 R09: 0000000000000000
> R10: 0000000000200046 R11: 0000000000000000 R12: 00000000000000a6
> R13: ffff81012fcf8800 R14: 0000000000000000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff81012fc0f480(0063) knlGS:00000000f7f228e0
> CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> CR2: 00000000f1559000 CR3: 0000000128cd8000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process postgres (pid: 2535, threadinfo ffff810128d18000, task ffff81012cbb6930)
> Stack:  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  ffffffff00000000 0000000000000001 ffffffff806432c0 ffff81012fe25bc0
>  0000000000000000 0000000000000000 0000000000000008 ffffffff8025d6d0
> Call Trace:
>  <IRQ>  [<ffffffff8025d6d0>] ? handle_IRQ_event+0x25/0x53
>  [<ffffffff8025ec3a>] ? handle_edge_irq+0xdd/0x11c
>  [<ffffffff8020c0cc>] ? call_softirq+0x1c/0x28
>  [<ffffffff8020e26a>] ? do_IRQ+0xf1/0x15f
>  [<ffffffff8020b451>] ? ret_from_intr+0x0/0xa
>  <EOI> 
> 
> Code: a0 28 00 bf 0a 00 00 00 48 89 c3 e8 73 6b ff ff 48 89 de 41 88 c4 48 c7 c7 f8 5e 65 80 e8 14 a1 28 00 45 84 e4 78 04 eb 12 f3 90 <48> 8b 05 25 1e 3e 00 48 29 e8 48 83 f8 04 76 ee 48 c7 c7 f8 5e 
> ---[ end trace 8625c90c6582673f ]---
> Kernel panic - not syncing: Aiee, killing interrupt handler!
> 
> Also, I have these messages in syslog:
> 
> Apr 28 13:13:31 boogie kernel: rtc: lost 157 interrupts
> Apr 28 13:13:32 boogie kernel: rtc: lost 37 interrupts
> Apr 28 13:25:37 boogie kernel: rtc: lost 60 interrupts
> 
> More info about the machine is attached. I've also seen similar hangs with
> 2.6.25-rc6 on an nforce4/Athlon64 box but I'm reluctant to re-test there
> because RAID rebuild takes too long.

I don't see any loop in hpet_rtc_interrupt() which can lock up so I assume
that for some reason we stop clearing the interrupt source and we
continuously reenter the interrupt handler.

I think this could also happen if someone runs
hpet_unregister_irq_handler() while the hpet is still active.

Ugly.  If it was sanely reproducible then you could perhaps bisect it, but
two hours makes that unfeasible :(

Suspicion would have to be directed at the 2.6.25 CONFIG_HPET_EMULATE_RTC
changes.

I think our best bet here would be to persuade someone who knows what's
going on in there to prepare a debugging patch for you to run with
(please).  See if we can find out what the code is doing at the time when
it freezes up.

