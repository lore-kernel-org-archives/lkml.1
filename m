Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbXJYCUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbXJYCUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbXJYCUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:20:12 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37445 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbXJYCUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:20:10 -0400
Message-ID: <471FFD31.3020405@ak.jp.nec.com>
Date: Thu, 25 Oct 2007 11:19:29 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>, jffs-dev@axis.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make jffs2_get_acl() static
References: <20071024162734.GU30533@stusta.de>
In-Reply-To: <20071024162734.GU30533@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> jffs2_get_acl() can now become static again.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: KaiGai Kohei <kaigai@ak.jp.nec.com>

> ---
> 
>  fs/jffs2/acl.c |    2 +-
>  fs/jffs2/acl.h |    2 --
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> add2b887d64536f3fe978e62f0774292456f1ddb 
> diff --git a/fs/jffs2/acl.c b/fs/jffs2/acl.c
> index 9728614..b14e805 100644
> --- a/fs/jffs2/acl.c
> +++ b/fs/jffs2/acl.c
> @@ -176,7 +176,7 @@ static void jffs2_iset_acl(struct inode *inode, struct posix_acl **i_acl, struct
>  	spin_unlock(&inode->i_lock);
>  }
>  
> -struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
> +static struct posix_acl *jffs2_get_acl(struct inode *inode, int type)
>  {
>  	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
>  	struct posix_acl *acl;
> diff --git a/fs/jffs2/acl.h b/fs/jffs2/acl.h
> index 76c6ebd..0bb7f00 100644
> --- a/fs/jffs2/acl.h
> +++ b/fs/jffs2/acl.h
> @@ -28,7 +28,6 @@ struct jffs2_acl_header {
>  
>  #define JFFS2_ACL_NOT_CACHED ((void *)-1)
>  
> -extern struct posix_acl *jffs2_get_acl(struct inode *inode, int type);
>  extern int jffs2_permission(struct inode *, int, struct nameidata *);
>  extern int jffs2_acl_chmod(struct inode *);
>  extern int jffs2_init_acl_pre(struct inode *, struct inode *, int *);
> @@ -40,7 +39,6 @@ extern struct xattr_handler jffs2_acl_default_xattr_handler;
>  
>  #else
>  
> -#define jffs2_get_acl(inode, type)		(NULL)
>  #define jffs2_permission			(NULL)
>  #define jffs2_acl_chmod(inode)			(0)
>  #define jffs2_init_acl_pre(dir_i,inode,mode)	(0)
> 
> 

