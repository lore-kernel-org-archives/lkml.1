Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbZEDOVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbZEDOVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 10:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZEDOU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 10:20:59 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:44755 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZEDOU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 10:20:58 -0400
Date: Mon, 4 May 2009 10:08:50 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090502210147.GA23766@Krystal>
Message-ID: <alpine.DEB.1.10.0905041006310.17937@qirst.com>
References: <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal> <alpine.DEB.1.10.0904301559500.11923@qirst.com>
 <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com> <20090501192142.GA18339@Krystal> <alpine.DEB.1.10.0905011527260.7795@qirst.com> <20090502210147.GA23766@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 May 2009, Mathieu Desnoyers wrote:

> Modifying mmzone.h "struct per_cpu_pageset" so it uses percpu dynamic
> allocation seems to be the far-reaching part of the modification (of a
> subsystem I'm not completely familiar with, including NUMA special
> cases). Is there any patch already doing this kind of modification
> floating around ?

Yes. Its was part of the original cpu alloc patchset. One reason to do cpu
alloc was to clean up the current problem with a having to allocate for
NR_CPUS in the page allocator. That in turn would result in the ability to
use the fast percpu ops to optimize the allocator paths. Hopefully we can
end up with page allocator alloc/free operations that do not need to
disable interrupts.

> I'd be glad to give a try at some percpu_add_return counters experiments
> if percpu struct per_cpu_pageset allocation happens to be already
> available.

Look at the cpu alloc patchset following the link that I posted.


