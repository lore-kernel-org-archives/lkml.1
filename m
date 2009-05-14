Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbZENRzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbZENRzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZENRyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:54:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34984 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZENRyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:54:49 -0400
To: jens.axboe@oracle.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, max@duempel.org,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20090514172935.GR4140@kernel.dk> (message from Jens Axboe on
	Thu, 14 May 2009 19:29:35 +0200)
Subject: Re: [patch 2/3] splice: implement default splice_read method
References: <20090507133734.450612199@szeredi.hu> <20090507133748.161689790@szeredi.hu> <20090512223500.d7ef4648.akpm@linux-foundation.org> <20090513063707.GC4140@kernel.dk> <E1M4ALP-0005za-1i@pomaz-ex.szeredi.hu> <20090514172935.GR4140@kernel.dk>
Message-Id: <E1M4f8b-0000Tb-GI@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 May 2009 19:54:33 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Jens Axboe wrote:

> > The bigger problem is that the default_file_splice_write()
> > implementation in the other patch does the same (it calls
> > buf->ops->map() on all buffers).
> 
> Yep that's even worse, as that should go BUG() pretty much immediately
> when the KM_USER0 slot is reused!

No, ->map() calls plain kmap() if "atomic" argument is zero.
Nevertheless the deadlock due to multiple kmaps is still possible.

> > Hmm.  Simple solution would be to do a write() for each buffer.  But
> > this only affects HIGHMEM kernels, so it's a bit pointless to do that
> > on all archs.  Sigh...
> 
> It is unfortunate, we are going to be stuck with that for some time
> still...

I'm going to be offline till next monday, I'll post a fix after that.

Thanks,
Miklos
