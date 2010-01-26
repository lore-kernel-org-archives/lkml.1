Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680Ab0AZVbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0AZVbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:31:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677Ab0AZVbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:31:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab0AZVbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:31:48 -0500
Date: Tue, 26 Jan 2010 22:30:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, tromey@redhat.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100126213010.GA19146@redhat.com>
References: <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <877hr4g49l.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001261038150.3574@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001261038150.3574@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Linus Torvalds wrote:
>
> The problem is that anything that is based on reparenting and signals is
> fundamentally a "one parent only" kind of interface. See?

Indeed. signals + do_wait() is the horrible model.

> So the reason I think using an fd is a good idea is _not_ because gdb
> already uses an fd internally, but because it gives you a "connection"
> between the debugger and debuggee that is not fundamentally limited to a
> single controller.
>
> (It doesn't have to be a file descriptor, of course, but could be any kind
> of other model that allows multiple connections.

Yes.

But then we need something which represents this connection in kernel:
utrace_engine. Then we need something which allows multiple tracers to
cooperate. Just for example, one tracer wants to resume the tracee,
another tracer wants the tracee to be stopped. Utrace does this. And,
since we should preserve the current ptrace, the tracers should cooperate
with ptrace too.

IOW, this quickly leads to the new abstraction layer, I think. And of
course it is possible to implement this new model on top of utrace.

Yes, utrace itself comes with utrace_engine_ops vector to implement
"whatever you like", perhaps you dislike this part.

Oleg.

