Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZF3Wkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZF3Wkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbZF3WkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:40:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54034 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZF3WkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:40:20 -0400
Date: Wed, 1 Jul 2009 00:40:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve lpage NUMA support
Message-ID: <20090630224018.GJ6760@one.firstfloor.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <20090630223138.GH1241@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630223138.GH1241@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How would you allow that guest to stay on 2 virtual CPUs but still 
> be able to hot-plug many other CPUs if the guest context rises above 
> its original CPU utilization?

(unless you're planning to rewrite lots of possible cpu users all over
the tree) -- the only way is to keep the percpu area small and preallocate. 

As long as the per cpu data size stays reasonable (not more than a 100-200k)
that's very doable. It probably won't work with 4096 guest CPUs without
wasting too much memory, but then I don't think we have any Hypervisor
that scales to that many CPUs anyways, so it's not the biggest
concern. For the 128CPU case it works (although i might need
to enlarge vmalloc area a bit on 32bit) 

Unfortunately a few debugging subsystems seem to currently eat
much more, but those just need to be fixed to only allocate
state for actually running CPUs, not just possible ones.

I suspect we need a scripts/percpubloat.pl

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
