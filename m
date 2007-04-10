Return-Path: <linux-kernel-owner+w=401wt.eu-S1030684AbXDJOeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030684AbXDJOeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030725AbXDJOeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:34:03 -0400
Received: from mail.screens.ru ([213.234.233.54]:57015 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030684AbXDJOeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:34:01 -0400
Date: Tue, 10 Apr 2007 17:38:08 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410133808.GA163@tv-sign.ru>
References: <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070410134814.GA28016@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410134814.GA28016@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Ingo Molnar wrote:
> 
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > > no. Two _completely separate_ lists.
> > >
> > > i.e. a to-be-reaped task will still be on the main list _too_. The 
> > > main list is for all the PID semantics rules. The reap-list is just 
> > > for wait4() processing. The two would be completely separate.
> > 
> > And what pray tell except for heuristics is the list of children used 
> > for?
> 
> on a second thought: the p->children list is needed for the whole 
> child/parent task tree, which is needed for sys_getppid(). The question 
> is, does anything require us to reparent to within the same thread 
> group?

No! That is why I suggest (a long ago, in fact) to move ->children into
->signal_struct. When sub-thread forks, we set ->parent = group_leader.
We don't need forget_original_parent() until the last thead exists. This
also simplify do_wait().

However, this breaks the current ->pdeath_signal behaviour. In fact (and
Eric thinks the same) this _fixes_ this behaviour, but may break things.

Oleg.

