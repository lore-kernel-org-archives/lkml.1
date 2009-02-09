Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZBIBqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZBIBqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 20:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbZBIBqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 20:46:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42252 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbZBIBqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 20:46:22 -0500
Date: Mon, 9 Feb 2009 02:43:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] ptrace: detach wakeup fixes
Message-ID: <20090209014355.GA27609@redhat.com>
References: <20090208184720.GA27070@redhat.com> <20090209005405.888BFFC317@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209005405.888BFFC317@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Roland McGrath wrote:
>
> > Q: when the tracer exits we bypass ptrace_disable() and
> > clear_tsk_thread_flag(TIF_SYSCALL_TRACE), is this correct?
>
> It's always been that way.  It's obviously wrong in an abstract sense.  But
> for me, ptrace today is purely about compatibility with how it's behaved in
> the past, however stupid that was--whenever it's been fully consistent and
> predictable, userland is already saddled with coping with the stupidity.
>
> > Perhaps we should move this code into __ptrace_unlink?
>
> Locking nightmare.  ptrace_disable can do stuff that may require the thread
> to be stopped like other ptrace operations require (fiddle registers),
> might include access_process_vm, etc.  Trust me, we don't want to go there
> now.

OK, thanks.

> (In case you were looking for reasons why I'll be soon advocating
> reorganization to get ptrace entirely out of the tasklist_lock arena, this
> is a fine example of the true horror that the current data structure set-up
> gives us.)

Heh. No, I don't need yet another reason to remove tasklist from ptrace ;)
This would be obviously great.

(btw, I do remember I promised the cleanup, will send a bit later).

Oleg.

