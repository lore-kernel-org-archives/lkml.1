Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbXDFR1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbXDFR1q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933602AbXDFR1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:27:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38597 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933606AbXDFR1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:27:45 -0400
Date: Fri, 6 Apr 2007 19:27:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406172720.GA1147@elte.hu>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I'd almost prefer to just not add kernel threads to any parent process 
> list *at*all*.

i think part of the problem is the legacy that the list is artificially 
unified: tasks that 'will possibly exit' are on the same list as tasks 
that 'have already exited'. If we split it up into its natural data 
structure, having a list of tasks that are there and do not intend to 
exit, plus a separate list of tasks that are exiting and want to notify 
their parent, all this scanning goes away. I can see no real reason for 
this other than legacy - i dont think the semantics of the wait4() API 
force us to scan all those threads.

putting the freshly reaped tasks at the 'head' of the list is just a 
fancy (and incomplete) way of splitting the list up into two lists, and 
i'd advocate a clean split. Just like have have split the ptrace_list 
away from the main list too.

	Ingo
