Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbYBOTOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbYBOTOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYBOTOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:14:09 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54171 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbYBOTOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:14:08 -0500
To: harvey.harrison@gmail.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <1203101902.15275.25.camel@brick> (message from Harvey Harrison
	on Fri, 15 Feb 2008 10:58:22 -0800)
Subject: Re: [RFC-PATCH] fuse: shadowed variable warning
References: <1203101902.15275.25.camel@brick>
Message-Id: <E1JQ60S-0005vO-QW@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 15 Feb 2008 20:13:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> fs/fuse/dir.c:909:7: warning: symbol 'err' shadows an earlier one
> fs/fuse/dir.c:893:6: originally declared here
> 
> This means that an error between lines 909 and 923 will not be
> returned.

Right.  Just submitted the exact same patch this morning :)

Thanks,
Miklos

> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Miklos, could you confirm whether or not you want the err from lines
> 909-923 returned or not.  If so, I can respin this patch changing the
> variable name instead which would preserve the current behavior.
> This patch changes behavior.
> 
>  fs/fuse/dir.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index 7fb514b..c4807b3 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -906,7 +906,7 @@ static int fuse_permission(struct inode *inode, int mask, struct nameidata *nd)
>  	}
>  
>  	if (fc->flags & FUSE_DEFAULT_PERMISSIONS) {
> -		int err = generic_permission(inode, mask, NULL);
> +		err = generic_permission(inode, mask, NULL);
>  
>  		/* If permission is denied, try to refresh file
>  		   attributes.  This is also needed, because the root
> -- 
> 1.5.4.1.1278.gc75be
> 
> 
> 
> 
