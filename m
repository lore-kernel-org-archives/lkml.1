Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbXLIAe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbXLIAe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbXLIAeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:34:20 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45641 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXLIAeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:34:20 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ptrace_stop: remove the wrong ->group_stop_count bookkeeping
References: <20071208183801.GA9943@tv-sign.ru>
Date: Sat, 08 Dec 2007 17:31:51 -0700
In-Reply-To: <20071208183801.GA9943@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 8 Dec 2007 21:38:01 +0300")
Message-ID: <m1wsroogi0.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> ptrace_stop() decrements ->group_stop_count to "participate" in group stop.
> This looks very wrong to me, the task can in fact decrement this counter twice.
> If the tracee returns to the user-space before other threads complete the group
> stop, it will notice TIF_SIGPENDING and do it again.

This is one of those interesting weird cases.  The ptrace interface remains per
task.

So need to handle a simultaneous thread group stop and a per task stop.


>
> Another problem is that we don't set SIGNAL_STOP_STOPPED if the counter becomes
> zero.
>
> I must admit, I don't undestand the reason why this code was added, it is very
> old.

I haven't dug in enough yet to understand better, but it is my hunch we
need to do something when we have both kinds of stop happening simultaneously.

Eric
