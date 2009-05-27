Return-Path: <linux-kernel-owner+w=401wt.eu-S1761762AbZE0XWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761762AbZE0XWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 19:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZE0XWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 19:22:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbZE0XWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 19:22:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: ptrace && task->exit_code
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 01:05:23 +0200 <20090527230523.GA10032@redhat.com>
References: <20090525000016.GA2239@redhat.com>
	<20090525215903.GA9113@redhat.com>
	<20090527021131.4778BFC36B@magilla.sf.frob.com>
	<20090527224140.GC6770@redhat.com>
	<20090527230523.GA10032@redhat.com>
X-Windows: putting new limits on productivity.
Message-Id: <20090527232141.8B24DFC2BD@magilla.sf.frob.com>
Date: Wed, 27 May 2009 16:21:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I didn't realize this until yesterday, but perhaps it makes sense
> to decouple ptrace && task_struct->exit_code?

I've long thought this was an attractive idea.  But it seems to have lots
of complications at least as long as ptrace-wait shares so much code with
normal wait.  I'd figured this might be one of the last things we clean up
after ptrace is disentangled from core data structures in most every other
way.

> This is not completely trivial, needs another short series.

I suspect it is more hassle than benefit to do this now.
I don't think it is the right priority.

> And. I spent a lot of time, but I can't see how to solve the problems
> with TASK_STOPPED tasks if we do this change.

I bet the complications of this all will be substantially different after
we change the ptrace locking.  So let's not worry about it yet.


Thanks,
Roland
