Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZDNSVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZDNSVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbZDNSUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:20:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36808 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbZDNSUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:20:51 -0400
Date: Tue, 14 Apr 2009 20:20:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Nikanth Karthikesan <knikanth@suse.de>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Kleikamp <shaggy@austin.ibm.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 0/6] Handle bio_alloc failure
Message-ID: <20090414182049.GI5178@kernel.dk>
References: <200904141636.26557.knikanth@novell.com> <20090414111838.GG5178@kernel.dk> <200904141711.20378.knikanth@suse.de> <20090414181632.GI955@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414181632.GI955@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14 2009, Theodore Tso wrote:
> On Tue, Apr 14, 2009 at 05:11:19PM +0530, Nikanth Karthikesan wrote:
> > On Tuesday 14 April 2009 16:48:38 Jens Axboe wrote:
> > >
> > > It will not fail as long as __GFP_WAIT is set, which it is for all 6 of
> > > your patches.
> 
> Um, before we take out the checks, can we please make sure this is a
> guaranteed, documented behaviour?  In include/linux/page_alloc.h,
> __GFP_NOFAIL is documented as "will never fail", but it says
> absolutely nothing about __GFP_WAIT.
> 
> Some day, someone will create a static checker that will flag warnings
> when people fail to check for allocation failures, and it would be
> good if the formal semantics for __GFP_WAIT, and hence for GFP_NOFS,
> GFP_KERNEL, and GFP_USER, et. al. are defined.
> 
> We have code in fs/jbd2/transaction.c that calls kzalloc with
> GFP_NOFS|__GFP_NOFAIL, since I and many other people had the
> assumption that without __GFP_NOFAIL, an GFP_NOFS allocation could
> very well fail.
> 
> Or is this special-case behaviour which bio_alloc() guarantees, but
> not necessarily any other allocation function?

It's a bio_alloc() guarantee, it uses a mempool backing. And if you use
a mempool backing, any allocation that can wait will always be
satisfied.

-- 
Jens Axboe

