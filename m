Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbZBCAEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbZBCAEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754051AbZBCAEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:04:22 -0500
Received: from tundra.namei.org ([65.99.196.166]:4328 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbZBCAEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:04:22 -0500
Date: Tue, 3 Feb 2009 11:03:36 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 3/6] integrity: IMA display
In-Reply-To: <20090202231428.GB18452@hallyn.com>
Message-ID: <alpine.LRH.1.10.0902031103220.19912@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com> <d92bfa1d386febc0f56c80204203a43d63d42d02.1233262163.git.zohar@linux.vnet.ibm.com> <alpine.LRH.1.10.0901302013200.31987@tundra.namei.org> <1233321251.3602.3.camel@localhost.localdomain>
 <20090202231428.GB18452@hallyn.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, Serge E. Hallyn wrote:

> >From dec581b116f16657db9b6f59b7e71f7a7026cd21 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Mon, 2 Feb 2009 15:07:33 -0800
> Subject: [PATCH 1/1] securityfs: fix long-broken securityfs_create_file comment
> 
> If there is an error creating a file through securityfs_create_file,
> NULL is not returned, rather the error is propagated.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>


Applied, thanks.

> ---
>  security/inode.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/security/inode.c b/security/inode.c
> index efea5a6..ae243dd 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -205,12 +205,11 @@ static int create_by_name(const char *name, mode_t mode,
>   * This function returns a pointer to a dentry if it succeeds.  This
>   * pointer must be passed to the securityfs_remove() function when the file is
>   * to be removed (no automatic cleanup happens if your module is unloaded,
> - * you are responsible here).  If an error occurs, %NULL is returned.
> + * you are responsible here).  If an error occurs, the function will return
> + * the erorr value (via ERR_PTR).
>   *
>   * If securityfs is not enabled in the kernel, the value %-ENODEV is
> - * returned.  It is not wise to check for this value, but rather, check for
> - * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
> - * code.
> + * returned.
>   */
>  struct dentry *securityfs_create_file(const char *name, mode_t mode,
>  				   struct dentry *parent, void *data,
> -- 
> 1.5.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>
