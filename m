Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbYGZEWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbYGZEWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 00:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750810AbYGZEWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 00:22:32 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:10127 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYGZEWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 00:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JZQEBxJLCktVO2WvAXwunhj7pHI2Xndeahnb7mlMzz8DW713NrywNDXJCRnAFFdUf7
         aOOuo0c2+Ha4wVwS2w+Ycp+qdDv94zrx6FIpi6kFI3hU/1MLNeloIzybExqsa0sXMnXf
         BesCi67x4CNVEXYfPOqTYWLzSxSLtk4ukzL00=
Message-ID: <91b13c310807252122k6c0f589i901644d3c7ed42d8@mail.gmail.com>
Date: Sat, 26 Jul 2008 12:22:29 +0800
From: "rae l" <crquan@gmail.com>
To: "Jens Axboe" <axboe@kernel.dk>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] bio: make use of bvec_nr_vecs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1217009473-25878-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217009473-25878-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 2:11 AM, Denis ChengRq <crquan@gmail.com> wrote:
>        bvl = mempool_alloc(bs->bvec_pools[*idx], gfp_mask);
> -       if (bvl) {
> -               struct biovec_slab *bp = bvec_slabs + *idx;
> -
> -               memset(bvl, 0, bp->nr_vecs * sizeof(struct bio_vec));
> -       }
> +       if (bvl)
> +               memset(bvl, 0, bvec_nr_vecs(*idx) * sizeof(struct bio_vec));
and if we have a mempool_zalloc, this can be more simplified,

there was no mempool_zalloc yet, should we create it inlined with
__GFP_ZERO, for this and further use?
