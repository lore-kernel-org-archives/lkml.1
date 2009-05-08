Return-Path: <linux-kernel-owner+w=401wt.eu-S1761684AbZEHJVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761684AbZEHJVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbZEHJVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:21:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60778 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbZEHJVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:21:04 -0400
Date: Fri, 8 May 2009 11:20:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Adam Langley <agl@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       markus@google.com
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
Message-ID: <20090508092039.GC3559@elte.hu>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa> <20090507221447.GE28770@elte.hu> <a84d7bc60905071534l1e65f216mfd9330e93e4da4e2@mail.gmail.com> <20090507230021.GC6472@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090507230021.GC6472@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, May 07, 2009 at 03:34:58PM -0700, Adam Langley wrote:
> > > That assessment is incorrect, there's no difference between safety
> > > here really.
> > >
> > > LSM cannot magically inspect user-space memory either when multiple
> > > threads may access it. The point would be to define filters for
> > > system call _arguments_, which are inherently thread-local and safe.
> > 
> > If I hook security_operations.socket_connect, I can validate the struct
> > sockaddr after the final copy_from_user. However, since the sockaddr lives in
> > userspace memory, if I try and validate it from ftrace SYSCALL_ENTER, I can't
> > know that it won't change before sys_connect reads it again.
> > 
> > Because of that, there are system calls which an LSM hook can safely accept
> > that an ftrace hook cannot. However, as you point out, any arguments passed in
> > registers are inheriently safe and these may be sufficiently powerful.
> > 
> > > There are two problems with the bitmap scheme, which i also
> > > suggested in a previous thread but then found it to be lacking:
> > >
> > > 1) enumeration: you define a bitmap. That will be problematic
> > >   between compat and native 64-bit (both have different syscall
> > >   vectors).
> > 
> > I /think/ it works out, but I've been bitten before with subtle 32/64 bit
> > compat issues and accept that it's a bit ugly.
> > 
> > > 2) flexibility. It's an on/off selection per syscall. With the
> > >   filter we have on, off, or filtered. That's a _whole_ lot more
> > >   flexible.
> > 
> > Absolutely.
> > 
> > Is there a git tree that I can pull this parsing code from?
> > (git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > maybe?). I can patch in the seccomp-on-ftrace work and try building the
> > filtering on top of that. I'll see how it turns out anyway.
> 
> 
> Hi,
> 
> The most uptodate one is:
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> on the tracing/filters topic.
> 
> See kernel/trace/trace_events_filter.c

tracing/filters may lag behind - i'd suggest to use the master 
branch, that's the most stable stuff generally. Or tracing/core for 
any Git based tree.

	Ingo
