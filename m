Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZKDOZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZKDOZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756528AbZKDOZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:25:36 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49522 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756523AbZKDOZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:25:35 -0500
Date: Wed, 4 Nov 2009 08:25:15 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>
Subject: Re: [PATCH 14/13] sysfs: sysfs_setattr remove unnecessary
	permission check.
Message-ID: <20091104142515.GC4355@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <m1ljim1op9.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ljim1op9.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> inode_change_ok already clears the SGID bit when necessary so there is
> no reason for sysfs_setattr to carry code to do the same, and it is
> good to kill the extra copy because when I moved the code, I goofed
> and in certain corner cases the code will look at the wrong gid.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/inode.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index 72e2e99..e2595a7 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -120,10 +120,6 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>  		return error;
> 
>  	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
> -	if (iattr->ia_valid & ATTR_MODE) {
> -		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> -			iattr->ia_mode &= ~S_ISGID;
> -	}
> 
>  	error = inode_setattr(inode, iattr);
>  	if (error)
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
