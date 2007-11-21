Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXKUJoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXKUJoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 04:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbXKUJoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 04:44:10 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:51037 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbXKUJoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 04:44:08 -0500
Message-ID: <4743FDBF.7010900@linux.vnet.ibm.com>
Date: Wed, 21 Nov 2007 15:13:27 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-acpi@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <4743CC0B.9000508@linux.vnet.ibm.com> <20071120221839.faab108e.akpm@linux-foundation.org> <4743F8D2.2090302@linux.vnet.ibm.com> <20071121012918.eff93b22.akpm@linux-foundation.org>
In-Reply-To: <20071121012918.eff93b22.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 21 Nov 2007 14:52:26 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
>> Andrew Morton wrote:
>>> On Wed, 21 Nov 2007 11:41:23 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>>>
>>>> Hi Andrew,
>>>>
>>>> Kernel panic's across different architectures like powerpc, x86_64, 
>>> powerpc complains about IO-APICs??
>>>
>>>> Dentry cache hash table entries: 8388608 (order: 14, 67108864 bytes)
>>>> Inode-cache hash table entries: 4194304 (order: 13, 33554432 bytes)
>>>> Mount-cache hash table entries: 256
>>>> SMP alternatives: switching to UP code
>>>> ACPI: Core revision 20070126
>>>> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>>>> Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter
>>> ACPI or x86 breakage, I guess.
>>>
>>> Did 'noapic' work?
>> Hi Andrew,
>>
>> Passing noapic works,
> 
> OK.
> 
>>  but the kernel oops's 
>>
>> [   97.161103] Unable to handle kernel NULL pointer dereference at 0000000000000009 RIP:
>> [   97.193973]  [<ffffffff802341df>] cpu_to_allnodes_group+0x69/0x7c
>> [   97.245359] PGD 0
>> [   97.257611] Oops: 0000 [1] SMP
>> [   97.276638] last sysfs file:
>> [   97.294417] CPU 0
>> [   97.306620] Modules linked in:
>> [   97.325066] Pid: 1, comm: swapper Not tainted 2.6.24-rc3-mm1 #1
>> [   97.360514] RIP: 0010:[<ffffffff802341df>]  [<ffffffff802341df>] cpu_to_allnodes_group+0x69/0x7c
>> [   97.413287] RSP: 0000:ffff81012fabb650  EFLAGS: 00010286
>> [   97.445363] RAX: ffffffff809bb060 RBX: ffff81012fabb650 RCX: 00000000000000ff
>> [   97.488378] RDX: 0000000000000001 RSI: 000000000000013e RDI: 0000000000000100
>> [   97.531413] RBP: ffff81012fabb680 R08: ffff81012fa88180 R09: 0000000000000000
>> [   97.574428] R10: 0000000000000000 R11: 0000000000000000 R12: ffff810001005f50
>> [   97.617394] R13: 0000000000000000 R14: ffff81012fa88180 R15: ffff810001005f40
>> [   97.660421] FS:  0000000000000000(0000) GS:ffffffff806c3000(0000) knlGS:0000000000000000
>> [   97.709327] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>> [   97.743995] CR2: 0000000000000009 CR3: 0000000000201000 CR4: 00000000000006a0
>> [   97.787021] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> [   97.830053] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> [   97.873036] Process swapper (pid: 1, threadinfo FFFF81012FABA000, task FFFF81012FAB8040)
>> [   97.921993] Stack:  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [   97.971056]  ffff810001005f40 ffff81012fabb700 ffff81012fabbdf0 ffffffff80235487
>> [   98.016420]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> [   98.060324] Call Trace:
>> [   98.076657]  [<ffffffff80235487>] build_sched_domains+0x1e1/0xc19
>> [   98.113383]  [<ffffffff8025072a>] __kernel_text_address+0x22/0x30
>> [   98.150173]  [<ffffffff8025b127>] check_chain_key+0x9c/0x15f
>> [   98.184355]  [<ffffffff8025d544>] mark_lock+0x3b/0x5b3
>> [   98.215406]  [<ffffffff8025db06>] mark_held_locks+0x4a/0x6a
>> [   98.249027]  [<ffffffff80284f4a>] get_page_from_freelist+0x42a/0x77d
>> [   98.287362]  [<ffffffff8025dda1>] trace_hardirqs_on+0x198/0x1c3
>> [   98.323123]  [<ffffffff8028527a>] get_page_from_freelist+0x75a/0x77d
>> [   98.361429]  [<ffffffff8025d544>] mark_lock+0x3b/0x5b3
>> [   98.392427]  [<ffffffff8025b127>] check_chain_key+0x9c/0x15f
>> [   98.426621]  [<ffffffff8034d01a>] number+0x115/0x21f
>> [   98.456594]  [<ffffffff8025072a>] __kernel_text_address+0x22/0x30
>> [   98.493362]  [<ffffffff8020d80c>] dump_trace+0x248/0x25d
>> [   98.525493]  [<ffffffff8025b127>] check_chain_key+0x9c/0x15f
>> [   98.559678]  [<ffffffff8025f03f>] __lock_acquire+0xdee/0xf06
>> [   98.593868]  [<ffffffff8025b127>] check_chain_key+0x9c/0x15f
>> [   98.628038]  [<ffffffff8025b127>] check_chain_key+0x9c/0x15f
>> [   98.662225]  [<ffffffff8025b127>] check_chain_key+0x9c/0x15f
>> [   98.696370]  [<ffffffff8025f03f>] __lock_acquire+0xdee/0xf06
>> [   98.730563]  [<ffffffff8025b127>] check_chain_key+0x9c/0x15f
>> [   98.764689]  [<ffffffff8025d544>] mark_lock+0x3b/0x5b3
>> [   98.795767]  [<ffffffff8025db06>] mark_held_locks+0x4a/0x6a
>> [   98.829432]  [<ffffffff8034d01a>] number+0x115/0x21f
>> [   98.859460]  [<ffffffff804ca267>] kprobe_flush_task+0x63/0xa9
>> [   98.894166]  [<ffffffff8034ddbd>] vsnprintf+0x58f/0x5d5
>> [   98.925739]  [<ffffffff8034de6b>] sprintf+0x68/0x6a
>> [   98.955257]  [<ffffffff8025f1c9>] lock_acquire+0x72/0xe0
>> [   98.987363]  [<ffffffff8025ca45>] lock_acquired+0x57/0x1d4
>> [   99.020446]  [<ffffffff8025f430>] lock_release+0x67/0x21a
>> [   99.053079]  [<ffffffff8025b127>] check_chain_key+0x9c/0x15f
>> [   99.087261]  [<ffffffff8025d544>] mark_lock+0x3b/0x5b3
>> [   99.118328]  [<ffffffff8025d544>] mark_lock+0x3b/0x5b3
>> [   99.149394]  [<ffffffff80236330>] arch_init_sched_domains+0x27/0x69
>> [   99.187217]  [<ffffffff802a5a5f>] dbg_redzone2+0x2a/0x52
>> [   99.219320]  [<ffffffff802a656b>] cache_alloc_debugcheck_after+0x16e/0x1cb
>> [   99.260779]  [<ffffffff802a8083>] kmem_cache_alloc+0x15e/0x182
>> [   99.295944]  [<ffffffff80236365>] arch_init_sched_domains+0x5c/0x69
>> [   99.333768]  [<ffffffff8098e501>] sched_init_smp+0x27/0x113
>> [   99.367400]  [<ffffffff8034ff35>] __bitmap_weight+0x78/0x8d
>> [   99.401090]  [<ffffffff8097e631>] kernel_init+0x12d/0x315
>> [   99.433718]  [<ffffffff804c6f57>] _spin_unlock_irq+0x2b/0x30
>> [   99.467842]  [<ffffffff8025dda1>] trace_hardirqs_on+0x198/0x1c3
>> [   99.503534]  [<ffffffff8025dda1>] trace_hardirqs_on+0x198/0x1c3
>> [   99.539251]  [<ffffffff8020d1b8>] child_rip+0xa/0x12
>> [   99.569234]  [<ffffffff8020c8cf>] restore_args+0x0/0x30
>> [   99.600845]  [<ffffffff8097e504>] kernel_init+0x0/0x315
>> [   99.632426]  [<ffffffff8020d1ae>] child_rip+0x0/0x12
>> [   99.662455]
>> [   99.671637] INFO: lockdep is turned off.
>> [   99.695385]
>> [   99.695385] Code: 48 03 42 08 49 89 04 24 48 83 c4 20 89 c8 5b 41 5c c9 c3 55
>> [   99.750603] RIP  [<ffffffff802341df>] cpu_to_allnodes_group+0x69/0x7c
>> [   99.789632]  RSP <ffff81012fabb650>
> 
> urgh, mess.  Enabling frame pointers might help here.
> 
> But we're cc'ing the right guy ;)
> 

The kernel was compiled with frame pointers enabled.
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
