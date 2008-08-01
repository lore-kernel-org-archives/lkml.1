Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYHAAmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYHAAmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 20:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYHAAmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 20:42:04 -0400
Received: from mga07.intel.com ([143.182.124.22]:45545 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752238AbYHAAmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 20:42:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,289,1215414000"; 
   d="scan'208";a="28250557"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1217490560.25608.168.camel@ymzhang>
References: <1217474425.25608.150.camel@ymzhang>
	 <1217489463.25608.157.camel@ymzhang>  <1217489949.8157.78.camel@twins>
	 <1217490560.25608.168.camel@ymzhang>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 08:39:14 +0800
Message-Id: <1217551154.25608.169.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-07-31 at 15:49 +0800, Zhang, Yanmin wrote:
> On Thu, 2008-07-31 at 09:39 +0200, Peter Zijlstra wrote:
> > On Thu, 2008-07-31 at 15:31 +0800, Zhang, Yanmin wrote:
> > > On Thu, 2008-07-31 at 11:20 +0800, Zhang, Yanmin wrote:
> > > > Ingo,
> > > > 
> > > > volanoMark has regression with 2.6.27-rc1.
> > > > 1) 70% on 16-core tigerton;
> > > > 2) 18% on a new multi-core+HT mahcine;
> > > > 
> > > > I tried to use git bisect to locate the root cause, but git bisect always went
> > > > back to 2.6.26. Then, I used my mechanical bisect script linearly to locate below commit:
> > > > 
> > > > commit 82638844d9a8581bbf33201cc209a14876eca167
> > > > Merge: 9982fbf... 63cf13b...
> > > > Author: Ingo Molnar <mingo@elte.hu>
> > > > Date:   Wed Jul 16 00:29:07 2008 +0200
> > > > 
> > > >     Merge branch 'linus' into cpus4096
> > > > 
> > > >     Conflicts:
> > > > 
> > > >         arch/x86/xen/smp.c
> > > >         kernel/sched_rt.c
> > > >         net/iucv/iucv.c
> > > > 
> > > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > > 
> > > > 
> > > > 
> > > > But if I use 'git show 82638844d9a8581bbf33201cc209a14876eca167', it looks like I could only
> > > > get a part of the patch. If I use web to acces the commit, I could get a big patch. As it's
> > > > a merge, what're commit numbers of the subpatches?
> > > > 
> > > > 
> > > > BTW, sysbench+mysql(oltp readonly) has about 15% regression, but git bisect looks crazy again.
> > 
> > > Oh, it looks like they are the old issues in 2.6.26-rc1 and the 2 patches were reverted before 2.6.26.
> > > New patches are merged into 2.6.27-rc1, but the issues are still not resolved clearly.
> > > http://www.uwsg.iu.edu/hypermail/linux/kernel/0805.2/1148.html.
> > 
> > The new smp-group stuff doesn't remotely look like what was in .26
> > 
> > Also, on my quad (admittedly smaller than your machines) both volano and
> > sysbench didn't regress anymore - where they clearly did with the code
> > reverted from .26.
> The regression I reported exists on:
> 1) 8-core+HT(totally 16 logical processor) tulsa: 40% regression with volano, 8% with oltp;
> 2) 8-core+HT Montvale Itanium: 9% regression with volano; 8% with oltp;
> 3) 16-core tigerton: %70 with volano, %18 with oltp;
> 4) 8-core stoakley: %15 with oltp, testing failed with volanoMark.
> 
> So the issues are popular on different architectures.
I know kernel needs the features and it might not be a good idea to reject them over and over again.
I will collect more data on tigerton and try to optimize it.

-yanmin


