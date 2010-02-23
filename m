Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0BWMfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:35:23 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:54164 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980Ab0BWMfV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:35:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMxZg0tGGOM5/2dsb2JhbACbAnS7eoRpBIMVgn0
Date: Tue, 23 Feb 2010 07:30:16 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: naresh kamboju <naresh.kernel@gmail.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: LTTng 0.193 fixes RT kernel support
Message-ID: <20100223123016.GA12857@Krystal>
References: <f5a7b3811002160717y65b4577buf53e5784c71575c3@mail.gmail.com> <1266337450.24271.140.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1002161727570.2811@localhost.localdomain> <20100216164744.GA25115@Krystal> <alpine.LFD.2.00.1002161757050.2811@localhost.localdomain> <20100216170540.GA28039@Krystal> <f5a7b3811002170236i6c560eadp2de7deb10082db4f@mail.gmail.com> <20100217230854.GA25636@Krystal> <f5a7b3811002220737r502e75c1w5ab5a64b6cc27b68@mail.gmail.com> <f5a7b3811002230329w64cabac9lff95a40cb5e7dfa5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <f5a7b3811002230329w64cabac9lff95a40cb5e7dfa5@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 07:24:22 up 68 days, 20:42,  4 users,  load average: 0.07, 0.10,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* naresh kamboju (naresh.kernel@gmail.com) wrote:
> On Mon, Feb 22, 2010 at 9:07 PM, naresh kamboju <naresh.kernel@gmail.com> wrote:
> > On Thu, Feb 18, 2010 at 4:38 AM, Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com> wrote:
> >> * naresh kamboju (naresh.kernel@gmail.com) wrote:
> >>> Hi,
> >>>
> >>> On Tue, Feb 16, 2010 at 10:35 PM, Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
> >> [...]
> >>> > Oh, right. Thanks for the explanation. I'll look into moving LTTng to a
> >>> > saner del_timer_sync() scheme to delete the timers.
> >>>
> >>> Could you give more info regarding, what kind of changes we can work on.
> >>> let me also work around on it.
> >>>
> >>
> >> I just released LTTng 0.193 for kernel 2.6.32.4 which includes patches
> >> fixing these odd per-cpu timer teardowns.
> >
> > I have downloaded LTTng 0.193 patches and viewed i can see below patches
> >
> > 1. lttng-transport-lockless-add-timer-on-works-with-del-timer-sync.patch
> > 2. omap-trace-clock-use-del-timer-sync.patch
> > 3. x86-trace-clock-use-mod-timer.patch
> > 4. trace-clock-32-to-64-use-del-timer-sync.patch
> 
> FYI.
> 
> I have ported  LTTng 0.193 these four patches and able to resolve the
> issues on Uni-processor (UP) on ARM arch Thank you.
> 
> A different bug is reported on SMP.
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: lttctl/754
> caller is put_synthetic_tsc+0x7c/0xf8
> 
> Backtrace:
> [<c002d438>] (dump_backtrace+0x0/0x10c) from [<c03a7150>] (dump_stack+0x18/0x1c)
>  r7:c04c4994 r6:c008e24c r5:00000003 r4:ce0b6000
> [<c03a7138>] (dump_stack+0x0/0x1c) from [<c02423b4>]
> (debug_smp_processor_id+0xc0/0xec)
> [<c02422f4>] (debug_smp_processor_id+0x0/0xec) from [<c008e24c>]
> (put_synthetic_tsc+0x7c/0xf8)
>  r6:c04f82cc r5:c0023600 r4:00000003
> [<c008e1d0>] (put_synthetic_tsc+0x0/0xf8) from [<c008e610>]
> (put_trace_clock+0x68/0x7c)
>  r8:bece6eb9 r7:0000000b r6:ce0b7d2a r5:cc037600 r4:00000000
> [<c008e5a8>] (put_trace_clock+0x0/0x7c) from [<c022a96c>]
> (ltt_trace_destroy+0x40/0x94)
> [<c022a92c>] (ltt_trace_destroy+0x0/0x94) from [<c0232f6c>]
> (destroy_trace_write+0xbc/0x140)
>  r5:00000000 r4:0000000b
> [<c0232eb0>] (destroy_trace_write+0x0/0x140) from [<c00be240>]
> (vfs_write+0xb4/0x144)
>  r7:0000000b r6:ce0b7f70 r5:bece6eb9 r4:ceae7860
> [<c00be18c>] (vfs_write+0x0/0x144) from [<c00be424>] (sys_write+0x48/0xf4)
>  r7:0000000b r6:ceae7860 r5:00000000 r4:00000000
> [<c00be3dc>] (sys_write+0x0/0xf4) from [<c0028e3c>]
> (__sys_trace_return+0x0/0x24)
> 
> 
> patch trace-clock-32-to-64-use-del-timer-sync.patch is causing above
> problem on SMP.
> 
> with out this patch on SMP reported the previous bug as BUG: sleeping
> function called from invalid context at kernel/rtmutex.c:685
> 
> However, i'll investigate.

Hrm, we should turn the arch/{arm/mach-omap2,x86/kernel}/trace-clock.c:
trace_clock_lock into a mutex, and kernel/trace/trace-clock-32-to-64.c:
synthetic_tsc_lock into a mutex too.

I used a spinlock previously on ARM because it was called from power
management resume, but now that the data structures touched by this code
path are per-cpu, this lock is not taken there, so it should be OK to
turn it into a mutex.

Can you try that and tell me if that fixes your issues ?

Thanks,

Mathieu

> 
> Best regards,
> Naresh Kamboju
> >> Thanks,
> >>
> >> Mathieu
> >>
> >> --
> >> Mathieu Desnoyers
> >> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> >>
> >
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
