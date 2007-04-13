Return-Path: <linux-kernel-owner+w=401wt.eu-S1030266AbXDMU4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266AbXDMU4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 16:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965626AbXDMU4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 16:56:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965632AbXDMU4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 16:56:03 -0400
Date: Fri, 13 Apr 2007 22:55:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070413205545.GA18032@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070413202745.GA17993@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413202745.GA17993@gnuppy.monkey.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Bill Huey <billh@gnuppy.monkey.org> wrote:

> Con has been asking for module support for years if I understand your 
> patch corectly. [...]

Yeah. Note that there are some subtle but crutial differences between 
PlugSched (which Con used, and which i opposed in the past) and this 
approach.

PlugSched cuts the interfaces at a high level in a monolithic way and 
introduces kernel/scheduler.c that uses one pluggable scheduler 
(represented via the 'scheduler' global template) at a time.

while in this CFS patchset i'm using modularization ('scheduler 
classes') to simplify the _existing_ multi-policy implementation of the 
scheduler. These 'scheduler classes' are in a hierarchy and are stacked 
on top of each other. They are in use at once. Currently there's two of 
them: sched_ops_rt is stacked ontop of sched_ops_fair. Fortunately the 
performance impact is minimal.

So scheduler classes are mainly a simplification of the design of the 
scheduler - not just a mere facility to select multiple schedulers. 
Their ability to also facilitate easier experimentation with schedulers 
is 'just' a happy side-effect. So all in one: it's a fairly different 
model from PlugSched (and that's why i didnt reuse PlugSched) - but 
there's indeed overlap.

> [...] You'll also need this for -rt as well with regards to bandwidth 
> scheduling.

yeah.

scheduler classes are also useful for other purposes like containers and 
virtualization, hierarchical/group scheduling, security encapsulation, 
etc. - features that can be on-demand layered, and which we dont 
necessarily want to have enabled all the time.

> [...] Good to see that you're moving in this direction.

thanks! :)

	Ingo
