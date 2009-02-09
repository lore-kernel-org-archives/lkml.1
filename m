Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZBIAyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZBIAyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZBIAyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:54:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbZBIAyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:54:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] ptrace: detach wakeup fixes
In-Reply-To: Oleg Nesterov's message of  Sunday, 8 February 2009 19:47:20 +0100 <20090208184720.GA27070@redhat.com>
References: <20090208184720.GA27070@redhat.com>
X-Shopping-List: (1) Indifferent confusion tables
   (2) Grandiloquent vapor
   (3) Simultaneous tape winches
   (4) Felicitous cotillions
Message-Id: <20090209005405.888BFFC317@magilla.sf.frob.com>
Date: Sun,  8 Feb 2009 16:54:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Q: when the tracer exits we bypass ptrace_disable() and
> clear_tsk_thread_flag(TIF_SYSCALL_TRACE), is this correct?

It's always been that way.  It's obviously wrong in an abstract sense.  But
for me, ptrace today is purely about compatibility with how it's behaved in
the past, however stupid that was--whenever it's been fully consistent and
predictable, userland is already saddled with coping with the stupidity.

> Perhaps we should move this code into __ptrace_unlink?

Locking nightmare.  ptrace_disable can do stuff that may require the thread
to be stopped like other ptrace operations require (fiddle registers),
might include access_process_vm, etc.  Trust me, we don't want to go there
now.  (In case you were looking for reasons why I'll be soon advocating
reorganization to get ptrace entirely out of the tasklist_lock arena, this
is a fine example of the true horror that the current data structure set-up
gives us.)


Thanks,
Roland
