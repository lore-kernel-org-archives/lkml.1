Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbXJOBxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbXJOBxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 21:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbXJOBxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 21:53:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33062 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754004AbXJOBxa (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 21:53:30 -0400
Date: Mon, 15 Oct 2007 11:53:03 +1000
From: David Chinner <dgc@sgi.com>
To: David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/52] CRED: Introduce a COW credentials record
Message-ID: <20071015015303.GC995458@sgi.com>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk> <20071012160524.15119.18793.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012160524.15119.18793.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 05:05:24PM +0100, David Howells wrote:
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 4ca4beb..a460508 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -383,7 +383,7 @@ xfs_acl_allow_set(
>  	error = bhv_vop_getattr(vp, &va, 0, NULL);
>  	if (error)
>  		return error;
> -	if (va.va_uid != current->fsuid && !capable(CAP_FOWNER))
> +	if (va.va_uid != current->cred->uid && !capable(CAP_FOWNER))

current_fsuid() should be used here.

>  		return EPERM;
>  	return error;
>  }
> @@ -457,13 +457,13 @@ xfs_acl_access(
>  		switch (fap->acl_entry[i].ae_tag) {
>  		case ACL_USER_OBJ:
>  			seen_userobj = 1;
> -			if (fuid != current->fsuid)
> +			if (fuid != current->cred->uid)
>  				continue;
>  			matched.ae_tag = ACL_USER_OBJ;
>  			matched.ae_perm = allows;
>  			break;
>  		case ACL_USER:
> -			if (fap->acl_entry[i].ae_id != current->fsuid)
> +			if (fap->acl_entry[i].ae_id != current->cred->uid)

and here as well....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
