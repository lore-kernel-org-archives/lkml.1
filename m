Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbYIBNDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbYIBNDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYIBND2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:03:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:51290 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbYIBND2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:03:28 -0400
Date: Tue, 2 Sep 2008 06:03:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task
 struct
Message-ID: <20080902060323.70245b83@infradead.org>
In-Reply-To: <20080902100439.GA11383@elf.ucw.cz>
References: <20080901160343.75a89ec9@infradead.org>
	<20080901161423.59ebf2fc@infradead.org>
	<20080902100439.GA11383@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008 12:04:39 +0200
Pavel Machek <pavel@suse.cz> wrote:

> Hi!
> 
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Subject: [PATCH] hrtimer: create a "timer_slack" field in the task
> > struct
> > 
> > We want to be able to control the default "rounding" that is used by
> > select() and poll() and friends. This is a per process property
> > (so that we can have a "nice" like program to start certain
> > programs with a looser or stricter rounding) that can be set/get
> > via a prctl().
> > 
> > For this purpose, a field called "timer_slack_ns" is added to the
> > task struct. In addition, a field called "default_timer_slack"ns"
> > is added so that tasks easily can temporarily to a more/less
> > accurate slack and then back to the default.
> 
> Is this a good idea? IMO it should be per-syscall, not per
> application.

Yes it would be nice to have new syscalls for this
and no, nobody and nothing would use them.

THe really big advantag of this default-from-task-struct is that you
can have a program similar to "nice" that allows you to run an existing
program at a specified granularity (say, a version of acroread that has
a really high wakeup count but you still want to save power)

> Threads would certainly like private values...

of course these are per thread.. they're in the task struct after all 

> and this makes really ugly interface.

prctl() is ugly?

> 
> ...plus it bloats task struct.
> 
> ...where did the sys_indirect proposals go? We created new syscalls,
> right?

... which nobody uses today.
It's not just new syscalls, it's a new glibc api as well at that point.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
