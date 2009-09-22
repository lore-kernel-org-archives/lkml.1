Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZIVFdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZIVFdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZIVFdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:33:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:15140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbZIVFdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,429,1249282800"; 
   d="scan'208";a="495634365"
Subject: Re: +
 generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
 added to -mm tree
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB6FB62.3000605@cn.fujitsu.com>
References: <200907310030.n6V0Uqgw001644@imap1.linux-foundation.org>
	 <1252616988.7205.102.camel@laptop>  <4AAA0001.2060703@cn.fujitsu.com>
	 <1252696132.3756.21.camel@sbs-t61.sc.intel.com>
	 <4AADEF2F.5080504@cn.fujitsu.com>
	 <1252973802.2899.88.camel@sbs-t61.sc.intel.com>
	 <4AAEF5DC.4070308@cn.fujitsu.com>
	 <1253067602.2667.13.camel@sbs-t61.sc.intel.com>
	 <4AB1A652.1010000@cn.fujitsu.com>
	 <1253326599.3948.732.camel@sbs-t61.sc.intel.com>
	 <4AB6EB1C.5090106@cn.fujitsu.com> <1253502682.2528.4.camel@sbs-t61>
	 <4AB6FB62.3000605@cn.fujitsu.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 21 Sep 2009 22:32:33 -0700
Message-Id: <1253597553.2519.8.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-20 at 21:04 -0700, Xiao Guangrong wrote:
> 
> Suresh Siddha wrote:
> > 
> > I am referring to the missing csd_lock_wait() here that you had in the
> > first version of your patch. Let's say, if cpu X is going offline, we
> > need to ensure that the smp_call_function() initiated by cpu X (i.e.,
> > smp_call_function IPI sent to some other cpu's from cpu X) got serviced
> > before cpu X goes offline. We can't do csd_lock_wait() here, as that
> > might deadlock (as all the other cpu's are already in stop machine with
> > interrupts disabled).
> > 
> 
> It not happen because the preemption is disabled while send IPI request and
> can't schedule to stop machine path, it also stop cpu down.

Xiao, I am getting confused. I am referring to case '1' mentioned by you
here http://marc.info/?l=linux-kernel&m=125265516529139&w=2

thanks,
suresh

