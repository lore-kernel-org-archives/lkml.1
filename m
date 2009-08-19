Return-Path: <linux-kernel-owner+w=401wt.eu-S1752216AbZHSNuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbZHSNuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZHSNuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:50:16 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:58718 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbZHSNuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:50:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgEAK+bi0pMRdTz/2dsb2JhbACBUtVdgjOBZwU
Date: Wed, 19 Aug 2009 09:50:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Josh Stone <jistone@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, jiayingz@google.com,
       mbligh@google.com, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Create generic syscall TRACE_EVENTs
Message-ID: <20090819135011.GA8674@Krystal>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250634359-31642-1-git-send-email-jistone@redhat.com> <4A8B5624.9040607@cn.fujitsu.com> <4A8B6C01.1060503@redhat.com> <20090819130517.GB14215@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090819130517.GB14215@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:45:53 up 1 day, 35 min,  2 users,  load average: 0.10, 0.36,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Josh Stone <jistone@redhat.com> wrote:
> 
> > On 08/18/2009 06:32 PM, Li Zefan wrote:
> > > It would be much better to see a sample output of these TRACE_EVENTs,
> > > so we'll see the what's the output if a syscall has less than 6 args.
> > > 
> > > And I guess it should be "(%lx, %lx, ..., %lx)"? Otherwise I think we'll
> > > see some negative values.
> > 
> > Thanks, you're right -- the args should be unsigned long.  Whether they
> > are hex or decimal doesn't matter to me, but I guess that does make
> > pointers easier to spot.
> > 
> > Here's some output that I get on x86_64:
> > 
> > > # tail trace
> > >             tail-1106  [000] 113218.474657: syscall_enter: NR 2 (7f2d34dd38f0, 0, 7f2d35009010, 5, 4, ffffffffffffffb0)
> > > 
> > >             tail-1106  [000] 113218.474809: syscall_enter: NR 5 (3, 7f2d35009040, 7f2d35009040, 5, 4, ffffffffffffffb0)
> > > 
> > >             tail-1106  [000] 113218.474855: syscall_enter: NR 9 (0, 50d3ad0, 1, 2, 3, 0)
> > > 
> > >             tail-1106  [000] 113218.474946: syscall_enter: NR 3 (3, 7f2d2f9a0000, 5e22, 2, 3, 0)
> > > 
> > >             tail-1106  [000] 113218.475673: syscall_enter: NR 2 (7fff5e42a654, 0, 0, 7fff5e429600, 80, 3)
> > 
> > It's very raw indeed, but that's what Ingo asked for. :) The 
> > extra args show up as whatever happened to be in those registers.
> 
> If the syscalls are handled as a single tracepoint, then they 
> cannot really have per syscall properties.
> 
> The per syscall tracepoints on the other hand give very finegrained 
> information.
> 

Hi Ingo,

Aiming to identify the event payload type with the event ID alone, I
would recommend either:

- one tracepoint per syscall argument set types (e.g. same syscall
  prototype)
or
- one tracepoint per syscall (seems to be more straightforward)

Otherwise getting to fit a struct sockaddr into an integer might be
cumbersome.

Thanks,

Mathieu

> Note that via the use of filters one can limit the generic 
> tracepoint to only output certain syscall NRs, and only with 
> certain parameters.
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
