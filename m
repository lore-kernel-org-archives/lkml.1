Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbYEUEza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbYEUEza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 00:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYEUEzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 00:55:20 -0400
Received: from mga10.intel.com ([192.55.52.92]:35579 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbYEUEzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 00:55:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,518,1204531200"; 
   d="scan'208";a="566919841"
Subject: Re: hackbench regression with 2.6.26-rc2 on tulsa machine
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1211275352.24305.6.camel@marge.simson.net>
References: <1211270946.3177.236.camel@ymzhang>
	 <1211275352.24305.6.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 May 2008 12:54:10 +0800
Message-Id: <1211345650.3177.247.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-20 at 11:22 +0200, Mike Galbraith wrote:
> On Tue, 2008-05-20 at 16:09 +0800, Zhang, Yanmin wrote:
> > Comparing with 2.6.26-rc1, hackbench has about 30% regression with 2.6.26-rc2 on my tulsa machine
> > which is a netburst architecure hyper-threading x86_64.
> > 
> > Command line to test: #hackbench 100 process 2000
> > 
> > With ﻿2.6.26-rc1, it takes 30 seconds. But with 2.6.26-rc2/rc3, it takes 40 seconds.
> > 
> > Bisect located below patch:
> > 46151122e0a2e80e5a6b2889f595e371fe2b600d is first bad commit
> > commit 46151122e0a2e80e5a6b2889f595e371fe2b600d
> > Author: Mike Galbraith <efault@gmx.de>
> > Date:   Thu May 8 17:00:42 2008 +0200
> > 
> >     sched: fix weight calculations
> >     
> >     The conversion between virtual and real time is as follows:
> >     
> >       dvt = rw/w * dt <=> dt = w/rw * dvt
> >     
> >     Since we want the fair sleeper granularity to be in real time, we actually
> >     need to do:
> >     
> >       dvt = - rw/w * l
> > 
> > 
> > 
> > The bisect steps look stable.
> > 
> > On my core architecure machines(stoakley and tigerton), I do see improvement instead of regression,
> > like result from 31 seconds down to 28 seconds.
> > 
> > I'm not sure if hyper-threading need more cares in this situation.
> 
> Oh joy.  I'll update my poor old P4 and see what I can duplicate this.
> 
> Do you still have group scheduling enabled?
Yes.
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set

>   If so, can you turn it off
> and try again?  (when in doubt, grasp at any straw within reach;)
I reran the test for dozeons of times.
1) Background processes have impact on the result and cause result to fluctuate with 8~9 seconds;
2) After turning off most services (background processes), the result looks stable;
3) I tested both 2.6.26-rc1 and 2.6.26-rc2 with ﻿CONFIG_GROUP_SCHED=n. the first one's result
is about 30 seconds and the second one's result is about 31 seconds. So ﻿CONFIG_GROUP_SCHED is the key.

The previous results wree got with turning off most background processes.

I'm busy in other issues.

-yanmin


