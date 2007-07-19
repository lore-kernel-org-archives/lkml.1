Return-Path: <linux-kernel-owner+w=401wt.eu-S1761031AbXGSGcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbXGSGcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbXGSGb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:31:57 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:47236 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbXGSGb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:31:56 -0400
Date: Thu, 19 Jul 2007 11:58:35 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: System hangs on running kernbench
Message-ID: <20070719062835.GE3699@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070718075648.GA4235@linux.vnet.ibm.com> <20070718010700.1ca7fd9f.akpm@linux-foundation.org> <20070718094142.GA12330@linux.vnet.ibm.com> <20070718144637.GC5337@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718144637.GC5337@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 08:16:37PM +0530, Dhaval Giani wrote:
> Hi Andrew,
> 
> On Wed, Jul 18, 2007 at 03:11:42PM +0530, Dhaval Giani wrote:
> > On Wed, Jul 18, 2007 at 01:07:00AM -0700, Andrew Morton wrote:
> > > On Wed, 18 Jul 2007 13:26:48 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> > >  
> > In the meantime I will go and check if it was there in 2.6.22-rc4-mm2
> > 
> 
> It is hanging with 2.6.22-rc4-mm2 as well as on the latest git on
> kernel.org (2.6.22-git10).
> 
> I will get back to you with more information as soon as I have it.

Hi Andrew,

I've got a crash dump and stack traces. They are as follows (The trace
is on 2.6.22-git10)


(gdb) thread 1
[Switching to thread 1 (process 8096)]#0  delay_tsc (loops=1)
    at include/asm/msr.h:64
64      {
(gdb) bt
#0  delay_tsc (loops=1) at include/asm/msr.h:64
#1  0xc0245130 in __delay (loops=Variable "loops" is not available.
) at arch/i386/lib/delay.c:74
#2  0xc0247115 in __spin_lock_debug (lock=0xc0564480)
    at lib/spinlock_debug.c:111
#3  0xc02471cc in _raw_spin_lock (lock=0xc0564480) at lib/spinlock_debug.c:132
#4  0xc041ad3e in _spin_lock_irq (lock=0xc0564480) at kernel/spinlock.c:105
#5  0xc015ff2c in shrink_active_list (nr_pages=32, zone=0xc0563300, 
    sc=0xd65b3e60, priority=5) at mm/vmscan.c:926
#6  0xc01602a3 in shrink_zone (priority=5, zone=0xc0563300, sc=0xd65b3e60)
    at mm/vmscan.c:1044
#7  0xc016036c in shrink_zones (priority=5, zones=0xc056584c, sc=0xd65b3e60)
    at mm/vmscan.c:1101
#8  0xc0160488 in try_to_free_pages (zones=0xc056584c, order=Variable "order" is not available.
)
    at mm/vmscan.c:1153
#9  0xc015c190 in __alloc_pages (gfp_mask=688338, order=0, zonelist=0xc0565848)
    at mm/page_alloc.c:1336
#10 0xc0165285 in do_anonymous_page (mm=0xe4498280, vma=0xd3afef3c, 
    address=3083890688, page_table=0xd65ca838, pmd=0xe3e33df0, write_access=1)
    at include/linux/gfp.h:100
#11 0xc0165a58 in __handle_mm_fault (mm=0xe4498280, vma=0xd3afef3c, 
    address=3083890688, write_access=1) at mm/memory.c:2549
#12 0xc041c984 in do_page_fault (regs=0xd65b3fb8, error_code=6)
    at include/linux/mm.h:776
#13 0xc041b37a in error_code () at include/linux/sched.h:13
#14 0x0000006c in ?? ()
#15 0x0000001b in ?? ()
#16 0x00000000 in ?? ()
(gdb) thread 2
[Switching to thread 2 (process 7371)]#0  __spin_lock_debug (lock=0xc0564480)
    at include/asm/spinlock.h:88
88      {
(gdb) bt
#0  __spin_lock_debug (lock=0xc0564480) at include/asm/spinlock.h:88
#1  0xc02471cc in _raw_spin_lock (lock=0xc0564480) at lib/spinlock_debug.c:132
#2  0xc041ad3e in _spin_lock_irq (lock=0xc0564480) at kernel/spinlock.c:105
#3  0xc0160181 in shrink_active_list (nr_pages=32, zone=0xc0563300, sc=Variable "sc" is not available.
)
    at mm/vmscan.c:994
#4  0xc01602a3 in shrink_zone (priority=5, zone=0xc0563300, sc=0xeea67e60)
    at mm/vmscan.c:1044
