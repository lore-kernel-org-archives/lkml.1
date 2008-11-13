Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbYKMXII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbYKMXII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYKMXHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:07:52 -0500
Received: from ms01.sssup.it ([193.205.80.99]:42030 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755688AbYKMXHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:07:51 -0500
Date: Fri, 14 Nov 2008 00:10:23 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Nauman Rafique <nauman@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       menage@google.com, ngupta@google.com, Rik van Riel <riel@redhat.com>,
       Jeff Moyer <jmoyer@redhat.com>, "dpshah@google.com" <dpshah@google.com>,
       Mike Waychison <mikew@google.com>, rohitseth@google.com,
       paolo.valente@unimore.it
Subject: Re: [patch 0/4] [RFC] Another proportional weight IO controller
Message-ID: <20081113231023.GM14817@gandalf.sssup.it>
References: <e98e18940811061507t3e19183byf2b8b291458ba81b@mail.gmail.com> <20081107141943.GC21884@redhat.com> <e98e18940811071336n58a073d8w2cbaeddd5657d1e9@mail.gmail.com> <20081110141143.GC26956@redhat.com> <e98e18940811111155q4bd73480pebe088fa1adbe2e4@mail.gmail.com> <20081111223024.GA31527@redhat.com> <e98e18940811121320w5f321302n13b526887cbb4012@mail.gmail.com> <20081113180821.GF7542@redhat.com> <20081113191546.GL14817@gandalf.sssup.it> <e98e18940811131427i5eea3543jc7e934632f15bcf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98e18940811131427i5eea3543jc7e934632f15bcf4@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nauman Rafique <nauman@google.com>
> Date: Thu, Nov 13, 2008 02:27:41PM -0800
>
> On Thu, Nov 13, 2008 at 11:15 AM, Fabio Checconi <fchecconi@gmail.com> wrote:
> >> How the proportional weight division is done among tasks is a property
> >> of IO scheduler. cfq decides to use time slices according to priority
> >> and bfq decides to use tokens. So probably we can't move this to common
> >> elevator layer.
> >>
> >
> > cfq and bfq are pretty similar in the concepts they adopt, and the pure
> > time-based approach of cfq can be extended to arbitrary hierarchies.
> >
> > Even in bfq, when dealing with groups that generate only seeky traffic
> > we don't try to be fair in the service domain, as it would decrease too
> > much the aggregate throughput, but we fall back to a time-based approach.
> >
> > [ This is a design choice, but it does not depend on the algorithms,
> >  and of course can be changed... ]
> >
> > The two approaches can be mixed/unified, for example, using wf2q+ to
> > schedule the slices, in the time domain, of cfq; the main remaining
> > difference would be the ability of bfq to provide service-domain
> > guarantees.
> 
> Before going into the design of elevator level scheduler, we should
> have some consensus on abandoning the two level approach. Infact, it
> would be useful if we had Ryo and Satoshi jump into this discussion
> and express their opinion.
> 

You're right.  I was only trying to give some design elements thinking
that they could help in the evaluation of the two approaches, talking
of the one I know better.


...
> >> So at this point of time I think that probably porting BFQ's hierarchical
> >> scheduling implementation to other IO schedulers might make sense. Thoughts?
> >>
> >
> > IMO for cfq, given the similarities, this can be done without conceptual
> > problems.  How to do that for schedulers like as, noop or deadline, and
> > if this is the best solution, is an interesting problem :)
> 
> It might be a little too early to start patching things into other
> schedulers. First, because we still don't have a common ground on the
> exact approach for proportional bandwidth division. Second, if
> somebody is using vanilla no-op, deadline or as, do they really care
> about proportional division? If they did, they would probably be using
> cfq already. So we can have something going for cfq first, and then we
> can move to other schedulers.
> 

Sorry for being unclear, I didn't want to start patching anything.  In my
opinion a hierarchical extension of as/deadline poses some interesting
scheduling issues, and exploring them can help in making better decisions.
