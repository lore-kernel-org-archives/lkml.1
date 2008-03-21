Return-Path: <linux-kernel-owner+w=401wt.eu-S1758175AbYCUPzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175AbYCUPzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYCUPy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:54:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47103 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbYCUPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:54:56 -0400
Date: Fri, 21 Mar 2008 15:54:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org
Subject: Re: r-o bind in nfsd
Message-ID: <20080321155451.GU10722@ZenIV.linux.org.uk>
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 03:59:44PM +0100, Miklos Szeredi wrote:
> Why is it that in fs/nfsd/vfs.c only vfs_mknod() and vfs_rename() are
> surrounded by mnt_want_write/mnt_drop_write, and not the other
> operations (vfs_create, vfs_mkdir, vfs_symlink, ...)?
> 
> I noticed this while looking at the AppArmor patches, which need to
> pass the vfsmount down to the security module.  And I'm wondering, why
> can't mnt_want_write() and mnt_drop_write() be done _inside_ vfs_foo()?
> 
> I know there are a few cases, where filesystems call vfs_foo()
> internally, where the vfsmount isn't available, but I think the proper
> solution is just to fix those places, and not recurse back into the
> VFS (which is AFAICS in all those cases totally unnecessary anyway).
> This would make everybody happy, no?

Apparmor can go play with itself.  The proper fix is to lift the LSM nonsense
into callers and leave vfs_...() alone; vfsmounts should *not* be passed
there at all, with the exception of vfs_follow_link() which gets the full
nameidata.
