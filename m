Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbYLCLwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbYLCLwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYLCLwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:52:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34393 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYLCLwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:52:10 -0500
Date: Wed, 3 Dec 2008 06:52:08 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-graph-tracer: improve duration
 output
In-Reply-To: <20081203081906.GH21006@elte.hu>
Message-ID: <alpine.DEB.1.10.0812030649480.29045@gandalf.stny.rr.com>
References: <4935E19C.3090501@gmail.com> <4935E226.3060906@gmail.com> <20081203081906.GH21006@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 3 Dec 2008, Ingo Molnar wrote:
> 
> > An example of a trace after these two patches (with funcgraph-proc enabled):
> > 
> >  0)    cat-2796    |               |            put_prev_task_fair() {
> >  0)    cat-2796    |   0.609 us    |              update_curr();
> >  0)    cat-2796    |   1.842 us    |            }
> >  0)    cat-2796    |               |            pick_next_task_fair() {
> >  0)    cat-2796    |   0.526 us    |              wakeup_preempt_entity();
> >  0)    cat-2796    |   0.797 us    |              set_next_entity();
> >  0)    cat-2796    |   0.541 us    |              hrtick_start_fair();
> >  0)    cat-2796    |   4.195 us    |            }
> >  0)    cat-2796    |   1.263 us    |            _spin_trylock();
> >  0)    cat-2796    |   0.624 us    |            _spin_unlock();
> >  0)    cat-2796    |   0.789 us    |            _spin_trylock();
> >  0)    cat-2796    |   0.617 us    |            _spin_unlock();
> >  0)    cat-2796    |   0.579 us    |            native_load_sp0();
> >  0)    cat-2796    |   0.722 us    |            native_load_tls();
> >
> >  ------------------------------------------
> >  | 0)    cat-2796    =>   events/-9   
> >  ------------------------------------------
> 
> small detail: i'd suggest to remove the newline before the context-switch 
> box. That makes it appear visually to attach logically with the 
> switch-out place, not the switch-in place:

Actually, I was also thinking of keeping the CPU number in front:

 ------------------------------------------
 0)    cat-2796    =>   events/-9
 ------------------------------------------

This way we can easily grep for a common CPU and still get the context 
switches:

grep '^0)' trace > /tmp/trace0

Of course it will probably also work without the '^' now, but then it 
might grab ftrace_printks with a '0)' if we add those.

-- Steve

> 
> >  0)    cat-2796    |   0.579 us    |            native_load_sp0();
> >  0)    cat-2796    |   0.722 us    |            native_load_tls();
> >  ------------------------------------------
> >  | 0)    cat-2796    =>   events/-9   
> >  ------------------------------------------
> > 
> >  0)   events/-9    |               |    finish_task_switch() {
> >  0)   events/-9    |   0.789 us    |      _spin_unlock_irq();
> >  0)   events/-9    |   2.309 us    |    }
> >  0)   events/-9    | ! 269848.5 us |  }
> 
> which is what we want to express.
> 
> 	Ingo
> 
> 
