Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbXKUTdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbXKUTdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbXKUTdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:33:45 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:39137 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbXKUTdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:33:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WD4waxBpCbDwPldjZe7H1ZtTQkmgufUGh61PL86hdU6WeUtszthwCzUORWa2JIyzmf3E+l6xAQpdS4dx74pgiKYDCIss8BMToEKo01kKZvQEzQrPBIBH6w7Dd4sxxIZJbpxVGtXeXC57KsGFLPivrsadAHDg1SrkvLiPgVZ99rk=
Message-ID: <64bb37e0711211133g355a808dl7c2bec7fe3789ddd@mail.gmail.com>
Date: Wed, 21 Nov 2007 20:33:36 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, "Andy Whitcroft" <apw@shadowen.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>, linux-acpi@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20071121012918.eff93b22.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <4743CC0B.9000508@linux.vnet.ibm.com>
	 <20071120221839.faab108e.akpm@linux-foundation.org>
	 <4743F8D2.2090302@linux.vnet.ibm.com>
	 <20071121012918.eff93b22.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 21, 2007 10:29 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 21 Nov 2007 14:52:26 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
>
> > Andrew Morton wrote:
> > > On Wed, 21 Nov 2007 11:41:23 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> > >> ACPI: Core revision 20070126
> > >> ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> > >> Kernel panic - not syncing: IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter

I seen an identical error.

> > > ACPI or x86 breakage, I guess.
> > >
> > > Did 'noapic' work?
> >
> > Passing noapic works,
>
> OK.

Not for me. I get a similar oops, but then the kernel panics

> >  but the kernel oops's
> >
> > [   97.161103] Unable to handle kernel NULL pointer dereference at 0000000000000009 RIP:
> > [   97.193973]  [<ffffffff802341df>] cpu_to_allnodes_group+0x69/0x7c
[snip]
> urgh, mess.  Enabling frame pointers might help here.

CONFIG_FRAME_POINTER=y

The oops/panic that happens with noapic:
[   35.866758] Initializing CPU#3
[   35.868769] Stuck ??
[   35.874043] Inquiring remote APIC #3...
[   35.877896] ... APIC #3 ID: 03000000
[   35.881523] ... APIC #3 VERSION: 80050010
[   35.885587] ... APIC #3 SPIV: 000001ff
[   35.889390] Brought up 1 CPUs
[   35.892375] Unable to handle kernel NULL pointer dereference at
0000000000000009 RIP:
[   35.897868]  [<ffffffff8022fc5b>] cpu_to_allnodes_group+0x4b/0x60
[   35.906464] PGD 0
[   35.908523] Oops: 0000 [1] SMP
[   35.911757] last sysfs file:
[   35.914740] CPU 0
[   35.916798] Modules linked in:
[   35.919990] Pid: 1, comm: swapper Not tainted 2.6.24-rc3-mm1 #2
[   35.925914] RIP: 0010:[<ffffffff8022fc5b>]  [<ffffffff8022fc5b>]
cpu_to_allnodes_group+0x4b/0x60
[   35.934734] RSP: 0000:ffff81011ff2bdb0  EFLAGS: 00010282
[   35.940053] RAX: ffffffff8084d870 RBX: ffff810001005810 RCX: 0000000000000004
[   35.947188] RDX: 0000000000000001 RSI: ffff81011ff26f68 RDI: ffff81011ff2bdb0
[   35.954323] RBP: ffff81011ff2bdd0 R08: 2222222222222222 R09: 0000000000000000
[   35.961457] R10: ffff81007ff1c200 R11: 0000000000000200 R12: ffff810001005800
[   35.968592] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   35.975727] FS:  0000000000000000(0000) GS:ffffffff807d4000(0000)
knlGS:0000000000000000
[   35.983951] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   35.989701] CR2: 0000000000000009 CR3: 0000000000201000 CR4: 00000000000006a0
[   35.996836] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   36.003971] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   36.011105] Process swapper (pid: 1, threadinfo FFFF81011FF2A000,
task FFFF81007FF2A000)
[   36.019191] Stack:  0000000000000000 ffffffff807e8f98
0000000000000000 ffff810001005800
[   36.027373]  ffff81011ff2be80 ffffffff80230580 ffffffff8084d640
ffffffff8084d6e0
[   36.034922]  ffffffff8084d780 ffffffff8084d800 ffffffffffffffff
ffff81011ff26f68
[   36.042247] Call Trace:
[   36.044929]  [<ffffffff80230580>] build_sched_domains+0x460/0x820
[   36.051701]  [<ffffffff805cf489>] mutex_lock_nested+0x199/0x2e0
[   36.057624]  [<ffffffff80230991>] arch_init_sched_domains+0x51/0x60
[   36.063895]  [<ffffffff8080e422>] sched_init_smp+0x22/0xe0
[   36.069385]  [<ffffffff80806825>] smp_cpus_done+0x25/0x30
[   36.074791]  [<ffffffff807fb739>] kernel_init+0x109/0x350
[   36.080196]  [<ffffffff8025a34f>] trace_hardirqs_on+0xbf/0x160
[   36.086032]  [<ffffffff805d03d2>] trace_hardirqs_on_thunk+0x35/0x3a
[   36.092303]  [<ffffffff8025a34f>] trace_hardirqs_on+0xbf/0x160
[   36.098141]  [<ffffffff8020cbc8>] child_rip+0xa/0x12
[   36.103113]  [<ffffffff8020c2df>] restore_args+0x0/0x30
[   36.108345]  [<ffffffff807fb630>] kernel_init+0x0/0x350
[   36.113750]  [<ffffffff8020cbbe>] child_rip+0x0/0x12
[   36.118722]
[   36.120236] INFO: lockdep is turned off.
[   36.124170]
[   36.124170] Code: 48 03 42 08 48 89 03 48 83 c4 18 89 c8 5b c9 c3
0f 1f 44 00
[   36.133640] RIP  [<ffffffff8022fc5b>] cpu_to_allnodes_group+0x4b/0x60
[   36.140116]  RSP <ffff81011ff2bdb0>
[   36.143619] CR2: 0000000000000009
[   36.146952] Kernel panic - not syncing: Attempted to kill init!

(gdb) list *0xffffffff8022fc5b
0xffffffff8022fc5b is in cpu_to_allnodes_group (kernel/sched.c:6073).
6068
6069            cpus_and(nodemask, nodemask, *cpu_map);
6070            group = first_cpu(nodemask);
6071
6072            if (sg)
6073                    *sg = &per_cpu(sched_group_allnodes, group);
6074            return group;
6075    }
6076
6077    static void init_numa_sched_groups_power(struct sched_group *group_head)

Hope this stack trace is better.

Torsten
