Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbYILEdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbYILEdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 00:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYILEdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 00:33:23 -0400
Received: from ozlabs.org ([203.10.76.45]:48652 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYILEdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 00:33:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/3] cpumask: add for_each_online_cpu_mask_nr function
Date: Fri, 12 Sep 2008 14:33:22 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       linux-kernel@vger.kernel.org
References: <20080909155013.455071000@polaris-admin.engr.sgi.com> <20080909155013.735125000@polaris-admin.engr.sgi.com>
In-Reply-To: <20080909155013.735125000@polaris-admin.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809121433.23593.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 01:50:14 Mike Travis wrote:
>   * Add for_each_online_cpu_mask_nr() function to eliminate need for
>     a common use of a temporary cpumask_t variable.  When the following
>     procedure is being used:
>
>     funcproto(cpumask_t *mask, ...)
>     {
> 	cpumask_t temp;
>
> 	cpus_and(temp, *mask, cpu_online_map);
> 	for_each_cpu_mask_nr(cpu, temp)
> 		...
>
>     If then becomes:
>
>     funcproto(cpumask_t *mask, ...)
>     {
> 	for_each_online_cpu_mask_nr(cpu, *mask)
> 		...
>
>   * Note the generic __next_cpu_and (and __next_cpu_and_nr) functions
>     allowing AND'ing with any cpumask_t variable, not just the
> cpu_online_map.

Good idea!  But I really dislike the _nr versions (too many names!).  Do we 
really need them, since by definition cpus after nr_cpu_ids are never 
online...

(And we should initialize nr_cpu_ids to NR_CPUS so even early boot works, if 
we don't already...).

Cheers,
Rusty.
