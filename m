Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbZEKPSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbZEKPSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756360AbZEKPSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:18:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46152 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbZEKPSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:18:03 -0400
To: torvalds@linux-foundation.org
CC: miklos@szeredi.hu, jens.axboe@oracle.com, max@duempel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <alpine.LFD.2.01.0905070845590.4983@localhost.localdomain>
	(message from Linus Torvalds on Thu, 7 May 2009 08:55:03 -0700 (PDT))
Subject: Re: [patch 0/3] make splice more generic
References: <20090507133734.450612199@szeredi.hu> <alpine.LFD.2.01.0905070845590.4983@localhost.localdomain>
Message-Id: <E1M3XFU-0001Ra-K7@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 11 May 2009 17:17:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Linus Torvalds wrote:
> On Thu, 7 May 2009, Miklos Szeredi wrote:
> > 
> > One more generalization would be to allow splice to work on two
> > non-pipes, using an internal intermediate pipe, a-la do_splice_direct().
> 
> You can't do that without some painful issues.
> 
> Or rather, you can only do it trivially for the one case where we 
> _already_ do that, namely "sendfile()". That's exactly what sendfile() is 
> now.

Hmm yeah, almost exactly: sendfile doesn't have a "destination offset"
argument.

> That said, maybe we could allow it in a few more cases. Or maybe people 
> think the simplification in user interfaces is worth making the IO be 
> non-interruptible (but still killable, for example, at which point the 
> buffered data really is dropped - but that's not different from having 
> the buffers in user space, so at that point it's ok).

That's a hard decision.  I think it's better to leave it in its
current form.  That means more complexity in the apps, but less
unexpected nastiness from being non-interruptible.

One more interesting use of splice() would be for things like speeding
up "cp" on network filesystems and similarly for fs which can
refcount/COW data blocks.  Seems like BTRFS already has an ioctl for
this, wouldn't it be nice to do it with splice()?

Thanks,
Miklos
