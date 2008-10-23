Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbYJWXCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbYJWXCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbYJWXB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:01:56 -0400
Received: from ozlabs.org ([203.10.76.45]:55180 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYJWXBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:01:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [bug] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct cpumask
Date: Fri, 24 Oct 2008 10:01:53 +1100
User-Agent: KMail/1.9.10
Cc: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <20081023125529.GA18327@elte.hu>
In-Reply-To: <20081023125529.GA18327@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241001.54175.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2008 23:55:29 Ingo Molnar wrote:
> ok, the new cpumask code blew up in -tip testing, with various sorts of
> slab corruptions during scheduler init:
...
> i suspect it's due to:
>
> 01b8bd9: sched: cpumask: get rid of boutique sched.c allocations, use
> cpumask_va

Just drop it.  It's a conversion, so it doesn't really belong in this "new 
API" stuff.  Nothing depends on it, and we need to be sure it's that which is 
causing the blowup.

Oh, and here's (one) problem:

		*nodemask = node_to_cpumask(cpu_to_node(i));

This is an old-style cpumask_t assigment, but nodemask wasn't allocated 
NR_CPUS bits if CONFIG_CPUMASK_OFFSTACK.  This is why assignment is banned 
(and will eventually fail compile), but that conversion hasn't been done on 
sched.c yet, so this patch is ahead of its time.

Thanks,
Rusty.
