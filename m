Return-Path: <linux-kernel-owner+w=401wt.eu-S964959AbZKYWeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959AbZKYWeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964921AbZKYWeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:34:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964853AbZKYWef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:34:35 -0500
Date: Wed, 25 Nov 2009 23:28:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 0/14] utrace/ptrace
Message-ID: <20091125222854.GA2283@redhat.com>
References: <20091124200127.GA5751@redhat.com> <20091125214818.GA4916@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125214818.GA4916@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Christoph Hellwig wrote:
>
> On Tue, Nov 24, 2009 at 09:01:27PM +0100, Oleg Nesterov wrote:
> > Hello.
> >
> > This is the new iteration of Roland's utrace patch, this time
> > with "rewrite-ptrace-via-utrace" + cleanups in utrace core.
> >
> > 1-7 are already in -mm tree, I am sending them to simplify the
> > review.
> >
> > 8-12 don not change the behaviour, simple preparations.
> >
> > 13-14 add utrace-ptrace and utrace
>
> Skipped over it very, very briefly.  One thing I really hate about this
> is that it introduces two ptrace implementation by adding the new one
> without removing the old one.

Yes, we obviously need the old one when CONFIG_UTRACE is not enabled.

So, I'd like to try to restate: one thing we all really hate is that
CONFIG_UTRACE exists.

> Given that's it's pretty much too later
> for the 2.6.33 cycle anyway I'd suggest you make sure the remaining
> two major architectures (arm and mips) get converted, and if the
> remaining minor architectures don't manage to get their homework done
> they're left without ptrace.

Well, I can't comment this. I mean, I can't judge.

> The other thing is that this patchset really doesn't quite justify
> utrace.  It's growing a lot more code without actually growing any
> useful functionality.

This should be clarified. I don't think ptrace-utrace adds a lot more
code compared to the old ptrace. Note that we can kill a lot of old
code once CONFIG_UTRACE goes away. ptrace_signal(), ptrace_notify(),
even task_struct->almost_all_ptrace_related can go away.

kernel/utrace.c does add 12280 bytes (on my machine), yes.

> What about all those other utrace killer
> features that have been promised for a long time?

It is not clear how we can expect the new "killer" modules/applications
which use utrace before we merge it.

We already have some users, say, systemtap. But I don not know
what can be counted as a "really killer" application of utrace.

Oleg.

