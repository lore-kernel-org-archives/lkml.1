Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbYHAVQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbYHAVQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760427AbYHAVKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:37 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41413 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760426AbYHAVKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:10:34 -0400
Date: Fri, 1 Aug 2008 14:10:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Gautham Shenoy <ego@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] rcu classic: new algorithm for
	callbacks-processing(v2)
Message-ID: <20080801211032.GT14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48708F2F.2060406@cn.fujitsu.com> <20080718140930.GT6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718140930.GT6875@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 04:09:30PM +0200, Ingo Molnar wrote:
> 
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > This is v2, it's a little deference from v1 that I
> > had send to lkml.
> > use ACCESS_ONCE
> > use rcu_batch_after/rcu_batch_before for batch # comparison.
> > 
> > rcutorture test result:
> > (hotplugs: do cpu-online/offline once per second)
> > 
> > No CONFIG_NO_HZ:           OK, 12hours
> > No CONFIG_NO_HZ, hotplugs: OK, 12hours
> > CONFIG_NO_HZ=y:            OK, 24hours
> > CONFIG_NO_HZ=y, hotplugs:  Failed.
> > (Failed also without my patch applied, exactly the same bug occurred,
> > http://lkml.org/lkml/2008/7/3/24)
> 
> thanks, i've applied this to tip/core/rcu - but it would be nice have an 
> ack/nak from Paul as well, before we can proceed further.

I like the general approach -- simplification is a good thing.

So, for the moment:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I need to do a more detailed review (e.g., the memory-barrier changes
and the incorporation of some grace-period processing into call_rcu()),
after which I will either ask for changes or give a Reviewed-by.

I need to do this more-detailed review before we ship to mainline.
(Gak, already two weeks since Jiangshan sent this!!!  My apologies!!!)

							Thanx, Paul
