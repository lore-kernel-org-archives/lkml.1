Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbYBARLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbYBARLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbYBARLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:11:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42942 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957AbYBARLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:11:09 -0500
Date: Fri, 1 Feb 2008 18:10:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <srostedt@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during
	suspend/hibernation on x86-64 (bisected)
Message-ID: <20080201171022.GC2159@elte.hu>
References: <200801272229.48955.rjw@sisk.pl> <200801280226.22013.rjw@sisk.pl> <1201795128.32654.22.camel@lappy> <200801312154.33754.rjw@sisk.pl> <1201867497.32654.49.camel@lappy> <b647ffbd0802010711q744f5023mdbfccd9540556b70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0802010711q744f5023mdbfccd9540556b70@mail.gmail.com>
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


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> On 01/02/2008, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > ---
> >  - restore the old wakeup mechanism
> 
> and how does it change behavior, logically-wise?
> 
> do we somehow miss a 'wake-up' from kthread_stop() so that its caller 
> gets blocked until watchdog's msleep_interruptible(10000) timeouts? On 
> average, it would take +-5 sec. and might explain the first 
> observation of Ravael -- "...adds a 5 - 10 sec delay..." (although, 
> lately he reported up to +30 sec. delays).
> 
> (/me goint to also try reproducing it later today)

thanks - i cannot reproduce it on my usual suspend/resume testbox 
because e1000 broke on it, and this is a pretty annoying regression. 
We'll have to undo the hung-tasks detection feature if it's not fixed 
quickly. (there's no point in debugging features that _add_ bugs)

	Ingo
