Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZJCK32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZJCK32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 06:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbZJCK32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 06:29:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:50799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZJCK31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 06:29:27 -0400
Message-ID: <4AC7279B.3050901@kernel.org>
Date: Sat, 03 Oct 2009 19:29:47 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: cl@linux-foundation.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org>
In-Reply-To: <20091001212559.879284755@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 03 Oct 2009 10:28:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cl@linux-foundation.org wrote:
> Explicitly initialize the pagesets after the per cpu areas have been
> initialized. This is necessary in order to be able to use per cpu
> operations in later patches.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  arch/ia64/kernel/setup.c       |    1 +
>  arch/powerpc/kernel/setup_64.c |    1 +
>  arch/sparc/kernel/smp_64.c     |    1 +
>  arch/x86/kernel/setup_percpu.c |    2 ++
>  include/linux/mm.h             |    1 +
>  mm/page_alloc.c                |   40 +++++++++++++++++++++++++++++-----------
>  mm/percpu.c                    |    2 ++

Hmmm... why not call this function from start_kernel() after calling
setup_per_cpu_areas() instead of modifying every implementation of
setup_per_cpu_areas()?

Thanks.

-- 
tejun
