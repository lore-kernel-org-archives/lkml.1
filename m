Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbYACN7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbYACN7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYACN7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:59:09 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:41960 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYACN7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:59:07 -0500
Date: Thu, 3 Jan 2008 08:58:51 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org
Subject: Re: [RFC PATCH 01/11] Add basic support for gcc profiler instrumentation
In-Reply-To: <20080103092104.GE10813@elte.hu>
Message-ID: <Pine.LNX.4.58.0801030849180.1468@gandalf.stny.rr.com>
References: <20080103071609.478486470@goodmis.org> <20080103072226.776141236@goodmis.org>
 <20080103092104.GE10813@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[Added Chris Wright, Rusty and Virt list because they were involved with
this issue before]

On Thu, 3 Jan 2008, Ingo Molnar wrote:

>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > +# function tracing might turn this off:
> > +config REGPARM
> > +	bool
> > +	depends on !MCOUNT
> > +	default y
>
> are you sure -pg really needs this?

Nope! Arnaldo and I only carried it because you had it ;-)

> I just carried this along the years
> and went the path of least resistence, but we should not be
> reintroducing the !REGPARM build mode for the kernel. I'd not be
> surprised if there were a few issues with REGPARM + mcount, but we have
> to figure it out before merging ...

Hmm, I know paravirt-ops had an issue with mcount in the RT tree. I can't
remember the exact issues, but it did have something to do with the way
parameters were passed in.

Chris, do you remember what the issues were?

I'm also thinking that this is only an i386 issue.

Thanks,

-- Steve

