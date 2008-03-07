Return-Path: <linux-kernel-owner+w=401wt.eu-S1759679AbYCGGQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679AbYCGGQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 01:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYCGGQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 01:16:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788AbYCGGQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 01:16:23 -0500
Date: Thu, 6 Mar 2008 22:16:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
Message-Id: <20080306221602.790cd26e.akpm@linux-foundation.org>
In-Reply-To: <10815.1204862325@turing-police.cc.vt.edu>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<10815.1204862325@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2008 22:58:45 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 04 Mar 2008 01:19:28 PST, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc3/2.6.25-rc3-mm1/
> 
> Dell Latitude D820, x86_64, Core2 Duo T7200
> 
> 'shutdown -h' blows up at the very end. shutdown -r works OK. I caught this one
> with netconsole.  There's another, different, crash I've been seeing a bit
> earlier in the shutdown -h as well, but I haven't been able to catch that one
> yet...
> 
> [   74.254402] CPU 1 is now offline
> [   74.255395] SMP alternatives: switching to UP code
> [   74.256373] BUG: unable to handle kernel paging request at ffffffff8020a023
> [   74.256373] IP: [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
> [   74.256373] PGD 203067 PUD 207063 PMD 7e4cc163 PTE 20a161
> [   74.256373] Oops: 0003 [1] PREEMPT SMP 
> [   74.256373] last sysfs file: /sys/devices/virtual/block/dm-14/dev
> [   74.256373] CPU 0 
> [   74.256373] Modules linked in: rtc sha256_generic aes_generic acpi_cpufreq tpm_tis arc4 ecb pcmcia iwl3945 iTCO_wdt ohci1394 firmware_class iTCO_vendor_support yenta_socket watchdog_core thermal rsrc_nonstatic mac80211 snd_hda_intel intel_agp watchdog_dev ieee1394 pcmcia_core processor button ac battery cfg80211
> [   74.256373] Pid: 1767, comm: halt Not tainted 2.6.25-rc3-mm1 #8
> [   74.256373] RIP: 0010:[<ffffffff80211872>]  [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
> [   74.256373] RSP: 0018:ffff81007ac63d10  EFLAGS: 00010093
> [   74.256373] RAX: ffffffff80573190 RBX: ffff81007f83a8c0 RCX: ffffffff80563cec
> [   74.256373] RDX: ffffffff8020a023 RSI: ffffffff8078a0b8 RDI: ffffffff80783018
> [   74.256373] RBP: ffff81007ac63d28 R08: 0000000000000001 R09: ffffffff80563cec
> [   74.256373] R10: ffffffff80200000 R11: ffff81007ac63d1f R12: 0000000000000000
> [   74.256373] R13: 0000000000000001 R14: 0000000000000246 R15: ffff81007d156340
> [   74.256373] FS:  00007f2d0ab206f0(0000) GS:ffffffff8076e000(0000) knlGS:0000000000000000
> [   74.256373] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   74.256373] CR2: ffffffff8020a023 CR3: 000000007edf3000 CR4: 00000000000006e0
> [   74.256373] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   74.256373] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   74.256373] Process halt (pid: 1767, threadinfo ffff81007ac62000, task ffff81007db96300)
> [   74.256373] Stack:  ffffffff8080df80 90ffffff8055ba3b ffff81007f83a8c0 ffff81007ac63d68
> [   74.256374]  ffffffff80211a01 ffffffff807c6584 0000000000000001 ffffffff807c6584
> [   74.256374]  0000000000000001 0000000000000001 0000000000000001 ffff81007ac63d98
> [   74.256374] Call Trace:
> [   74.256374]  [<ffffffff80211a01>] alternatives_smp_switch+0x17a/0x1b6
> [   74.256374]  [<ffffffff80219dd3>] __cpu_die+0x58/0x87
> [   74.256374]  [<ffffffff805498b2>] _cpu_down+0x1a4/0x28c
> [   74.256374]  [<ffffffff80252e90>] disable_nonboot_cpus+0x60/0x108
> [   74.256374]  [<ffffffff80241619>] kernel_power_off+0x21/0x3b
> [   74.256374]  [<ffffffff80241863>] sys_reboot+0xf8/0x196
> [   74.256374]  [<ffffffff8055b93f>] ? preempt_schedule+0x3c/0xaa
> [   74.256374]  [<ffffffff8055b9a4>] ? preempt_schedule+0xa1/0xaa
> [   74.256374]  [<ffffffff8023e7eb>] ? sys_kill+0xd8/0x1c1
> [   74.256374]  [<ffffffff8055c112>] ? do_nanosleep+0x4b/0xd6
> [   74.256374]  [<ffffffff8020c21b>] system_call_after_swapgs+0x7b/0x80
> [   74.256374] 
> [   74.256374] 
> [   74.256374] Code: 57 80 48 0f 42 d0 48 8b 42 08 4c 8d 5d f7 8a 00 41 b8 01 00 00 00 88 45 f7 eb 1b 48 8b 17 4c 39 d2 72 0f 4c 39 ca 77 0a 41 8a 03 <88> 02 44 89 c0 0f a2 48 83 c7 08 48 39 f7 72 e0 5a 59 5b c9 c3 
> [   74.256374] RIP  [<ffffffff80211872>] alternatives_smp_unlock+0x66/0x7b
> [   74.256374]  RSP <ffff81007ac63d10>
> [   74.256374] CR2: ffffffff8020a023

Yes, I hit a similar one during halt on the t61p.  But because of the
netconsole bustage I was only able to see (on the screen) oops #2 - oops #1
had scrolled off.  oops #2 had a simlar trace and the EIP was in
text_poke().

I suppose one of us should bisect it.
