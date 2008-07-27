Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYG0MMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYG0MMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 08:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYG0MME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 08:12:04 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:44428 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYG0MMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 08:12:03 -0400
Date: Sun, 27 Jul 2008 16:15:40 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, roland@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Q: wait_task_inactive() and !CONFIG_SMP && CONFIG_PREEMPT
Message-ID: <20080727121540.GB178@tv-sign.ru>
References: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807260245.m6Q2jwB4012297@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without CONFIG_SMP wait_task_inactive() is noop, this doesn't look right.
Shouldn't we also take CONFIG_PREEMPT into account?

Not that it really matters, just curious. kthread_bind() itself could be
noop without CONFIG_SMP. ptrace_check_attach() shouldn't have real problems,
but still.


Also, the !SMP version of wait_task_inactive() always returns 1, this
doesn't conform to the comment near kernel/sched.c:wait_task_inactive().

Oleg.

