Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXDKSYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXDKSYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbXDKSYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:24:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42014 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbXDKSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:24:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Don't depend on work queues
References: <20070410185133.GA104@tv-sign.ru>
	<m13b37v517.fsf@ebiederm.dsl.xmission.com>
	<20070411000316.52f2551e.akpm@linux-foundation.org>
Date: Wed, 11 Apr 2007 12:22:40 -0600
In-Reply-To: <20070411000316.52f2551e.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 11 Apr 2007 00:03:16 -0700")
Message-ID: <m1lkgysrdb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> argh.  Your description freely confuddles the terms "kernel thread" and
> "kthread".  Can we not do that?  Henceforth the term "kernel thread" refers
> to something which was started with kernel_thread() and "kthread" refers to
> something which was created by kthread_create(), OK?

Yes.  Will fix.

> Your patch gets midly tangled up with Oleg's recent
>
> reduce-reparent_to_init.patch
> make-kernel-threads-invisible-to-sbin-init.patch
> reparent-kernel-threads-to-swapper.patch
>
> but they seemed fairly unpopular anyway so I'll drop 'em.

Ok.  I kind of liked the first one but that is a minor cleanup.

> Your wait_event() will contribute to load average, I expect.  We get mail. 
> I converted it to wait_event_interruptible().

Ok.  That is more polite.

> I guess using PF_NOFREEZE rather than try_to_freeze() is OK, but one
> wonders what thinking led to that?

That is what we are currently doing for the work queues, and I was lazy.
For people who care they can fix it.

> Often when we have a singleton thread like this it is neater to use
> wake_up_process() directly on it, rather than creating a rather pointless
> waitqueue_head for it.  I started looking into that but it would have taken
> more than 30 seconds.

Sure I took a look and it isn't too hard.  Updated patch in a minute...

I have left the locking the way it is despite the reasonable chance that
Oleg points I can only acquire the lock when deleting the list entry.
I'm to lazy to think through the SMP races to make certain that is safe.

Eric




