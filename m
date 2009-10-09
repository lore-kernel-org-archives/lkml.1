Return-Path: <linux-kernel-owner+w=401wt.eu-S1760415AbZJIKD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415AbZJIKD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZJIKD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:03:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZJIKD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:03:27 -0400
Date: Fri, 9 Oct 2009 12:02:49 +0200
From: Nick Piggin <npiggin@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>, chris.mason@oracle.com
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009100249.GD17818@wotan.suse.de>
References: <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <20091008123622.GA30316@wotan.suse.de> <20091008125746.GL9228@kernel.dk> <20091008132200.GB30316@wotan.suse.de> <20091009085451.GS9228@kernel.dk> <20091009095119.GT9228@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009095119.GT9228@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 11:51:19AM +0200, Jens Axboe wrote:
> Nick,
> 
> One more thing... I see you converted part of btrfs, but there's still
> this one sitting in btrfs_invalidate_inodes()
> 
>         if (atomic_read(&inode->i_count) > 1)
>                 d_prune_aliases(inode);
> 
> Not sure how best to solve that, with a __d_prune_aliases() that assumed
> the lock was held it would be easy. But perhaps you have better ideas,
> this email is more of a heads-up since perhaps you missed this spot
> (CC'ing Chris).

It's OK, you can load inode->i_count integer atomically -- in this
sequence d_prune_aliases can't have assumed anything about i_count
anyway because regardless of its type it might have changed in
between.

