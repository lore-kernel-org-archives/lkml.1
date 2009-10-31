Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbZJaB4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbZJaB4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 21:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757614AbZJaB4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 21:56:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757591AbZJaB4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 21:56:34 -0400
Date: Fri, 30 Oct 2009 18:56:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: cleanup ptrace_init_task()->ptrace_link() path
Message-Id: <20091030185620.b8e0fc8b.akpm@linux-foundation.org>
In-Reply-To: <20091031005507.GA4005@redhat.com>
References: <20091029235656.GA26438@redhat.com>
	<20091030155057.270cf1a0.akpm@linux-foundation.org>
	<20091031005507.GA4005@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009 01:55:07 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> On 10/30, Andrew Morton wrote:
> >
> > On Fri, 30 Oct 2009 00:56:56 +0100
> > Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > >  ptrace
> >
> > Speaking of which, I'm still sitting on
> > do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch.
> 
> (this patch has nothing to do with ptrace)
> 
> > Should I drop it?
> 
> Why? I think this is good optimization and imho cleanup.
> 
> There is no point to have sub-thread in ->children list and this
> slows down do_wait() if a child has a lot of threads, it has to
> iterate over all sub-threads just to filter them out.
> 

On 17 Sep you said:

: Yes, risky... God knows who can do list_for_each(->children) and expect to
: find the sub-threads. But this is obviously good optimization/simplification.
:
: It is just ugly to place sub-threads on ->children list, this buys nothing
: but slown downs do_wait(). (this was needed, afaics, to handle ptraced but
: not re-parented threads a long ago).

so that's why I didn't merge it into 2.6.32.  Is the patch still
considered "risky"?

