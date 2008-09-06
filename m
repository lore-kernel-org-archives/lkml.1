Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYIFQSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYIFQSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 12:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYIFQSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 12:18:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46227 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYIFQSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:18:39 -0400
Date: Sat, 6 Sep 2008 18:17:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Andi Kleen <andi@firstfloor.org>,
       Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org
Subject: Re: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Message-ID: <20080906161740.GB10238@elte.hu>
References: <20080906143318.GA23621@elte.hu> <20080905215452.GF11692@us.ibm.com> <20080906000154.GC18288@one.firstfloor.org> <20080906153855.7260.E1E9C6FF@jp.fujitsu.com> <9031244.1220716855172.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9031244.1220716855172.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* kamezawa.hiroyu@jp.fujitsu.com <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> > Removing those limitations of kernel-space allocations should indeed 
> > be done in baby steps - and whether it's worth turning such memory 
> > into completely generic kernel memory is an open question.
>
> I think generic kernel space memory hotplug will never be available.

yeah, most likely. (It's possible technically even on a native kernel - 
just very expensive to various aspects of the kernel.)

> > But the fact that a piece of memory is not fully generic is no 
> > reason not to allow users to create special, capability-limited RAM 
> > resources like they can already do via hugetlbfs or ramfs, as long 
> > as the the capability limitations are advertised clearly.
>
> Hmm, adding a feature like
>  - offline some memory at boot.
>  - online-memory-as-hugeltb mode
>   
> is useful for generic pc users ?

yeah - it's actually the way how hugetlb should be done. Plus expand 
gbpages to hugetlbfs and hotplug memory on Barcelona CPUs and you can do 
user-space apps that can run for a long time without any TLB misses. 
_That_ might make sense to explore in practice. (i'm not holding my 
breath though, TLB misses are _fast_ on the best x86 CPUs.)

But we wont be able to make such experiments without having the 
capability on x86. So i'd like to break the catch-22 by accepting all 
this into arch/x86, it certainly is simple and makes some sense, it's 
just that i'm not that convinced about it personally at the moment.

So feel free to turn it all into a killer feature (make hugetlb backed 
memory transparent to user-space, etc. etc.) that high-performance 
computing users strive for and all that will change. Please send the 
reshaped patches so we can move past the 'what if' discussion phase ;-)

	Ingo
