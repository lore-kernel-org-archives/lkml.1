Return-Path: <linux-kernel-owner+w=401wt.eu-S932727AbZJFQlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbZJFQlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932535AbZJFQll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:41:41 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:35243 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932531AbZJFQlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:41:40 -0400
Date: Tue, 6 Oct 2009 12:34:56 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 13/20] this_cpu_ops: page allocator conversion
In-Reply-To: <20091006094544.GC18185@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0910061230170.18309@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091001212600.068637154@gentwo.org> <20091002151437.GP21906@csn.ul.ie> <alpine.DEB.1.10.0910021331020.26189@gentwo.org> <20091005094527.GB12681@csn.ul.ie> <alpine.DEB.1.10.0910051040270.16359@gentwo.org>
 <alpine.DEB.1.10.0910051055120.16359@gentwo.org> <20091006094544.GC18185@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Mel Gorman wrote:

> > -	local_irq_save(flags);
> > -	pcp = &this_cpu_ptr(zone->pageset)->pcp;
> >  	migratetype = get_pageblock_migratetype(page);
> >  	set_page_private(page, migratetype);
> >  	if (unlikely(wasMlocked))
>
> Why did you move local_irq_save() ? It should have stayed where it was
> because VM counters are updated under the lock. Only the this_cpu_ptr
> should be moving.

The __count_vm_event()? VM counters may be incremented in a racy way if
convenient. x86 usually produces non racy code (and with this patchset
will always produce non racy code) but f.e. IA64 has always had racy
updates. I'd rather shorted the irq off section.

See the comment in vmstat.h.

