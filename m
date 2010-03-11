Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab0CKMrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 07:47:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52514 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757774Ab0CKMrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 07:47:35 -0500
Date: Thu, 11 Mar 2010 13:47:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/9] oprofile, perf, x86: introduce new functions to
 reserve perfctrs
Message-ID: <20100311124716.GH31354@elte.hu>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
 <1267725559.25158.208.camel@laptop>
 <1268308081.5037.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268308081.5037.14.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2010-03-04 at 18:59 +0100, Peter Zijlstra wrote:
> > On Thu, 2010-03-04 at 16:22 +0100, Robert Richter wrote:
> > > This patch set improves the perfctr reservation code. New functions
> > > are available to reserve a counter by its index only. It is no longer
> > > necessary to allocate both msrs of a counter which also improves the
> > > code and makes it easier.
> > > 
> > > For oprofile a handler is implemented that returns an error now if a
> > > counter is already reserved by a different subsystem such as perf or
> > > watchdog. Before, oprofile silently ignored that counter. Finally the
> > > new reservation functions can be used to allocate special parts of the
> > > pmu such as IBS, which is necessary to use IBS with perf too.
> > > 
> > > The patches are available in the oprofile tree:
> > > 
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> > > 
> > > If there are no objections, I suggest to merge it into the
> > > tip/perf/core too, maybe after pending patches went in. If there are
> > > already conflicts, I will do the merge for this.
> > 
> > Right, so cleaning up that reservation code is nice, but wouldn't it be
> > much nicer to simply do away with all that and make everything use the
> > (low level) perf code?
> 
> Alternatively, could we maybe further simplify this reservation into:
> 
> int  reserve_pmu(void);
> void release_pmu(void);
> 
> And not bother with anything finer grained.

Yeah, that looks quite a bit simpler.

It's all about making it easier to live with legacies anyway - all modern 
facilities will use perf events to access the PMU.

	Ingo
