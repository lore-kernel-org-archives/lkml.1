Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbXEWHhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbXEWHhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXEWHhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:37:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46407 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548AbXEWHg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:36:59 -0400
Date: Wed, 23 May 2007 08:36:58 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] file as directory
Message-ID: <20070523073658.GO4095@ftp.linux.org.uk>
References: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu> <20070522221045.GH4095@ftp.linux.org.uk> <E1HqkS4-00017K-00@dorka.pomaz.szeredi.hu> <20070523070306.GM4095@ftp.linux.org.uk> <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hql7t-0001EQ-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 09:19:17AM +0200, Miklos Szeredi wrote:
> > Eh...  Arbitrary limitations are fun, aren't they?
> 
> But these mounts _are_ special.  There is really no point in moving or
> pivoting them.

pivoting - probably true, moving... why not?
 
> > What about MNT_SLAVE stuff being set up prior to that lookup?
> 
> These mounts are not propagated.  Or at least I hope so.  Propagation
> stuff is a bit too complicated for my poor little brain.

Er...  These mounts might not be propagated, but what about a bind
over another instance of such file in master tree?
 
> I think they should be the same superblock, same dentry.  What would
> be the advantage of doing otherwise?

Then you are going to have interesting time with locking in final mntput().
BTW, what about having several links to the same file?  You have i_mutex
on the inode, so serialization of those is not a problem, but...
 
> I think doing this recursively should be allowed.  "Releasing last ref
> cleans up the mess" should work in that case.

Releasing the last reference will lead to cascade of umounts in that
case...  IOW, need to be careful with locking.
