Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZCRW2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZCRW2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758217AbZCRW2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:28:36 -0400
Received: from tundra.namei.org ([65.99.196.166]:1560 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040AbZCRW2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:28:34 -0400
Date: Thu, 19 Mar 2009 09:21:01 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Igor Zhbanov <izh1979@gmail.com>,
       Serge Hallyn <serue@us.ibm.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, stable@kernel.org
Subject: Re: [PATCH] nfsd: nfsd should drop CAP_MKNOD for non-root
In-Reply-To: <1237393292-14934-3-git-send-email-bfields@fieldses.org>
Message-ID: <alpine.LRH.2.00.0903190920340.15412@tundra.namei.org>
References: <1237393292-14934-1-git-send-email-bfields@fieldses.org> <1237393292-14934-2-git-send-email-bfields@fieldses.org> <1237393292-14934-3-git-send-email-bfields@fieldses.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, J. Bruce Fields wrote:

> From: J. Bruce Fields <bfields@citi.umich.edu>
> 
> Since creating a device node is normally an operation requiring special
> privilege, Igor Zhbanov points out that it is surprising (to say the
> least) that a client can, for example, create a device node on a
> filesystem exported with root_squash.
> 
> So, make sure CAP_MKNOD is among the capabilities dropped when an nfsd
> thread handles a request from a non-root user.
> 
> Reported-by: Igor Zhbanov <izh1979@gmail.com>
> Cc: stable@kernel.org
> Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

Acked-by: James Morris <jmorris@namei.org>

> ---
>  include/linux/capability.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 1b98725..4864a43 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -393,8 +393,10 @@ struct cpu_vfs_cap_data {
>  # define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
>  # define CAP_INIT_EFF_SET ((kernel_cap_t){{ ~CAP_TO_MASK(CAP_SETPCAP), ~0 }})
>  # define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0, CAP_FS_MASK_B1 } })
> -# define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0|CAP_TO_MASK(CAP_SYS_RESOURCE), \
> -					CAP_FS_MASK_B1 } })
> +# define CAP_NFSD_SET     ((kernel_cap_t){{ CAP_FS_MASK_B0 \
> +					    | CAP_TO_MASK(CAP_SYS_RESOURCE) \
> +					    | CAP_TO_MASK(CAP_MKNOD), \
> +					    CAP_FS_MASK_B1 } })
>  
>  #endif /* _KERNEL_CAPABILITY_U32S != 2 */
>  
> -- 
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>
