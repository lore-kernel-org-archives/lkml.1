Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbYF0Uwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbYF0Uwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762285AbYF0Uuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:50:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762004AbYF0Uut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:50:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sched: fix TASK_WAKEKILL vs SIGKILL race
In-Reply-To: Oleg Nesterov's message of  Sunday, 8 June 2008 21:20:41 +0400 <20080608172041.GA10383@tv-sign.ru>
References: <20080608172041.GA10383@tv-sign.ru>
Emacs: impress your (remaining) friends and neighbors.
Message-Id: <20080627204954.4CC04154226@magilla.localdomain>
Date: Mon,  9 Jun 2008 14:10:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was also concerned about perturbing the schedule() hot path with the
original patch.  With this version making signal_pending_state() inline,
I think it's good.

> Note this "__TASK_STOPPED | __TASK_TRACED" check in signal_pending_state().
> This is needed to preserve the current behaviour (ptrace_notify). I hope
> this check will be removed soon, but this (afaics good) change needs the
> separate discussion.

Agreed.  I think it might actually already be safe to drop it, but we can
get to that after this settles.


Thanks,
Roland
