Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYKQRh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYKQRh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYKQRht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:37:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60783 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbYKQRht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:37:49 -0500
Date: Mon, 17 Nov 2008 18:37:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix wakeup_cpu with numaq/es7000 v2
Message-ID: <20081117173728.GA7384@elte.hu>
References: <491FDE2A.1010809@kernel.org> <49200031.2040701@kernel.org> <20081117165224.GH12081@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117165224.GH12081@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, one of my testboxes is rather unhappy about your patch:

[   54.718062] SMP alternatives: switching to SMP code
[   55.083610] Booting processor 1 APIC 0x1 ip 0x6000
[   55.088329] BUG: unable to handle kernel paging request at ffffffff817b0880
[   55.092304] IP: [<ffffffff80f5ce20>] native_cpu_up+0x410/0xf30
[   55.092304] PGD 203067 PUD 207063 PMD 3d7dc163 PTE 17b0162
[   55.092304] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   55.092304] last sysfs file: /sys/devices/system/cpu/cpu1/online
[   55.092304] CPU 0 
[   55.092304] Pid: 7165, comm: S99local Not tainted 2.6.28-rc5-tip #53217
[   55.092304] RIP: 0010:[<ffffffff80f5ce20>]  [<ffffffff80f5ce20>] native_cpu_up+0x410/0xf30
[   55.092304] RSP: 0018:ffff8800398bfcd8  EFLAGS: 00010296
[   55.092304] RAX: 0000000000000000 RBX: ffffffff81820068 RCX: 0000000000000000
[   55.092304] RDX: 000000000000f3f2 RSI: 0000000000000000 RDI: 0000000000000280
[   55.092304] RBP: ffff8800398bfe18 R08: 0000000000000002 R09: 0000000000000000
[   55.092304] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000006000
[   55.092304] R13: 0000000000000001 R14: ffffffff80f5de20 R15: 0000000000000001
[   55.092304] FS:  00007fd7562d76f0(0000) GS:ffffffff81726500(0000) knlGS:00000000f7f116c0
[   55.092304] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   55.092304] CR2: ffffffff817b0880 CR3: 000000003ce2e000 CR4: 00000000000006a0
[   55.092304] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   55.092304] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   55.092304] Process S99local (pid: 7165, threadinfo ffff8800398be000, task ffff88003cf08000)
[   55.092304] Stack:
[   55.092304]  ffff8800398bfd28 ffff8800025fb908 ffff88003d7d5910 0000000000000000
[   55.092304]  ffffffffdead4ead ffffffffffffffff ffffffff81c19fe8 0000000000000000
[   55.092304]  ffffffff8135f488 0000000000000000 ffff8800398bfe18 0000000000000008
[   55.092304] Call Trace:
[   55.092304]  [<ffffffff80f5c8f0>] ? do_fork_idle+0x0/0x40
[   55.092304]  [<ffffffff80f5fa6f>] _cpu_up+0x9f/0x130
[   55.092304]  [<ffffffff80f5fb59>] cpu_up+0x59/0x90
[   55.092304]  [<ffffffff80ef7788>] store_online+0x68/0xa0
[   55.092304]  [<ffffffff806c4820>] sysdev_store+0x20/0x30
[   55.092304]  [<ffffffff8034d885>] sysfs_write_file+0xf5/0x150
[   55.092304]  [<ffffffff802fea4c>] vfs_write+0xcc/0x170
[   55.092304]  [<ffffffff802febe5>] sys_write+0x55/0x90
[   55.092304]  [<ffffffff8022f8ea>] system_call_fastpath+0x16/0x1b
[   55.092304] Code: 05 f1 ec 3c 01 40 0f 85 3f 08 00 00 48 8b 05 98 99 7c 00 bf 80 02 00 00 31 f6 ff 50 08 48 8b 05 87 99 7c 00 bf 80 02 00 00 ff 10 <48> 8b 05 59 3a 85 00 48 8b 40 70 48 85 c0 0f 84 62 03 00 00 4c 
[   55.092304] RIP  [<ffffffff80f5ce20>] native_cpu_up+0x410/0xf30
[   55.092304]  RSP <ffff8800398bfcd8>
[   55.092304] CR2: ffffffff817b0880
[   55.092304] ---[ end trace 627abebe98896ded ]---

Config attached. Please send delta fix against the patch in 
tip/x86/quirks. (i've excluded the branch from tip/master for now)

	Ingo
