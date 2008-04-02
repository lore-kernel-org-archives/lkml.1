Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbYDBXlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbYDBXlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 19:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbYDBXk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 19:40:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54693 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbYDBXk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 19:40:56 -0400
Date: Thu, 3 Apr 2008 00:40:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080402234043.GR9785@ZenIV.linux.org.uk>
References: <20080402201247.358430231@szeredi.hu> <20080402201321.062856131@szeredi.hu> <20080402205450.GO9785@ZenIV.linux.org.uk> <E1JhAF9-0007Zx-Rq@pomaz-ex.szeredi.hu> <20080402214824.GP9785@ZenIV.linux.org.uk> <1207174890.722.12.camel@heimdal.trondhjem.org> <20080402223637.GQ9785@ZenIV.linux.org.uk> <1207178398.20254.19.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207178398.20254.19.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 07:19:58PM -0400, Trond Myklebust wrote:

> I'm just suggesting splitting out the namespace-specific part of struct
> file into a separate structure that would be private to the VFS.
> Something like
> 
> struct file_descriptor {
> 	struct file *file;
> 	struct vfsmount *mnt;
> 	atomic_t refcount;
> };
> 
> and then having the 'struct file' hold a reference to the superblock
> instead of holding a reference to the vfsmount.
> 
> Why would that be problematic for SCM_RIGHTS? We don't allow people to
> send arbitrary references to 'struct file' using SCM_RIGHTS now; they
> have to send descriptors.

HUH?  Descriptor is a number.  There is no struct file_descriptor,
let alone refcounting for such.  There is a table, indexed by number
and containing references to struct file.

If you want to shove pointer to vfsmount in there (what for?  to waste
some memory and make SMP protection on access more interesting?), you
could do that, but IMO it's too ugly to consider.

Anyway, what the hell for?  It's more complex and buys you nothing
useful.
