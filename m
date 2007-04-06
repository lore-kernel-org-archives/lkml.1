Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbXDFRdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbXDFRdF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbXDFRdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:33:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34700 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbXDFRdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:33:04 -0400
Date: Fri, 6 Apr 2007 19:32:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406173249.GA2517@elte.hu>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406163100.GA554@tv-sign.ru>
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


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > Thinking about it I do agree with Linus that two lists sounds like 
> > the right solution because it ensures we always have O(1) time when 
> > waiting for a zombie.
> 
> Well. I bet this will be painful, and will uglify the code even more.
> 
> do_wait() has to iterate over 2 lists, __ptrace_unlink() should check 
> ->exit_state, etc...

no. Two _completely separate_ lists.

i.e. a to-be-reaped task will still be on the main list _too_. The main 
list is for all the PID semantics rules. The reap-list is just for 
wait4() processing. The two would be completely separate.

	Ingo
