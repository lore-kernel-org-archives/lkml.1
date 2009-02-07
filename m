Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323AbZBGAPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323AbZBGAPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 19:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbZBGAPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 19:15:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbZBGAPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 19:15:23 -0500
Date: Fri, 6 Feb 2009 16:15:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: namespaces?: bug at mm/slub.c:2750
Message-Id: <20090206161518.81e7d42c.akpm@linux-foundation.org>
In-Reply-To: <20090206113556.GA3161@alice>
References: <20090206113556.GA3161@alice>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 12:35:56 +0100
Eric Sesterhenn <snakebyte@gmx.de> wrote:

> Hi,
> 
> with todays -git i get the following bug when i reboot the machine
> 
> [   94.369135] ------------[ cut here ]------------
> [   94.369344] kernel BUG at mm/slub.c:2750!
> [   94.369463] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [   94.369828] last sysfs file: /sys/devices/pnp0/00:0c/id
> [   94.369952] Modules linked in:
> [   94.370035] 
> [   94.370035] Pid: 0, comm: swapper Not tainted
> (2.6.29-rc3-00653-g8285bbf #240) System Name
> [   94.370035] EIP: 0060:[<c018340b>] EFLAGS: 00010246 CPU: 0
> [   94.370035] EIP is at kfree+0x3c/0xe4
> [   94.370035] EAX: 00000400 EBX: c1139000 ECX: 00000000 EDX: c09fb204
> [   94.370035] ESI: c114cf60 EDI: c09fb204 EBP: c0ab0f94 ESP: c0ab0f80
> [   94.370035]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> [   94.370035] Process swapper (pid: 0, ti=c0ab0000 task=c09f23ac
> task.ti=c0a50000)
> [   94.370035] Stack:
> [   94.370035]  c0ab0f94 00000286 c09fb204 c014e784 00000020 c0ab0fa0
> c014e79c c09fb204
> [   94.370035]  c0ab0fb0 c04dca32 cede1240 00000282 c0ab0fc4 c01297d1
> c012c8aa cf9e4dc0
> [   94.370035]  cf9e4e20 c0ab0fd0 c0135b0d 00000000 c0ab0fe0 c015a783
> 00000100 00000001
> [   94.370035] Call Trace:
> [   94.370035]  [<c014e784>] ? free_user_ns+0x0/0x1b
> [   94.370035]  [<c014e79c>] ? free_user_ns+0x18/0x1b
> [   94.370035]  [<c04dca32>] ? kref_put+0x3b/0x49
> [   94.370035]  [<c01297d1>] ? free_uid+0x49/0xa4
> [   94.370035]  [<c012c8aa>] ? groups_free+0x31/0x35
> [   94.370035]  [<c0135b0d>] ? put_cred_rcu+0x52/0x63
> [   94.370035]  [<c015a783>] ? rcu_process_callbacks+0x60/0x74
> [   94.370035]  [<c0125af2>] ? __do_softirq+0x6a/0xf1
> [   94.370035]  [<c0125a88>] ? __do_softirq+0x0/0xf1
> [   94.370035]  <IRQ> <0> [<c01598a8>] ? handle_level_irq+0x0/0xbc
> [   94.370035]  [<c0125a0a>] ? irq_exit+0x3b/0x77
> [   94.370035]  [<c010411d>] ? do_IRQ+0xdc/0xf3
> [   94.370035]  [<c010340c>] ? common_interrupt+0x2c/0x34
> [   94.370035]  [<c013007b>] ? param_array_set+0x18/0xc6
> [   94.370035]  [<c051f5d2>] ? acpi_idle_enter_simple+0x167/0x1d1
> [   94.370035]  [<c062c69d>] ? cpuidle_idle_call+0x57/0x8e
> [   94.370035]  [<c01019eb>] ? cpu_idle+0x59/0x86
> [   94.370035]  [<c077a585>] ? rest_init+0x61/0x63
> [   94.370035] Code: 00 00 00 8b 1d e4 0f 03 c1 e8 fb f3 f8 ff c1 e8 0c
> c1 e0 05 8d 34 03 f6 46 01 40 74 03 8b 76 0c 8b 06 84 c0 78 15 f6 c4 60
> 75 04 <0f> 0b eb fe 89 f0 e8 90 7a fe ff e9 90 00 00 00 8b 45 04 89 45 
> [   94.370035] EIP: [<c018340b>] kfree+0x3c/0xe4 SS:ESP 0068:c0ab0f80
> [   94.383497] ---[ end trace 4779637014de8de6 ]---
> [   94.383620] Kernel panic - not syncing: Fatal exception in interrupt
> 
> The bug triggered is BUG_ON(!PageCompound(page)) in kfree();
> 
> (gdb) l *(free_user_ns+0x0)
> 0xc014e784 is in free_user_ns (kernel/user_namespace.c:64).
> 59	
> 60		return 0;
> 61	}
> 62	
> 63	void free_user_ns(struct kref *kref)
> 64	{
> 65		struct user_namespace *ns;
> 66	
> 67		ns = container_of(kref, struct user_namespace, kref);
> 68		free_uid(ns->creator);
> (gdb) l *(groups_free)
> 0xc012c879 is in groups_free (kernel/sys.c:1160).
> 1155	}
> 1156	
> 1157	EXPORT_SYMBOL(groups_alloc);
> 1158	
> 1159	void groups_free(struct group_info *group_info)
> 1160	{
> 1161		if (group_info->blocks[0] != group_info->small_block) {
> 1162			int i;
> 1163			for (i = 0; i < group_info->nblocks; i++)
> 1164				free_page((unsigned
> long)group_info->blocks[i]);
> 

Well that's ugly.  We seem to have passed a non-slab address into
kfree().

void kfree(const void *x)
{
	struct page *page;
	void *object = (void *)x;

	if (unlikely(ZERO_OR_NULL_PTR(x)))
		return;

	page = virt_to_head_page(x);
	if (unlikely(!PageSlab(page))) {
		BUG_ON(!PageCompound(page));


doing BUG_ON(!PageCompound) is a rather odd way of reporting that.

I'm unsure what could have caused this.  Could you have a play around
please?  Set all the memory debug options, try using slab instead of
slub, etc?


