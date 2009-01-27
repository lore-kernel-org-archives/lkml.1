Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZA0QGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZA0QGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZA0QGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:06:34 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46297 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZA0QGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:06:33 -0500
Subject: Re: [PATCH 11/20] fs/jfs: return f_fsid for statfs(2), v3
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, coly.li@suse.de
In-Reply-To: <1233062766.3779.3.camel@norville.austin.ibm.com>
References: <4975F653.2000109@suse.de>
	 <1233062766.3779.3.camel@norville.austin.ibm.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 10:06:29 -0600
Message-Id: <1233072389.3779.82.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 07:26 -0600, Dave Kleikamp wrote:
> Andrew,
> Please take this version of the jfs patch, rather than the one you
> currently have in the -mm tree (fs-jfs-return-f_fsid-for-statfs2.patch).

... or would you rather I handle it though the jfs tree and you drop it?

Shaggy

> On Wed, 2009-01-21 at 00:05 +0800, Coly Li wrote:
> > This patch makes jfs return f_fsid info for statfs(2). By Andreas' suggestion, this patch populates
> > a persistent f_fsid between boots/mounts with help of on-disk uuid record.
> > 
> > Signed-off-by: Coly Li <coly.li@suse.de>
> > Acked-By: Dave Kleikamp <shaggy@austin.ibm.com>
> > ---
> >  fs/jfs/super.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> > index b37d1f7..6ce1aac 100644
> > --- a/fs/jfs/super.c
> > +++ b/fs/jfs/super.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/posix_acl.h>
> >  #include <linux/buffer_head.h>
> >  #include <linux/exportfs.h>
> > +#include <linux/crc32.h>
> >  #include <asm/uaccess.h>
> >  #include <linux/seq_file.h>
> > 
> > @@ -168,7 +169,10 @@ static int jfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> >  	buf->f_files = maxinodes;
> >  	buf->f_ffree = maxinodes - (atomic_read(&imap->im_numinos) -
> >  				    atomic_read(&imap->im_numfree));
> > -
> > +	buf->f_fsid.val[0] = (u32)crc32_le(0, sbi->uuid, sizeof(sbi->uuid)/2);
> > +	buf->f_fsid.val[1] = (u32)crc32_le(0, sbi->uuid + sizeof(sbi->uuid)/2,
> > +					sizeof(sbi->uuid)/2);
> > +
> >  	buf->f_namelen = JFS_NAME_MAX;
> >  	return 0;
> >  }
> > 
-- 
David Kleikamp
IBM Linux Technology Center

