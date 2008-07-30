Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbYG3Kcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbYG3Kcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 06:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYG3Kci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 06:32:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:54185 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYG3Kch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 06:32:37 -0400
Subject: Re: [RFT][PATCH] sched: scale sysctl_sched_shares_ratelimit with
	nr_cpus
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: vatsa@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080730.032930.55051878.davem@davemloft.net>
References: <1217413511.8157.7.camel@twins>
	 <20080730.032930.55051878.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 12:32:29 +0200
Message-Id: <1217413949.8157.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 03:29 -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 30 Jul 2008 12:25:11 +0200
> 
> > Dhaval, Vatsa,
> > 
> > Could you guys give this patch a spin on the big iron and possibly tune
> > the default shares_ratelimit value to give satisfactory fairness on your
> > large machines while considering the overhead?
> > 
> > 
> > ---
> > Subject: sched: scale sysctl_sched_shares_ratelimit with nr_cpus
> > 
> > David reported that his Niagra spend a little too much time in
> > tg_shares_up(), which considering he has a large cpu count makes sense.
> > 
> > So scale the ratelimit value with the number of cpus like we do for
> > other controls as well.
> > 
> > Reported-by: David Miller <davem@davemloft.net>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> This turned out to be a false theory, and the lockdep problem I
> reported the past few days was the real culprit.
> 
> The rebalancing et al. showing up in my debugging dumps was
> just chance and not even consistent.

Ah, still I think the proposed change makes sense, but lets wait for
some test results from Dhaval and or Vatsa.. ;-)

