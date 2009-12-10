Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbZLJIAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbZLJIAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760673AbZLJIAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:00:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760650AbZLJIAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:00:05 -0500
Date: Thu, 10 Dec 2009 08:59:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Chinner <david@fromorbit.com>, Lachlan McIlroy <lachlan@sgi.com>
Subject: Re: spinlock in completion_done() (was: Re: Async resume patch (was:
 Re: [GIT PULL] PM updates for 2.6.33))
Message-ID: <20091210075947.GD25549@elte.hu>
References: <Pine.LNX.4.44L0.0912081633540.3046-100000@iolanthe.rowland.org>
 <200912082248.14138.rjw@sisk.pl>
 <20091209092922.GC28428@elte.hu>
 <200912092337.52492.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912092337.52492.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Wednesday 09 December 2009, Ingo Molnar wrote:
> > 
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > 
> > > On Tuesday 08 December 2009, Alan Stern wrote:
> > > > On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > > > 
> > > > > BTW, is there a good reason why completion_done() doesn't use spin_lock_irqsave
> > > > > and spin_unlock_irqrestore?  complete() and complete_all() use them, so why not
> > > > > here?
> > > > 
> > > > And likewise in try_wait_for_completion().  It looks like a bug.  Maybe 
> > > > these routines were not intended to be called with interrupts disabled, 
> > > > but that requirement doesn't seem to be documented.  And it isn't a 
> > > > natural requirement anyway.
> > > 
> > > OK, let's ask Ingo about that.
> > > 
> > > Ingo, is there any particular reason why completion_done() and
> > > try_wait_for_completion() don't use spin_lock_irqsave() and
> > > spin_unlock_irqrestore()?
> > 
> > that's a bug that should be fixed - all the wakeup side (and atomic) 
> > variants of completetion API should be irq safe.
> > 
> > It appears that these new completion APIs were added via the XFS tree 
> > about a year ago:
> > 
> >   39d2f1a: [XFS] extend completions to provide XFS object flush requirements
> > 
> > Please Cc: scheduler folks to all scheduler patches.
> 
> If you haven't fixed it locally yet, would you mind me posting a fix?

I wouldnt mind it at all.

Thanks,

	Ingo
