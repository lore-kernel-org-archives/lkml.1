Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZJBFvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZJBFvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 01:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbZJBFvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 01:51:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbZJBFvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 01:51:04 -0400
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Date: Fri, 2 Oct 2009 15:52:16 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19141.38160.888705.175222@notabene.brown>
Cc: Suresh Jayaraman <sjayaraman@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Miklos Szeredi <mszeredi@suse.cz>, Wouter Verhelst <w@uter.be>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 00/31] Swap over NFS -v20
In-Reply-To: message from Christoph Hellwig on Thursday October 1
References: <1254405858-15651-1-git-send-email-sjayaraman@suse.de>
	<20091001174201.GA30068@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday October 1, hch@infradead.org wrote:
> 
> The other really big one is adding a proper method for safe, page-backed
> kernelspace I/O on files.  That is not something like the grotty
> swap-tied address_space operations in this patch, but more something in
> the direction of the kernel direct I/O patches from Jenx Axboe he did
> for using in the loop driver.  But even those aren't complete as they
> don't touch the locking issue yet.

Do you have a problem with the proposed address_space operations apart
from their names including the word "swap"?  Would something like:
  direct_on, direct_off, direct_read, direct_write
be better.
Semantics being that the read and write:
  - bypass the page cache (invalidation is up to caller)
  - must not make a blocking non-emergency memory allocation
direct_on does any pre-allocation and pre-reading to ensure those
semantics and be provided.

I have wondered if an extra flag along the lines of "I don't care
about this data after a crash" would be useful.
It would be set for swap, but not set for other users.  Thus
e.g. RAID1 could easily avoid resyncing an area that was used only for
swap.

The only thing of Jens' that I could find used bmap - is there
something more recent I should look for?

> 
> Especially the latter is an absolutely essential step to make any
> progress here, and an excellent patch series of it's own as there are
> multiple users for this, like making swap safe on btrfs files, making
> the MD bitmap code actually safe or improving the loop driver.

100% agree.

Thanks,
NeilBrown