#5  0xc016036c in shrink_zones (priority=5, zones=0xc056584c, sc=0xeea67e60)
    at mm/vmscan.c:1101
#6  0xc0160488 in try_to_free_pages (zones=0xc056584c, order=Variable "order" is not available.
)
    at mm/vmscan.c:1153
#7  0xc015c190 in __alloc_pages (gfp_mask=688338, order=0, zonelist=0xc0565848)
    at mm/page_alloc.c:1336
#8  0xc0165285 in do_anonymous_page (mm=0xeeaabdc0, vma=0xf137c7ac, 
    address=3084021760, page_table=0xeeabf938, pmd=0xeeaafdf0, write_access=1)
    at include/linux/gfp.h:100
#9  0xc0165a58 in __handle_mm_fault (mm=0xeeaabdc0, vma=0xf137c7ac, 
    address=3084021760, write_access=1) at mm/memory.c:2549
#10 0xc041c984 in do_page_fault (regs=0xeea67fb8, error_code=6)
    at include/linux/mm.h:776
#11 0xc041b37a in error_code () at include/linux/sched.h:13
#12 0x0000002c in ?? ()
#13 0x0000000b in ?? ()
#14 0x00000000 in ?? ()
(gdb) thread 3
[Switching to thread 3 (process 8392)]#0  __spin_lock_debug (lock=0xc0564480)
    at include/asm/spinlock.h:88
88      {
(gdb) bt
#0  __spin_lock_debug (lock=0xc0564480) at include/asm/spinlock.h:88
#1  0xc02471cc in _raw_spin_lock (lock=0xc0564480) at lib/spinlock_debug.c:132
#2  0xc041ad3e in _spin_lock_irq (lock=0xc0564480) at kernel/spinlock.c:105
#3  0xc016000f in shrink_active_list (nr_pages=32, zone=0xc0563300, sc=Variable "sc" is not available.
)
    at mm/vmscan.c:950
#4  0xc01602a3 in shrink_zone (priority=5, zone=0xc0563300, sc=0xf733de60)
    at mm/vmscan.c:1044
#5  0xc016036c in shrink_zones (priority=5, zones=0xc056584c, sc=0xf733de60)
    at mm/vmscan.c:1101
#6  0xc0160488 in try_to_free_pages (zones=0xc056584c, order=Variable "order" is not available.
)
    at mm/vmscan.c:1153
#7  0xc015c190 in __alloc_pages (gfp_mask=688338, order=0, zonelist=0xc0565848)
    at mm/page_alloc.c:1336
#8  0xc0165285 in do_anonymous_page (mm=0xf3054940, vma=0xf60496a4, 
    address=135188540, page_table=0xd275c768, pmd=0xf317d200, write_access=1)
    at include/linux/gfp.h:100
#9  0xc0165a58 in __handle_mm_fault (mm=0xf3054940, vma=0xf60496a4, 
    address=135188540, write_access=1) at mm/memory.c:2549
#10 0xc041c984 in do_page_fault (regs=0xf733dfb8, error_code=6)
    at include/linux/mm.h:776
#11 0xc041b37a in error_code () at include/linux/sched.h:13
#12 0x4a492ff4 in ?? ()
#13 0x00000208 in ?? ()
#14 0x00000208 in ?? ()
#15 0x00016fc9 in ?? ()
#16 0x080ed038 in ?? ()
#17 0xbfa6aa40 in ?? ()
#18 0x080ece38 in ?? ()
#19 0x0000007b in ?? ()
#20 0x0000007b in ?? ()
(gdb) thread 4
[Switching to thread 4 (process 7831)]#0  __spin_lock_debug (lock=0xc0564480)
    at include/asm/spinlock.h:88
88      {
(gdb) bt
#0  __spin_lock_debug (lock=0xc0564480) at include/asm/spinlock.h:88
#1  0xc02471cc in _raw_spin_lock (lock=0xc0564480) at lib/spinlock_debug.c:132
#2  0xc041ad3e in _spin_lock_irq (lock=0xc0564480) at kernel/spinlock.c:105
#3  0xc015ff2c in shrink_active_list (nr_pages=32, zone=0xc0563300, 
    sc=0xdf36fe60, priority=5) at mm/vmscan.c:926
#4  0xc01602a3 in shrink_zone (priority=5, zone=0xc0563300, sc=0xdf36fe60)
    at mm/vmscan.c:1044
#5  0xc016036c in shrink_zones (priority=5, zones=0xc056584c, sc=0xdf36fe60)
    at mm/vmscan.c:1101
#6  0xc0160488 in try_to_free_pages (zones=0xc056584c, order=Variable "order" is not available.
)
    at mm/vmscan.c:1153
