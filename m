Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZFPNIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZFPNIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 09:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZFPNId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 09:08:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47652 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbZFPNIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 09:08:32 -0400
Date: Tue, 16 Jun 2009 15:08:33 +0200
From: Nick Piggin <npiggin@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: 2.6.29.4: softlockup at find_get_page() et al
Message-ID: <20090616130833.GA27925@wotan.suse.de>
References: <20090616110051.GA4864@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616110051.GA4864@x200.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 03:00:51PM +0400, Alexey Dobriyan wrote:
> Happened during overnight run when box was cross-compiling kernel slowly
> (only -j7).
> 
> Example messages:
> 
> [67287.109985] BUG: soft lockup - CPU#0 stuck for 61s! [conf:3980]
> [67287.110001] CPU 0:
> [67287.110001] Pid: 3980, comm: conf Not tainted 2.6.29.4-x86_64 #1 P5E
> [67287.110001] RIP: 0010:[<ffffffff80264902>]  [<ffffffff80264902>] find_get_page+0x52/0xb0
> [67287.110001] RSP: 0018:ffff8801001eddd8  EFLAGS: 00000246
> [67287.110001] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000034
> [67287.110001] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffe200010a9f40
> [67287.110001] RBP: ffffffff8020c3ee R08: ffffe200010a9f48 R09: ffff8800aa798c28
> [67287.110001] R10: ffffe200010a9f40 R11: ffffffff802f9480 R12: ffff8800aa798c18
> [67287.110001] R13: ffffffff8020c3ee R14: ffffffff802f4e70 R15: 000000000000000c
> [67287.110001] FS:  0000000000000000(0000) GS:ffffffff8075b040(0063) knlGS:00000000557116c0
> [67287.110001] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [67287.110001] CR2: 00000000556d9374 CR3: 000000012faa4000 CR4: 00000000000006e0
> [67287.110001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [67287.110001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [67287.110001] Call Trace:
> [67287.110001]  [<ffffffff802648cb>] ? find_get_page+0x1b/0xb0
> [67287.110001]  [<ffffffff80264bf3>] ? find_lock_page+0x23/0x80
> [67287.110001]  [<ffffffff80265631>] ? find_or_create_page+0x41/0xc0
> [67287.110001]  [<ffffffff802f4edd>] ? ext2_make_empty+0x2d/0x1f0
> [67287.110001]  [<ffffffff802f9556>] ? ext2_mkdir+0xd6/0x170
> [67287.110001]  [<ffffffff8029b37c>] ? sys_mkdirat+0x11c/0x130
> [67287.110001]  [<ffffffff802a585a>] ? alloc_fd+0x4a/0x140
> [67287.110001]  [<ffffffff8022ab14>] ? sysenter_dispatch+0x7/0x2b
> [67352.609983] BUG: soft lockup - CPU#0 stuck for 61s! [conf:3980]
> [67352.610001] CPU 0:
> [67352.610001] Pid: 3980, comm: conf Not tainted 2.6.29.4-x86_64 #1 P5E
> [67352.610001] RIP: 0010:[<ffffffff8026dfbe>]  [<ffffffff8026dfbe>] put_page+0x2e/0x170
> [67352.610001] RSP: 0018:ffff8801001eddc8  EFLAGS: 00000202
> [67352.610001] RAX: ffffe200010a9f48 RBX: ffff8800aa798c18 RCX: 0000000000000034
> [67352.610001] RDX: 0000000000000000 RSI: ffffe200010a9f40 RDI: ffffe200010a9f40
> [67352.610001] RBP: ffffffff8020c3ee R08: fa00000000000000 R09: 8000000000000000
> [67352.610001] R10: ffffe200010a9f40 R11: ffffffff802f9480 R12: ffffffff802f4e70
> [67352.610001] R13: 000000000000000c R14: ffffffff80299de9 R15: 0000000100000241
> [67352.610001] FS:  0000000000000000(0000) GS:ffffffff8075b040(0063) knlGS:00000000557116c0
> [67352.610001] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [67352.610001] CR2: 00000000556d9374 CR3: 000000012faa4000 CR4: 00000000000006e0
> [67352.610001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [67352.610001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [67352.610001] Call Trace:
> [67352.610001]  [<ffffffff80264c42>] ? find_lock_page+0x72/0x80
> [67352.610001]  [<ffffffff80265631>] ? find_or_create_page+0x41/0xc0
> [67352.610001]  [<ffffffff802f4edd>] ? ext2_make_empty+0x2d/0x1f0
> [67352.610001]  [<ffffffff802f9556>] ? ext2_mkdir+0xd6/0x170
> [67352.610001]  [<ffffffff8029b37c>] ? sys_mkdirat+0x11c/0x130
> [67352.610001]  [<ffffffff802a585a>] ? alloc_fd+0x4a/0x140
> [67352.610001]  [<ffffffff8022ab14>] ? sysenter_dispatch+0x7/0x2b
> [67418.109983] BUG: soft lockup - CPU#0 stuck for 61s! [conf:3980]
> [67418.110001] CPU 0:
> [67418.110001] Pid: 3980, comm: conf Not tainted 2.6.29.4-x86_64 #1 P5E
> [67418.110001] RIP: 0010:[<ffffffff8026492e>]  [<ffffffff8026492e>] find_get_page+0x7e/0xb0
> [67418.110001] RSP: 0018:ffff8801001eddd8  EFLAGS: 00000246
> [67418.110001] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000001
> [67418.110001] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffe200010a9f40
> [67418.110001] RBP: ffffffff8020c3ee R08: ffffe200010a9f48 R09: ffff8800aa798c28
> [67418.110001] R10: ffffe200010a9f40 R11: ffffffff802f9480 R12: ffff8800aa798c18
> [67418.110001] R13: ffffffff8020c3ee R14: ffffffff802f4e70 R15: 000000000000000c
> [67418.110001] FS:  0000000000000000(0000) GS:ffffffff8075b040(0063) knlGS:00000000557116c0
> [67418.110001] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [67418.110001] CR2: 00000000556d9374 CR3: 000000012faa4000 CR4: 00000000000006e0
> [67418.110001] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [67418.110001] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [67418.110001] Call Trace:
> [67418.110001]  [<ffffffff802648cb>] ? find_get_page+0x1b/0xb0
> [67418.110001]  [<ffffffff80264bf3>] ? find_lock_page+0x23/0x80
> [67418.110001]  [<ffffffff80265631>] ? find_or_create_page+0x41/0xc0
> [67418.110001]  [<ffffffff802f4edd>] ? ext2_make_empty+0x2d/0x1f0
> [67418.110001]  [<ffffffff802f9556>] ? ext2_mkdir+0xd6/0x170
> [67418.110001]  [<ffffffff8029b37c>] ? sys_mkdirat+0x11c/0x130
> [67418.110001]  [<ffffffff802a585a>] ? alloc_fd+0x4a/0x140
> [67418.110001]  [<ffffffff8022ab14>] ? sysenter_dispatch+0x7/0x2b
> 
> 	...
> 
> Then box became unusable:
> 
> [90276.999985] BUG: soft lockup - CPU#0 stuck for 61s! [conf:3980]
> [90277.000002] CPU 0:
> [90277.000002] Pid: 3980, comm: conf Not tainted 2.6.29.4-x86_64 #1 P5E
> [90277.000002] RIP: 0010:[<ffffffff80264902>]  [<ffffffff80264902>] find_get_page+0x52/0xb0
> [90277.000002] RSP: 0018:ffff8801001eddd8  EFLAGS: 00000246
> [90277.000002] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000034
> [90277.000002] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffffe200010a9f40
> [90277.000002] RBP: ffffffff8020c3ee R08: ffffe200010a9f48 R09: ffff8800aa798c28
> [90277.000002] R10: ffffe200010a9f40 R11: ffffffff802f9480 R12: ffff8800aa798c18
> [90277.000002] R13: ffffffff8020c28e R14: ffffffff802f4e70 R15: 000000000000000c
> [90277.000002] FS:  0000000000000000(0000) GS:ffffffff8075b040(0063) knlGS:00000000557116c0
> [90277.000002] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
> [90277.000002] CR2: 00000000556d9374 CR3: 000000012faa4000 CR4: 00000000000006e0
> [90277.000002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [90277.000002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [90277.000002] Call Trace:
> [90277.000002]  [<ffffffff802648cb>] ? find_get_page+0x1b/0xb0
> [90277.000002]  [<ffffffff80264bf3>] ? find_lock_page+0x23/0x80
> [90277.000002]  [<ffffffff80265631>] ? find_or_create_page+0x41/0xc0
> [90277.000002]  [<ffffffff802f4edd>] ? ext2_make_empty+0x2d/0x1f0
> [90277.000002]  [<ffffffff802f9556>] ? ext2_mkdir+0xd6/0x170
> [90277.000002]  [<ffffffff8029b37c>] ? sys_mkdirat+0x11c/0x130
> [90277.000002]  [<ffffffff802a585a>] ? alloc_fd+0x4a/0x140
> [90277.000002]  [<ffffffff8022ab14>] ? sysenter_dispatch+0x7/0x2b
> [90279.364317] nf_conntrack: table full, dropping packet.
> [90282.362418] nf_conntrack: table full, dropping packet.
> 	...
> 
> FWIW, userpace is 32-bit, ext2 is used to host source tree, build result
> and ccache.

Thanks. Is it rebooted? It would be interesting to know what other
CPUs are doing (and even what other tasks are doing) if it is
still up.


