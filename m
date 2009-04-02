Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbZDBRZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbZDBRZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764411AbZDBRYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:24:30 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42798 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbZDBRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:24:27 -0400
Subject: Re: [Announce] 2.6.29-rt2
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
In-Reply-To: <alpine.LFD.2.00.0904021842050.12916@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
	 <1238688145.8813.16.camel@lexx>
	 <alpine.LFD.2.00.0904021842050.12916@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Thu, 02 Apr 2009 12:24:13 -0500
Message-Id: <1238693053.8813.27.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 18:45 +0200, Thomas Gleixner wrote:
> On Thu, 2 Apr 2009, Will Schmidt wrote:
> 
> > On Thu, 2009-04-02 at 02:17 +0200, Thomas Gleixner wrote:
> > > We are pleased to announce the next update to our new preempt-rt
> > > series.
> > > 
> > >       - fix a fork/exit bug in the signal per task cache (/me puts on
> > >         a huge brown paper bag - Thanks to Phillipe Reynes and Will
> > >         Schmidt for reporting and testing)
> > > 
> > >       - fix a group scheduling migration accounting bug (decoded with
> > >         and fixed by Peter Zijlstra - reported by Robin Gareus)
> > > 
> > >       - tlb gather rework by Peter Zijlstra - Thanks Peter !
> > > 
> > >       - the usual fixlets
> > > 
> > > The tlb rework might be incomplete on some of the uncountable
> > > incarnations of PowerPC and ARM platforms, so look out for wreckage
> > > and keep the usual tools (fire-extinguishers, brooms, buckets etc.)
> > > handy.
> > 
> > I can confirm that the tlb rework does appear to be missing some parts
> > for Power.  (Using 2.6.29-rt3 on pseries ppc64)
> > 
> > arch/powerpc/kernel/built-in.o:(.toc1+0x4d0): undefined reference to
> > `per_cpu__ppc64_tlb_batch'
> > <...>
> > mm/built-in.o:(.toc1+0xed0): more undefined references to
> > `per_cpu__ppc64_tlb_batch' follow
> > 
> > Not clear to me if this is just missing a "DEFINE_PER_CPU_LOCKED" to
> > replace the removed "DEFINE_PER_CPU", (similar to the prior RT patches),
> > or if the tlb rework is more involved.   So, I will patiently remain
> > tuned in.  :-)
> 
> No, the DEFINE_PER_CPU was removed accidentaly. Should have stayed there
> 
> Thanks,
> 
> 	tglx

Thanks for the quick respin. 

Panic during boot:
<snip>
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ide-cd driver 5.00
mice: PS/2 mouse device common for all mice
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Freeing unused kernel memory: 292k freed
Red Hat nash version 5.1.19.6 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Unable to handle kernel paging request for instruction fetch
Faulting instruction address: 0x00000c30
cpu 0x3: Vector: 400 (Instruction Access) at [c0000000e8203b00]
    pc: 0000000000000c30
    lr: c0000000000b7d24: .rcu_process_callbacks+0xc0/0xec
    sp: c0000000e8203d80
   msr: 8000000040009032
  current = 0xc0000000e81ff0f0
  paca    = 0xc000000000663800
    pid   = 53, comm = sirq-rcu/3
enter ? for help
[c0000000e8203d80] c0000000000b7d24 .rcu_process_callbacks+0xc0/0xec
(unreliable)
[c0000000e8203e10] c000000000070f48 .ksoftirqd+0x208/0x39c
[c0000000e8203f00] c000000000085a34 .kthread+0x78/0xc4
[c0000000e8203f90] c000000000029818 .kernel_thread+0x54/0x70
3:mon>                
3:mon> r
R00 = c0000000e8480100   R16 = c000000000467280
R01 = c0000000e8203d80   R17 = c000000000465980
R02 = 000000000014ff97   R18 = 0000000000000000
R03 = c0000000e6b6b880   R19 = c0000000e8200000
R04 = 0000000000000001   R20 = c00000000065be58
R05 = c000000000663800   R21 = 0000000000000000
R06 = c0000000e8203cc8   R22 = 0000000000000003
R07 = 0000000000200200   R23 = 0000000000000003
R08 = 0000000000000001   R24 = c000000000663800
R09 = c0000000e6b60eb0   R25 = c000000000696f00
R10 = c000000000538280   R26 = c00000000079e620
R11 = 0000000000000001   R27 = 0000000000000100
R12 = 0000000084000082   R28 = 0000000000000001
R13 = c000000000663800   R29 = c00000000079ea28
R14 = 0000000000000000   R30 = c0000000005d1538
R15 = 0000000002100000   R31 = c0000000e8480100
pc  = 0000000000000c30
lr  = c0000000000b7d24 .rcu_process_callbacks+0xc0/0xec
msr = 8000000040009032   cr  = 24000088
ctr = 0000000000000c31   xer = 0000000020000004   trap =  400




> 
> --------
> 
> Index: linux-2.6-tip/arch/powerpc/mm/tlb_hash64.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/powerpc/mm/tlb_hash64.c
> +++ linux-2.6-tip/arch/powerpc/mm/tlb_hash64.c
> @@ -32,6 +32,8 @@
>  #include <asm/bug.h>
>  #include <asm/machdep.h>
> 
> +DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
> +
>  /*
>   * A linux PTE was changed and the corresponding hash table entry
>   * neesd to be flushed. This function will either perform the flush

