Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbXJZMfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbXJZMfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbXJZMfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:35:05 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:56393 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753340AbXJZMfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:35:03 -0400
Subject: Re: [AppArmor 35/45] Allow permission functions to tell between
	parent and leaf checks
From: Stephen Smalley <sds@tycho.nsa.gov>
To: jjohansen@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
In-Reply-To: <20071026064051.877606581@suse.de>
References: <20071026064024.243943043@suse.de>
	 <20071026064051.877606581@suse.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 26 Oct 2007 08:32:23 -0400
Message-Id: <1193401943.11953.3.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 23:40 -0700, jjohansen@suse.de wrote:
> plain text document attachment (parent-permission.diff)
> Set the LOOKUP_CONTINUE flag when checking parent permissions. This allows
> permission functions to tell between parent and leaf checks.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: John Johansen <jjohansen@suse.de>
> 
> ---
>  fs/namei.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1472,6 +1472,10 @@ static int may_delete(struct inode *dir,
>  	BUG_ON(victim->d_parent->d_inode != dir);
>  	audit_inode_child(victim->d_name.name, victim, dir);
>  
> +#if 0
> +	if (nd)
> +		nd->flags |= LOOKUP_CONTINUE;
> +#endif

#if 0?

>  	error = permission(dir,MAY_WRITE | MAY_EXEC, NULL);
>  	if (error)
>  		return error;
> @@ -1509,6 +1513,8 @@ static inline int may_create(struct inod
>  		return -EEXIST;
>  	if (IS_DEADDIR(dir))
>  		return -ENOENT;
> +	if (nd)
> +		nd->flags |= LOOKUP_CONTINUE;
>  	return permission(dir,MAY_WRITE | MAY_EXEC, nd);
>  }
>  
> 
-- 
Stephen Smalley
National Security Agency

