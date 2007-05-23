Return-Path: <linux-kernel-owner+w=401wt.eu-S1762678AbXEWJEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678AbXEWJEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbXEWJD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:03:57 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:39249 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbXEWJD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:03:56 -0400
To: viro@ftp.linux.org.uk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-reply-to: <20070523082918.GP4095@ftp.linux.org.uk> (message from Al Viro on
	Wed, 23 May 2007 09:29:18 +0100)
Subject: Re: [RFC PATCH] file as directory
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <20070523070306.GM4095@ftp.linux.org.uk> <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu> <20070523073658.GO4095@ftp.linux.org.uk> <E1HqlqT-0001KD-00@dorka.pomaz.szeredi.hu> <20070523082918.GP4095@ftp.linux.org.uk>
Message-Id: <E1HqmkO-0001R4-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 23 May 2007 11:03:08 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, May 23, 2007 at 10:05:21AM +0200, Miklos Szeredi wrote:
> > > Er...  These mounts might not be propagated, but what about a bind
> > > over another instance of such file in master tree?
> > 
> > So your question is, which mount takes priority on the lookup?  It
> > probably should be the propagated real mount, rather than the
> > dir-on-file one, shouldn't it?
> 
> There might be dragons in that area...
>  
> > > > I think they should be the same superblock, same dentry.  What would
> > > > be the advantage of doing otherwise?
> > > 
> > > Then you are going to have interesting time with locking in final mntput().
> > 
> > Final mntput of what?
> 
> When the last reference to your mount goes away.

I still don't get it where the superblock comes in.  The locking is
"interesting" in there, yes.  And I haven't completely convinced
myself it's right, let alone something that won't easily be screwed up
in the future.  So there's definitely room for thought there.

But how does it matter if two different paths have the same sb or a
different sb mounted over them?

> > > BTW, what about having several links to the same file?  You have i_mutex
> > > on the inode, so serialization of those is not a problem, but...
> > 
> > Sorry, I lost it...
> 
> Say /foo/bar/a is such a file.
> 
> cd /foo/bar
> ln a b
> 
> now do lookups on a/ and b/
> 
> What happens?

The same dentry is mounted over each one.  The contents of the
directory should only depend on the contents of the underlying inode.
The path leading up to it is completely irrelevant.

Miklos
