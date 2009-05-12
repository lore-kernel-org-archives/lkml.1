Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbZELBft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbZELBft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 21:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758756AbZELBfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 21:35:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:33545 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759360AbZELBff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 21:35:35 -0400
Date: Tue, 12 May 2009 11:35:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] securityfs: securityfs_remove should handle IS_ERR
 pointers
In-Reply-To: <20090512004714.4111.46789.stgit@dhcp231-142.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0905121135110.4463@tundra.namei.org>
References: <20090512004714.4111.46789.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Eric Paris wrote:

> Both of the securityfs users (TPM and IMA) can call securityfs_remove and pass
> an IS_ERR(dentry) in their failure paths.  This patch handles those rather
> than panicing when it tries to start deferencing some negative memory.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

> ---
> 
>  security/inode.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/inode.c b/security/inode.c
> index f3b91bf..f7496c6 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -287,7 +287,7 @@ void securityfs_remove(struct dentry *dentry)
>  {
>  	struct dentry *parent;
>  
> -	if (!dentry)
> +	if (!dentry || IS_ERR(dentry))
>  		return;
>  
>  	parent = dentry->d_parent;
> 

-- 
James Morris
<jmorris@namei.org>
