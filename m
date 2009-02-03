Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZBCIxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZBCIxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 03:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZBCIxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 03:53:08 -0500
Received: from brick.kernel.dk ([93.163.65.50]:16925 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbZBCIxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 03:53:08 -0500
Date: Tue, 3 Feb 2009 09:51:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alberto Bertogli <albertito@blitiri.com.ar>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bio.h: If they MUST be inlined, then use __always_inline
Message-ID: <20090203085111.GT30821@kernel.dk>
References: <1233533251-30240-1-git-send-email-albertito@blitiri.com.ar> <1233533251-30240-2-git-send-email-albertito@blitiri.com.ar> <20090203005141.0214d47b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203005141.0214d47b.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03 2009, Andrew Morton wrote:
> On Sun,  1 Feb 2009 22:07:31 -0200 Alberto Bertogli <albertito@blitiri.com.ar> wrote:
> 
> > bvec_kmap_irq() and bvec_kunmap_irq() comments say they MUST be inlined,
> > so mark them as __always_inline.
> > 
> > Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
> > ---
> >  include/linux/bio.h |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/bio.h b/include/linux/bio.h
> > index 0c8e3fb..713ec6e 100644
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -445,7 +445,8 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
> >   *
> >   * This function MUST be inlined - it plays with the CPU interrupt flags.
> >   */
> > -static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
> > +static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
> > +		unsigned long *flags)
> 
> The comment is wrong - this was a sparc requirement, long since removed.

The comment probably dates back to around 2001 or so, I wasn't aware
that the non-local irq flags requirement had since been voided on sparc.

-- 
Jens Axboe

