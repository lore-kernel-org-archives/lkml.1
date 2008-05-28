Return-Path: <linux-kernel-owner+w=401wt.eu-S1752323AbYE1OCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbYE1OCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 10:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbYE1OCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 10:02:23 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35944 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbYE1OCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 10:02:22 -0400
Subject: Re: [Jfs-discussion] [PATCH] JFS: diAlloc() should return -EIO
	rather than EIO
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <483BBE82.3020805@cn.fujitsu.com>
References: <483BBE82.3020805@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 28 May 2008 09:02:05 -0500
Message-Id: <1211983325.31158.30.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-27 at 15:55 +0800, Li Zefan wrote:
> The comment above the function says one of its return value is -EIO,
> and also the caller of diAlloc() checks for -EIO:
> 
> struct inode *ialloc(struct inode *parent, umode_t mode)
> {
> 	...
> 	rc = diAlloc(parent, S_ISDIR(mode), inode);
> 	if (rc) {
> 		jfs_warn("ialloc: diAlloc returned %d!", rc);
> 		if (rc == -EIO)
> 			make_bad_inode(inode);
> 	...
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> ---
>  fs/jfs/jfs_imap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jfs/jfs_imap.c b/fs/jfs/jfs_imap.c
> index 734ec91..d6363d8 100644
> --- a/fs/jfs/jfs_imap.c
> +++ b/fs/jfs/jfs_imap.c
> @@ -1520,7 +1520,7 @@ int diAlloc(struct inode *pip, bool dir, struct inode *ip)
>  					jfs_error(ip->i_sb,
>  						  "diAlloc: can't find free bit "
>  						  "in wmap");
> -					return EIO;
> +					return -EIO;
>  				}
> 
>  				/* determine the inode number within the
> -- 1.5.4.rc3

I'm not sure how this one escaped detection this long.  I've added this
patch to the jfs git tree.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

