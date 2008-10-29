Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbYJ2QnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbYJ2QnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753998AbYJ2QnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:43:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40204 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbYJ2QnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:43:10 -0400
Date: Wed, 29 Oct 2008 17:42:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, torvalds@osdl.org,
       viro@zeniv.linux.org.uk, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] headers: move release_kernel_lock(),
	reacquire_kernel_lock() to sched.c
Message-ID: <20081029164255.GA17213@elte.hu>
References: <20081029044351.GA2304@x200.localdomain> <20081029044447.GB2304@x200.localdomain> <20081029061827.GA7936@elte.hu> <20081029100437.GA30492@infradead.org> <20081029131402.GA2642@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029131402.GA2642@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Oct 29, 2008 at 06:04:37AM -0400, Christoph Hellwig wrote:
> > On Wed, Oct 29, 2008 at 07:18:27AM +0100, Ingo Molnar wrote:
> > > please dont move #ifdefs and interfaces into a .c file - if then move 
> > > it into another header file.
> > 
> > Sorry, but that makes no sense at all.  This stuff is implementation
> > private to sched.c, and adding some header for it is just braindead.
> 
> Well, yes, that was the logic behind move -- keep it private to scheduler.

i have no objections at all against the whole sched.h cleanup 
(reducing header file dependencies is a much needed activity). But 
please keep it in a header file - i.e. put it into 
kernel/sched_internals.h. (like we do it for 
kernel/lockdep_internals.h)

that could then probably be merged with kernel/sched_stats.h as well. 
(which too is an #ifdef laden interface piece of code we have moved 
into a header)

Thanks,

	Ingo
