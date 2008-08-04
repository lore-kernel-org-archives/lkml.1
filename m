Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYHDFlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYHDFlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 01:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYHDFlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 01:41:32 -0400
Received: from mga10.intel.com ([192.55.52.92]:13147 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752834AbYHDFlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 01:41:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,302,1215414000"; 
   d="scan'208";a="603823196"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20080804052228.GA5444@linux.vnet.ibm.com>
References: <1217474425.25608.150.camel@ymzhang>
	 <1217489463.25608.157.camel@ymzhang> <1217489949.8157.78.camel@twins>
	 <1217490560.25608.168.camel@ymzhang> <1217551154.25608.169.camel@ymzhang>
	 <20080801051407.GA5232@linux.vnet.ibm.com>
	 <1217826278.25608.198.camel@ymzhang>
	 <20080804052228.GA5444@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 13:37:58 +0800
Message-Id: <1217828278.25608.206.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-08-04 at 10:52 +0530, Dhaval Giani wrote:
> On Mon, Aug 04, 2008 at 01:04:38PM +0800, Zhang, Yanmin wrote:
> > 
> > On Fri, 2008-08-01 at 10:44 +0530, Dhaval Giani wrote:
> > > On Fri, Aug 01, 2008 at 08:39:14AM +0800, Zhang, Yanmin wrote:
> > > > 
> > > > On Thu, 2008-07-31 at 15:49 +0800, Zhang, Yanmin wrote:
> > > > > On Thu, 2008-07-31 at 09:39 +0200, Peter Zijlstra wrote:
> > > > > > On Thu, 2008-07-31 at 15:31 +0800, Zhang, Yanmin wrote:
> > > > > > > On Thu, 2008-07-31 at 11:20 +0800, Zhang, Yanmin wrote:
> > > > > > > > Ingo,
> > > > > > > > 
> > > > > > > Oh, it looks like they are the old issues in 2.6.26-rc1 and the 2 patches were reverted before 2.6.26.
> > > > > > > New patches are merged into 2.6.27-rc1, but the issues are still not resolved clearly.
> > > > > > > http://www.uwsg.iu.edu/hypermail/linux/kernel/0805.2/1148.html.
> > > > > > 
> > > > > > The new smp-group stuff doesn't remotely look like what was in .26
> > > > > > 
> > > > > > Also, on my quad (admittedly smaller than your machines) both volano and
> > > > > > sysbench didn't regress anymore - where they clearly did with the code
> > > > > > reverted from .26.
> > > > > The regression I reported exists on:
> > > > > 1) 8-core+HT(totally 16 logical processor) tulsa: 40% regression with volano, 8% with oltp;
> > > > > 2) 8-core+HT Montvale Itanium: 9% regression with volano; 8% with oltp;
> > > > > 3) 16-core tigerton: %70 with volano, %18 with oltp;
> > > > > 4) 8-core stoakley: %15 with oltp, testing failed with volanoMark.
> > > > > 
> > > > > So the issues are popular on different architectures.
> > > > I know kernel needs the features and it might not be a good idea to reject them over and over again.
> > > > I will collect more data on tigerton and try to optimize it.
> > > 
> > > Hi Yanmin,
> > > 
> > > Would it be possible for you to switch of the group scheduling feature
> > > and see if the regression still exists. In all our testing, we did not
> > > see a regression. I would like to eliminate it from your testing as
> > > well.
> > I tested with CONFIG_GROUP_SCHED=n. To test faster, I simplified the benchmark parameter.
> > 
> > volanoMark:
> > kernel				| 	result
> > ----------------------------------------------------------
> > 2.6.27-rc1_group		|	205901
> > ----------------------------------------------------------
> > 2.6.27-rc1_nogroup		|	303377
> > ----------------------------------------------------------
> > 2.6.26_group			|	529388
> > 
> 
> There seem to be two different regressions here. One in the user group
> scheduling (which I do remember did have problems) and something totally
> unrelated to group scheduling. In some of the runs I tried here, I got
> similar results for 2.6.27-rc1_nogroup and 2.6.27-rc1_cgroup
Does cgroup here mean CONFIG_CGROUPS? Or just a typo?

I never enable CONFIG_CGROUP.

>  but had bad
> results for user. Anyway, we will need to fix both the regressions.
That's great.

> Would it be possible for you to see what causes the regression between
> 2.6.26 and 2.6.27-rc1 for the non group scheduling case?
I will check it. But git bisect doesn't work on this issue. Mostly, it's still
caused by scheduler. If checking the old emails about 2.6.26-rc1, we can find the
major issues about scheduler are related to 2 patches, although I'm not sure
current regression is still caused by them.

yanmin


