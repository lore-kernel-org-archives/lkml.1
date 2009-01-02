Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZABAL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZABAL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 19:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZABALT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 19:11:19 -0500
Received: from mail.fieldses.org ([141.211.133.115]:52333 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbZABALS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 19:11:18 -0500
Date: Thu, 1 Jan 2009 19:11:16 -0500
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] fs/nfs/nfs4proc.c: make nfs4_map_errors() static
Message-ID: <20090102001116.GB31840@fieldses.org>
References: <20081225215523.GH3130@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081225215523.GH3130@hack.private>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 09:55:23PM +0000, Américo Wang wrote:
> 
> nfs4_map_errors() can become static.
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: J. Bruce Fields <bfields@fieldses.org>

Thanks, applied for 2.6.29.--b.

> 
> ---
> diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
> index ea79064..b8fb6a6 100644
> --- a/fs/nfs/nfs4_fs.h
> +++ b/fs/nfs/nfs4_fs.h
> @@ -174,7 +174,6 @@ extern ssize_t nfs4_listxattr(struct dentry *, char *, size_t);
>  
>  
>  /* nfs4proc.c */
> -extern int nfs4_map_errors(int err);
>  extern int nfs4_proc_setclientid(struct nfs_client *, u32, unsigned short, struct rpc_cred *);
>  extern int nfs4_proc_setclientid_confirm(struct nfs_client *, struct rpc_cred *);
>  extern int nfs4_proc_async_renew(struct nfs_client *, struct rpc_cred *);
> diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
> index 83e700a..91e46ec 100644
> --- a/fs/nfs/nfs4proc.c
> +++ b/fs/nfs/nfs4proc.c
> @@ -69,7 +69,7 @@ static int _nfs4_proc_lookup(struct inode *dir, const struct qstr *name, struct
>  static int _nfs4_proc_getattr(struct nfs_server *server, struct nfs_fh *fhandle, struct nfs_fattr *fattr);
>  
>  /* Prevent leaks of NFSv4 errors into userland */
> -int nfs4_map_errors(int err)
> +static int nfs4_map_errors(int err)
>  {
>  	if (err < -1000) {
>  		dprintk("%s could not handle NFSv4 error %d\n",
> 
