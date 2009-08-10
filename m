Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZHJMWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZHJMWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZHJMWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:22:06 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:55172 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbZHJMWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:22:05 -0400
Subject: Re: [PATCH] SELinux: re. BUG memory leakage at
 ./security/selinux/hooks.c
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: iceberg <strakh@ispras.ru>, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, Eric Paris <eparis@redhat.com>
In-Reply-To: <alpine.LRH.2.00.0908102216430.10792@tundra.namei.org>
References: <200908101257.43672.strakh@ispras.ru>
	 <alpine.LRH.2.00.0908102152270.10706@tundra.namei.org>
	 <alpine.LRH.2.00.0908102216430.10792@tundra.namei.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 10 Aug 2009 08:24:07 -0400
Message-Id: <1249907047.2422.31.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 22:17 +1000, James Morris wrote:
> Please review.
> 
> Author: James Morris <jmorris@namei.org>
> Date:   Mon Aug 10 22:00:13 2009 +1000
> 
>     SELinux: fix memory leakage in /security/selinux/hooks.c
>     
>     Fix memory leakage in /security/selinux/hooks.c
>     
>     The buffer always needs to be freed here; we either error
>     out or allocate more memory.
>     
>     Reported-by: iceberg <strakh@ispras.ru>
>     Signed-off-by: James Morris <jmorris@namei.org>

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 15c2a08..1e8cfc4 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1285,6 +1285,8 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
>  		rc = inode->i_op->getxattr(dentry, XATTR_NAME_SELINUX,
>  					   context, len);
>  		if (rc == -ERANGE) {
> +			kfree(context);
> +
>  			/* Need a larger buffer.  Query for the right size. */
>  			rc = inode->i_op->getxattr(dentry, XATTR_NAME_SELINUX,
>  						   NULL, 0);
> @@ -1292,7 +1294,6 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
>  				dput(dentry);
>  				goto out_unlock;
>  			}
> -			kfree(context);
>  			len = rc;
>  			context = kmalloc(len+1, GFP_NOFS);
>  			if (!context) {
> 
-- 
Stephen Smalley
National Security Agency

