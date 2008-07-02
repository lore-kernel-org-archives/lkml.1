Return-Path: <linux-kernel-owner+w=401wt.eu-S1759838AbYGBAAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759838AbYGBAAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 20:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYGBAAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 20:00:35 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47067 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYGBAAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 20:00:34 -0400
Date: Tue, 1 Jul 2008 20:00:09 -0400
Message-Id: <200807020000.m62009ug014713@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>, Erez Zadok <ezk@cs.sunysb.edu>,
       Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>, hooanon05@yahoo.co.jp,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking 
In-reply-to: Your message of "Tue, 01 Jul 2008 03:03:50 EDT."
             <20080701070350.GA22914@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080701070350.GA22914@infradead.org>, Christoph Hellwig writes:
> On Mon, Jun 30, 2008 at 04:49:01PM -0500, Michael Halcrow wrote:
> > eCryptfs depends on the results of i_size_read() on the lower inode
> > when it needs to interpolate the filesize when the metadata is stored
> > in the lower file's xattr region.
> 
> please use vfs_getattr to get the size in thst case.

So, Christoph, is using vfs_getattr() the preferred choice for stackable
file systems in general to get the lower inode size?

If so, the Hugh's fsstack_copy_inode_size patch will have to be updated: and
we'll probably have to change the names of the src/dst parameters to
lower/upper, possibly watch out for whether "src" was the lower or upper
inode, and be careful about locking semantics when calling vfs_getattr.

Who'd have thought that a concept as simple as
      dst->i_size = src->i_size
could turn out to be so hairy... 1/2 a :-)

Thanks,
Erez.
