Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbZGABU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbZGABU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932185AbZGAAtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:49:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:43818 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192AbZGAAtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:49:03 -0400
Message-ID: <4A4AB24F.6050707@kernel.org>
Date: Wed, 01 Jul 2009 09:48:15 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-arch@vger.kernel.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu> <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <20090630223138.GH1241@elte.hu> <20090630224018.GJ6760@one.firstfloor.org>
In-Reply-To: <20090630224018.GJ6760@one.firstfloor.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Jul 2009 00:48:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andi.

Andi Kleen wrote:
>> How would you allow that guest to stay on 2 virtual CPUs but still 
>> be able to hot-plug many other CPUs if the guest context rises above 
>> its original CPU utilization?
> 
> (unless you're planning to rewrite lots of possible cpu users all over
> the tree) -- the only way is to keep the percpu area small and preallocate. 
> 
> As long as the per cpu data size stays reasonable (not more than a 100-200k)
> that's very doable. It probably won't work with 4096 guest CPUs without
> wasting too much memory, but then I don't think we have any Hypervisor
> that scales to that many CPUs anyways, so it's not the biggest
> concern. For the 128CPU case it works (although i might need
> to enlarge vmalloc area a bit on 32bit) 

I don't see much reason why we should put artificial limit on how much
percpu memory could be used.  For lockdep, that much of percpu memory
is actually necessary.  Another layer of indirection surely can lessen
the pressure on the generic percpu implementation but the problem can
be solved by the generic code without too much difficulty.

Thanks.

-- 
tejun
