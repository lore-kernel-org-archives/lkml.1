Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbYLSWNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbYLSWNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbYLSWH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:07:58 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:44525 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894AbYLSWHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vs60GGWiTK1+yVMkS5sZYPOYO/lIMblZeGkcYy+Dd/as+JDzMvw7gXopfJQ9C6/Drc
         syyaLiSJyWhbU44X9ycOFH2eK7LEz2/yQz6gi3JnsSntR+KT2S4q7Z04TRbzLOoacnMt
         57wZlliP9jmoP2zLsUfUWLXTpxe+pE8wG5ypU=
Message-ID: <a4e6962a0812191407g40e14e8fw2e08f7e4e812389d@mail.gmail.com>
Date: Fri, 19 Dec 2008 16:07:53 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH, v5] 9p: don't print IS_ERR strings
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ron Minnich" <rminnich@sandia.gov>,
       "Latchesar Ionkov" <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net
In-Reply-To: <1229719638-6982-2-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229719638-6982-1-git-send-email-duaneg@dghda.com>
	 <1229719638-6982-2-git-send-email-duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK - the print is a debug to mark function entry when debugging is on
-- it is not intended to show only success.  If an erroneous s will
cause the print to break then perhaps it should be parameterized, but
the entire print shouldn't be pushed inside the if statement.

            -eric


On Fri, Dec 19, 2008 at 2:47 PM, Duane Griffin <duaneg@dghda.com> wrote:
> Move the printk inside the !IS_ERR test.
>
> Cc: Eric Van Hensbergen <ericvh@gmail.com>
> Cc: Ron Minnich <rminnich@sandia.gov>
> Cc: Latchesar Ionkov <lucho@ionkov.net>
> Cc: v9fs-developer@lists.sourceforge.net
> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> ---
>
> Unchanged from original version.
>
>  fs/9p/vfs_inode.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 8fddfe8..c50d555 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -1022,9 +1022,10 @@ v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd, void *p)
>  {
>        char *s = nd_get_link(nd);
>
> -       P9_DPRINTK(P9_DEBUG_VFS, " %s %s\n", dentry->d_name.name, s);
> -       if (!IS_ERR(s))
> +       if (!IS_ERR(s)) {
> +               P9_DPRINTK(P9_DEBUG_VFS, " %s %s\n", dentry->d_name.name, s);
>                __putname(s);
> +       }
>  }
>
>  /**
> --
> 1.6.0.4
>
>
