Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZAACgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZAACgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 21:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753526AbZAACgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 21:36:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58495 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbZAACgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 21:36:22 -0500
Date: Thu, 1 Jan 2009 02:36:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Duane Griffin <duaneg@dghda.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ufs: copy symlink data into the correct union
	member
Message-ID: <20090101023620.GD28946@ZenIV.linux.org.uk>
References: <1230742208-23972-1-git-send-email-duaneg@dghda.com> <1230742208-23972-2-git-send-email-duaneg@dghda.com> <1230742208-23972-3-git-send-email-duaneg@dghda.com> <1230742208-23972-4-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230742208-23972-4-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 04:50:08PM +0000, Duane Griffin wrote:
> Copy symlink data into the union member it is accessed through. Although
> this shouldn't make a difference to behaviour it makes the code easier
> to follow and grep through. It may also prevent problems if the
> struct/union definitions change in the future.
> 
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
>  fs/ufs/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
> index e3a9b1f..3884730 100644
> --- a/fs/ufs/namei.c
> +++ b/fs/ufs/namei.c
> @@ -147,7 +147,7 @@ static int ufs_symlink (struct inode * dir, struct dentry * dentry,
>  	} else {
>  		/* fast symlink */
>  		inode->i_op = &ufs_fast_symlink_inode_operations;
> -		memcpy((char*)&UFS_I(inode)->i_u1.i_data,symname,l);
> +		memcpy((char *) &UFS_I(inode)->i_u1.i_symlink, symname, l);

Just what are these cast and & doing there?  i_symlink is an array of u8,
for fsck sake; taking its address is a pointless obfuscation.  And memcpy()
is just as fine with u8 * as it is with char *...
