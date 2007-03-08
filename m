Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbXCHQmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbXCHQmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbXCHQmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:42:14 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:57651 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbXCHQmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:42:08 -0500
Date: Thu, 8 Mar 2007 08:41:32 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 2/6] integrity: fs hook placement
Message-ID: <20070308164132.GL6602@sequoia.sous-sol.org>
References: <1173369812.5981.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173369812.5981.2.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mimi Zohar (zohar@linux.vnet.ibm.com) wrote:
> +	integrity_d_instantiate(entry, inode);
>  	security_d_instantiate(entry, inode);

> +		integrity_d_instantiate(entry, inode);
>  		security_d_instantiate(entry, inode);

>  			spin_unlock(&dcache_lock);
> +			integrity_d_instantiate(new, inode);
>  			security_d_instantiate(new, inode);
>  			d_rehash(dentry);

>  			d_move(new, dentry);
> +			integrity_d_instantiate(dentry, inode);
>  			security_d_instantiate(dentry, inode);
>  			d_rehash(dentry);

>  	if (actual == dentry) {
> +		integrity_d_instantiate(dentry, inode);
>  		security_d_instantiate(dentry, inode);


>  		file->f_op->release(inode, file);
>  	security_file_free(file);
> +	integrity_file_free(file);


>  		security_file_free(file);
> +		integrity_file_free(file);


> 		if (security_inode_alloc(inode)) {
...
> +		if (integrity_inode_alloc(inode)) {
> +			if (inode->i_sb->s_op->destroy_inode)
> +				inode->i_sb->s_op->destroy_inode(inode);

>  	security_inode_free(inode);
> +	integrity_inode_free(inode);

>  	error = security_inode_setxattr(dentry, name, value, size, flags);
>  	if (error)
>  		goto out;
> +
> +	error = integrity_inode_setxattr(dentry, name, value, size, flags);

>  			fsnotify_xattr(dentry);
> +			integrity_inode_post_setxattr(dentry, name);
>  			security_inode_post_setxattr(dentry, name, value,

I know there's some slightly different goals, but this just doesn't make
sense.  Need to get back to defining and expressing just the differences.
