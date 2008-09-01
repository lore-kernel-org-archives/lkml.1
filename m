Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYIAPTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYIAPTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 11:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbYIAPTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 11:19:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:51186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYIAPTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 11:19:40 -0400
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce
	PRIO_THREAD extension
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <1220281737.8426.67.camel@twins>
References: <1220278355.3866.21.camel@localhost.localdomain>
	 <1220280138.3866.31.camel@localhost.localdomain>
	 <1220281737.8426.67.camel@twins>
Content-Type: text/plain
Date: Mon, 01 Sep 2008 17:19:35 +0200
Message-Id: <1220282375.8426.69.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-01 at 17:08 +0200, Peter Zijlstra wrote:
> On Mon, 2008-09-01 at 16:42 +0200, Denys Vlasenko wrote:
> > On Mon, 2008-09-01 at 16:12 +0200, Denys Vlasenko wrote:
> > > Patch is run tested. I will post test program etc as a reply.
> > 
> > Looks like Evolution word-wrapped the patch. Let me try again.
> 
> Patch looks simple enough, although a few comments below.
> Also, I guess the glibc people (Ulrich added to CC) might have an
> opinion.
> 
> > Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> > --

> > +		case PRIO_PROCESS:
> > +			if (who)
> > +				pid = find_vpid(who);
> > +			else {
> > +				pid = task_pid(current);
> > +				who = current->pid;
> > +			}
> > +			do_each_pid_thread(pid, PIDTYPE_PID, p) {
> > +				if (who == p->pid || who == p->tgid) {
> > +					error = set_one_prio(p, niceval, error);
> > +				}
> > +			} while_each_pid_thread(pid, PIDTYPE_PID, p);
> 
> I worry about destroying the return value here, support one thread
> fails, but the next succeeds, should we still report failure?

Ok - got fooled by this funny set_one_prio() function. It passes the old
error value and maintains it if no new error occurs (except for -ESRCH,
but I guess people know wth they're doing).

So I'll retract my concern.