#7  0xc015c190 in __alloc_pages (gfp_mask=688338, order=0, zonelist=0xc0565848)
    at mm/page_alloc.c:1336
#8  0xc0165285 in do_anonymous_page (mm=0xe03ff4c0, vma=0xdf74f0cc, 
    address=138633916, page_table=0xdf3b01b0, pmd=0xdf302210, write_access=1)
    at include/linux/gfp.h:100
#9  0xc0165a58 in __handle_mm_fault (mm=0xe03ff4c0, vma=0xdf74f0cc, 
    address=138633916, write_access=1) at mm/memory.c:2549
#10 0xc041c984 in do_page_fault (regs=0xdf36ffb8, error_code=6)
    at include/linux/mm.h:776
#11 0xc041b37a in error_code () at include/linux/sched.h:13
#12 0x4a492ff4 in ?? ()
#13 0x084362b8 in ?? ()
#14 0x00000329 in ?? ()
#15 0x0001ad49 in ?? ()
#16 0x08435f90 in ?? ()
#17 0xbfe69ed4 in ?? ()
#18 0x08435f98 in ?? ()
#19 0x0000007b in ?? ()
#20 0x0000007b in ?? ()
#21 0x00000000 in ?? ()
(gdb) thread 5
[Switching to thread 5 (process 7678)]#0  __lock_acquire (lock=0xc0564490, 
    subclass=0, trylock=0, read=0, check=2, hardirqs_off=1, ip=2)
    at kernel/lockdep.c:2041
2041            if (unlikely(!class)) {
(gdb) bt
#0  __lock_acquire (lock=0xc0564490, subclass=0, trylock=0, read=0, check=2, 
    hardirqs_off=1, ip=2) at kernel/lockdep.c:2041
#1  0xc01400f1 in lock_acquire (lock=0xc0564490, subclass=0, trylock=0, 
    read=2, check=2, ip=3227958332) at include/asm/irqflags.h:122
#2  0xc041ad37 in _spin_lock_irq (lock=0xc0564480) at kernel/spinlock.c:104
#3  0xc0160181 in shrink_active_list (nr_pages=32, zone=0xc0563300, sc=Variable "sc" is not available.
)
    at mm/vmscan.c:994
#4  0xc01602a3 in shrink_zone (priority=5, zone=0xc0563300, sc=0xe473be60)
    at mm/vmscan.c:1044
#5  0xc016036c in shrink_zones (priority=5, zones=0xc056584c, sc=0xe473be60)
    at mm/vmscan.c:1101
#6  0xc0160488 in try_to_free_pages (zones=0xc056584c, order=Variable "order" is not available.
)
    at mm/vmscan.c:1153
#7  0xc015c190 in __alloc_pages (gfp_mask=688338, order=0, zonelist=0xc0565848)
    at mm/page_alloc.c:1336
#8  0xc0165285 in do_anonymous_page (mm=0xe470bb80, vma=0xe4704a6c, 
    address=138608668, page_table=0xe4746180, pmd=0xe4742210, write_access=1)
    at include/linux/gfp.h:100
#9  0xc0165a58 in __handle_mm_fault (mm=0xe470bb80, vma=0xe4704a6c, 
    address=138608668, write_access=1) at mm/memory.c:2549
#10 0xc041c984 in do_page_fault (regs=0xe473bfb8, error_code=6)
    at include/linux/mm.h:776
#11 0xc041b37a in error_code () at include/linux/sched.h:13
#12 0x4a492ff4 in ?? ()
#13 0x00020fe9 in ?? ()
#14 0x08430018 in ?? ()
#15 0x0842ec10 in ?? ()
#16 0x4a494820 in ?? ()
#17 0xbfded0cc in ?? ()
#18 0x00001409 in ?? ()
#19 0x0000007b in ?? ()
#20 0x0000007b in ?? ()
#21 0x08450000 in ?? ()
#22 0xffffffff in ?? ()
#23 0x4a3cf705 in ?? ()
#24 0x00000073 in ?? ()
#25 0x00010202 in ?? ()
#26 0xbfded010 in ?? ()
#27 0x0000007b in ?? ()
#28 0x00000000 in ?? ()
(gdb) thread 6
[Switching to thread 6 (process 6233)]#0  __do_softirq ()
    at kernel/softirq.c:231
231                     if (pending & 1) {
(gdb) bt
#0  __do_softirq () at kernel/softirq.c:231
#1  0xc012998b in do_softirq () at kernel/softirq.c:269
#2  0xc0129a09 in irq_exit () at kernel/softirq.c:305
#3  0xc0117443 in smp_apic_timer_interrupt (regs=Variable "regs" is not available.
)
    at arch/i386/kernel/apic.c:592
