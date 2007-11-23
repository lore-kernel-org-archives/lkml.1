Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbXKWK43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbXKWK43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 05:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXKWK4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 05:56:21 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:35590 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbXKWK4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 05:56:21 -0500
Date: Fri, 23 Nov 2007 13:54:57 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] ptrace_stop: fix the race with ptrace detach+attach
Message-ID: <20071123105457.GA93@tv-sign.ru>
References: <20071122161459.GA5973@tv-sign.ru> <20071123102351.GD6240@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071123102351.GD6240@localhost.sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23, Alexey Dobriyan wrote:
>
> On Thu, Nov 22, 2007 at 07:14:59PM +0300, Oleg Nesterov wrote:
> > If the tracer went away (may_ptrace_stop() failed), ptrace_stop() drops tasklist
> > and then changes the ->state from TASK_TRACED to TASK_RUNNING.
> > 
> > This can fool another tracer which attaches to us in between. Change the ->state
> > under tasklist_lock to ensure that ptrace_check_attach() can't wrongly succeed.
> 
> ptrace_check_attach? Both do read_lock -- can run in parallel,

Yep.

> so how can it help?

read_lock prevents ptrace_attach(), so the new tracer can't attach
and then do ptrace_check_attach().

Oleg.

