Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbYEHFdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbYEHFdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 01:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbYEHFdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 01:33:04 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:39728 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbYEHFdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 01:33:01 -0400
Date: Thu, 8 May 2008 11:02:16 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
Message-ID: <20080508053216.GA32729@linux.vnet.ibm.com>
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

Hmm. On another machine I am seeing a 10% regression, with and without
group sched. Let us work on fixing this one.

-- 
regards,
Dhaval
