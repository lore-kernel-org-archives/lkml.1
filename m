Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbZJ1IAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbZJ1IAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 04:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932615AbZJ1IAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 04:00:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:51810 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576AbZJ1IAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 04:00:19 -0400
Message-ID: <4AE7FA12.2070905@kernel.org>
Date: Wed, 28 Oct 2009 09:00:18 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20091028074832.GC19402@elte.hu>
In-Reply-To: <20091028074832.GC19402@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo Molnar wrote:
> Hm, we are now further complicating the bootmem model.
> 
> I think we could remove the bootmem allocator middle man altogether. 
> 
> This can be done by initializing the page allocator sooner and by 
> extending (already existing) 'reserve memory early on' mechanisms in 
> architecture code. (the reserve_early*() APIs in x86 for example)
...
> reserve_early() might need some small amount of extra work before it can 
> be used as a generic early allocator - like adding a node field to it 
> (so that the buddy can then pick those ranges up in a NUMA aware 
> fashion) - but nothing very complex.

ISTR an attempt to initialize the kmalloc allocator much earlier
during boot such that it can completely replace the bootmem allocator,
which would nicely remove all the complications although it may
require the kmalloc allocator to go through more complex boot
strapping steps.  I didn't follow how that went.  Did it prove to be
unworkable?

As for percpu allocator, as long as it can grab memory in NUMA aware
way, changing shouldn't be a problem at all.  The good thing about
bootmem allocator is that it is generic and standardizes memory
bootstrapping across different architectures.  As long as that can be
maintained, makings things simpler would be great.

Thanks.

-- 
tejun
