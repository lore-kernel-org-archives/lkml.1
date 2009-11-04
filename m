Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbZKDHgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbZKDHgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZKDHgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:36:09 -0500
Received: from [95.166.99.235] ([95.166.99.235]:46255 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZKDHgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:36:09 -0500
Date: Wed, 4 Nov 2009 08:36:14 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: yodor1@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at mm/highmem.c:259
Message-ID: <20091104073613.GR8742@kernel.dk>
References: <4AEF4181.9080100@gmail.com> <20091103104044.GC22235@kernel.dk> <E1N5Zwf-0005r9-Fn@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1N5Zwf-0005r9-Fn@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04 2009, Miklos Szeredi wrote:
> On Tue, 3 Nov 2009, Jens Axboe wrote:
> > Looks like another victim of the confusing kmap() vs kmap_atomic() API
> > differences.
> > 
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index a3492f7..8a219bd 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -1599,7 +1599,7 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
> >  			kaddr += copy;
> >  		}
> >  
> > -		kunmap(map);
> > +		kunmap(page);
> >  	}
> >  
> >  	return 0;
> 
> Todor, thanks for the bug report!  Jens, can I add your Signed-off-by?

Yes certainly, go ahead. I should have signed it off when posting.

-- 
Jens Axboe

