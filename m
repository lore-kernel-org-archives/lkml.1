Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZJEPC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZJEPC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 11:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZJEPC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 11:02:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:53694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbZJEPC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 11:02:56 -0400
Message-ID: <4ACA0A4F.3090004@kernel.org>
Date: Tue, 06 Oct 2009 00:01:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org> <4AC7279B.3050901@kernel.org> <alpine.DEB.1.10.0910051038410.16359@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0910051038410.16359@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 05 Oct 2009 15:01:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Sat, 3 Oct 2009, Tejun Heo wrote:
> 
>>>  arch/ia64/kernel/setup.c       |    1 +
>>>  arch/powerpc/kernel/setup_64.c |    1 +
>>>  arch/sparc/kernel/smp_64.c     |    1 +
>>>  arch/x86/kernel/setup_percpu.c |    2 ++
>>>  include/linux/mm.h             |    1 +
>>>  mm/page_alloc.c                |   40 +++++++++++++++++++++++++++++-----------
>>>  mm/percpu.c                    |    2 ++
>> Hmmm... why not call this function from start_kernel() after calling
>> setup_per_cpu_areas() instead of modifying every implementation of
>> setup_per_cpu_areas()?
> 
> Because it has to be called immediately after per cpu areas become
> available. Otherwise page allocator uses will fail.

But... setup_per_cpu_area() isn't supposed to call page allocator and
start_kernel() is the only caller of setup_per_cpu_areas().

-- 
tejun
