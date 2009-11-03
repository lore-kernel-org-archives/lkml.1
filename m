Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZKCRIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZKCRIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZKCRIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:08:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbZKCRIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:08:37 -0500
Date: Tue, 3 Nov 2009 18:08:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Paris <eparis@redhat.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, zhaolei@cn.fujitsu.com, lizf@cn.fujitsu.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [-next regression] lockdep? tracing? BUG: unable to handle
	kernel paging request at
Message-ID: <20091103170831.GB3074@elte.hu>
References: <1257263296.2891.97.camel@dhcp231-106.rdu.redhat.com> <1257264170.26028.3340.camel@gandalf.stny.rr.com> <1257267617.2891.107.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257267617.2891.107.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Eric Paris <eparis@redhat.com> wrote:

> On Tue, 2009-11-03 at 11:02 -0500, Steven Rostedt wrote:
> > [ Added Peter Zijlstra ]
> > 
> > On Tue, 2009-11-03 at 10:48 -0500, Eric Paris wrote:
> > > Linux-next from Oct 30 did not have this problem.  Linux next from
> > > yesterday (and today) I always hit this on boot.
> > 
> > Could you also give the SHA1 of Linux-next, as well as the config you
> > used.
> 
> False alarm, apparently this is due to a patch that I added.  Odd part 
> is, I don't touch anything even remotely close to this section of 
> code. I'm at a bit of a lose, but apply my patch, boom, revert, works.
> 
> I'll figure it out eventually I guess.

When i saw your crash earlier today my first guess was memory 
corruption: lockdep is one of the first things to blow up on kernel data 
structure memory corruption. It tracks all locks and affects everything 
so gets hit first.

( Nevertheless we do have fresh changes in the tracing tree so some
  genuine lockdep/tracing crash was not implausible either. )

	Ingo
