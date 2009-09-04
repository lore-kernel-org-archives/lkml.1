Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZIDHTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZIDHTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbZIDHTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:19:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647AbZIDHTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:19:10 -0400
Date: Fri, 4 Sep 2009 09:19:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: [RFC][PATCH 0/8] load-balancing and cpu_power -v2
Message-ID: <20090904071905.GI29829@elte.hu>
References: <20090901083431.748830771@chello.nl> <20090903121045.GK7216@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090903121045.GK7216@alberich.amd.com>
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


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> On Tue, Sep 01, 2009 at 10:34:31AM +0200, Peter Zijlstra wrote:
> > A more complete version, one that compiles and mostly works on the
> > simple tests to which it was subjected.
> > 
> > It still lacks integration with APERF/MPERF because that stuff was
> > hidding in some acpi driver instead of placed in arch code for general
> > consumption.. will fix.
> > 
> > Also, SD_SHARE_CPUPOWER seems redundant in the face of sd->level ==
> > SD_LV_SIBLING, should we remove the SD_flag or depricate the level?
> > 
> > Anyway, have at it, poke holes and report issues.
> 
> Tested it (to a certain extend).
> Found no performance degradation (on 1P, 2P, 4P systems). (One could
> think performance might slightly degrade due to more frequent
> __cpu_power updates).

Ok, thanks for doing that, it's really useful - this saved me a day 
of testing and allows me to accelerate these patches and try to 
queue them up in tip:sched today.

Note, we have regressed the load-balancer in recently but its 
inherent complexity makes it pretty hard to fix. We dont max out 
kbuild performance for example - i see this in my distcc builds. 
Would be nice to sort that out too for .32, on top of Peter's 
power-balancing series.

We've got the sched-domains setup simplification suggestions from 
Peter as well, those could be done separately (but are important as 
well, to express more complex hierarchies like Magny-Cours).

	Ingo
