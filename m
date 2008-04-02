Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYDBIow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYDBIow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 04:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYDBIon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 04:44:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39224 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbYDBIom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 04:44:42 -0400
Subject: Re: [PATCH 2/2] Customize sched domain via cpuset
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
In-Reply-To: <47F346A8.5000801@jp.fujitsu.com>
References: <47F21C38.8090608@jp.fujitsu.com>
	 <1207050712.8514.715.camel@twins>  <47F346A8.5000801@jp.fujitsu.com>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 10:44:31 +0200
Message-Id: <1207125871.8514.755.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 17:41 +0900, Hidetoshi Seto wrote:
> Peter Zijlstra wrote:
> > On Tue, 2008-04-01 at 20:27 +0900, Hidetoshi Seto wrote:
> >> The implementation is here.
> >>
> >>  - Add 2 new cpuset files:
> >>      sched_wake_idle_far
> >>      sched_balance_newidle_far
> >>
> >>  - Modify partition_sched_domains() and build_sched_domains()
> >>    to take flags parameter passed from cpuset.
> >>
> >>  - Fill newidle_idx for node domains which currently unused but
> >>    might be required for sched_balance_newidle_far.
> > 
> > Just to be clear; the same effect can be had by poking into:
> > 
> >  /proc/sys/kernel/sched_domain/$cpu/$domain/flags
> > 
> > but this interface you now propose gives a more stable interface in that
> > you'd have to re-do your setting after every cpuset change (admittedly
> > those are rare, but I see how it could be a nuisance).
> 
> And the sysctl entry "sched_domain" is not available unless SCHED_DEBUG.
> 
> So it is common sense that this sysctl is not open to public yet,
> and that the expected users are scheduler developers, Ingo and friends.

Ah, right, totally forgot about that :-)

> > Or do you actually add something that wasn't available through the
> > initial domain interface?
> 
> At this time I have no idea, but it would be possible if there are
> something unreasonable on global system but acceptable on a part.
> 
> In other words, we can invent other sched_* families which has special
> effect that "default scheduler" never have.

I was asking about this patch in specific, and the answer seems to be:
no, we don't add anything that wasn't available.

And yes, I see the possiblilties to extend this :-)

