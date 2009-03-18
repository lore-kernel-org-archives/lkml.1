Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZCRRJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZCRRJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 13:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZCRRIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 13:08:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52801 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbZCRRIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:08:51 -0400
Date: Wed, 18 Mar 2009 12:08:43 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, Igor Zhbanov <izh1979@gmail.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, stable@kernel.org
Subject: Re: [PATCH] nfsd: nfsd should drop CAP_MKNOD for non-root
Message-ID: <20090318170843.GA29045@us.ibm.com>
References: <1237393292-14934-1-git-send-email-bfields@fieldses.org> <1237393292-14934-2-git-send-email-bfields@fieldses.org> <1237393292-14934-3-git-send-email-bfields@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237393292-14934-3-git-send-email-bfields@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting J. Bruce Fields (bfields@fieldses.org):
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

Acked-by: Serge Hallyn <serue@us.ibm.com>

I assume CAP_LINUX_IMMUTABLE simply does not apply to nfs?

And, you're adding CAP_FS_MASK_B1 in anticipation of labeled nfs?

Though, I was going to send a patch later today or tomorrow (figure I
should do some ltp testing) adding CAP_MKNOD to the whole
CAP_FS_MASK_B0 (and CAP_LINUX_IMMUTABLE and CAP_FS_MASK_B1 to
CAP_FS_SET).  That will conflict with this one.

thanks,
-serge

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
