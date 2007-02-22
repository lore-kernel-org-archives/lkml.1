Return-Path: <linux-kernel-owner+w=401wt.eu-S1751915AbXBVVaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbXBVVaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXBVVaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:30:21 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:57385 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbXBVVaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:30:20 -0500
To: trond.myklebust@fys.uio.no
CC: miklos@szeredi.hu, staubach@redhat.com, akpm@linux-foundation.org,
       hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1172178253.6382.12.camel@heimdal.trondhjem.org> (message from
	Trond Myklebust on Thu, 22 Feb 2007 16:04:13 -0500)
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu>
	 <20070221202615.a0a167f4.akpm@linux-foundation.org>
	 <E1HK8hU-0005Mq-00@dorka.pomaz.szeredi.hu> <45DDD55F.4060106@redhat.com>
	 <E1HKIN1-0006RX-00@dorka.pomaz.szeredi.hu> <45DDF9C1.4090003@redhat.com>
	 <E1HKKrL-0006k6-00@dorka.pomaz.szeredi.hu> <1172178253.6382.12.camel@heimdal.trondhjem.org>
Message-Id: <E1HKLUp-0006qY-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Feb 2007 22:28:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This still does not address the situation where a file is 'permanently'
> > > mmap'd, does it?
> > 
> > So?  If application doesn't do msync, then the file times won't be
> > updated.  That's allowed by the standard, and so portable applications
> > will have to call msync.
> 
> It is allowed, but it is clearly not useful behaviour. Nowhere is it set
> in stone that we should be implementing just the minimum allowed.

You're right.  In theory, at least.  But in practice I don't think
this matters.  Show me an application that writes to a shared mapping
then doesn't call either msync or munmap and doesn't even exit.

If there were lot of these apps, then this bug would have been fixed
lots of years earlier.  In fact there are _very_ few apps writing to
shared mappings at all.

Applications should be encouraged to call msync(MS_ASYNC) because:

  - it's very fast (basically a no-op) on recent linux kernels

  - it's the only portable way to guarantee, that the data you written
    will _ever_ hit the disk.

There's really no downside to using msync(MS_ASYNC) in your
application, so making an effort to support applications that don't do
this is stupid, IMO.

Thanks,
Miklos
