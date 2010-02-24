Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0BXPlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:41:51 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47196 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab0BXPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:41:49 -0500
Subject: Re: [PATCH] security: fix error return path in ima_inode_alloc
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       "Amit K. Arora" <amitarora@in.ibm.com>
In-Reply-To: <1267007942-315-1-git-send-email-dfeng@redhat.com>
References: <1267007942-315-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 10:41:30 -0500
Message-ID: <1267026090.2618.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 18:39 +0800, Xiaotian Feng wrote:
> If radix_tree_preload is failed in ima_inode_alloc, we don't need
> radix_tree_preload_end because kernel is alread preempt enabled
> 
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

thanks,
Mimi

> Cc: Mimi Zohar <zohar@us.ibm.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Amit K. Arora <amitarora@in.ibm.com>
> ---
>  security/integrity/ima/ima_iint.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
> index 0d83edc..2d4d05d 100644
> --- a/security/integrity/ima/ima_iint.c
> +++ b/security/integrity/ima/ima_iint.c
> @@ -63,12 +63,11 @@ int ima_inode_alloc(struct inode *inode)
>  	spin_lock(&ima_iint_lock);
>  	rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
>  	spin_unlock(&ima_iint_lock);
> +	radix_tree_preload_end();
>  out:
>  	if (rc < 0)
>  		kmem_cache_free(iint_cache, iint);
> 
> -	radix_tree_preload_end();
> -
>  	return rc;
>  }
> 


