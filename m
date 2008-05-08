Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYEHFl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYEHFl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 01:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbYEHFk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 01:40:56 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:42304 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYEHFkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 01:40:55 -0400
Date: Thu, 8 May 2008 11:10:47 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080508054047.GD32729@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang> <20080506115207.GA24862@linux.vnet.ibm.com> <20080507173357.GA4424@linux.vnet.ibm.com> <1210223914.3453.102.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210223914.3453.102.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 01:18:34PM +0800, Zhang, Yanmin wrote:
> 
> On Wed, 2008-05-07 at 23:03 +0530, Dhaval Giani wrote:
> > On Tue, May 06, 2008 at 05:22:07PM +0530, Dhaval Giani wrote:
> > > On Tue, May 06, 2008 at 10:06:30AM +0800, Zhang, Yanmin wrote:
> > > > Comparing with 2.6.25, volanoMark has big regression with kernel 2.6.26-rc1.
> > > > It's about 50% on my 8-core stoakley, 16-core tigerton, and Itanium Montecito.
> > > > 
> > > > With bisect, I located below patch.
> > > > 
> > > > 18d95a2832c1392a2d63227a7a6d433cb9f2037e is first bad commit
> > > > commit 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > Date:   Sat Apr 19 19:45:00 2008 +0200
> > > > 
> > > >     sched: fair-group: SMP-nice for group scheduling
> > > >     
> > > >     Implement SMP nice support for the full group hierarchy.
> > > > 
> > > > If I reverse the patch with resolving some conflictions, volanoMark result could
> > > > be restored completely.
> > > > 
> > > 
> > > ok, that's bad. Let's get vatsa and Ingo also involved.
> > > 
> > 
> > Just to confirm, do you still have a performance regression with
> > !group_sched?
> I just tried it with CONFIG_GROUP_SCHED=n a moment ago. The regression becomes less than 3%.
> 

One more thing if you can try out, please set the shares for other users
to 2 except for the one which is running the benchmark. You can set it
at /sys/kernel/uids/<uid>/cpu_share

-- 
regards,
Dhaval
