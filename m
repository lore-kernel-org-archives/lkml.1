Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbXLSXpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbXLSXpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 18:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbXLSXpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 18:45:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39071 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbXLSXpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 18:45:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Chinner <dgc@sgi.com>
Subject: Re: xfs mknod regression
Date: Thu, 20 Dec 2007 01:04:49 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Christoph Hellwig <hch@infradead.org>, Bret Towe <magnade@gmail.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com> <20071218173642.GA7338@infradead.org> <20071219003745.GR4396912@sgi.com>
In-Reply-To: <20071219003745.GR4396912@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200104.50252.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 19 of December 2007, David Chinner wrote:
> On Tue, Dec 18, 2007 at 05:36:42PM +0000, Christoph Hellwig wrote:
> > 
> > This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
> > which assigned the re-shuffled ondisk dev_t back to the rdev variable in
> > xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
> > of the linux dev_t later down the function.
> > 
> > Fortunately the fix for it is trivial:  we can just remove the
> > assignment because xfs_revalidate_inode has done the proper job before
> > unlocking the inode.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
> > ===================================================================
> > --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:32.000000000 +0100
> > +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:43.000000000 +0100
> > @@ -345,9 +345,7 @@ xfs_vn_mknod(
> >  		ASSERT(vp);
> >  		ip = vn_to_inode(vp);
> >  
> > -		if (S_ISCHR(mode) || S_ISBLK(mode))
> > -			ip->i_rdev = rdev;
> > -		else if (S_ISDIR(mode))
> > +		if (S_ISDIR(mode))
> >  			xfs_validate_fields(ip);
> >  		d_instantiate(dentry, ip);
> >  		xfs_validate_fields(dir);
> 
> Thanks for this, Christoph - I'll run some tests on it and check it in.
> 
> Rafael - this is a regression introduced in 2.6.24-rc1 if you want to
> track it.

I do, thanks.

Added to the list, http://bugzilla.kernel.org/show_bug.cgi?id=9608 .
I'll close it when the fix is upstream.

Thanks,
Rafael
