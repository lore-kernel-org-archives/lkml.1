Return-Path: <linux-kernel-owner+w=401wt.eu-S1762519AbXEWI33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762519AbXEWI33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 04:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756965AbXEWI3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 04:29:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbXEWI3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 04:29:20 -0400
Date: Wed, 23 May 2007 09:29:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523082918.GP4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <20070523070306.GM4095@ftp.linux.org.uk> <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu> <20070523073658.GO4095@ftp.linux.org.uk> <E1HqlqT-0001KD-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqlqT-0001KD-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 10:05:21AM +0200, Miklos Szeredi wrote:
> > Er...  These mounts might not be propagated, but what about a bind
> > over another instance of such file in master tree?
> 
> So your question is, which mount takes priority on the lookup?  It
> probably should be the propagated real mount, rather than the
> dir-on-file one, shouldn't it?

There might be dragons in that area...
 
> > > I think they should be the same superblock, same dentry.  What would
> > > be the advantage of doing otherwise?
> > 
> > Then you are going to have interesting time with locking in final mntput().
> 
> Final mntput of what?

When the last reference to your mount goes away.
 
> > BTW, what about having several links to the same file?  You have i_mutex
> > on the inode, so serialization of those is not a problem, but...
> 
> Sorry, I lost it...

Say /foo/bar/a is such a file.

cd /foo/bar
ln a b

now do lookups on a/ and b/

What happens?
