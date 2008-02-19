Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYBSUET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYBSUET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 15:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYBSUEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 15:04:04 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:39191 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbYBSUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 15:04:01 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAP/EukdMQWRV/2dsb2JhbACBWZBJnSU
Date: Tue, 19 Feb 2008 15:03:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080219200358.GB11197@Krystal>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080219172739.55c341b5.dada1@cosmosbay.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:17:38 up 8 days, 15:18,  3 users,  load average: 0.27, 0.37,
	0.55
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet (dada1@cosmosbay.com) wrote:
> On Tue, 19 Feb 2008 09:02:30 -0500
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Pekka Enberg (penberg@cs.helsinki.fi) wrote:
> > > On Feb 19, 2008 8:54 AM, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> > > > > > [ 5282.056415] ------------[ cut here ]------------
> > > > > > [ 5282.059757] kernel BUG at lib/list_debug.c:33!
> > > > > > [ 5282.062055] invalid opcode: 0000 [1] SMP
> > > > > > [ 5282.062055] CPU 3
> > > > >
> > > > > hm. Your crashes do seem to span multiple subsystems, but it always
> > > > > seems to be around the SLUB code. Could you try the patch below? The
> > > > > SLUB code has a new optimization and i'm not 100% sure about it. [the
> > > > > hack below switches the SLUB optimization off by disabling the CPU
> > > > > feature it relies on.]
> > > > >
> > > > >         Ingo
> > > > >
> > > > > ------------->
> > > > >  arch/x86/Kconfig |    4 ----
> > > > >  1 file changed, 4 deletions(-)
> > > > >
> > > > > Index: linux/arch/x86/Kconfig
> > > > > ===================================================================
> > > > > --- linux.orig/arch/x86/Kconfig
> > > > > +++ linux/arch/x86/Kconfig
> > > > > @@ -59,10 +59,6 @@ config HAVE_LATENCYTOP_SUPPORT
> > > > >  config SEMAPHORE_SLEEPERS
> > > > >         def_bool y
> > > > >
> > > > > -config FAST_CMPXCHG_LOCAL
> > > > > -       bool
> > > > > -       default y
> > > > > -
> > > > >  config MMU
> > > > >         def_bool y
> > > > >
> > > >
> > > > $ grep FAST_CMPXCHG_LOCAL */.config
> > > > linux-2.6.24-rc2-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
> > > > linux-2.6.24-rc3-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
> > > > linux-2.6.24-rc3-mm2/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
> > > > linux-2.6.24-rc6-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
> > > > linux-2.6.24-rc8-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
> > > > linux-2.6.25-rc1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
> > > > linux-2.6.25-rc2-mm1/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
> > > > linux-2.6.25-rc2/.config:CONFIG_FAST_CMPXCHG_LOCAL=y
> > > >
> > > > -rc2-mm1 still worked for me.
> > > >
> > > > Did you mean the new SLUB_FASTPATH?
> > > > $ grep "define SLUB_FASTPATH" */mm/slub.c
> > > > linux-2.6.25-rc1/mm/slub.c:#define SLUB_FASTPATH
> > > > linux-2.6.25-rc2-mm1/mm/slub.c:#define SLUB_FASTPATH
> > > > linux-2.6.25-rc2/mm/slub.c:#define SLUB_FASTPATH
> > > >
> > > > The 2.6.24-rc3+ mm-kernels did crash for me, but don't seem to contain this...
> > > >
> > > > On the other hand:
> > > > From the crash in 2.6.25-rc2-mm1:
> > > > [59987.116182] RIP  [<ffffffff8029f83d>] kmem_cache_alloc_node+0x6d/0xa0
> > > >
> > > > (gdb) list *0xffffffff8029f83d
> > > > 0xffffffff8029f83d is in kmem_cache_alloc_node (mm/slub.c:1646).
> > > > 1641                    if (unlikely(is_end(object) || !node_match(c, node))) {
> > > > 1642                            object = __slab_alloc(s, gfpflags,
> > > > node, addr, c);
> > > > 1643                            break;
> > > > 1644                    }
> > > > 1645                    stat(c, ALLOC_FASTPATH);
> > > > 1646            } while (cmpxchg_local(&c->freelist, object, object[c->offset])
> > > > 1647
> > > >  != object);
> > > > 1648    #else
> > > > 1649            unsigned long flags;
> > > > 1650
> > > >
> > > > That code is part for SLUB_FASTPATH.
> > > >
> > > > I'm willing to test the patch, but don't know how fast I can find the
> > > > time to do it, so my answer if your patch helps might be delayed until
> > > > the weekend.
> > > 
> > > Mathieu, Christoph is on vacation and I'm not at all that familiar
> > > with this cmpxchg_local() optimization, so if you could take a peek at
> > > this bug report to see if you can spot something obviously wrong with
> > > it, I would much appreciate that.
> > 
> > Sure,
> > 
> > Initial thoughts :
> > 
> > I'd like to get the complete config causing this bug. I suspect either :
> > 
> > - A race between the lockless algo and an IRQ in a driver allocating
> >   memory.
> > - stat(c, ALLOC_FASTPATH); seems to be using a var++, therefore
> >   indicating it is not reentrant if IRQs are disabled. Since those are
> >   only stats, I guess it's ok, but still weird.
> > - CPU hotplug problem. 
> >   http://bugzilla.kernel.org/attachment.cgi?id=14877&action=view shows
> >   last sysfs file:
> >   /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> >   -- is this linked to a cpu up/down event ?
> > 
> > Since this shows mostly with network card drivers, I think the most
> > plausible cause would be an IRQ nesting over kmem_cache_alloc_node and
> > calling it.
> > 
> > Will dig further...
> 
> I wonder how SLUB_FASTPATH is supposed to work, since it is affected by
> a classical ABA problem of lockless algo.
> 
> cmpxchg_local(&c->freelist, object, object[c->offset]) can succeed,
> while an interrupt came (on this cpu), and several allocations were done,
> and one free was performed at the end of this interruption, so 'object'
> was recycled.
> 
> c->freelist can then contain the previous value (object), but
> object[c->offset] was changed by IRQ.
> 
> We then put back in freelist an already allocated object.
> 

I think you are right. A way to fix this would use the fact that the
freelist is only useful to point to the first free object in a page. We
could change it to an offset rather than an address.

The freelist would become a counter of type "long" which increments
until it wraps at 2^32 or 2^64. A PAGE_MASK bitmask could then be used
to get low order bits which would get the page offset of the first free
object, while the high order bits would insure we can detect this type
of object reuse when doing a cmpxchg. Upon free, the freelist counter
should always be incremented; this would be provided by adding PAGE_SIZE
to the counter and setting the LSBs to the correct offset.

On 32 bits architectures, it would allow 2^(32-12) = 1048576
allocations-free pairs to be done within interrupt handlers interrupting
a cmpxchg_local before the counter wraps. On 64 bits archs, it would
give 2^(64-12) = 2^52 allocation-free.

If we assume kmalloc/kfree pairs can take up to 1000 cycles to execute
(see
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=068fbad288a2c18b75b0425fb56d241f018a1cb5)
(3GHz Pentium 4) (therefore 333ns)
an interrupt handler doing 1048576 kmalloc/kfree would run for 0.35
seconds. An interrupt handler taking that much time would lead to other
OS problems (potential scheduler problems), so this quantity of
available allocations before a wrap-around looks safe. However, making
sure preemption is disabled would be safer here, since we cannot bound
the number of allocations that can be done by other processes if we are
scheduled out in the middle of the cmpxchg_local loop.

A revert is indeed the right solution at this stage until a corrected
version is ready.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
