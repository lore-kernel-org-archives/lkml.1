Return-Path: <linux-kernel-owner+w=401wt.eu-S1764151AbZDAMrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764151AbZDAMrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763701AbZDAMrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:47:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47020 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763196AbZDAMrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:47:11 -0400
Date: Wed, 1 Apr 2009 14:47:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] bio: actually inline inline bvecs into bio
Message-ID: <20090401124709.GG5178@kernel.dk>
References: <1238583884-13517-1-git-send-email-tj@kernel.org> <1238583884-13517-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238583884-13517-5-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01 2009, Tejun Heo wrote:
> Impact: cleanup
> 
> BIO_INLINE_VECS bvecs are inlined into bio to avoid bvec allocation
> for small transfers.  This was achieved by declaring zero sized bvec
> array at the end of bio and allocating bio with extra bytes at the
> end.  As BIO_INLINE_VECS is constant, there is no reason to do this
> allocation trick.  This patch simply defines BIO_INLINE_VECS sized
> bvec array at the end.  This will help fixing bio_kmalloc().

I don't like this, it's much nicer to do it with a zero sized array. If
you don't need a bio_vec, then you don't consume the extra space. I
guess for that to really work, we'd need one more slab and mempool
though. At least for non-stack bio's. I also fear that direct uses of
->bi_inline_vecs[] will then crop up, making it harder to go back.

-- 
Jens Axboe

