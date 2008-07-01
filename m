Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbYGAVra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbYGAVra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbYGAVrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:47:22 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:48984 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751570AbYGAVrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:47:20 -0400
X-YMail-OSG: SGyxMTUVM1mqM4aa3bgzBuGcaTiXeJjvEbyWih2usU6dv_3CHi_yXjbuLi.d1EzgxLuMZP7Ni.8V.dqUPCEm4bQhY1ARHr8i12xzoOKb5hR5JEbvZpKu4I_uW0A6VgGyD3w-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <486AA5E5.2010300@schaufler-ca.com>
Date: Tue, 01 Jul 2008 14:47:17 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] smack: remove unnecessary xattr checks
References: <E1KDmlY-0006ML-If@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KDmlY-0006ML-If@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> Hi Casey,
>
> This is an untested patch, if it looks OK, can you please apply it to
> your tree (or ACK it)?
>
>   

I will give it some review and a test or two
then let you know. Things are hopping right now,
so it may take a day or two.

Thank you for the work you've put into this.

> Thanks,
> Miklos
>
> ----
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> getxattr() calls security_inode_permission(MAY_READ) so
> smack_inode_getxattr() is unnecessary.
>
> setxattr() and removexattr() call security_inode_permission(MAY_WRITE)
> so the write permission checks in smack_inode_setxattr() and
> smack_inode_removexattr() are unnecessary.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  security/smack/smack_lsm.c |   19 -------------------
>  1 file changed, 19 deletions(-)
>
> Index: linux-2.6/security/smack/smack_lsm.c
> ===================================================================
> --- linux-2.6.orig/security/smack/smack_lsm.c	2008-07-01 21:44:05.000000000 +0200
> +++ linux-2.6/security/smack/smack_lsm.c	2008-07-01 21:45:27.000000000 +0200
> @@ -588,9 +588,6 @@ static int smack_inode_setxattr(struct d
>  	} else
>  		rc = cap_inode_setxattr(dentry, name, value, size, flags);
>  
> -	if (rc == 0)
> -		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> -
>  	return rc;
>  }
>  
> @@ -636,18 +633,6 @@ static void smack_inode_post_setxattr(st
>  }
>  
>  /*
> - * smack_inode_getxattr - Smack check on getxattr
> - * @dentry: the object
> - * @name: unused
> - *
> - * Returns 0 if access is permitted, an error code otherwise
> - */
> -static int smack_inode_getxattr(struct dentry *dentry, const char *name)
> -{
> -	return smk_curacc(smk_of_inode(dentry->d_inode), MAY_READ);
> -}
> -
> -/*
>   * smack_inode_removexattr - Smack check on removexattr
>   * @dentry: the object
>   * @name: name of the attribute
> @@ -668,9 +653,6 @@ static int smack_inode_removexattr(struc
>  	} else
>  		rc = cap_inode_removexattr(dentry, name);
>  
> -	if (rc == 0)
> -		rc = smk_curacc(smk_of_inode(dentry->d_inode), MAY_WRITE);
> -
>  	return rc;
>  }
>  
> @@ -2606,7 +2588,6 @@ struct security_operations smack_ops = {
>  	.inode_getattr = 		smack_inode_getattr,
>  	.inode_setxattr = 		smack_inode_setxattr,
>  	.inode_post_setxattr = 		smack_inode_post_setxattr,
> -	.inode_getxattr = 		smack_inode_getxattr,
>  	.inode_removexattr = 		smack_inode_removexattr,
>  	.inode_need_killpriv =		cap_inode_need_killpriv,
>  	.inode_killpriv =		cap_inode_killpriv,
>
>
>   


-- 

----------------------

Casey Schaufler
casey@schaufler-ca.com
650.906.1780


