Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbZJaC2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbZJaC2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 22:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbZJaC2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 22:28:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757608AbZJaC2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 22:28:51 -0400
Date: Sat, 31 Oct 2009 03:24:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: cleanup ptrace_init_task()->ptrace_link() path
Message-ID: <20091031022402.GA9883@redhat.com>
References: <20091029235656.GA26438@redhat.com> <20091030155057.270cf1a0.akpm@linux-foundation.org> <20091031005507.GA4005@redhat.com> <20091030185620.b8e0fc8b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030185620.b8e0fc8b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30, Andrew Morton wrote:
>
> On Sat, 31 Oct 2009 01:55:07 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 10/30, Andrew Morton wrote:
> > >
> > > On Fri, 30 Oct 2009 00:56:56 +0100
> > > Oleg Nesterov <oleg@redhat.com> wrote:
> > >
> > > >  ptrace
> > >
> > > Speaking of which, I'm still sitting on
> > > do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch.
> >
> > (this patch has nothing to do with ptrace)
> >
> > > Should I drop it?
> >
> > Why? I think this is good optimization and imho cleanup.
> >
> > There is no point to have sub-thread in ->children list and this
> > slows down do_wait() if a child has a lot of threads, it has to
> > iterate over all sub-threads just to filter them out.
> >
>
> On 17 Sep you said:
>
> : Yes, risky... God knows who can do list_for_each(->children) and expect to
> : find the sub-threads. But this is obviously good optimization/simplification.
> :
> : It is just ugly to place sub-threads on ->children list, this buys nothing
> : but slown downs do_wait(). (this was needed, afaics, to handle ptraced but
> : not re-parented threads a long ago).
>
> so that's why I didn't merge it into 2.6.32.  Is the patch still
> considered "risky"?

I hope not, it didn't cause any problems during 3 months in -mm.

Oleg.

