Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbYKQVuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbYKQVuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYKQVuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:50:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbYKQVuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:50:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Frank Mayhar <fmayhar@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
In-Reply-To: Oleg Nesterov's message of  Monday, 17 November 2008 23:18:57 +0100 <20081117221857.GA29423@redhat.com>
References: <1226053744.7803.5851.camel@twins>
	<1226081448.28191.64.camel@bobble.smo.corp.google.com>
	<1226089574.31966.85.camel@lappy.programming.kicks-ass.net>
	<Pine.LNX.4.64.0811100834500.21257@quilx.com>
	<1226328152.7685.192.camel@twins>
	<1226340009.19109.17.camel@bobble.smo.corp.google.com>
	<20081114024239.07CC91541E8@magilla.localdomain>
	<20081114164155.GA7738@redhat.com>
	<20081117143623.GA4658@redhat.com>
	<20081117181655.8BDE9154221@magilla.localdomain>
	<20081117221857.GA29423@redhat.com>
X-Windows: foiled again.
Message-Id: <20081117214946.8F601154240@magilla.localdomain>
Date: Mon, 17 Nov 2008 13:49:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But please note that currently this already happens for sub-threads (and
> if we protect ->signal with rcu too), the exiting sub-thread does not
> contribute to accounting after release_task(self). Also, when the last
> thread exits the process can be reaped by its parent, but after that
> the threads can still use CPU.

Understood (I think I mentioned this earlier).  All this is what makes it
seem potentially attractive in the long run to reorganize this more thoroughly.

> > Yes, I think you're right.  The best solution that comes to mind off hand
> > is to protect the update/read of that u64 with a seqcount_t on 32-bit.
> 
> Oh, but we need them to be per-cpu, and both read and write need memory
> barriers... Not that I argue, this will fix the problem of course, just
> I don't know how this impacts the perfomance.

I agree it's a sticky question.  Just the only thing I've thought of so far.


Thanks,
Roland
