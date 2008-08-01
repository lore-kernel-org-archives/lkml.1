Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYHAFOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYHAFOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYHAFOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:14:31 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60852 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbYHAFOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:14:31 -0400
Date: Fri, 1 Aug 2008 10:44:08 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: VolanoMark regression with 2.6.27-rc1
Message-ID: <20080801051407.GA5232@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <1217474425.25608.150.camel@ymzhang> <1217489463.25608.157.camel@ymzhang> <1217489949.8157.78.camel@twins> <1217490560.25608.168.camel@ymzhang> <1217551154.25608.169.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217551154.25608.169.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 08:39:14AM +0800, Zhang, Yanmin wrote:
> 
> On Thu, 2008-07-31 at 15:49 +0800, Zhang, Yanmin wrote:
> > On Thu, 2008-07-31 at 09:39 +0200, Peter Zijlstra wrote:
> > > On Thu, 2008-07-31 at 15:31 +0800, Zhang, Yanmin wrote:
> > > > On Thu, 2008-07-31 at 11:20 +0800, Zhang, Yanmin wrote:
> > > > > Ingo,
> > > > > 
> > > > Oh, it looks like they are the old issues in 2.6.26-rc1 and the 2 patches were reverted before 2.6.26.
> > > > New patches are merged into 2.6.27-rc1, but the issues are still not resolved clearly.
> > > > http://www.uwsg.iu.edu/hypermail/linux/kernel/0805.2/1148.html.
> > > 
> > > The new smp-group stuff doesn't remotely look like what was in .26
> > > 
> > > Also, on my quad (admittedly smaller than your machines) both volano and
> > > sysbench didn't regress anymore - where they clearly did with the code
> > > reverted from .26.
> > The regression I reported exists on:
> > 1) 8-core+HT(totally 16 logical processor) tulsa: 40% regression with volano, 8% with oltp;
> > 2) 8-core+HT Montvale Itanium: 9% regression with volano; 8% with oltp;
> > 3) 16-core tigerton: %70 with volano, %18 with oltp;
> > 4) 8-core stoakley: %15 with oltp, testing failed with volanoMark.
> > 
> > So the issues are popular on different architectures.
> I know kernel needs the features and it might not be a good idea to reject them over and over again.
> I will collect more data on tigerton and try to optimize it.

Hi Yanmin,

Would it be possible for you to switch of the group scheduling feature
and see if the regression still exists. In all our testing, we did not
see a regression. I would like to eliminate it from your testing as
well.

The option to switch off would be CONFIG_GROUP_SCHED, that should disable
all the group scheduling features.

Thanks,
-- 
regards,
Dhaval
