Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYBDUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYBDUwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756176AbYBDUwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:52:20 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59272 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbYBDUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:52:19 -0500
To: hch@lst.de
CC: npiggin@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20080204193939.GA19236@lst.de> (message from Christoph Hellwig
	on Mon, 4 Feb 2008 14:39:39 -0500)
Subject: Re: [patch 0/3] add perform_write to a_ops
References: <20080204170409.991123259@szeredi.hu> <20080204193939.GA19236@lst.de>
Message-Id: <E1JM8IQ-0003pP-Dw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 04 Feb 2008 21:52:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > a_ops->perform_write() was left out from Nick Piggin's new a_ops
> > patchset, as it was non-essential, and postponed for later inclusion.
> > 
> > This short series reintroduces it, but only adds the fuse
> > implementation and not simple_perform_write(), which I'm not sure
> > would be a significant improvement.
> > 
> > This allows larger than 4k buffered writes for fuse, which is one of
> > the most requested features.
> > 
> > This goes on top of the "fuse: writable mmap" patches.
> 
> Please don't do this, but rather implement your own .aio_write.  There's
> very little in generic_file_aio_write that wouldn't be handle by
> ->perform_write and we should rather factor those up or move to higher
> layers than adding this ill-defined abstraction.
> 

Moving up to higher layers might not be possible, due to lock/unlock
of i_mutex being inside generic_file_aio_write().

But with fuse being the only user, it's not a huge issue duplicating
some code.

Nick, were there any other candidates, that would want to use such an
interface in the future?

Thanks,
Miklos
