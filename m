Return-Path: <linux-kernel-owner+w=401wt.eu-S1946118AbXDLKGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946118AbXDLKGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946078AbXDLKGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:06:31 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35715 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945980AbXDLKG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:06:29 -0400
Date: Thu, 12 Apr 2007 11:06:28 +0100
From: Christoph Hellwig <hch@infradead.org>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070412100628.GA25078@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	Tony Jones <tonyj@suse.de>, Andreas Gruenbacher <agruen@suse.de>
References: <20070412090809.917795000@suse.de> <20070412090836.207973000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412090836.207973000@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 02:08:10AM -0700, jjohansen@suse.de wrote:
> This is needed for computing pathnames in the AppArmor LSM.
> 
> Signed-off-by: Tony Jones <tonyj@suse.de>
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: John Johansen <jjohansen@suse.de>
> 
> ---
>  fs/namei.c               |    2 +-
>  include/linux/security.h |    9 ++++++---
>  security/dummy.c         |    2 +-
>  security/selinux/hooks.c |    3 ++-
>  4 files changed, 10 insertions(+), 6 deletions(-)
> 
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -1503,7 +1503,7 @@ int vfs_create(struct inode *dir, struct
>  		return -EACCES;	/* shouldn't it be ENOSYS? */
>  	mode &= S_IALLUGO;
>  	mode |= S_IFREG;
> -	error = security_inode_create(dir, dentry, mode);
> +	error = security_inode_create(dir, dentry, nd ? nd->mnt : NULL, mode);

Once again very strong NACK.  Every conditional passing of vfsmounts get my
veto.  As mentioned last time if you really want this send a patch series
first that passed the vfsmount consistantly.

