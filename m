Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZIQVMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZIQVMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZIQVMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:12:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbZIQVMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:12:50 -0400
Date: Thu, 17 Sep 2009 23:08:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, menage@google.com,
       bblum@google.com, ebiederm@xmission.com, lizf@cn.fujitsu.com,
       matthltc@us.ibm.com
Subject: Re: cgrooups && 2.6.32 -mm merge plans
Message-ID: <20090917210806.GA31441@redhat.com>
References: <20090915161535.db0a6904.akpm@linux-foundation.org> <20090917201516.GA29346@redhat.com> <20090917133846.a00daece.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917133846.a00daece.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17, Andrew Morton wrote:
>
> On Thu, 17 Sep 2009 22:15:16 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 09/15, Andrew Morton wrote:
> > >
> > > #cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch: Oleg conniptions
> > > cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
> > > cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
> > > cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
> > >
> > >   Merge after checking with Oleg.
> >
> > Well. I think these patches are buggy :/
> >
>
> Well that's never prevented us from merging stuff before.
>
> Thanks, I'll disable the patches for now.  Do we have a grip on what's
> wrong and what needs to be done to fix things?

Afaics, ->threadgroup_fork_lock doesn't really work, we can race with exec.

list_for_each_entry_rcu() loops in these patches are not safe.

And in fact, personally I dislike even atomic_inc(&sighand->count). Just
consider sys_unshare(CLONE_SIGHAND). Yes, this code is a joke, but still.


Sadly, I don't have any ideas how to fix this... I'd wish I had a time
to at least try to find the solution ;)

Oleg.

