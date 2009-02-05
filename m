Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZBEXC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZBEXC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 18:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbZBEXCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 18:02:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131AbZBEXCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 18:02:19 -0500
Date: Thu, 5 Feb 2009 23:59:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] posix-cpu-timers: use ->sighand instead of
	->signal to check the task is alive
Message-ID: <20090205225944.GA10345@redhat.com>
References: <20090203231717.GA5028@redhat.com> <20090205033120.2294BFC381@magilla.sf.frob.com> <20090205155454.GD20953@redhat.com> <20090205204521.E1642FC381@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205204521.E1642FC381@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05, Roland McGrath wrote:
>
> > We can't use them as refcounts. You can't bump ->live or ->count without
> > breaking group_dead or exec logic. Perhaps we can use ->count, but then
> > we need other changes.
>
> We certainly need to clean up exec anyway.

Agreed.

> > The goal is to keep task->signal after release_task(), it will be freed
> > by __put_task_struct(). This allows a lot of simplifications and we can
> > move some fields from task_struct to signal_struct.
>
> That sounds fine to me in theory, but I still wonder what the story will be
> about the use of siglock.

I think we should change nothing with the usage of siglock for now?

> > But first we should change the code which does [...]
>
> I did understand the rationale given the signal_struct lifetime change.

Ah, sorry for noise then.

> > Even cpu_clock_sample_group() is not safe, unless we add other changes.
>
> Why?  It does no locking and only relies on the signal_struct lifetime.

Yes, I was wrong, thanks. I forgot we should always have a reference
to task_struct anyway.

Oleg.

