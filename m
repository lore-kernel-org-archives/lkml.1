Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXDFJoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXDFJoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 05:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXDFJoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 05:44:25 -0400
Received: from mail.screens.ru ([213.234.233.54]:47930 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbXDFJoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 05:44:24 -0400
Date: Fri, 6 Apr 2007 13:44:13 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, Chris Snook <csnook@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406094413.GA673@tv-sign.ru>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > Robin Holt wrote:
> >>
> >> wait_task_zombie() is taking many seconds to get through the list.
> >> For the case of a modprobe, stop_machine creates one thread per cpu
> >> (remember big number). All are parented to init and their exit will
> >> cause wait_task_zombie to scan multiple times most of the way through
> >> this very long list looking for threads which need to be reaped.
> >
> > Could you try this patch
> >
> > 	http://marc.info/?l=linux-kernel&m=117337194209912
> >
> > ?
> >
> > It can't solve the whole problem, but at least an exiting kernel thread
> > won't kick init.
> 
> At first glance your patch looks reasonable.
> 
> Unfortunately it only applies to the rare thread that calls daemonize,
> and not also to kernel/kthread/kthread() which means it will miss many of
> our current kernel threads.

Note that a thread created by kthread_create() has ->parent == "[kthread]",
not /sbin/init (unless it was created before core_initcall). So I don't really
understand how stop_machine() creates the threads parented to init.

> For the sgi problem I doubt it is will make a difference

most probably you are right.

Oleg.

