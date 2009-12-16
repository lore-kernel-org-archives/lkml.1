Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZLPAwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZLPAwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756613AbZLPAwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:52:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:48534 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755815AbZLPAwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:52:40 -0500
Message-ID: <4B282F9E.7070902@kernel.org>
Date: Wed, 16 Dec 2009 09:53:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V7 1/8] this_cpu_ops: page allocator conversion
References: <20091214220320.665065925@quilx.com> <20091214220339.160361197@quilx.com> <4B270841.2000203@kernel.org> <alpine.DEB.2.00.0912150855040.16754@router.home>
In-Reply-To: <alpine.DEB.2.00.0912150855040.16754@router.home>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On 12/16/2009 12:04 AM, Christoph Lameter wrote:
> A static array would have to be dimensioned to NR_CPUS. That is one thing
> we are trying to avoid.
> 
> The assignment of the pageset "percpu" pointer does not mean that the pcp
> is usable. It must first be properly initialized through setup_pageset().
>
> setup_pageset() is run for each cpu. zone->pageset is the same for all
> cpus that is why it is in zone_pcp_init() and not in setup_pageset().
> 
> The boot pageset initialization was moved into __build_all_zonelists(). We
> could move the zone->pageset initialization there too?

Maybe that is a bit less scary. (at least for me :-) The reason why
I'm a bit worried is that different architectures handle percpu
pointers differently before setup_per_cpu_areas().  x86 sets up the
offsets and stuff such that cpu0 can access the original percpu
section in the kernel image.  ia64 sets up everything properly way
before setup_per_cpu_areas() and in some archs percpu pointers are
completely invalid before setup_per_cpu_areas().  So, percpu pointer
being handled in generic code which is being called before percpu
setup is a bit worrying.

Another thing is that there were attempts to simplify memory
initialization stages such that bootmem is removed and page / k*
allocators can be used earlier which kind of puts percpu allocator in
the dependency loop but I don't think it's something we need to worry
about at this point.

Thanks.

-- 
tejun
