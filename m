Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZBKGDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZBKGDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 01:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZBKGDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 01:03:34 -0500
Received: from mx1.suse.de ([195.135.220.2]:54158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbZBKGDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 01:03:34 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] check bh->b_blocknr only if BH_Mapped is set
Date: Wed, 11 Feb 2009 11:31:00 +0530
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, stack.box@gmail.com
References: <200902091748.12545.knikanth@suse.de> <20090210124640.81d25a27.akpm@linux-foundation.org>
In-Reply-To: <20090210124640.81d25a27.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902111131.00539.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009 02:16:40 Andrew Morton wrote:
> On Mon, 9 Feb 2009 17:48:11 +0530
>
> Nikanth Karthikesan <knikanth@suse.de> wrote:
> > check bh->b_blocknr only if BH_Mapped is set
>
> Why?
>

b_blocknr will have a valid blocknr only when BH_Mapped is set.

> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 665d446..782c365 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -344,13 +344,13 @@ __find_get_block_slow(struct block_device *bdev,
> > sector_t block)
> >  	head = page_buffers(page);
> >  	bh = head;
> >  	do {
> > -		if (bh->b_blocknr == block) {
> > +		if (!buffer_mapped(bh))
> > +			all_mapped = 0;
> > +		else if (bh->b_blocknr == block) {
> >  			ret = bh;
> >  			get_bh(bh);
> >  			goto out_unlock;
> >  		}
> > -		if (!buffer_mapped(bh))
> > -			all_mapped = 0;
> >  		bh = bh->b_this_page;
> >  	} while (bh != head);
>
> Does this fix some user-visible misbehaviour?  If so, what was that
> behaviour?
>

No. I was looking at the "Bug 12593 - __find_get_block_slow while using 
parted." Even though this may not be the cause of that bug, I think this could 
be a potential problem elsewhere.

> Please write good changelogs.  This is not some pointless book-keeping
> exercise.  People will make decisions about which kernel versions
> patches should be merged into, and they will want to know if a
> particular patch addresses a particular problem which they are
> experiencing.  For this, they need information.
>

Sorry for the bad changelog. Thanks for pointing it out.

Thanks
Nikanth
