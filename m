Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbYCJWEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYCJWEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYCJWEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:04:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33758 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbYCJWED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:04:03 -0400
To: akpm@linux-foundation.org
CC: staubach@redhat.com, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@lst.de,
       haveblue@us.ibm.com
In-reply-to: <20080310143832.08ad52a9.akpm@linux-foundation.org> (message from
	Andrew Morton on Mon, 10 Mar 2008 14:38:32 -0700)
Subject: Re: [PATCH 1/3] enhanced lookup ESTALE error handling (v3)
References: <4790C761.1010603@redhat.com>
	<47A387CF.70201@redhat.com>
	<47D598C5.7080609@redhat.com> <20080310143832.08ad52a9.akpm@linux-foundation.org>
Message-Id: <E1JYq5I-0000D9-8a@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 10 Mar 2008 23:03:04 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is a patch to enhance ESTALE error handling during the
> > lookup process.  The error, ESTALE, can occur when out of data
> > dentries, stored in the dcache, is used to translate a pathname
> > component to a dentry.  When this occurs, the dentry which
> > contains the pointer to the inode which refers to the non-existent
> > file is dropped from the dcache and then the lookup process
> > started again.  Care is taken to ensure that forward process is
> > always being made.  If forward process is not detected, then the
> > lookup process is terminated and the error, ENOENT, is returned
> > to the caller.
> 
> This collides in non-trivial ways with the always-coming-never-arrives
> r-o-bind-mounts patches.
> 
> I have an old version of those patches in -mm and I believe that Al
> is/was/has set up some git tree with these patches and perhaps other stuff.
> 
> So some coordination is required please.  I'd suggest that if Al indeed
> does have such a tree, he hand over the URL so I can get it into -mm and
> that you then redo these patches on top of that.
> 
> Please also Cc Al and Christoph on these patches, as they are hitting files
> which they maintain and develop.

Also my objection about breaking backward compatibility for fuse
filesystems is still seemingly unaddressed.

I know it would be more convenient to push this problem into the fuse
filesystems, but they are unfortunately on the other side of the
stable kernel ABI, so this is not an option.

I've already presented a solution (which wasn't greeted with big
enthusiasm), and I'm open to discussion about other ways to solve
this.

Miklos
