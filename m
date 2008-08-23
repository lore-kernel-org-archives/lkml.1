Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYHWHMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYHWHMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 03:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbYHWHM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 03:12:27 -0400
Received: from saeurebad.de ([85.214.36.134]:54378 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbYHWHM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 03:12:26 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: 9a2d43b: __alloc_bootmem_core(): zero-sized request
References: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
Date: Sat, 23 Aug 2008 09:12:06 +0200
In-Reply-To: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
	(Vegard Nossum's message of "Fri, 22 Aug 2008 21:24:50 +0200")
Message-ID: <87myj4yzll.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Vegard Nossum" <vegard.nossum@gmail.com> writes:

> Hi,
>
> I was trying out
>
> commit 9a2d43b7566caeeeb414aa628bc2759028897dbb
> Date:   Tue Jul 15 21:21:43 2008 +0200
>
> ..as part of the debugging of a different issue, but I got this:
>
> __alloc_bootmem_core(): zero-sized request
> ------------[ cut here ]------------
> kernel BUG at /uio/arkimedes/s29/vegardno/git-working/linux-2.6/mm/bootmem.c:247!
> invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 0, comm: swapper Not tainted (2.6.26-00014-g9a2d43b #34)
> EIP: 0060:[<c082be18>] EFLAGS: 00010286 CPU: 0
> EIP is at __alloc_bootmem_core+0x28/0x300
> EAX: 0000002e EBX: 00000080 ECX: c080e000 EDX: 00000002
> ESI: 01000000 EDI: 01000000 EBP: c080ff44 ESP: c080ff00
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=c080e000 task=c078d400 task.ti=c080e000)
> Stack: c0716894 c080ff14 c0636753 0000230d 00000080 00000000 c08c2fa0 00000096
>        ffffdcf3 34791ce0 00000217 c080ffac c0136894 c080ffac 00000080 00000000
>        01000000 c080ff60 c082c28c 01000000 00000000 00000000 00000400 00000000
> Call Trace:
>  [<c0636753>] ? _spin_unlock_irqrestore+0x43/0x70
>  [<c0136894>] ? vprintk+0x1c4/0x420
>  [<c082c28c>] ? __alloc_bootmem_node+0x2c/0x50
>  [<c082d370>] ? alloc_large_system_hash+0x1e0/0x2d0
>  [<c03704f2>] ? dotest+0x382/0x400
>  [<c082e40c>] ? vfs_caches_init_early+0x5c/0xb0
>  [<c08159f0>] ? start_kernel+0x250/0x390
>  [<c0815180>] ? unknown_bootoption+0x0/0x210
>  [<c0815008>] ? __init_begin+0x8/0x10
>  =======================
> Code: 00 00 00 55 89 e5 57 56 53 83 ec 38 85 d2 8b 75 08 89 4d cc 8b
> 4d 0c 89 45 d4 89 55 d0 75 14 c7 04 24 94 68 71 c0 e8 d8 ac 90 ff <0f>
> 0b eb fe 8d 74 26 00 8b 7d cc 83 ef 01 85 7d cc 75 16 8b 55
> EIP: [<c082be18>] __alloc_bootmem_core+0x28/0x300 SS:ESP 0068:c080ff00
> ---[ end trace 4eaa2a86a8e2da22 ]---
>
> I saw some bootmem errata lately, can I cherry-pick anything to fix
> this?

This behaviour hasn't changed after the rewrite.

	Hannes
