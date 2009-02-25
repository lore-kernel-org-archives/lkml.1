Return-Path: <linux-kernel-owner+w=401wt.eu-S1762472AbZBYK3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762472AbZBYK3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762229AbZBYK2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:28:53 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48008 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762181AbZBYK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:28:51 -0500
To: hooanon05@yahoo.co.jp
CC: miklos@szeredi.hu, tomas@slax.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <15922.1235492819@jrobl> (hooanon05@yahoo.co.jp)
Subject: Re: New filesystem for Linux kernel
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl> <E1LbycM-0007FV-Rg@pomaz-ex.szeredi.hu> <15922.1235492819@jrobl>
Message-Id: <E1LcH0H-00016K-Im@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Feb 2009 11:28:37 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, hooanon05@yahoo.co.j wrote:
> > The simplest version is with all branches read-only.  That gets rid of
> > a _huge_ amount of complexity, yet it's still useful in some
> > situations.  It also deals with a lot of the basic infrastucture
> > needed for stacking.
> 
> If you really think it is a better way to get merged into mainline, then
> I'll try implement such version.

I'd personally be more motivated to review <2000 line chunks (where
each step adds new functionality and makes sense in itself), than a
20000 line filesystem all in one.

> > And that's when one starts thinking about whether unioning is really
> > the right solution.  Instead this could be implemented with a special
> > filesystem format that only contains deltas to the data, metatata and
> > directory tree.  It would be much more space efficient, could easily
> > handle renames, hard links etc, without all the hacks that
> > unionfs/aufs does.
> 
> It sounds like an ODF (on disk format) version of unionfs (while it
> seems to be inactive).
> At implementing, I don't think it easier to maintain delta of filedata
> and metadata. Since aufs has a writable branch in it, it is better and
> easier to maintain data in a branch fs.

Perhaps it's easier, but copy-up is a very inefficient operation, both
in disk space and in time.  My personal opinion is that a "delta"
filesystem would be cleaner and more useful than a writable union.
Writable union filesystems need many hacks to make them useful, such
as copy-up, whiteouts, inode number tables, virtual hard links, etc.

But that's just a thought, I haven't gone too deeply into this.

> If you think there should not be any writable branch in aufs, and all
> "write" goes to a new filesystem format, then it is equivalent to a
> writable branch, isn't it?

Yes, it should be equivalent.

> If you say "just a part of write" goes to a new fs, then I don't think
> we can support several essential features, for instance mmap.

It should be possible to support mmap.

Miklos
