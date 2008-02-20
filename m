Return-Path: <linux-kernel-owner+w=401wt.eu-S935039AbYBTXin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039AbYBTXin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 18:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbYBTXia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 18:38:30 -0500
Received: from mail.fieldses.org ([66.93.2.214]:41337 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934939AbYBTXi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 18:38:28 -0500
Date: Wed, 20 Feb 2008 18:38:24 -0500
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] nfsd: fix sparse warning in vfs.c
Message-ID: <20080220233824.GM30160@fieldses.org>
References: <1203540542.25307.26.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203540542.25307.26.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 12:49:02PM -0800, Harvey Harrison wrote:
> fs/nfsd/vfs.c:991:27: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  fs/nfsd/vfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Also applied, thanks.--b.

> 
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 0265310..17ac51b 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -988,7 +988,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
>  	 * flushing the data to disk is handled separately below.
>  	 */
>  
> -	if (file->f_op->fsync == 0) {/* COMMIT3 cannot work */
> +	if (!file->f_op->fsync) {/* COMMIT3 cannot work */
>  	       stable = 2;
>  	       *stablep = 2; /* FILE_SYNC */
>  	}
> -- 
> 1.5.4.2.200.g99e75
> 
