Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbYG0UGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbYG0UGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 16:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757692AbYG0UF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 16:05:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682AbYG0UF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 16:05:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
In-Reply-To: Oleg Nesterov's message of  Sunday, 27 July 2008 16:15:40 +0400 <20080727121540.GB178@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
	<20080727121540.GB178@tv-sign.ru>
X-Windows: complex nonsolutions to simple nonproblems.
Message-Id: <20080727200551.D3F6A154284@magilla.localdomain>
Date: Sun, 27 Jul 2008 13:05:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Without CONFIG_SMP wait_task_inactive() is noop, this doesn't look right.
> Shouldn't we also take CONFIG_PREEMPT into account?

wait_task_inactive is only called when task->state is nonzero (i.e. not
TASK_RUNNING).  Preemption leaves a task in TASK_RUNNING, so a preempted
task shouldn't ever be passed to wait_task_inactive.  I dont see the problem.

> Also, the !SMP version of wait_task_inactive() always returns 1, this
> doesn't conform to the comment near kernel/sched.c:wait_task_inactive().

You mean the "(its total switch count)" part of the comment?
The normative part was only meant to be "a positive number".


Thanks,
Roland
