Return-Path: <linux-kernel-owner+w=401wt.eu-S1763999AbZFPU5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763999AbZFPU5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763719AbZFPU4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:56:54 -0400
Received: from yw-out-2122.google.com ([74.125.46.25]:53985 "EHLO
	yw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763796AbZFPU4w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:56:52 -0400
MIME-Version: 1.0
Date: Tue, 16 Jun 2009 13:56:54 -0700 (PDT)
In-Reply-To: <cqv1s-5wS-7@gated-at.bofh.it>
X-IP: 86.25.246.25
References: <comvb-35N-1@gated-at.bofh.it> <coonp-67a-17@gated-at.bofh.it> 
	<cqv1s-5wS-7@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 Gecko/2008061017 Firefox/3.0,gzip(gfe),gzip(gfe)
X-HTTP-Via: 1.1 home (squid/3.0.STABLE8)
Message-ID: <677c7cd8-4cdf-49be-a72d-67d2c381b4eb@l12g2000yqo.googlegroups.com>
Subject: Re: lockdep warning: module_mutex vs. ftrace_lock
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 13, 3:10 pm, Steven Rostedt <srost...@redhat.com> wrote:
> On Tue, 2009-04-07 at 20:30 +0200, Frederic Weisbecker wrote:
> > On Tue, Apr 07, 2009 at 06:34:56PM +0200, Miklos Szeredi wrote:
> > > =======================================================
> > > [ INFO: possible circular locking dependency detected ]
> > > 2.6.29-09854-gd508afb-dirty #6
> > > -------------------------------------------------------
> > > modprobe/3184 is trying to acquire lock:
> > >  (ftrace_lock){+.+.+.}, at: [<ffffffff80277e71>] ftrace_convert_nops+0x32/0x267
>
> > > but task is already holding lock:
> > >  (module_mutex){+.+.+.}, at: [<ffffffff8026a539>] sys_init_module+0x3f/0x1d3
>
> > > which lock already depends on the new lock.
>
> > > the existing dependency chain (in reverse order) is:
>
> > > -> #1 (module_mutex){+.+.+.}:
> > >        [<ffffffff8026134a>] __lock_acquire+0x12fe/0x1668
> > >        [<ffffffff802617a2>] lock_acquire+0xee/0x112
> > >        [<ffffffff804fe0a6>] mutex_lock_nested+0x4f/0x305
> > >        [<ffffffff8026709e>] module_update_tracepoints+0x1c/0x73
> > >        [<ffffffff80274f74>] tracepoint_update_probes+0x21/0x23
> > >        [<ffffffff8027510a>] tracepoint_probe_register+0x4a/0x68
> > >        [<ffffffff80277cae>] register_ftrace_graph+0x2a9/0x30f
> > >        [<ffffffff8027f928>] trace_selftest_startup_function_graph+0x2e/0xbb
> > >        [<ffffffff8027fdc5>] register_tracer+0x151/0x26e
> > >        [<ffffffff8070b942>] init_graph_trace+0x10/0x12
> > >        [<ffffffff80209066>] do_one_initcall+0x5b/0x135
> > >        [<ffffffff806fa5e4>] kernel_init+0x12f/0x185
> > >        [<ffffffff8020c2ba>] child_rip+0xa/0x20
> > >        [<ffffffffffffffff>] 0xffffffffffffffff
>
> > > -> #0 (ftrace_lock){+.+.+.}:
> > >        [<ffffffff80261067>] __lock_acquire+0x101b/0x1668
> > >        [<ffffffff802617a2>] lock_acquire+0xee/0x112
> > >        [<ffffffff804fe0a6>] mutex_lock_nested+0x4f/0x305
> > >        [<ffffffff80277e71>] ftrace_convert_nops+0x32/0x267
> > >        [<ffffffff802780bd>] ftrace_init_module+0x17/0x19
> > >        [<ffffffff8026a011>] load_module+0x1122/0x160b
> > >        [<ffffffff8026a556>] sys_init_module+0x5c/0x1d3
> > >        [<ffffffff8020b21b>] system_call_fastpath+0x16/0x1b
> > >        [<ffffffffffffffff>] 0xffffffffffffffff
>
> > Ah that's this ftrace/modules lock dependency that Steven told me about
> > recently. Steven, do you know more about it now?
>
> Yeah, I think I submitted a patch to fix that. I'll check my repo.

This is still live in 2.6.30 proper.

Let me know if you'd like further testing on your patch, or if you
can't find locate it.

Thanks,
  Daniel
--
Daniel J Blueman
