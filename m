Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZFAVjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZFAVjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbZFAVjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:39:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34209 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZFAVjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:39:17 -0400
Date: Mon, 1 Jun 2009 23:34:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH? tracehook_report_clone: fix false positives
Message-ID: <20090601213443.GA26291@redhat.com>
References: <20090528113601.GA18725@redhat.com> <20090528114100.GA18744@redhat.com> <20090528212418.2F605FC2BD@magilla.sf.frob.com> <20090529122411.GC19812@redhat.com> <20090530185212.GA10677@redhat.com> <20090601002226.480CEFC3C7@magilla.sf.frob.com> <20090601200723.GA22204@redhat.com> <20090601205056.16307FC3C7@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601205056.16307FC3C7@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Roland McGrath wrote:
>
> > Oh, I never thought about attach && SIGCONT interaction...
> >
> > But, tracehook_report_clone() has the same problems?
>
> I don't follow.
>
> > And if we move sigaddset to ptrace_task_init(), we should not worry about
> > SIGCONT? Without CLONE_THREAD the new task is not visible to user-space yet.
> > Even if we clone a sub-thread, ptrace_init_task() runs under ->siglock.
> > If SIGCONT is already pending, copy_process() won't succeed.
>
> It could be pending and blocked.

Yes, I missed that, thanks.

> > Or do you mean something else?
>
> Sorry, I don't think I understood what your question was.
> I just pointed out that the element of PTRACE_ATTACH semantics
> that would be changed unintentionally if you just replaced its
> send_sig_info() call with ptrace_init_task() using sigaddset().

I suspect you misread my previous question.

I didn't mean PTRACE_ATTACH should use ptrace_init_task). I just meant that
perhaps it makes sense to move sigaddset() from tracehook_finish_clone()
to tracehook_finish_clone()->ptrace_init_task().

As you correctly pointed out, this sigaddset() is not the same as
send_sig_info(), but the same is true for tracehook_finish_clone() too.

Oleg.

