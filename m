Return-Path: <linux-kernel-owner+w=401wt.eu-S934167AbXHPQjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbXHPQjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764570AbXHPQi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:38:56 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:60880 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763485AbXHPQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:38:54 -0400
Date: Thu, 16 Aug 2007 11:38:50 -0500
To: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Add scaled time to taskstats based process accounting
Message-ID: <20070816163850.GU4261@austin.ibm.com>
References: <20070816070922.37B5370074@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816070922.37B5370074@localhost.localdomain>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 05:09:22PM +1000, Michael Neuling wrote:
> This adds two items to the taststats struct to account for user and
> system time based on scaling the CPU frequency and instruction issue
> rates.
> 
> Adds account_(user|system)_time_scaled callbacks which architectures
> can use to account for time using this mechanism.

There's something simple here that I just don't understand.

>  /*
> + * Account scaled user cpu time to a process.
> + * @p: the process that the cpu time gets accounted to
> + * @cputime: the cpu time spent in user space since the last update
> + */
> +void account_user_time_scaled(struct task_struct *p, cputime_t cputime)
> +{
> +	p->utimescaled = cputime_add(p->utimescaled, cputime);
> +}

My gut impression (maybe wrong?) is that the scaled time is,
in a certain sense, "more accurate" than the unscaled time.
In fact, the unscaled time gives me the impression of being
rather meaningless, as it has no particular significance
with respect to the wall-clock, and it also doesn't give
any accurate hint of how much cpu resource was actually
consumed.

If one has a cpu with frequency scaling, then when would
one ever be interested in the non-scaled time? If the answer
is "never", then why not just always use the scaled time,
instead of adding more stuff to the kernel structs?

--linas

