Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbXJKKo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbXJKKo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXJKKov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:44:51 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40620 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbXJKKov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:44:51 -0400
Date: Thu, 11 Oct 2007 14:49:42 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] core dump: remain dumpable
Message-ID: <20071011104942.GA144@tv-sign.ru>
References: <20071011062730.19F774D026B@magilla.localdomain> <20071011102507.GA101@tv-sign.ru> <20071011103446.89BCC4D03F7@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011103446.89BCC4D03F7@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11, Roland McGrath wrote:
>
> > Hmm. Actually, do we need any check? If another thread (or CLONE_VM task)
> > already started do_coredump(), we must see SIGNAL_GROUP_EXIT when we take
> > ->mmap_sem. In that case coredump_wait() does nothing but returns -EAGAIN.
> 
> You're right again here.  I'm sure the old use predates this checking in
> zap_threads, so it's understandable that something different was needed for
> this synchronization before.

Ugh, sorry, I was wrong. coredump_wait() initializes mm->core_done and sets
mm->core_startup_done before checking SIGNAL_GROUP_EXIT. This means we have
to check ->core_waiters or SIGNAL_GROUP_EXIT before calling coredump_wait().

Oleg.

