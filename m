Return-Path: <linux-kernel-owner+w=401wt.eu-S1757533AbXE3U6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbXE3U6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbXE3U6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:58:30 -0400
Received: from holomorphy.com ([66.93.40.71]:58834 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbXE3U6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:58:30 -0400
Date: Wed, 30 May 2007 13:59:27 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070530205927.GE6909@holomorphy.com>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530140229.811672406@polymtl.ca>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 10:00:34AM -0400, Mathieu Desnoyers wrote:
> Use conditional calls with lower d-cache hit in optimized version as a
> condition for scheduler profiling call.
[...]
> +	if (prof_on)
> +		BUG_ON(cond_call_arm("profile_on"));

What's the point of this BUG_ON()? The condition is a priori impossible.


On Wed, May 30, 2007 at 10:00:34AM -0400, Mathieu Desnoyers wrote:
> -	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
> +	cond_call(profile_on,
> +		profile_hit(SCHED_PROFILING, __builtin_return_address(0)));

It'd probably be prettier to stuff cond_call() inside a macro that does
something like this named profile_hit() with the old profile_hit()
renamed to __profile_hit() etc. Otherwise fine.


-- wli
