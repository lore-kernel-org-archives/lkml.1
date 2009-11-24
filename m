Return-Path: <linux-kernel-owner+w=401wt.eu-S934283AbZKXVun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283AbZKXVun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933920AbZKXVun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:50:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933841AbZKXVum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:50:42 -0500
Date: Tue, 24 Nov 2009 22:44:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091124214450.GA12828@redhat.com>
References: <20091124200220.GA5828@redhat.com> <87my2bwtno.fsf@basil.nowhere.org> <20091124204152.GA9131@redhat.com> <20091124212619.GB29096@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124212619.GB29096@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(restore cc's)

On 11/24, Andi Kleen wrote:
>
> On Tue, Nov 24, 2009 at 09:41:52PM +0100, Oleg Nesterov wrote:
> > On 11/24, Andi Kleen wrote:
> > >
> > > Oleg Nesterov <oleg@redhat.com> writes:
> > >
> > > > From: Roland McGrath <roland@redhat.com>
> > > >
> > > > This adds the utrace facility, a new modular interface in the kernel
> > > > for implementing user thread tracing and debugging.  This fits on top
> > > > of the tracehook_* layer, so the new code is well-isolated.
> > >
> > > Could we just drop the tracehook layer if this finally merged
> > > and call the low level functions directly?
> >
> > Not sure I understand. Tracehooks are trivial inline wrappers on
> > top utrace calls,
>
> Yes that's the problem -- they are unnecessary obfuscation
> when you can just call directly.

This is subjective, but personally I disagree. Contrary, imho it
is good that tracehook hides the (simple) details. I do not understand
why the reader of, say, do_fork() should see the contents of
tracehook_report_clone_complete(). This will complicate the understanding.
Those people who want to understand/change fork() do not care about
utrace/ptrace usually.

And please note that it is much, much easier to change this code
when it lives in tracehooks.h instead of sched.c/signal.c/etc.

> > What is the point?
>
> Less code obfuscation.
>
> When it's a utrace call, call it a utrace call, not something else.

Why do you think this is obfuscation? Well, we can rename these
helpers, s/tracehook_/utrace_/, but I don't see how this can make
the code more readable.

Oleg.

