Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbYHONuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbYHONuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYHONun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:50:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36039 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbYHONum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:50:42 -0400
Date: Fri, 15 Aug 2008 15:50:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix 2 section mismatch warnings -
	find_and_reserve_crashkernel
Message-ID: <20080815135027.GB14103@elte.hu>
References: <1218576186-31442-3-git-send-email-marcin.slusarz@gmail.com> <20080813111051.GA18660@elte.hu> <20080813140555.GA18523@elte.hu> <20080815123201.GB5285@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080815123201.GB5285@joi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> I looked at both implementations of arch_setup_additional_pages and 
> didn't see any call to native_set_fixmap or function which calls 
> directly native_set_fixmap... Can you tell me what's the callchain?

the callchain would be:

[   20.116039] PM: Adding info for No Bus:vcsa1
[   20.180039] BUG: unable to handle kernel paging request at c0833e44
[   20.180039] IP: [<c0833e44>] native_set_fixmap+0x0/0x1d
[   20.180039] *pde = 36f2a163 *pte = 00833162
[   20.180039] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
[   20.180039] Modules linked in:
[   20.180039]
[   20.180039] Pid: 1, comm: init Not tainted (2.6.27-rc3-00005-g844342a-dirty #24071)
[   20.180039] EIP: 0060:[<c0833e44>] EFLAGS: 00010216 CPU: 0
[   20.180039] EIP is at native_set_fixmap+0x0/0x1d
[   20.180039] EAX: 00000001 EBX: 00000001 ECX: 00000025 EDX: 3782e000
[   20.180039] ESI: 00000000 EDI: f671c000 EBP: f7836e68 ESP: f7836e4c
[   20.180039]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   20.180039] Process init (pid: 1, ti=f7836000 task=f7870000 task.ti=f7836000)
[   20.180039] Stack: c011d580 f671c034 c018bbea 00000025 00000000 00000988 f6ef2000 f7836f1c
[   20.180039]        c01b43d6 00000003 00000008 f7836f7c f782fd10 00000003 f78b6100 08048000
[   20.180039]        00000000 00000001 f67a2500 08050b99 08050b99 00000000 00000000 00000000
[   20.180039] Call Trace:
[   20.180039]  [<c011d580>] ? arch_setup_additional_pages+0x8c/0x124
[   20.180039]  [<c018bbea>] ? try_module_get+0x8/0x2f
[   20.180039]  [<c01b43d6>] ? load_elf_binary+0xae6/0x1108
[   20.180039]  [<c0144c6d>] ? lock_release_holdtime+0x43/0x48
[   20.180039]  [<c018c0c0>] ? search_binary_handler+0x92/0x1e5
[   20.180039]  [<c01b38f0>] ? load_elf_binary+0x0/0x1108
[   20.180039]  [<c018d2d7>] ? do_execve+0x14c/0x1d8
[   20.180039]  [<c0101dd8>] ? sys_execve+0x2e/0x56
[   20.180039]  [<c01030ca>] ? syscall_call+0x7/0xb
[   20.180039]  [<c01067c8>] ? kernel_execve+0x1c/0x21
[   20.180039]  [<c0101286>] ? run_init_process+0x1c/0x1e
[   20.180039]  [<c0101333>] ? init_post+0xab/0xd4
[   20.180039]  [<c0103d07>] ? kernel_thread_helper+0x7/0x10
[   20.180039]  =======================
[   20.180039] Code:  Bad EIP value.

	Ingo
