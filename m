Return-Path: <linux-kernel-owner+w=401wt.eu-S1754861AbXHXEUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbXHXEUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 00:20:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbXHXETx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 00:19:53 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52364 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbXHXETw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 00:19:52 -0400
Subject: Re: [PATCH 28/30] jfs: avoid pointless casts of kmalloc() return
	val
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net
In-Reply-To: <18983edfb06c7b133f699e34194112ca6a53b14d.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <18983edfb06c7b133f699e34194112ca6a53b14d.1187912217.git.jesper.juhl@gmail.com>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 23:19:49 -0500
Message-Id: <1187929189.6406.2.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, but Jack Stone submitted the same patch a few weeks ago.  It's
already in the jfs git tree and the -mm kernel.

Shaggy

On Fri, 2007-08-24 at 02:36 +0200, Jesper Juhl wrote:
> There's no need to cast the, void *, return value of kmalloc() when
> assigning to a pointer variable.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
>  fs/jfs/jfs_dtree.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
> index c14ba3c..3f15b36 100644
> --- a/fs/jfs/jfs_dtree.c
> +++ b/fs/jfs/jfs_dtree.c
> @@ -592,9 +592,7 @@ int dtSearch(struct inode *ip, struct component_name * key, ino_t * data,
>  	struct component_name ciKey;
>  	struct super_block *sb = ip->i_sb;
>  
> -	ciKey.name =
> -	    (wchar_t *) kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t),
> -				GFP_NOFS);
> +	ciKey.name = kmalloc((JFS_NAME_MAX + 1) * sizeof(wchar_t), GFP_NOFS);
>  	if (ciKey.name == 0) {
>  		rc = -ENOMEM;
>  		goto dtSearch_Exit2;
> @@ -957,9 +955,7 @@ static int dtSplitUp(tid_t tid,
>  	smp = split->mp;
>  	sp = DT_PAGE(ip, smp);
>  
> -	key.name =
> -	    (wchar_t *) kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t),
> -				GFP_NOFS);
> +	key.name = kmalloc((JFS_NAME_MAX + 2) * sizeof(wchar_t), GFP_NOFS);
>  	if (key.name == 0) {
>  		DT_PUTPAGE(smp);
>  		rc = -ENOMEM;
-- 
David Kleikamp
IBM Linux Technology Center

