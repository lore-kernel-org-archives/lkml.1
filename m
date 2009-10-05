Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZJEOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZJEOqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZJEOqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:46:19 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52498 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752119AbZJEOqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:46:18 -0400
Date: Mon, 5 Oct 2009 10:39:20 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 12/20] Move early initialization of pagesets
 out of zone_wait_table_init()
In-Reply-To: <4AC7279B.3050901@kernel.org>
Message-ID: <alpine.DEB.1.10.0910051038410.16359@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091001212559.879284755@gentwo.org> <4AC7279B.3050901@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Oct 2009, Tejun Heo wrote:

> >  arch/ia64/kernel/setup.c       |    1 +
> >  arch/powerpc/kernel/setup_64.c |    1 +
> >  arch/sparc/kernel/smp_64.c     |    1 +
> >  arch/x86/kernel/setup_percpu.c |    2 ++
> >  include/linux/mm.h             |    1 +
> >  mm/page_alloc.c                |   40 +++++++++++++++++++++++++++++-----------
> >  mm/percpu.c                    |    2 ++
>
> Hmmm... why not call this function from start_kernel() after calling
> setup_per_cpu_areas() instead of modifying every implementation of
> setup_per_cpu_areas()?

Because it has to be called immediately after per cpu areas become
available. Otherwise page allocator uses will fail.

