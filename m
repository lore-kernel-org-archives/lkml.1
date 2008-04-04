Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbYDDUyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbYDDUyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYDDUye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:54:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40610 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYDDUyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:54:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CoN+xG1z65ww+2DaVYh/df+eWr8ICNK0gH3gN8mcxvzkGnsYPLCUjQaFtZ+5J0nuz16Os+NzZsKdqb0h2BsynCXV95+po1xVdBJd0JMs5IUm+BEcrILqlik7LaBJGH1lkRj/+LHF3IYUFtcgLt4isuMEC1UZ7oK0gZ66LfzSu/I=
Message-ID: <6101e8c40804041354g2b065078i997e63cf03e576f0@mail.gmail.com>
Date: Fri, 4 Apr 2008 22:54:32 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH] splice: use mapping_gfp_mask
Cc: "Hugh Dickins" <hugh@veritas.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080404114609.GG29686@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0804032331190.27180@blonde.site>
	 <20080404114609.GG29686@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all!

this patch for 2.6.22.y ?

if i good see, the __generic_file_splice_read bring out to 2.6.22 ..

http://repo.or.cz/w/linux-2.6.22.y-op-patches.git
http://repo.or.cz/w/linux-2.6.22.y-op.git

On 4/4/08, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Apr 03 2008, Hugh Dickins wrote:
> > The loop block driver is careful to mask __GFP_IO|__GFP_FS out of its
> > mapping_gfp_mask, to avoid hangs under memory pressure.  But nowadays
> > it uses splice, usually going through __generic_file_splice_read.  That
> > must use mapping_gfp_mask instead of GFP_KERNEL to avoid those hangs.
> >
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > ---
> > Ought to go into 2.6.25.  For 2.6.23 and 2.6.24 stable?  Well, I've
> > not actually seen this hang on any of these, though presumably it's
> > lurking there.  Where I did see it, and test the fix, was 2.6.25-rc5-mm1:
> > whose SLUB had a disturbing predilection (since corrected) for order-4
> > allocations, even when allocating radix tree nodes.
>
> Thanks Hugh, definitely correct! I see it's already merged, so all is
> well.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
