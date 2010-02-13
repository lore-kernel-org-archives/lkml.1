Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab0BMSku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 13:40:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:57927 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757729Ab0BMSks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 13:40:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,468,1262592000"; 
   d="scan'208";a="772667209"
Subject: Re: [patch] sched: fix SMT scheduler regression in
 find_busiest_queue()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ma, Ling" <ling.ma@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>
In-Reply-To: <20100213182748.GB5882@dirshya.in.ibm.com>
References: <1266023662.2808.118.camel@sbs-t61.sc.intel.com>
	 <20100213182748.GB5882@dirshya.in.ibm.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Sat, 13 Feb 2010 10:39:36 -0800
Message-Id: <1266086376.2677.45.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-13 at 11:27 -0700, Vaidyanathan Srinivasan wrote:
> The fix that you have posted will solve the problem described.

Thanks. This SMT scheduler regression is critical for performance and
would like Ingo/Peterz to push this to Linus as soon as possible. We can
fix other known issues when we have patches ready and acceptable to
everyone. Agree?

> However we need to make sched_smt_powersavings also work by increasing
> the group capacity and allowing two tasks to run in a core.

I don't think you saying that this patch breaks sched_smt_powersavings?
If so, We need to address power-saving aspect differently. Atleast this
is not as critical, as we don't have any customer who is using the
smt/mc powersavings tunables.

> As Peter mentioned, SD_PREFER_SIBLING flag is meant to spread the work
> across group at any sched domain so that the solution will work for
> pre-Nehalem quad cores also.  But it still needs some work to get it
> right.

Agree.

> The solution you have posted will not work for non-HT quad cores where
> we want the tasks to be spread across cache domains for best
> performance though not a severe performance regression as in the case
> of Nehalem.

This is completely different issue from this patch and I started another
thread for this.

thanks
suresh


