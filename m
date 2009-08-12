Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZHLOa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZHLOa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZHLOa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:30:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40114 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbZHLOa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:30:28 -0400
Date: Wed, 12 Aug 2009 16:30:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [GIT PULL] tracing: Syscalls trace events + perf support
Message-ID: <20090812143002.GB19882@elte.hu>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <20090812091133.GA21655@elte.hu> <20090812110307.GA806@elte.hu> <20090812113308.GD6081@nowhere> <20090812135954.GA2711@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812135954.GA2711@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> On Wed, Aug 12, 2009 at 01:33:09PM +0200, Frederic Weisbecker wrote:
> > On Wed, Aug 12, 2009 at 01:03:07PM +0200, Ingo Molnar wrote:
> > > 
> > > one thing i noticed is that we dont seem to be catching 
> > > compat syscalls properly:
> > 
> > 
> > Oh right. While looking at fs/compat.c, it seems most of the
> > compat syscalls haven't been defined through the SYSCALL_DEFINE
> > macro.
> > 
> > Grr...
> > 
> 
> right. I mentioned this in a pervious mail that we weren't 
> handling compat syscalls. That said, the pervious syscall tracer 
> also had the same issue, so we haven't taken a step back. I guess 
> we need to convert some of the compat layer to use the 
> DEFINE_SYSCALL() macros. Also, there are a number of 64-bit 
> syscalls that don't use DEFINE_SYSCALL either. Those need to 
> converted as well. The patchset I submitted converted a couple of 
> them....

Those should come in separate patches as DEFINE_SYSCALL() coverage 
is useful to upstream as-is, even outside of syscall-tracing's 
scope.

	Ingo
