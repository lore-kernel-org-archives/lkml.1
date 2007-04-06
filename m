Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbXDFUVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbXDFUVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXDFUVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:21:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbXDFUVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:21:34 -0400
Date: Fri, 6 Apr 2007 22:21:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406202118.GA28466@elte.hu>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com> <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com> <20070406154750.GA541@tv-sign.ru> <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org> <20070406193621.GA96@tv-sign.ru> <20070406194329.GB21322@elte.hu> <20070406200116.GA169@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406200116.GA169@tv-sign.ru>
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

> Probably it is I who missed something :)
> 
> But why can't we do both changes? I think it is just ugly to use init 
> to reap the kernel thread. Ok, wait4() can find zombie quickly if we 
> do the ->children split. But /sbin/init could be swapped out, we still 
> need to deliver SIGCHLD, etc.
> 
> And I personally agree with Linus, it is nice to hide the kernel 
> threads from /sbin/init (or whatever) completely.

yeah, they should all be made auto-reap - nobody is really interested in 
their wait4()-driven completion. (any completion they do is via other 
mechanisms)

	Ingo
