Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYLIIU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYLIIU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbYLIIUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:20:22 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:58609 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbYLIIUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:20:20 -0500
Date: Tue, 9 Dec 2008 13:52:11 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] idle_balance() does not call load_balance_newidle()
Message-ID: <20081209082211.GA29340@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Gautham R Shenoy <ego@in.ibm.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20081208152249.GI5457@dirshya.in.ibm.com> <20081208154939.GA405@elte.hu> <20081209040706.GA20525@dirshya.in.ibm.com> <20081209063448.GA17706@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081209063448.GA17706@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-09 07:34:48]:

> 
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
> > * Ingo Molnar <mingo@elte.hu> [2008-12-08 16:49:39]:
> > 
> > > 
> > > * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE is
> > > > set at higher level domain (3-CPU) and not in low level domain (2-MC).
> > > > 
> > > > pulled_task is initialised to -1 and checked for non-zero which is
> > > > always true if the lowest level sched_domain does not have
> > > > SD_BALANCE_NEWIDLE flag set.
> > > > 
> > > > Trivial fix to initialise pulled_task to zero.
> > > > Patch against 2.6.28-rc7
> > > 
> > > applied to tip/sched/core, thanks! (Not for v2.6.28 because this could 
> > > affect performance.)
> > 
> > Thanks Ingo.  This patch does not change any functionality in v2.6.28 
> > and hence will not affect performance.  The SD flags are not touched. I 
> > found this bug while setting different SD flags at MC level and CPU 
> > level in my power saving balance patches.
> 
> if it does not change any functionality then we would not be doing the 
> change, right?
 
 :) 
  
> It does change functionality, because:
> 
> > > > load_balance_newidle() does not get called if SD_BALANCE_NEWIDLE is 
> > > > set at higher level domain (3-CPU) and not in low level domain 
> > > > (2-MC).
> 
> even though it's a bug fix, it affects how the SD flags are interpreted 
> and acted upon by the load balancer - i.e. the change can impact 
> performance.

Agreed.  In my test setup with two levels of sched_domains,
SD_BALANCE_NEWIDLE has not been set in both CPU level and MC level
starting from 2.6.28-rc4.  In a setup with more levels of
sched_domains and if the higher levels have SD_BALANCE_NEWIDLE set,
then we will have a functional impact.  

You are right in queueing it for 2.6.29.

Thanks for the clarification.

--Vaidy

