Return-Path: <linux-kernel-owner+w=401wt.eu-S933576AbXDFR0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933576AbXDFR0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbXDFR0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:26:45 -0400
Received: from mail.screens.ru ([213.234.233.54]:36532 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933576AbXDFR0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:26:44 -0400
Date: Fri, 6 Apr 2007 20:31:01 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406163100.GA554@tv-sign.ru>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Eric W. Biederman wrote:
>
> Thinking about it I do agree with Linus that two lists sounds like the
> right solution because it ensures we always have O(1) time when
> waiting for a zombie.

Well. I bet this will be painful, and will uglify the code even more.

do_wait() has to iterate over 2 lists, __ptrace_unlink() should check
->exit_state, etc...

>                        I'd like to place the list head for the zombie
> list in the signal_struct and not in the task_struct so our
> performance continues to be O(1) when we have a threaded process.

Sure. It would be nice to move ->children into signal_struct at first.
Except this change breaks (in fact fixes) ->pdeath_signal behaviour.

> The big benefit of the zombie list over your proposed list reordering
> is that waitpid can return immediately when we don't have zombies to
> wait for, but we have lots of children.

TASK_TRACED/TASK_STOPPED ?

Oleg.

