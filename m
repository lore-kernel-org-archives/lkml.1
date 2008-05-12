Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYELVuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYELVuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 17:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYELVuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 17:50:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50742 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbYELVt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 17:49:59 -0400
Subject: Re: [PATCH] jfs: 0 is not valid errno value
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jfs-discussion@lists.sourceforge.net,
       Alexander Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <20080511200842.GN19058@joi>
References: <20080511200842.GN19058@joi>
Content-Type: text/plain
Date: Mon, 12 May 2008 16:49:49 -0500
Message-Id: <1210628989.13027.4.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-11 at 22:08 +0200, Marcin Slusarz wrote:
> ... so return NULL from jfs_lookup
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> Cc: jfs-discussion@lists.sourceforge.net
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> ---
> is it ok to return NULL from this function?
> compile tested only

Yeah.  I'm not sure how ERR_PTR(0) got in there in the first place.
It's been that way for quite a while.

I'll add it to the jfs git tree.

Thanks,
Shaggy

> ---
>  fs/jfs/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
> --- a/fs/jfs/namei.c
> +++ b/fs/jfs/namei.c
> @@ -1455,7 +1455,7 @@ static struct dentry *jfs_lookup(struct inode *dip, struct dentry *dentry, struc
>  		free_UCSname(&key);
>  		if (rc == -ENOENT) {
>  			d_add(dentry, NULL);
> -			return ERR_PTR(0);
> +			return NULL;
>  		} else if (rc) {
>  			jfs_err("jfs_lookup: dtSearch returned %d", rc);
>  			return ERR_PTR(rc);
-- 
David Kleikamp
IBM Linux Technology Center

