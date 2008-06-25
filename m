Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYFYSgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYFYSgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 14:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYFYSf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 14:35:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58049 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbYFYSfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 14:35:55 -0400
To: jamie@shareable.org
CC: torvalds@linux-foundation.org, miklos@szeredi.hu, jens.axboe@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
In-reply-to: <20080625173837.GA10005@shareable.org> (message from Jamie Lokier
	on Wed, 25 Jun 2008 18:38:38 +0100)
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
References: <20080625124038.103406301@szeredi.hu> <20080625124121.839734708@szeredi.hu> <alpine.LFD.1.10.0806250757150.4733@hp.linux-foundation.org> <20080625173837.GA10005@shareable.org>
Message-Id: <E1KBZqG-0008OZ-Pw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 25 Jun 2008 20:35:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I also really don't think this even fixes the problems you have with 
> > FUSE/NFSD - because you'll still be reading zeroes for a truncated file. 
> > Yes, you get the rigth counts, but you don't get the right data.
> ...
> > That's "correct" from a splice() kind of standpoint (it's essentially a 
> > temporary mmap() with MAP_PRIVATE), but the thing is, it just sounds like 
> > the whole "page went away" thing is a more fundamental issue. It sounds 
> > like nfds should hold a read-lock on the file while it has any IO in 
> > flight, or something like that.
> 
> I'm thinking any kind of user-space server using splice() will not
> want to transmit zeros either, when another process truncates the file.
> E.g. Apache, Samba, etc.
> 
> Does this problem affect sendfile() users?

AFAICS it does.

And I agree, that splice should handle truncation better.  But as I
said, this affects every single filesystem out there.  And yes, my
original patch wouldn't solve this (although it wouldn't make it
harder to solve either).

However the page invalidation issue is completely orthogonal, and only
affects a few filesystems which call invalidate_complete_page2(),
namely: 9p, afs, fuse and nfs.

Miklos
