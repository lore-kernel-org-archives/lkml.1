Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZCJNfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZCJNfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZCJNew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:34:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbZCJNev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:34:51 -0400
Date: Tue, 10 Mar 2009 14:34:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>, Vegard Nossum <vegard.nossum@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: panic with strcmp
Message-ID: <20090310133443.GC29391@elte.hu>
References: <86802c440903091251x41899167r96680c62c35ad63b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440903091251x41899167r96680c62c35ad63b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Vegard Cc:-ed. Incidentally he found a use-after-free bug via 
kmemcheck in the sysfs code. Could it be related?)

* Yinghai Lu <yinghai@kernel.org> wrote:

> happen on kexec loop test, it seems it only do kexec three 
> time continuous. only on one two sockets with quad core 
> opteron + 16 sas disks.
> 
> YH
> 
> [   11.139038] calling  pty_init+0x0/0x606 @ 1
> [   11.163070] general protection fault: 0000 [#1] SMP
> [   11.167058] last sysfs file:
> [   11.167058] CPU 5
> [   11.167058] Modules linked in:
> [   11.167058] Pid: 1, comm: swapper Not tainted
> 2.6.29-rc7-tip-02233-ga94bfce-dirty #736 SMP Mon Mar 9 11:24:51 PDT
> 2009 Sun Fire X4240
> [   11.167058] RIP: 0010:[<ffffffff8053244d>]  [<ffffffff8053244d>]
> strcmp+0x19/0x45
> [   11.167058] RSP: 0018:ffff8804270499f0  EFLAGS: 00010246
> [   11.167058] RAX: 0000000000000000 RBX: ffff88042403e050 RCX: ffff880424776270
> [   11.167058] RDX: 0000000000000000 RSI: ffff880224676080 RDI: 0010c2c018100dbf
> [   11.167058] RBP: ffff880427049a00 R08: 0000000000000001 R09: ffff880427049978
> [   11.167058] R10: 000000003ce73f1d R11: 000000003ce73f20 R12: ffff880224676080
> [   11.167058] R13: ffff880427049ab0 R14: ffff880424776280 R15: ffff880427049b28
> [   11.167058] FS:  0000000000000000(0000) GS:ffffc20000069000(0000)
> knlGS:0000000000000000
> [   11.167058] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [   11.167058] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> [   11.167058] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   11.167058] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   11.167058] Process swapper (pid: 1, threadinfo ffff880427048000,
> task ffff880227060000)
> [   11.167058] Stack:
> [   11.167058]  0000000000000006 000000003ce73f1d ffff880427049a30
> ffffffff8034562e
> [   11.167058]  ffff880227c0b800 000000003ce73f1d ffff880224675f50
> ffff880224675f50
> [   11.167058]  ffff880427049a70 ffffffff803457ed 0000000000000001
> ffff880427049a6c
> [   11.167058] Call Trace:
> [   11.167058]  [<ffffffff8034562e>] sysfs_find_dirent+0x2f/0x5a
> [   11.167058]  [<ffffffff803457ed>] __sysfs_add_one+0x2e/0xd8
> [   11.167058]  [<ffffffff803458b9>] sysfs_add_one+0x22/0x68
> [   11.167058]  [<ffffffff80345fd9>] create_dir+0x67/0xb6
> [   11.167058]  [<ffffffff8034606f>] sysfs_create_dir+0x47/0x72
> [   11.167058]  [<ffffffff8052e05e>] kobject_add_internal+0xe4/0x1ba
> [   11.167058]  [<ffffffff8052e264>] kobject_add_varg+0x50/0x73
> [   11.167058]  [<ffffffff8052e374>] kobject_add+0x73/0x89
> [   11.167058]  [<ffffffff805dcbd6>] device_add+0xcf/0x56f
> [   11.167058]  [<ffffffff8052dbe4>] ? kobject_init+0x56/0xac
> [   11.167058]  [<ffffffff805dd09e>] device_register+0x28/0x43
> [   11.167058]  [<ffffffff805dd167>] device_create_vargs+0xae/0xf0
> [   11.167058]  [<ffffffff805dd1e4>] device_create+0x3b/0x51
> [   11.167058]  [<ffffffff805e1f1a>] ? kobj_map+0x12f/0x154
> [   11.167058]  [<ffffffff8059f792>] tty_register_device+0xe9/0x10a
> [   11.167058]  [<ffffffff8059f996>] tty_register_driver+0x1e3/0x221
> [   11.167058]  [<ffffffff8112938d>] ? pty_init+0x0/0x606
> [   11.167058]  [<ffffffff8112963b>] pty_init+0x2ae/0x606
> [   11.167058]  [<ffffffff80209092>] do_one_initcall+0x65/0x14e
> [   11.167058]  [<ffffffff810fa80e>] kernel_init+0x14a/0x1b6
> [   11.167058]  [<ffffffff80230d5a>] child_rip+0xa/0x20
> [   11.167058]  [<ffffffff810fa6c4>] ? kernel_init+0x0/0x1b6
> [   11.167058]  [<ffffffff80230d50>] ? child_rip+0x0/0x20
> [   11.167058] Code: 14 25 28 00 00 00 48 89 f8 74 05 e8 57 98 d3 ff
> c9 c3 55 31 d2 48 89 e5 48 83 ec 10 65 48 8b 04 25 28 00 00 00 48 89
> 45 f8 31 c0 <8a> 0c 17 88 c8 2a 04 16 84 c0 75 07 48 ff c2 84 c9 75 ed
> 48 8b
> [   11.167058] RIP  [<ffffffff8053244d>] strcmp+0x19/0x45
> [   11.167058]  RSP <ffff8804270499f0>
> [   11.461778] ---[ end trace 800948b0be98e94c ]---
