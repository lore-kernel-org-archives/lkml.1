Return-Path: <linux-kernel-owner+w=401wt.eu-S1762879AbXEWHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762879AbXEWHDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEWHDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:03:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35729 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbXEWHDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:03:09 -0400
Date: Wed, 23 May 2007 08:03:06 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523070306.GM4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 08:36:04AM +0200, Miklos Szeredi wrote:
> > Interesting...  How do you deal with mount propagation and things like
> > mount --move?
> 
> Moving (or doing other mount operations on) an ancestor shouldn't be a
> problem.  Moving this mount itself is not allowed, and neither is
> doing bind or pivot_root.  Maybe bind could be allowed...

Eh...  Arbitrary limitations are fun, aren't they?
 
> When doing recursive bind on ancestor, these mounts are skipped.

What about clone copying your namespace?  What about MNT_SLAVE stuff being
set up prior to that lookup?  More interesting question: should independent
lookups of that sucker on different paths end up with the same superblock
(and vfsmount for each) or should we get fully independent mount on each?
The latter would be interesting wrt cache coherency...

> > As for unlink...  How do you deal with having that thing
> > mounted, mounting something _under_ it (so that vfsmount would be kept
> > busy) and then unlinking that sucker?
> 
> Yeah, that's a good point.  Current patch doesn't deal with that.
> Simplest solution could be to disallow submounting these.  Don't think
> it makes much sense anyway.

Arbitrary limitations... (and that's where revalidate horrors come in, BTW).
BTW^2: what if fs mounted that way will happen to have such node itself?

I'm not saying that it's unfeasible or won't lead to interesting things,
but it really needs semantics done right...
