Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbYFLRTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbYFLRTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYFLRTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:19:22 -0400
Received: from styx.suse.cz ([82.119.242.94]:41956 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753299AbYFLRTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:19:21 -0400
Date: Thu, 12 Jun 2008 19:19:19 +0200
From: Jan Kara <jack@suse.cz>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: arjenpool@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Cant compile 2.6.26-rc5-mm2 kernel
Message-ID: <20080612171919.GD12367@duck.suse.cz>
References: <200806112008.56478.arjenpool@gmail.com> <20080611200342.GA24766@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611200342.GA24766@damson.getinternet.no>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-06-08 22:03:42, Vegard Nossum wrote:
> Hi,
> 
> Thanks for the report.
> 
> On Wed, Jun 11, 2008 at 8:08 PM,  <arjenpool@gmail.com> wrote:
> > Today i`ve tried to compile a linux-2.6.26-rc5-mm2 kernel obtained with the
> > Ketchup tool.
> >
> > It got halfway interupted with the following error messages:
> >
> > CC [M] fs/xfs/support/debug.o
> >  CC [M] fs/xfs/support/uuid.o
> >  LD [M] fs/xfs/xfs.o
> >  CC fs/quota.o
> > fs/quota.c: In function 'quota_sync_sb':
> > fs/quota.c:174: error: implicit declaration of function 'sb_dqopt'
> 
> It seems that this definition is needed regardless of CONFIG_QUOTA.
> 
> I'm attaching a patch that fixes it for me. I'm not 100% it's the right
> thing.
  Yes, it is the right thing. I forgot to test compilation with XFS and
quotas off... Thanks for fixing this.
  You can add: Acked-by: Jan Kara <jack@suse.cz>

									Honza
 
> From 5fc276129d8a3e2a70980104cc374bdc0d61afa3 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Wed, 11 Jun 2008 21:58:32 +0200
> Subject: [PATCH] fs: fix build breakage
> 
> The patch
> 
> | commit 9651a656c9fbf3e8183b5eb21740edc1eb9ca16b
> | Author: Jan Kara <jack@suse.cz>
> | Date:   Thu Jun 5 19:53:42 2008 +0000
> |
> |     quota-move-function-macros-from-quotah-to-quotaopsh
> |
> 
> causes the build to break for CONFIG_QUOTA=n.
> 
> Reported-by: Arjen Pool <arjenpool@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  include/linux/quotaops.h |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index 5644280..eb575d1 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -14,6 +14,11 @@
>  
>  #include <linux/fs.h>
>  
> +static inline struct quota_info *sb_dqopt(struct super_block *sb)
> +{
> +	return &sb->s_dquot;
> +}
> +
>  #if defined(CONFIG_QUOTA)
>  
>  /*
> @@ -52,11 +57,6 @@ void vfs_dq_drop(struct inode *inode);
>  int vfs_dq_transfer(struct inode *inode, struct iattr *iattr);
>  int vfs_dq_quota_on_remount(struct super_block *sb);
>  
> -static inline struct quota_info *sb_dqopt(struct super_block *sb)
> -{
> -	return &sb->s_dquot;
> -}
> -
>  static inline struct mem_dqinfo *sb_dqinfo(struct super_block *sb, int type)
>  {
>  	return sb_dqopt(sb)->info + type;
> -- 
> 1.5.4.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
