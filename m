Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZJBFTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZJBFTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZJBFTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:19:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:51937 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbZJBFTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:19:20 -0400
From: Neil Brown <neilb@suse.de>
To: David Rientjes <rientjes@google.com>
Date: Fri, 2 Oct 2009 15:20:34 +1000
Message-ID: <19141.36258.926599.862333@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 01/31] mm: serialize access to min_free_kbytes
In-Reply-To: message from David Rientjes on Thursday October 1
References: <1254405871-15687-1-git-send-email-sjayaraman@suse.de>
	<alpine.DEB.1.00.0910011330430.27559@chino.kir.corp.google.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday October 1, rientjes@google.com wrote:
> On Thu, 1 Oct 2009, Suresh Jayaraman wrote:
> 
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl> 
> > 
> > There is a small race between the procfs caller and the memory hotplug caller
> > of setup_per_zone_wmarks(). Not a big deal, but the next patch will add yet
> > another caller. Time to close the gap.
> > 
> 
> By "next patch," you mean "mm: emegency pool" (patch 08/31)?

:-)  It is always safer to say "a subsequent patch", isn't it....

> 
> If so, can't you eliminate var_free_mutex entirely from that patch and 
> take min_free_lock in adjust_memalloc_reserve() instead?

adjust_memalloc_reserve does a test alloc/free cycle under a lock.
That cannot be done under a spin-lock, it must be a mutex.
So I don't think you can eliminate var_free_mutex.

Thanks,
NeilBrown

> 
>  [ __adjust_memalloc_reserve() would call __setup_per_zone_wmarks()
>    under lock instead, now. ]
