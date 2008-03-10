Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYCJVC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYCJVC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbYCJVCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:02:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYCJVCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:02:18 -0400
Subject: Re: [PATCH] sched: fix race in schedule
From: Peter Zijlstra <peterz@infradead.org>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, hpj@urpla.net,
       stable <stable@kernel.org>
In-Reply-To: <47D59FFB.8030201@ct.jp.nec.com>
References: <47D57770.50909@ct.jp.nec.com> <1205174197.8514.159.camel@twins>
	 <47D593A5.5060906@ct.jp.nec.com> <1205181256.6241.320.camel@lappy>
	 <47D59FFB.8030201@ct.jp.nec.com>
Content-Type: text/plain
Date: Mon, 10 Mar 2008 22:01:54 +0100
Message-Id: <1205182914.6241.322.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-10 at 13:54 -0700, Hiroshi Shimamoto wrote:
> Peter Zijlstra wrote:
> > On Mon, 2008-03-10 at 13:01 -0700, Hiroshi Shimamoto wrote:
> > 
> >> thanks, your patch looks nice to me.
> >> I had focused setprio, on_rq=0 and running=1 situation, it makes me to
> >> fix these functions.
> >> But one point, I've just noticed. I'm not sure on same situation against
> >> sched_rt. I think the pre_schedule() of rt has chance to drop rq lock.
> >> Is it OK?
> > 
> > Ah, you are quite right, that'll teach me to rush out a patch just
> > because dinner is ready :-). 
> > 
> > How about we submit the following patch for mainline and CC -stable to
> > fix .23 and .24:
> 
> thanks for working, I'm OK, and will test it soon.
> IIRC, it came from the group scheduling, .23 probably doesn't have this issue.

Might not have this exact race, but I've checked both .23 and .24, both
can unlock the rq before we do ->put_prev_task(), leaving a window for
potential nasties. I'm rather safe than sorry :-)


