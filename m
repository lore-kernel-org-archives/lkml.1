Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbYHAVbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbYHAVbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762118AbYHAVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:31:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761945AbYHAVbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:31:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Mark McLoughlin <markmc@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: posix_timer_event: can't we kill the "switch to ->group_leader on failure" ?
In-Reply-To: Oleg Nesterov's message of  Friday, 1 August 2008 20:06:11 +0400 <20080801160611.GA2123@tv-sign.ru>
References: <20080801160611.GA2123@tv-sign.ru>
Emacs: Lovecraft was an optimist.
Message-Id: <20080801213102.71D85154252@magilla.localdomain>
Date: Fri,  1 Aug 2008 14:31:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> posix_timer_event() drops SIGEV_THREAD_ID and switches to ->group_leader
> if send_sigqueue() fails.
> 
> Is this really useful? I don't understand the point.

I don't think it's useful.  SIGEV_THREAD_ID is used not really used by
applications directly at all.  It's used by glibc internally to implement
the POSIX feature SIGEV_THREAD.  The target thread is a private service
thread that glibc maintains.  It should never die while there are timers
using it.  If it does, there are no expectations about the abandoned timers
firing usefully at all.

> But more importantly, I think this code gives the false promises, it
> doesn't work reliably.

Userland never relied on any such promise.  All that really needs to be
reliable is that the kernel doesn't keep a dangling pointer or task ref.

> If we can do the above, we can simplify the code further, see the patch
> below (should be 2 patches).

Probably fine, needs a little closer thought.


Thanks,
Roland
