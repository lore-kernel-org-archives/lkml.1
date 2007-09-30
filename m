Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXI3P5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXI3P5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbXI3P5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:57:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43426 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340AbXI3P5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:57:30 -0400
Date: Sun, 30 Sep 2007 17:57:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] robust futex thread exit race
Message-ID: <20070930155716.GA29627@elte.hu>
References: <1191164539.4047.5.camel@localhost> <20070930151827.GB23127@elte.hu> <alpine.LFD.0.9999.0709301750430.3142@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0709301750430.3142@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.1.7-deb
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0859]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> 
> On Sun, 30 Sep 2007, Ingo Molnar wrote:
> > * Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > 
> > > Hi Ingo,
> > > I finally found the bug that causes tst-robust8 from the glibc to fail
> > > on s390x. Turned out to be a common code problem with the processing of
> > > the robust futex list. The patch below fixes the bug for me.
> > 
> > good catch! A quick preliminary review of your patch indicates it's fine 
> > - and it might be v2.6.23 material.
> > 
> > Acked-by: Ingo Molnar <mingo@elte.hu>
> 
>   Acked-by: Thomas Gleixner <tglx@linutronix.de>
>  
> > > Calling handle_futex_death in exit_robust_list for the different 
> > > robust mutexes of a thread basically frees the mutex. Another thread 
> > > might grab the lock immediately which updates the next pointer of the 
> > > mutex. fetch_robust_entry over the next pointer might therefore branch 
> > > into the robust mutex list of a different thread. This can cause two 
> > > problems: 1) some mutexes held by the dead thread are not getting 
> > > freed and 2) some mutexs held by a different thread are freed. The 
> > > next point need to be read before calling handle_futex_death.
> > 
> > nasty race... Ulrich, Thomas, do you concur?
> 
> Yes. Where do they sell those brown paperbags again ?

i've still got plenty of them stacked up, can pass over a few. (i'm 
getting them cheap from the manufacturer - large quantity discount)

	Ingo
