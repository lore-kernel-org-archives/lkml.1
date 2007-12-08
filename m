Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbXLHC4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbXLHC4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 21:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbXLHC4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 21:56:39 -0500
Received: from www.tglx.de ([62.245.132.106]:34181 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbXLHC4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 21:56:38 -0500
Date: Sat, 8 Dec 2007 08:26:11 +0530 (IST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Parag Warudkar <parag.warudkar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: RE: soft lockup - CPU#1 stuck for 15s! [swapper:0]
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
Message-ID: <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain>
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com> <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Dec 2007, Pallipadi, Venkatesh wrote:
> >-----Original Message-----
> >From: Parag Warudkar [mailto:parag.warudkar@gmail.com] 
> >Sent: Friday, December 07, 2007 2:54 PM
> >To: LKML
> >Cc: Andrew Morton; Pallipadi, Venkatesh; Linus Torvalds
> >Subject: BUG: soft lockup - CPU#1 stuck for 15s! [swapper:0]
> >
> >Got this on today's git (2.6.24-rc4) while compiling  stuff - Looks
> >like it is related to CpuIdle stuff.
> >I chose CONFIG_CPU_IDLE for the first time so I don't know when this
> >was introduced.
> >
> >This is on x86_32, SMP.
> >
> >BUG: soft lockup - CPU#1 stuck for 15s! [swapper:0]
> >
> >Pid: 0, comm: swapper Not tainted (2.6.24-rc4 #3)
> >EIP: 0060:[<c0603e22>] EFLAGS: 00000202 CPU: 1
> >EIP is at _spin_lock_irqsave+0x16/0x27
> >EAX: c06b4110 EBX: 00000001 ECX: f7873808 EDX: 00000293
> >ESI: 00000005 EDI: f7873808 EBP: 00000000 ESP: f7829f10
> > DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> >CR0: 8005003b CR2: 004f5960 CR3: 372c5000 CR4: 000006d0
> >DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> >DR6: ffff0ff0 DR7: 00000400
> > [<c0438233>] tick_broadcast_oneshot_control+0x10/0xda
> > [<c0437c82>] tick_notify+0x1d4/0x2eb
> > [<c04281b4>] get_next_timer_interrupt+0x143/0x1b4
> > [<c0605819>] notifier_call_chain+0x2a/0x47
> > [<c04345a0>] raw_notifier_call_chain+0x17/0x1a
> > [<c04378b7>] clockevents_notify+0x19/0x4f
> > [<c0533cc3>] acpi_idle_enter_simple+0x183/0x1d0
> > [<c058cea3>] cpuidle_idle_call+0x53/0x78
> > [<c058ce50>] cpuidle_idle_call+0x0/0x78
> > [<c0402575>] cpu_idle+0x97/0xb8
> >
> 
> Looks like tick_broadcast_lock did not get freed in some path.
> You do not see this when you CPU_IDLE is not configured? 

This looks pretty much like the problem I was solving yesterday.

Parag, can you please try Linus latest and please check whether there
is a stack trace with clockevents_program_event on the top in your
dmesg.

Thanks,
	tglx
