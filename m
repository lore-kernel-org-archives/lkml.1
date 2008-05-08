Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYEHGFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYEHGFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYEHGFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:05:10 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:56490 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbYEHGFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:05:06 -0400
Date: Thu, 8 May 2008 11:34:40 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080508060440.GE32729@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1210039590.3453.18.camel@ymzhang> <20080506115207.GA24862@linux.vnet.ibm.com> <20080507173357.GA4424@linux.vnet.ibm.com> <1210223914.3453.102.camel@ymzhang> <20080508054047.GD32729@linux.vnet.ibm.com> <1210226013.3453.113.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210226013.3453.113.camel@ymzhang>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 01:53:33PM +0800, Zhang, Yanmin wrote:
> 
> On Thu, 2008-05-08 at 11:10 +0530, Dhaval Giani wrote:
> > On Thu, May 08, 2008 at 01:18:34PM +0800, Zhang, Yanmin wrote:
> > > 
> > > On Wed, 2008-05-07 at 23:03 +0530, Dhaval Giani wrote:
> > > > On Tue, May 06, 2008 at 05:22:07PM +0530, Dhaval Giani wrote:
> > > > > On Tue, May 06, 2008 at 10:06:30AM +0800, Zhang, Yanmin wrote:
> > > > > > Comparing with 2.6.25, volanoMark has big regression with kernel 2.6.26-rc1.
> > > > > > It's about 50% on my 8-core stoakley, 16-core tigerton, and Itanium Montecito.
> > > > > > 
> > > > > > With bisect, I located below patch.
> > > > > > 
> > > > > > 18d95a2832c1392a2d63227a7a6d433cb9f2037e is first bad commit
> > > > > > commit 18d95a2832c1392a2d63227a7a6d433cb9f2037e
> > > > > > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > > > > Date:   Sat Apr 19 19:45:00 2008 +0200
> > > > > > 
> > > > > >     sched: fair-group: SMP-nice for group scheduling
> > > > > >     
> > > > > >     Implement SMP nice support for the full group hierarchy.
> > > > > > 
> > > > > > If I reverse the patch with resolving some conflictions, volanoMark result could
> > > > > > be restored completely.
> > > > > > 
> > > > > 
> > > > > ok, that's bad. Let's get vatsa and Ingo also involved.
> > > > > 
> > > > 
> > > > Just to confirm, do you still have a performance regression with
> > > > !group_sched?
> > > I just tried it with CONFIG_GROUP_SCHED=n a moment ago. The regression becomes less than 3%.
> > > 
> > 
> > One more thing if you can try out, please set the shares for other users
> > to 2 except for the one which is running the benchmark. You can set it
> > at /sys/kernel/uids/<uid>/cpu_share
> I might try. There are only 2 users active in my system, root for background processes and mine
> for the testing. In the other hand, I kill most backgroud services when starting testing. So
> it might not have help.
> 

Even if one service is running as root, it is guaranteed 2/3 the CPU
(since root's shares are double that of other users by default). It
would cause issues for sure.

Thanks,
-- 
regards,
Dhaval
