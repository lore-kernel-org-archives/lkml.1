Return-Path: <linux-kernel-owner+w=401wt.eu-S939306AbXGSQRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939306AbXGSQRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764907AbXGSQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:17:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56059 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763081AbXGSQRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:17:11 -0400
Date: Thu, 19 Jul 2007 18:16:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org,
       Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: [patch] sched: implement cpu_clock(cpu) high-speed time
	source, take #2
Message-ID: <20070719161643.GA5153@elte.hu>
References: <469F75AF.5080000@goop.org> <20070719143528.GA8278@elte.hu> <469F793E.6030006@goop.org> <20070719145058.GA11971@elte.hu> <469F7D7A.204@goop.org> <20070719150955.GA19373@elte.hu> <469F8179.2060802@goop.org> <20070719154254.GA24225@elte.hu> <20070719154449.GA28998@elte.hu> <469F8D28.1010304@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469F8D28.1010304@goop.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > how about the patch below instead? (which, unlike the first one, 
> > happens to build and boot ;-)
> 
> Yes, that should be fine if its just based on sched_clock.  Presumably 
> that means that any architecture (eg, s390) which chooses to implement 
> sched_clock as unstolen time will get good behaviour from softlockup 
> as well as the scheduler.

yeah, that's the idea.

> How does this interact with the sched_clock changes Andi just posted?

those changes pose no problem, and they are largely orthogonal. Andi's 
changes should improve the quality of sched_clock() on some boxes that 
encounter a cpu frequency transition that makes the TSC readout 
unreliable.

	Ingo
