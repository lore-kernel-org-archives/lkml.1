Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154AbZHRGt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbZHRGt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 02:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZHRGtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 02:49:55 -0400
Received: from relay2.sgi.com ([192.48.179.30]:46337 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750994AbZHRGtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 02:49:55 -0400
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Sandeen <sandeen@sandeen.net>,
       Christoph Hellwig <hch@infradead.org>
Message-Id: <523385BE-5397-49A3-A158-FD1B9D12F067@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20090818101215.aba4d0bf.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: linux-next: manual merge of the xfs tree with Linus' tree
Date: Tue, 18 Aug 2009 01:49:52 -0500
References: <20090818101215.aba4d0bf.sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 17, 2009, at 7:12 PM, Stephen Rothwell wrote:

> Hi all,
>
> Today's linux-next merge of the xfs tree got a conflict in
> fs/xfs/linux-2.6/xfs_sync.h between commit
> bc990f5cb424cdca9dda866785d088e2c2110ecc ("xfs: fix locking in
> xfs_iget_cache_hit") from Linus' tree and commit
> 370f048214b4e9aa2102fa3c454ae1374da287c5 ("xfs: add more statics &  
> drop
> some unused functions") from the xfs tree.

Sorry, I didn't realize that there is a merge between linux-next,
which uses the xfs master tree, and the Linus' tree.

> Just context changes (add/remove). I fixed it up (see below) and can
> carry the fix as necessary.

Thanks for the fix, but there is no need to carrying it separately
from the xfs master tree. I merged the bc990f5 commit back into the
the master tree, and fixed all conflicts (there was another one in
fs/xfs/xfs_iget.c). I planned to do it anyway for 2.6.32.

Thanks,
Felix

>
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc fs/xfs/linux-2.6/xfs_sync.h
> index 5912060,23e7e7e..0000000
> --- a/fs/xfs/linux-2.6/xfs_sync.h
> +++ b/fs/xfs/linux-2.6/xfs_sync.h
> @@@ -48,8 -48,6 +48,7 @@@ int xfs_reclaim_inode(struct xfs_inode
>  int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
>
>  void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
> +void __xfs_inode_set_reclaim_tag(struct xfs_perag *pag, struct  
> xfs_inode *ip);
> - void xfs_inode_clear_reclaim_tag(struct xfs_inode *ip);
>  void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp, struct  
> xfs_perag *pag,
>  				struct xfs_inode *ip);
>

