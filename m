Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbXELFDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbXELFDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 01:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbXELFDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:03:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58524 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754627AbXELFDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:03:07 -0400
Date: Fri, 11 May 2007 22:03:14 -0700
From: Paul Jackson <pj@sgi.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: nickpiggin@yahoo.com.au, ray-lk@madrabbit.org, mingo@elte.hu,
       ck@vds.kolivas.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Message-Id: <20070511220314.f7af1d31.pj@sgi.com>
In-Reply-To: <200705121446.04191.kernel@kolivas.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<2c0942db0705092252n13a6a79aq39f13fcfae534de2@mail.gmail.com>
	<4642C416.3000205@yahoo.com.au>
	<200705121446.04191.kernel@kolivas.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Swap prefetch is not cpuset aware so make the config option depend on !CPUSETS.

Ok.

Could you explain what it means to say "swap prefetch is not cpuset aware",
or could you give a rough idea of what it would take to make it cpuset aware?

I wouldn't go so far as to say that no one would ever want to prefetch and
use cpusets at the same time, but I will grant that it's not a sufficiently
important need that it should block a useful prefetch implementation on
non-cpuset systems.

One case that would be useful, however, is to handle prefetch in the case
that cpusets are configured into ones kernel, but one is not making any
real use of them ('number_of_cpusets' <= 1).  That will actually be the
most common case for the major distribution(s) that enable cpusets by
default in their builds, for most arch's including the arch's popular
on desktops.

So what would it take to allow CONFIG'ing both prefetch and cpusets on,
but having prefetch dynamically adapt to the presence of active cpuset
usage, perhaps by basically shutting down if it can't easily do any
better?  I could certainly entertain requests to callout to some
prefetch routine from the cpuset code, at the critical points that
cpusets transitioned in or out of active use.

Semi-separate issue -- is it just cpusets that aren't prefetch friendly,
or is it also mm/mempolicy (mbind, set_mempolicy) as well?

For that matter, even if neither mm/mempolicy nor cpusets are used, on
systems with multiple memory nodes (not all memory equally distant from
all CPUs, aka NUMA), could prefetch cause some sort of shuffling of
memory placement, which might harm the performance of an HPC (High
Performance Computing) application with carefully tuned memory
placement.  Granted, this -is- getting to be a corner case.  Most HPC
apps running on NUMA hardware are making at least some use of
mm/mempolicy or cpusets.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
