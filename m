Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbZHBSGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbZHBSGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 14:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZHBSGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 14:06:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbZHBSGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 14:06:08 -0400
Date: Sun, 2 Aug 2009 20:05:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave <kilroyd@googlemail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] locking: Check spinlock_t/rwlock_t argument
	type on non-SMP builds too
Message-ID: <20090802180557.GA316@elte.hu>
References: <1248286295-8304-1-git-send-email-kilroyd@googlemail.com> <tip-02626aa5ecc03f94585164b97bedabe15302e3c3@git.kernel.org> <20090802134054.GA14026@elte.hu> <4A75C2C3.3070501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A75C2C3.3070501@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave <kilroyd@googlemail.com> wrote:

> Ingo Molnar wrote:
> > * tip-bot for David Kilroy <kilroyd@googlemail.com> wrote:
> > 
> >> Commit-ID:  02626aa5ecc03f94585164b97bedabe15302e3c3
> >> Gitweb:     http://git.kernel.org/tip/02626aa5ecc03f94585164b97bedabe15302e3c3
> >> Author:     David Kilroy <kilroyd@googlemail.com>
> >> AuthorDate: Wed, 22 Jul 2009 19:11:35 +0100
> >> Committer:  Ingo Molnar <mingo@elte.hu>
> >> CommitDate: Sun, 2 Aug 2009 14:59:29 +0200
> >>
> >> locking: Check spinlock_t/rwlock_t argument type on non-SMP builds too
> > 
> > -tip testing found UP crashes and i bisected it down to:
> > 
> >  02626aa5ecc03f94585164b97bedabe15302e3c3 is first bad commit
> >  commit 02626aa5ecc03f94585164b97bedabe15302e3c3
> >  Author: David Kilroy <kilroyd@googlemail.com>
> >  Date:   Wed Jul 22 19:11:35 2009 +0100
> > 
> >     locking: Check spinlock_t/rwlock_t argument type on non-SMP builds too
> > 
> > the crash looks like this:
> > 
> > [   55.257999] ip[3699]: segfault at 31108c6d80 ip 00000031108c6d80 sp 00007fff4aa183d8 error 14
> > 
> > sometimes it's just a spontaneous reboot with no log message.
> 
> 
> Crap. Looking really carefully:
> 
> +static inline int _spin_trylock_bh(spinlock_t *lock)
> +{ __LOCK(lock); return 1; }
> 
> Should have been:
> 
> +static inline int _spin_trylock_bh(spinlock_t *lock)
> +{ __LOCK_BH(lock); return 1; }
> 
> I can't say if that's definitely causing your issue, but it's 
> certainly wrong. I'll go through it all again, and send a v3 of 
> the patch.

Ok. (Note, please preserve the (minimally) edited changelog you can 
find in the v2 commit email)

	Ingo
