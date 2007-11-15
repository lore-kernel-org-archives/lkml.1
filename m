Return-Path: <linux-kernel-owner+w=401wt.eu-S1762023AbXKOUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762023AbXKOUL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 15:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbXKOULs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 15:11:48 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34516 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932126AbXKOULr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 15:11:47 -0500
To: a.p.zijlstra@chello.nl
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1195156900.22457.32.camel@lappy> (message from Peter Zijlstra on
	Thu, 15 Nov 2007 21:01:39 +0100)
Subject: Re: [RFC] fuse writable mmap design
References: <E1IshIR-0000fE-00@dorka.pomaz.szeredi.hu>
	 <1195154530.22457.16.camel@lappy>
	 <E1IskWl-0000oJ-00@dorka.pomaz.szeredi.hu>
	 <1195155759.22457.29.camel@lappy>
	 <E1Iskpw-0000qY-00@dorka.pomaz.szeredi.hu> <1195156900.22457.32.camel@lappy>
Message-Id: <E1Isl3p-0000rl-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 15 Nov 2007 21:11:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > OTOH, I'm thinking about adding a per-fs limit (adjustable for
> > privileged mounts) of dirty+writeback.
> > 
> > I'm not sure how hard would it be to add support for this into
> > balance_dirty_pages().  So I'm thinking of a parameter in struct
> > backing_dev_info that is used to clip the calculated per-bdi threshold
> > below this maximum.
> > 
> > How would that affect the proportions algorithm?  What would happen to
> > the unused portion?  Would it adapt to the slowed writeback and
> > allocate it to some other writer?
> 
> The unused part is gone, I've not yet found a way to re-distribute this
> fairly.
> 
> [ It's one of my open-problems, I can do a min_ratio per bdi, but not
>   yet a max_ratio ]

OK, I'll bear this in mind.

Limiting the number of dirty+writeback to << dirty_thresh could still
make sense, since it could prevent a nasty filesystem from pinning
lots of kernel memory (which it can do without fuse in other ways, so
this is not very important IMO).

Miklos
