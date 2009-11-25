Return-Path: <linux-kernel-owner+w=401wt.eu-S934248AbZKYIqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbZKYIqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933533AbZKYIqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:46:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41541 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758224AbZKYIqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:46:14 -0500
Date: Wed, 25 Nov 2009 09:46:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091125084617.GD29096@one.firstfloor.org>
References: <20091124200220.GA5828@redhat.com> <87my2bwtno.fsf@basil.nowhere.org> <20091124204152.GA9131@redhat.com> <20091124212619.GB29096@one.firstfloor.org> <20091124214450.GA12828@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124214450.GA12828@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is subjective, but personally I disagree. Contrary, imho it
> is good that tracehook hides the (simple) details. I do not understand
> why the reader of, say, do_fork() should see the contents of
> tracehook_report_clone_complete(). This will complicate the understanding.

Someone who has to debug or review fork needs to know what's going on.

Yes they can find out by going through inlines, but that
just costs more time and distracts from the actual problem.

> Those people who want to understand/change fork() do not care about
> utrace/ptrace usually.
> 
> And please note that it is much, much easier to change this code
> when it lives in tracehooks.h instead of sched.c/signal.c/etc.

The problem is that when you have to trace this code when something
goes wrong the extra layer just holds you up. For debugging usually
abstraction is a bad idea.

My experience is also that in general such extra "abstraction layers"
are frowned upon in Linux kernel code style. For example when new
vendor drivers are submitted for hardware like NICs etc,
they frequently tend to have all kinds of "abstraction layers".
Typically the first step to linuxify them is to get rid of those. 

This makes the code more readable, shorter, better to debug and read.

Another classic example is: lock_foo() is frowned upon (Linus
tends to always complain about that), rather prefer spin_lock(&foo_lock)
or mutex_lock(&foo_lock) that makes it clear what's going on.

I don't see why this should be any different for utrace.

> > Less code obfuscation.
> >
> > When it's a utrace call, call it a utrace call, not something else.
> 
> Why do you think this is obfuscation? Well, we can rename these
> helpers, s/tracehook_/utrace_/, but I don't see how this can make
> the code more readable.

Because the inlines do not add anything to functionality and actually
hide what the code does, that is obfuscation. For you it might be obvious
because you've been hacking that code for quite some time, but for 
someone who is not in your position that's different.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
