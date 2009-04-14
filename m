Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZDNSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZDNSsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZDNSsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:48:16 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55718 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbZDNSsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:48:15 -0400
Subject: Re: [PATCH 26/30] cr: mount namespace
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090410024004.GA27788@x200.localdomain>
References: <20090410024004.GA27788@x200.localdomain>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 11:48:10 -0700
Message-Id: <1239734890.32604.102.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 06:40 +0400, Alexey Dobriyan wrote:
> 
> +struct mnt_namespace *alloc_mnt_ns(void)
> +{
> +       struct mnt_namespace *mnt_ns;
> +
> +       mnt_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
> +       if (mnt_ns) {
> +               atomic_set(&mnt_ns->count, 1);
> +               mnt_ns->root = NULL;
> +               INIT_LIST_HEAD(&mnt_ns->list);
> +               init_waitqueue_head(&mnt_ns->poll);
> +               mnt_ns->event = 0;
> +       }
> +       return mnt_ns;
> +}
> +
>  /*
>   * Allocate a new namespace structure and populate it with contents
>   * copied from the namespace of the passed in task structure.
> @@ -1981,15 +1996,10 @@ static struct mnt_namespace *dup_mnt_ns(struct
> mnt_namespace *mnt_ns,
>         struct vfsmount *rootmnt = NULL, *pwdmnt = NULL;
>         struct vfsmount *p, *q;
> 
> -       new_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
> +       new_ns = alloc_mnt_ns();
>         if (!new_ns)
>                 return ERR_PTR(-ENOMEM);
> 
> -       atomic_set(&new_ns->count, 1);
> -       INIT_LIST_HEAD(&new_ns->list);
> -       init_waitqueue_head(&new_ns->poll);
> -       new_ns->event = 0;
> -
>         down_write(&namespace_sem);
>         /* First pass: copy the tree topology */
>         new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
> --- a/include/linux/cr.h

This bit should be broken out, and stuck at the beginning of the series.

-- Dave

