Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbZHSNFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbZHSNFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZHSNFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:05:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42579 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbZHSNFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:05:33 -0400
Date: Wed, 19 Aug 2009 15:05:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Josh Stone <jistone@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH] tracing: Create generic syscall TRACE_EVENTs
Message-ID: <20090819130517.GB14215@elte.hu>
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250634359-31642-1-git-send-email-jistone@redhat.com> <4A8B5624.9040607@cn.fujitsu.com> <4A8B6C01.1060503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8B6C01.1060503@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Stone <jistone@redhat.com> wrote:

> On 08/18/2009 06:32 PM, Li Zefan wrote:
> > It would be much better to see a sample output of these TRACE_EVENTs,
> > so we'll see the what's the output if a syscall has less than 6 args.
> > 
> > And I guess it should be "(%lx, %lx, ..., %lx)"? Otherwise I think we'll
> > see some negative values.
> 
> Thanks, you're right -- the args should be unsigned long.  Whether they
> are hex or decimal doesn't matter to me, but I guess that does make
> pointers easier to spot.
> 
> Here's some output that I get on x86_64:
> 
> > # tail trace
> >             tail-1106  [000] 113218.474657: syscall_enter: NR 2 (7f2d34dd38f0, 0, 7f2d35009010, 5, 4, ffffffffffffffb0)
> > 
> >             tail-1106  [000] 113218.474809: syscall_enter: NR 5 (3, 7f2d35009040, 7f2d35009040, 5, 4, ffffffffffffffb0)
> > 
> >             tail-1106  [000] 113218.474855: syscall_enter: NR 9 (0, 50d3ad0, 1, 2, 3, 0)
> > 
> >             tail-1106  [000] 113218.474946: syscall_enter: NR 3 (3, 7f2d2f9a0000, 5e22, 2, 3, 0)
> > 
> >             tail-1106  [000] 113218.475673: syscall_enter: NR 2 (7fff5e42a654, 0, 0, 7fff5e429600, 80, 3)
> 
> It's very raw indeed, but that's what Ingo asked for. :) The 
> extra args show up as whatever happened to be in those registers.

If the syscalls are handled as a single tracepoint, then they 
cannot really have per syscall properties.

The per syscall tracepoints on the other hand give very finegrained 
information.

Note that via the use of filters one can limit the generic 
tracepoint to only output certain syscall NRs, and only with 
certain parameters.

	Ingo
