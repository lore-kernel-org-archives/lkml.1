Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbZKLU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbZKLU5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbZKLU5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:57:30 -0500
Received: from www.tglx.de ([62.245.132.106]:44709 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584AbZKLU53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:57:29 -0500
Date: Thu, 12 Nov 2009 21:55:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
 resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related
 to preempt_count leakage in keventd)
In-Reply-To: <200911122153.12419.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0911122153320.24119@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl> <20091111171703.GA28506@redhat.com> <alpine.LFD.2.00.0911121821370.24119@localhost.localdomain> <200911122153.12419.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Rafael J. Wysocki wrote:

> On Thursday 12 November 2009, Thomas Gleixner wrote:
> > On Wed, 11 Nov 2009, Oleg Nesterov wrote:
> > > Well, yes. Because any buggy user can easily kill the system, and we
> > > constantly have the bugs like this one.
> > > 
> > > I think we should teach workqueue.c to use debugobjects.c at least.
> > 
> > Here you go. Would be interesting to know whether it catches the
> > problem at hand.
> 
> How would I tell if it did?

Apply the patch, enable debugobjects and try to reproduce the failure
- w/o the fix patch of course :)

debugobjects should catch the attempt to free the memory which holds
the work_struct, cancel it and print a backtrace where this happened.

Thanks,

	tglx
