Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbXLDVAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbXLDVAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXLDVAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:00:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39520 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbXLDVAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:00:35 -0500
Date: Tue, 4 Dec 2007 22:00:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jarek Poplawski <jarkao2@gmail.com>, Jarek Poplawski <jarkao2@o2.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Need lockdep help
Message-ID: <20071204210006.GE32018@elte.hu>
References: <4754907E.9060203@gmail.com> <Pine.LNX.4.44L0.0712041000540.4321-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0712041000540.4321-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> > I'm not sure I can understand your plan, but I doubt there should be 
> > such problems with taking rwsem for sleeping, so maybe it would be 
> > better to figure out what really scares lockdep, to fix the right 
> > place?
> 
> The real problem is that lockdep has to make some generalizations.  It 
> can't be aware of the details of every possible situation, and it 
> doesn't have a global view of the entire kernel, so it doesn't know 
> when special circumstances make deadlock impossible.
> 
> Furthermore, in this case deadlock isn't really impossible -- it could 
> occur if there were a bug somewhere else in the kernel.  So lockdep 
> was correct to warn that deadlock might occur.

ok. Thanks for resolving this by working it around - i _think_ in the 
long run we'd like to make all locking "simpler" - not just for the sake 
of lockdep, but also for the sake of human reviewability. So in that 
sense, even though in this particular case you are fully right that 
lockdep was wrong, we benefit long-term.

	Ingo
