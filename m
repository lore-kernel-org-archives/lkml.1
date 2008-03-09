Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbYCICf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbYCICf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 21:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYCICfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 21:35:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:23149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYCICfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 21:35:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,468,1199692800"; 
   d="scan'208";a="261525378"
Date: Sat, 8 Mar 2008 18:35:15 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: suresh.b.siddha@intel.com, rjw@sisk.pl, akpm@linux-foundation.org,
       dmitry.adamushko@gmail.com, ego@in.ibm.com, mingo@elte.hu, oleg@sign.ru,
       yi.y.yang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] adjust root-domain->online span in response to hotplug event
Message-ID: <20080309023515.GC15909@linux-os.sc.intel.com>
References: <20080308015045.GB15909@linux-os.sc.intel.com> <20080308050627.4831.87630.stgit@novell1.haskins.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308050627.4831.87630.stgit@novell1.haskins.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2008 at 12:10:15AM -0500, Gregory Haskins wrote:
> Suresh Siddha wrote:
>  >
>  > -	cpus_and(*lowest_mask, task_rq(task)->rd->online, task->cpus_allowed);
>  > +	cpus_and(*lowest_mask, task->cpus_allowed, cpu_online_map);
> 
> Hi Suresh,
>    Unfortunately, this patch will introduce its own set of bugs. 

Is that because of the missing get/put_online_cpus() ?

> However, your analysis was spot-on.  I think I see the problem now.  It 
> was introduced when I put a hack in to "fix" s2ram problems in -mm as a 
> result of the new root-domain logic.  I think the following patch will 
> fix both issues:

BTW, what is use of per root domains online map, when we have global
cpu_online_map() ? Each domains span & cpu_online_map should give
domain_online_map anyhow.

And is n't it buggy if someone accesses rd->online with out get/put_online_map()

thanks,
suresh
