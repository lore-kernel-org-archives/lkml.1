Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZLWRmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZLWRmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 12:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZLWRmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 12:42:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZLWRmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 12:42:53 -0500
Date: Wed, 23 Dec 2009 18:42:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [PATCH 0/7] utrace/ptrace
Message-ID: <20091223174232.GA14993@redhat.com>
References: <20091218011116.GA29534@redhat.com> <20091222135809.1ab10869.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222135809.1ab10869.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22, Andrew Morton wrote:
>
> On Fri, 18 Dec 2009 02:11:16 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > It allows for multiple separate tracing engines to work
> > in parallel without interfering with each other.  Higher-level tracing
> > facilities can be implemented as loadable kernel modules using this layer.
>
> That's a bit brief.  Do you have a nicer sales brochure?  What are
> these "separate tracing engines" and what is their merge status and why
> would we want any of them, for what purpose?  etc.
>
> IOW: give us a reason!

First of all, utrace makes other things possible. gdbstub, nondestructive
core dump, uprobes, kmview, hopefully more. I didn't look at these projects
closely, perhaps other people can tell more. As for their merge status,
until utrace itself is merged it is very hard to develop them out of tree.

To me, even seccomp is the good example why utrace is useful. seccomp
is simple, but it needs hooks in arch/ hot pathes. Contrary, utrace-based
implementation is more flexible, simple, and it is completely "hidden"
behind utrace.

In my opinion, ptrace-utrace is another example. Once CONFIG_UTRACE
goes away, we can remove almost all ptrace-related code from core
kernel (and kill task_struct->ptrace/etc members).

ftrace/etc is excellent in many ways, but even if we need the simple
"passive" tracing it is not enough sometimes. And we have nothing else
except ptrace currently. But ptrace is so horrible and unfixeable, and
it has so many limitations. In fact, even the simple things like stop/
continue this thread/process are not trivial using ptrace, gdb/strace
have to do a lot of hacks to overcome ptrace's limitations, and some
of these hacks falls into "mostly works, but that is all" category.

Of course, I can't promise we will have the new gdb which explores
utrace facilities soon, but I think at leat utrace gives a chance.


Well. I had a lot of technical discussions with Roland about utrace,
but I never asked him why he created this thing ;) To me, utrace
looks like vfs. Currently we have the single and very poor "filesystem",
ptrace. Until we add the appropriate layer, we can't expect the
further improvements is this area.

Oleg.

