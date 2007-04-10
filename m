Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXDJI7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXDJI7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 04:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966123AbXDJI7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 04:59:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51847 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXDJI7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 04:59:15 -0400
Date: Tue, 10 Apr 2007 10:59:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070410085901.GA13662@elte.hu>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <4616CBF0.7090606@garzik.org> <20070409172339.48d661d6.akpm@linux-foundation.org> <20070410015912.GE1994@redhat.com> <20070409193056.6b52c354.akpm@linux-foundation.org> <20070410074422.GA30507@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410074422.GA30507@flint.arm.linux.org.uk>
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


* Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> One per PC card socket to avoid the sysfs locking crappyness that 
> would otherwise deadlock, and to convert from the old unreadable state 
> machine implementation to a much more readable linearly coded 
> implementation.
> 
> Could probably be eliminated if we had some mechanism to spawn a 
> helper thread to do some task as required which didn't block other 
> helper threads until it completes.

looks like the perfect usecase for threadlets. (threadlets only use up a 
separate context if necessary and can be coded in the familiar 
sequential/linear model)

(btw., threadlets could in theory be executed in irq context too, and if 
we block on anything it gets bounced off to a real context - although 
this certainly pushes the limits and there would still be some deadlock 
potential for things like irq-unsafe non-sleeping locks (spinlocks, 
rwlocks).)

	Ingo
