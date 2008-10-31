Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbYJaR6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbYJaR6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYJaR6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:58:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:36263 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbYJaR6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:58:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,523,1220252400"; 
   d="scan'208";a="457702663"
Date: Fri, 31 Oct 2008 10:58:14 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Dave Jones <davej@redhat.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: venkatesh.pallipadi@intel.com
Subject: Re: sched domains oddness.
Message-ID: <20081031175813.GC10468@linux-os.sc.intel.com>
References: <20081031162443.GA29885@redhat.com> <1225471911.7803.1596.camel@twins> <20081031170928.GB10468@linux-os.sc.intel.com> <20081031171721.GA8837@redhat.com> <20081031173737.GA11443@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031173737.GA11443@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 10:37:37AM -0700, Dave Jones wrote:
> Even curiouser.. When I unplug AC and replug it, it happens again, but slightly
> differently..
> 
> CPU0 attaching NULL sched-domain.
> CPU1 attaching NULL sched-domain.
> CPU0 attaching sched-domain:
>  domain 0: span 0-1 level MC
>   groups: 0 1
>   domain 1: span 0-1 level CPU
>    groups: 0-1
>    domain 2: span 0-1 level NODE
>     groups: 0-1
> CPU1 attaching sched-domain:
>  domain 0: span 0-1 level MC
>   groups: 1 0
>   domain 1: span 0-1 level CPU
>    groups: 0-1
>    domain 2: span 0-1 level NODE
>     groups: 0-1
> CPU0 attaching NULL sched-domain.
> CPU1 attaching NULL sched-domain.
> CPU0 attaching sched-domain:
>  domain 0: span 0-1 level MC
>   groups: 0 1
>   domain 1: span 0-1 level NODE
>    groups: 0-1
> CPU1 attaching sched-domain:
>  domain 0: span 0-1 level MC
>   groups: 1 0
>   domain 1: span 0-1 level NODE
>    groups: 0-1
> 
> 
> Note how the CPU level doesn't show up in the 2nd case.

This is def coming from sched_mc_power_savings. Some battery script
or something is getting notified and setting this value. Can you do
a grep from / for sched_mc_power_savings ?

> This still doesn't explain the flip-flop I saw just from booting,
> as that was on AC the whole time.

Boot messages are def something not related to sched_mc_power_savings.

thanks,
suresh
