Return-Path: <linux-kernel-owner+w=401wt.eu-S1763698AbZDAM7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763698AbZDAM7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZDAM7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:59:20 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55402 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbZDAM7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:59:19 -0400
Date: Wed, 1 Apr 2009 14:59:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] bio: actually inline inline bvecs into bio
Message-ID: <20090401125916.GH5178@kernel.dk>
References: <1238583884-13517-1-git-send-email-tj@kernel.org> <1238583884-13517-5-git-send-email-tj@kernel.org> <20090401124709.GG5178@kernel.dk> <49D36452.9000605@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D36452.9000605@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01 2009, Tejun Heo wrote:
> Jens Axboe wrote:
> > On Wed, Apr 01 2009, Tejun Heo wrote:
> >> Impact: cleanup
> >>
> >> BIO_INLINE_VECS bvecs are inlined into bio to avoid bvec allocation
> >> for small transfers.  This was achieved by declaring zero sized bvec
> >> array at the end of bio and allocating bio with extra bytes at the
> >> end.  As BIO_INLINE_VECS is constant, there is no reason to do this
> >> allocation trick.  This patch simply defines BIO_INLINE_VECS sized
> >> bvec array at the end.  This will help fixing bio_kmalloc().
> > 
> > I don't like this, it's much nicer to do it with a zero sized array. If
> > you don't need a bio_vec, then you don't consume the extra space. I
> > guess for that to really work, we'd need one more slab and mempool
> > though. At least for non-stack bio's. I also fear that direct uses of
> > ->bi_inline_vecs[] will then crop up, making it harder to go back.
> 
> I don't know.  None of the current users cares about it and unless
> there's plan to make the number of inlined vecs variable, doing it
> separately doesn't buy much and I think we'll probably pay more by
> having extra slab and mempool.
> 
> Dropping this one isn't difficult tho.  If your objection is strong,
> I'll drop it and update the next one accordingly.  Actually, what we
> can do for bio_kmalloc() is to embed whole bvec as we know the size
> anyway.

Should not be hard, it's just a matter of what size to pass. Thanks!

-- 
Jens Axboe

