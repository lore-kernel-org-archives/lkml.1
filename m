Return-Path: <linux-kernel-owner+w=401wt.eu-S1759090AbZFAUvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090AbZFAUvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZFAUvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:51:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755917AbZFAUvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:51:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH? tracehook_report_clone: fix false positives
In-Reply-To: Oleg Nesterov's message of  Monday, 1 June 2009 22:07:23 +0200 <20090601200723.GA22204@redhat.com>
References: <20090528113601.GA18725@redhat.com>
	<20090528114100.GA18744@redhat.com>
	<20090528212418.2F605FC2BD@magilla.sf.frob.com>
	<20090529122411.GC19812@redhat.com>
	<20090530185212.GA10677@redhat.com>
	<20090601002226.480CEFC3C7@magilla.sf.frob.com>
	<20090601200723.GA22204@redhat.com>
X-Windows: there's got to be a better way.
Message-Id: <20090601205056.16307FC3C7@magilla.sf.frob.com>
Date: Mon,  1 Jun 2009 13:50:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, I never thought about attach && SIGCONT interaction...
> 
> But, tracehook_report_clone() has the same problems?

I don't follow.

> And if we move sigaddset to ptrace_task_init(), we should not worry about
> SIGCONT? Without CLONE_THREAD the new task is not visible to user-space yet.
> Even if we clone a sub-thread, ptrace_init_task() runs under ->siglock.
> If SIGCONT is already pending, copy_process() won't succeed.

It could be pending and blocked.

> Or do you mean something else?

Sorry, I don't think I understood what your question was.
I just pointed out that the element of PTRACE_ATTACH semantics
that would be changed unintentionally if you just replaced its
send_sig_info() call with ptrace_init_task() using sigaddset().


Thanks,
Roland
