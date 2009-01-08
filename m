Return-Path: <linux-kernel-owner+w=401wt.eu-S1760865AbZAHRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865AbZAHRoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZAHRoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:44:10 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:33481 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbZAHRoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:44:09 -0500
Date: Thu, 8 Jan 2009 23:16:55 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: balbir@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 0/8] Tunable sched_mc_power_savings=n
Message-ID: <20090108174655.GQ4574@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1231168786.9120.26.camel@marge.simson.net> <1231234297.3806.50.camel@marge.simson.net> <20090106150709.GG4574@dirshya.in.ibm.com> <1231264117.5254.23.camel@marge.simson.net> <20090106184552.GI17198@balbir.in.ibm.com> <1231318755.3899.57.camel@marge.simson.net> <20090107112639.GI4574@dirshya.in.ibm.com> <1231338985.5709.22.camel@marge.simson.net> <20090107153510.GN4574@dirshya.in.ibm.com> <1231402008.5721.37.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1231402008.5721.37.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Galbraith <efault@gmx.de> [2009-01-08 09:06:48]:

> On Wed, 2009-01-07 at 21:05 +0530, Vaidyanathan Srinivasan wrote:
> 
> > sched_mc=2 depends on NEWIDLE but the wakeup biasing part will be
> > enabled even without this flag.  The power savings will be marginally
> > better than sched_mc=1 without NEWIDLE.  But the end user can have
> > that setup if they want to.
> 
> That implies to me that there should exist a flag SD_WAKEUP_BIAS or
> whatnot.  All settings should be visible.  Currently, sched_mc > 0 turns
> on NEWIDLE, which is visible, but 2 turns on this 'invisible to the
> ultimate low-level control interface' thing.

Having a feature flag for each power saving balance is possible but
will be an overkill since independent control of features at each
sched domain may not yield useful configurations.  The present power
saving heuristics that gets enabled at sched_mc=1 is primarily
controlled by SD_POWERSAVE_BALANCE but has side effects and can be
rendered ineffective by changing other SD flags.

We did consider having individual SD_flag for each of the power
savings functions, but that quickly lead to too many possible
configurations with most of them incorrect or ineffective.  In order
to improve the consumeability of the power saving features, we have
proposed to enhance the existing tunable with monotonically increasing
powersavings vs performance tradeoffs.  

I agree with the 'visibility' to low level interface that you have
pointed out.  It will be good to have flags showup at the low level
interface, but do end users like system administrators would want to
know and tune these flags?  It makes sense with the current set of
flags which depict important scheduler features, but power savings
related flags only further qualify or emphasise existing functions and
control points in the scheduler.  

In my opinion adding flags for each powersaving feature will add 
un-necessary complexity and may not be as useful to end users.

--Vaidy

