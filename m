Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYHUGuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYHUGuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYHUGuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:50:04 -0400
Received: from mga06.intel.com ([134.134.136.21]:34910 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755187AbYHUGuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:50:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,243,1217833200"; 
   d="scan'208";a="327943705"
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <20080821061622.GC14572@elte.hu>
References: <20080811185008.GA29291@linux.vnet.ibm.com>
	 <1912726331.25608.235.camel@ymzhang>
	 <20080817115035.GA32223@linux.vnet.ibm.com>
	 <20080818052155.GA5063@linux.vnet.ibm.com>
	 <1219217089.8781.27.camel@ymzhang> <1219218089.10800.404.camel@twins>
	 <20080820105141.GA18226@elte.hu> <1219239137.8651.52.camel@twins>
	 <20080820134708.GA20648@elte.hu> <1219285502.8781.35.camel@ymzhang>
	 <20080821061622.GC14572@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 Aug 2008 14:48:26 +0800
Message-Id: <1219301306.8781.55.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-21 at 08:16 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > > ok, i've applied this one to tip/sched/urgent instead of the 
> > > feature-disabling patchlet. Yanmin, could you please check whether this 
> > > one does the trick?
> >
> > This new patch almost doesn't help volanoMark. Pls. use the patch 
> > which sets ﻿LB_BIAS=1 by default.
> 
> ok. That also removes the kernel.h complications ;-)
Sorry, I have new update.
Originally, I worked on 2.6.27-rc1. I just move to 2.6.27-rc3 and found
something defferent when CONFIG_GROUP_SCHED=n.

With 2.6.27-rc3, on my 8-core stoakley, all volanoMark regression disappears,
no matter if I enable LB_BIAS. On 16-core tigerton, the regression is still
there if I don't enable LB_BIAS and regression becomes 11% from 65%.

8-core stoakley:
﻿2.6.26_nogroup			340669
﻿2.6.27-rc1_nogroup		267237
2.6.27-rc1_nogroup+LB_BIAS=1	330693
2.6.27-rc3_nogroup		352193
2.6.27-rc3_nogroup+LB_BIAS=1	355872

16-core tigerton:
﻿2.6.26_nogroup			539644
﻿2.6.27-rc1_nogroup		309334
2.6.27-rc1_nogroup+LB_BIAS=1	478360
2.6.27-rc3_nogroup		348426
2.6.27-rc3_nogroup+LB_BIAS=1	483150

-yanmin


