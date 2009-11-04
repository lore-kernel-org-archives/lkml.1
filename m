Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZKDC5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZKDC5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 21:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZKDC5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 21:57:16 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52828 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332AbZKDC5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 21:57:15 -0500
Date: Tue, 3 Nov 2009 20:57:18 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 05/13] sysfs: Simplify iattr time assignments
Message-ID: <20091104025718.GB27639@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-5-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-5-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> The granularity of sysfs time when we keep it is 1 ns.  Which
> when passed to timestamp_trunc results in a nop.  So remove
> the unnecessary function call making sysfs_setattr slightly
> easier to read.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/inode.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index 8a08250..fed7a74 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -103,14 +103,11 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>  		if (ia_valid & ATTR_GID)
>  			iattrs->ia_gid = iattr->ia_gid;
>  		if (ia_valid & ATTR_ATIME)
> -			iattrs->ia_atime = timespec_trunc(iattr->ia_atime,
> -					inode->i_sb->s_time_gran);
> +			iattrs->ia_atime = iattr->ia_atime;
>  		if (ia_valid & ATTR_MTIME)
> -			iattrs->ia_mtime = timespec_trunc(iattr->ia_mtime,
> -					inode->i_sb->s_time_gran);
> +			iattrs->ia_mtime = iattr->ia_mtime;
>  		if (ia_valid & ATTR_CTIME)
> -			iattrs->ia_ctime = timespec_trunc(iattr->ia_ctime,
> -					inode->i_sb->s_time_gran);
> +			iattrs->ia_ctime = iattr->ia_ctime;
>  		if (ia_valid & ATTR_MODE) {
>  			umode_t mode = iattr->ia_mode;
> 
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
