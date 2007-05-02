Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbXEBEbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbXEBEbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 00:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbXEBEbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 00:31:38 -0400
Received: from thunk.org ([69.25.196.29]:54486 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbXEBEbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 00:31:25 -0400
Date: Wed, 2 May 2007 00:31:00 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Bill Irwin <bill.irwin@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       wli@holomorphy.com
Subject: Re: per-thread rusage
Message-ID: <20070502043100.GI26093@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ulrich Drepper <drepper@gmail.com>,
	Bill Irwin <bill.irwin@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
	wli@holomorphy.com
References: <20070404194829.1a93d8fd.dada1@cosmosbay.com> <20070404181050.GN2986@holomorphy.com> <20070409165315.4704021f.akpm@linux-foundation.org> <20070410004201.GA2986@holomorphy.com> <20070501172937.GQ26598@holomorphy.com> <a36005b50705011139p361dbc46ube0da5e42955f8b0@mail.gmail.com> <20070501202456.GR26598@holomorphy.com> <a36005b50705011510k4cd7873dr3fb8206c0f107169@mail.gmail.com> <20070501222724.GG26093@thunk.org> <a36005b50705011717g28023c58m431ec28413c1b613@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50705011717g28023c58m431ec28413c1b613@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 05:17:28PM -0700, Ulrich Drepper wrote:
> We have, in principal: setrlimit.  We jump through hoops in the moment
> to make RLIMIT_CPU a per-process facility.  This is all nice.  All you
> need to do is to add resources RLIMIT_*_THREAD (e.g.,
> RLIMIT_CPU_THREAD) and additionally do accounting in a per-thread
> basis.

Indeed; in fact it would be easier to do per-thread accounting than
our current per-process accounting, as you note.

> The thread library can also not simply hijack the SIGXCPU signal,
> the application want to use it.... So what would be additionally
> needed is a method to specify what signal to sent.  The default
> might just as well be SIGXCPU but this must be changable.


The question is should we use setrlimit() to set the per-thread CPU
limit, given that we would need some separate interface to set signal
that should be sent.  

Is there any reason why we should have the interface specify whether
the signal should be directed to a specified process or kernel
thread-id, perhaps using si_pid field in the siginfo_t to specify
which thread had exceeded its CPU limit.  Or would this be overkill?

> The thread cancellation must appear like any other cancellation,
> perhaps with a special status value (PTHREAD_CANCELED_XCPU instead of
> PTHREAD_CANCEL).  But that's a userlevel detail.

Yep, I agree that thread cancellation is the right thing to happen at
the Posix Threads level.

Do you think this is something that we could get standardized into an
upcoming Posix/Posix Threads standard?  

						- Ted
