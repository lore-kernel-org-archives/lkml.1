Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZIRJhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZIRJhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 05:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbZIRJha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 05:37:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63477 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138AbZIRJh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 05:37:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lmI3qUKVMJ0nGiIW9N1DQMATL+XvkPdraO0EIodfBnjNbY+Cz4XC4TMAZmO1ldF17
	9nDcKSoYame0xura5Aa1A==
Date: Fri, 18 Sep 2009 02:37:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Jayaram <sureshjayaram@gmail.com>
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at (null), last sysfs file:
 /sys/devices/pci0000:00/0000:00:01.0/local_cpus
In-Reply-To: <20090918075952.GA29026@elte.hu>
Message-ID: <alpine.DEB.1.00.0909180234510.22490@chino.kir.corp.google.com>
References: <20090915132105.2fdd1d45@jbarnes-g45> <20090917173012.GA11155@elte.hu> <20090917103614.6ab1385f@jbarnes-g45> <20090917175944.GA17304@elte.hu> <20090917114614.35aeb6b8@jbarnes-g45> <20090918075952.GA29026@elte.hu>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009, Ingo Molnar wrote:

> FYI, -tip testing has triggered this new crash in dev_attr_show() et al:
> 
> [  158.058140] warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
> [  159.370562] BUG: unable to handle kernel NULL pointer dereference at (null)
> [  159.372694] IP: [<ffffffff8143b722>] bitmap_scnprintf+0x72/0xd0
> [  159.372694] PGD 71d3e067 PUD 7052e067 PMD 0 
> [  159.372694] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  159.372694] last sysfs file: /sys/devices/pci0000:00/0000:00:01.0/local_cpus
> [  159.372694] CPU 0 
> [  159.372694] Pid: 7364, comm: irqbalance Not tainted 2.6.31-tip #8043 System Product Name
> [  159.372694] RIP: 0010:[<ffffffff8143b722>]  [<ffffffff8143b722>] bitmap_scnprintf+0x72/0xd0
> [  159.372694] RSP: 0018:ffff8800712a1e38  EFLAGS: 00010246
> [  159.372694] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  159.372694] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff880077dc5000
> [  159.372694] RBP: ffff8800712a1e68 R08: 0000000000000001 R09: 0000000000000001
> [  159.372694] R10: ffffffff8215c47c R11: 0000000000000000 R12: 0000000000000000
> [  159.372694] R13: 0000000000000000 R14: 0000000000000ffe R15: ffff880077dc5000
> [  159.372694] FS:  00007f5f578f76f0(0000) GS:ffff880007000000(0000) knlGS:0000000000000000
> [  159.372694] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  159.372694] CR2: 0000000000000000 CR3: 0000000071a77000 CR4: 00000000000006f0
> [  159.372694] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  159.372694] DR3: ffffffff835109dc DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  159.372694] Process irqbalance (pid: 7364, threadinfo ffff8800712a0000, task ffff880070773000)
> [  159.372694] Stack:
> [  159.372694]  2222222222222222 ffff880077dc5000 fffffffffffffffb ffff88007d366b40
> [  159.372694] <0> ffff8800712a1f48 ffff88007d3840a0 ffff8800712a1e88 ffffffff8146332b
> [  159.372694] <0> fffffffffffffff4 ffffffff82450718 ffff8800712a1ea8 ffffffff815a9a1f
> [  159.372694] Call Trace:
> [  159.372694]  [<ffffffff8146332b>] local_cpus_show+0x3b/0x60
> [  159.372694]  [<ffffffff815a9a1f>] dev_attr_show+0x2f/0x60
> [  159.372694]  [<ffffffff8118ee6f>] sysfs_read_file+0xbf/0x1d0
> [  159.372694]  [<ffffffff8112afe9>] vfs_read+0xc9/0x180
> [  159.372694]  [<ffffffff8112c365>] sys_read+0x55/0x90
> [  159.372694]  [<ffffffff810114f2>] system_call_fastpath+0x16/0x1b

Suresh Jayaram reported this yesterday with mmotm on T60p laptop but 
hasn't been able to look into it further.  My T60p doesn't crash with it 
so I'm assuming it's some bootstrap issue with an initscript reading 
`local_cpus' before the per-cpu nodemasks are allocated.

CONFIG_DEBUG_PER_CPU_MAPS might be able to diagnose the issue.
