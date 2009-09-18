Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbZIRQev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbZIRQev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbZIRQeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:34:50 -0400
Received: from outbound-mail-131.bluehost.com ([67.222.39.21]:51517 "HELO
	outbound-mail-131.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751106AbZIRQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:34:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iHL0pYGRbKt3ND/woJt9yKi0QV9wMcvM/pDA42rtDp8e9Fpml9YYo6H0pJIfdyyj92sWHzJ3lIE14LRYUMoFMtDFyXJHUEJtkCgYiRZxEGlBFe+NLZ7S/M+ry1gcUp1s;
Date: Fri, 18 Sep 2009 09:34:41 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at	(null), last sysfs file:	/sys/devices/pci0000:00/0000:00:01.0/local_cpus
Message-ID: <20090918093441.0f23fb9f@jbarnes-g45>
In-Reply-To: <4AB3B430.3030905@kernel.org>
References: <20090915132105.2fdd1d45@jbarnes-g45>
	<20090917173012.GA11155@elte.hu>
	<20090917103614.6ab1385f@jbarnes-g45>
	<20090917175944.GA17304@elte.hu>
	<20090917114614.35aeb6b8@jbarnes-g45>
	<20090918075952.GA29026@elte.hu>
	<4AB3B430.3030905@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Sep 2009 09:24:16 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > FYI, -tip testing has triggered this new crash in dev_attr_show()
> > et al:
> > 
> > [  158.058140] warning: `dbus-daemon' uses 32-bit capabilities
> > (legacy support in use) [  159.370562] BUG: unable to handle kernel
> > NULL pointer dereference at (null) [  159.372694] IP:
> > [<ffffffff8143b722>] bitmap_scnprintf+0x72/0xd0 [  159.372694] PGD
> > 71d3e067 PUD 7052e067 PMD 0 [  159.372694] Oops: 0000 [#1] SMP
> > DEBUG_PAGEALLOC [  159.372694] last sysfs
> > file: /sys/devices/pci0000:00/0000:00:01.0/local_cpus
> > [  159.372694] CPU 0 [  159.372694] Pid: 7364, comm: irqbalance Not
> > tainted 2.6.31-tip #8043 System Product Name [  159.372694] RIP:
> > 0010:[<ffffffff8143b722>]  [<ffffffff8143b722>]
> > bitmap_scnprintf+0x72/0xd0 [  159.372694] RSP:
> > 0018:ffff8800712a1e38  EFLAGS: 00010246 [  159.372694] RAX:
> > 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > [  159.372694] RDX: 0000000000000000 RSI: 0000000000000004 RDI:
> > ffff880077dc5000 [  159.372694] RBP: ffff8800712a1e68 R08:
> > 0000000000000001 R09: 0000000000000001 [  159.372694] R10:
> > ffffffff8215c47c R11: 0000000000000000 R12: 0000000000000000
> > [  159.372694] R13: 0000000000000000 R14: 0000000000000ffe R15:
> > ffff880077dc5000 [  159.372694] FS:  00007f5f578f76f0(0000)
> > GS:ffff880007000000(0000) knlGS:0000000000000000 [  159.372694]
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b [  159.372694]
> > CR2: 0000000000000000 CR3: 0000000071a77000 CR4: 00000000000006f0
> > [  159.372694] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000 [  159.372694] DR3: ffffffff835109dc DR6:
> > 00000000ffff0ff0 DR7: 0000000000000400 [  159.372694] Process
> > irqbalance (pid: 7364, threadinfo ffff8800712a0000, task
> > ffff880070773000) [  159.372694] Stack: [  159.372694]
> > 2222222222222222 ffff880077dc5000 fffffffffffffffb ffff88007d366b40
> > [  159.372694] <0> ffff8800712a1f48 ffff88007d3840a0
> > ffff8800712a1e88 ffffffff8146332b [  159.372694] <0>
> > fffffffffffffff4 ffffffff82450718 ffff8800712a1ea8 ffffffff815a9a1f
> > [  159.372694] Call Trace: [  159.372694]  [<ffffffff8146332b>]
> > local_cpus_show+0x3b/0x60 [  159.372694]  [<ffffffff815a9a1f>]
> > dev_attr_show+0x2f/0x60 [  159.372694]  [<ffffffff8118ee6f>]
> > sysfs_read_file+0xbf/0x1d0 [  159.372694]  [<ffffffff8112afe9>]
> > vfs_read+0xc9/0x180 [  159.372694]  [<ffffffff8112c365>]
> > sys_read+0x55/0x90 [  159.372694]  [<ffffffff810114f2>]
> > system_call_fastpath+0x16/0x1b [  159.372694] Code: 41 b9 01 00 00
> > 00 44 8d 46 03 49 63 fc 0f 49 d3 c1 f8 1f 4c 01 ff c1 e8 1a c1 fa
> > 06 41 c1 e8 02 8d 0c 03 48 63 d2 83 e1 3f 29 c1 <49> 8b 44 d5 00 48
> > c7 c2 8c 37 16 82 48 d3 e8 89 f1 44 89 f6 49 [  159.372694] RIP
> > [<ffffffff8143b722>] bitmap_scnprintf+0x72/0xd0 [  159.372694]  RSP
> > <ffff8800712a1e38> [  159.372694] CR2: 0000000000000000
> > [  159.600828] ---[ end trace 35550c356e84e60c ]---
> > 
> > That's a new breakage as well. Config and full crashlog attached.
> > 
> 
> exposed by Jesse's patch too.
> 
> please check
> 
> ---
>  arch/x86/include/asm/pci.h |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/include/asm/pci.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/pci.h
> +++ linux-2.6/arch/x86/include/asm/pci.h
> @@ -143,7 +143,14 @@ static inline int __pcibus_to_node(const
>  static inline const struct cpumask *
>  cpumask_of_pcibus(const struct pci_bus *bus)
>  {
> -	return cpumask_of_node(__pcibus_to_node(bus));
> +	int node;
> +
> +	node = __pcibus_to_node(bus);
> +
> +	if (node == -1)
> +		node = numa_node_id();
> +
> +	return cpumask_of_node(node);
>  }
>  #endif

Already pushed out David Rientjes' fix for this.

-- 
Jesse Barnes, Intel Open Source Technology Center