#4  0xc0105877 in apic_timer_interrupt () at include/asm/current.h:11
#5  0xc0564480 in contig_page_data ()
#6  0x00000007 in ?? ()
#7  0x00000001 in ?? ()
#8  0x00000000 in ?? ()
(gdb) thread 7
[Switching to thread 7 (process 6909)]#0  __spin_lock_debug (lock=0xc0564480)
    at include/asm/spinlock.h:88
88      {
(gdb) bt
#0  __spin_lock_debug (lock=0xc0564480) at include/asm/spinlock.h:88
#1  0xc02471cc in _raw_spin_lock (lock=0xc0564480) at lib/spinlock_debug.c:132
#2  0xc041ad3e in _spin_lock_irq (lock=0xc0564480) at kernel/spinlock.c:105
#3  0xc016000f in shrink_active_list (nr_pages=32, zone=0xc0563300, sc=Variable "sc" is not available.
)
    at mm/vmscan.c:950
#4  0xc01602a3 in shrink_zone (priority=5, zone=0xc0563300, sc=0xf0975e60)
    at mm/vmscan.c:1044
#5  0xc016036c in shrink_zones (priority=5, zones=0xc056584c, sc=0xf0975e60)
    at mm/vmscan.c:1101
#6  0xc0160488 in try_to_free_pages (zones=0xc056584c, order=Variable "order" is not available.
)
    at mm/vmscan.c:1153
#7  0xc015c190 in __alloc_pages (gfp_mask=688338, order=0, zonelist=0xc0565848)
    at mm/page_alloc.c:1336
#8  0xc0165285 in do_anonymous_page (mm=0xf0e5f040, vma=0xf7f1417c, 
    address=139046572, page_table=0xf0f254d0, pmd=0xf0f21210, write_access=1)
    at include/linux/gfp.h:100
#9  0xc0165a58 in __handle_mm_fault (mm=0xf0e5f040, vma=0xf7f1417c, 
    address=139046572, write_access=1) at mm/memory.c:2549
#10 0xc041c984 in do_page_fault (regs=0xf0975fb8, error_code=6)
    at include/linux/mm.h:776
#11 0xc041b37a in error_code () at include/linux/sched.h:13
#12 0x4a492ff4 in ?? ()
#13 0x0849aea8 in ?? ()
#14 0x00000ff1 in ?? ()
#15 0x00004159 in ?? ()
#16 0x08499eb8 in ?? ()
#17 0xbfaa9580 in ?? ()
#18 0x08499ec0 in ?? ()
#19 0x0000007b in ?? ()
#20 0x0000007b in ?? ()
#21 0x00000000 in ?? ()
(gdb) thread 8
[Switching to thread 8 (process 6679)]#0  shrink_active_list (nr_pages=32, 
    zone=0xc0563300, sc=Variable "sc" is not available.
) at include/linux/list.h:47
47              next->prev = new;
(gdb) bt
#0  shrink_active_list (nr_pages=32, zone=0xc0563300, sc=Variable "sc" is not available.
)
    at include/linux/list.h:47
#1  0xc01602a3 in shrink_zone (priority=5, zone=0xc0563300, sc=0xf14dde60)
    at mm/vmscan.c:1044
#2  0xc016036c in shrink_zones (priority=5, zones=0xc056584c, sc=0xf14dde60)
    at mm/vmscan.c:1101
#3  0xc0160488 in try_to_free_pages (zones=0xc056584c, order=Variable "order" is not available.
)
    at mm/vmscan.c:1153
#4  0xc015c190 in __alloc_pages (gfp_mask=688338, order=0, zonelist=0xc0565848)
    at mm/page_alloc.c:1336
#5  0xc0165285 in do_anonymous_page (mm=0xf1a9e040, vma=0xf11cca14, 
    address=3082788864, page_table=0xf5dbdfd0, pmd=0xf140ade8, write_access=1)
    at include/linux/gfp.h:100
#6  0xc0165a58 in __handle_mm_fault (mm=0xf1a9e040, vma=0xf11cca14, 
    address=3082788864, write_access=1) at mm/memory.c:2549
#7  0xc041c984 in do_page_fault (regs=0xf14ddfb8, error_code=6)
    at include/linux/mm.h:776
#8  0xc041b37a in error_code () at include/linux/sched.h:13
#9  0x00000014 in ?? ()
#10 0x00000005 in ?? ()
#11 0x00000000 in ?? ()
(gdb)

I am also starting a git bisect soon.

Thanks
-- 
regards,
Dhaval

I would like to change the world but they don't give me the source code!
