Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZENSAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZENSAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 14:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZENSAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 14:00:07 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40079 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbZENSAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 14:00:05 -0400
Date: Thu, 14 May 2009 20:00:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, max@duempel.org, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] splice: implement default splice_read method
Message-ID: <20090514180003.GU4140@kernel.dk>
References: <20090507133734.450612199@szeredi.hu> <20090507133748.161689790@szeredi.hu> <20090512223500.d7ef4648.akpm@linux-foundation.org> <20090513063707.GC4140@kernel.dk> <E1M4ALP-0005za-1i@pomaz-ex.szeredi.hu> <20090514172935.GR4140@kernel.dk> <E1M4f8b-0000Tb-GI@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M4f8b-0000Tb-GI@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14 2009, Miklos Szeredi wrote:
> On Thu, 14 May 2009, Jens Axboe wrote:
> 
> > > The bigger problem is that the default_file_splice_write()
> > > implementation in the other patch does the same (it calls
> > > buf->ops->map() on all buffers).
> > 
> > Yep that's even worse, as that should go BUG() pretty much immediately
> > when the KM_USER0 slot is reused!
> 
> No, ->map() calls plain kmap() if "atomic" argument is zero.
> Nevertheless the deadlock due to multiple kmaps is still possible.

It's buggy either way, didn't check whether you used atomic maps or not.

> > > Hmm.  Simple solution would be to do a write() for each buffer.  But
> > > this only affects HIGHMEM kernels, so it's a bit pointless to do that
> > > on all archs.  Sigh...
> > 
> > It is unfortunate, we are going to be stuck with that for some time
> > still...
> 
> I'm going to be offline till next monday, I'll post a fix after that.

Until monday, or the monday after? I'm tempted to revert the
readv/writev part until this is settled, we cannot ship it as-is.

-- 
Jens Axboe

