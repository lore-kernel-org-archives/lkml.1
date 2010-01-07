Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325Ab0AGLdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0AGLdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039Ab0AGLdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:33:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:34652 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0AGLdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:33:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IlVEsQYc+2h8kbCGoX9ex7O8pSZLl2JLqOdae7M9BuVLWbAUUN1PKRbeSVlZaLsCxD
         bbPWLLOE/1cUP7Ow/US9AYl12J4XgmqdCyS18MfYHsB+ZxdQOGRi/n/RFZ8J6Vi8bC0J
         06aJWD1tf3hPUsLTE/6I+a0Y565LIYiOcEfmU=
Date: Thu, 7 Jan 2010 12:33:44 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] FS: reiserfs, fix unreachable statement
Message-ID: <20100107113341.GA5093@nowhere>
References: <1262815790-5864-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262815790-5864-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 11:09:50PM +0100, Jiri Slaby wrote:
> Stanse found an unreachable statement in reiserfs_ioctl. There is
> if followed by assignment and `break'. with no braces. Add the
> braces so that we don't break every time, but only in error case.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: reiserfs-devel@vger.kernel.org
> ---



Looks good.
I've applied it, thanks!



>  fs/reiserfs/ioctl.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
> index ace7745..f53505d 100644
> --- a/fs/reiserfs/ioctl.c
> +++ b/fs/reiserfs/ioctl.c
> @@ -104,9 +104,10 @@ setflags_out:
>  		err = put_user(inode->i_generation, (int __user *)arg);
>  		break;
>  	case REISERFS_IOC_SETVERSION:
> -		if (!is_owner_or_cap(inode))
> +		if (!is_owner_or_cap(inode)) {
>  			err = -EPERM;
>  			break;
> +		}
>  		err = mnt_want_write(filp->f_path.mnt);
>  		if (err)
>  			break;
> -- 
> 1.6.5.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

