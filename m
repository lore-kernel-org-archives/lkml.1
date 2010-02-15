Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab0BODo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 22:44:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48461 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab0BODo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 22:44:26 -0500
Date: Mon, 15 Feb 2010 03:44:17 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: linux-next: manual merge of the xfs tree with the vfs tree
Message-ID: <20100215034417.GV30031@ZenIV.linux.org.uk>
References: <20100215122740.87c6cb5f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215122740.87c6cb5f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 12:27:40PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xfs tree got a conflict in
> fs/xfs/linux-2.6/xfs_super.c between commits
> 4a295406e025bb7c8241ea956ec1b84830499e96 ("make sure data is on disk
> before calling ->write_inode") and
> 716c28c0bc8bcbdd26e819f38dfc8fdfaafc0289 ("pass writeback_control to
> ->write_inode") from the vfs tree and commit
> 07fec73625dc0db6f9aed68019918208a2ca53f5 ("xfs: log changed inodes
> instead of writing them synchronously") from the xfs tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.
> What other file systems are doing for these conflicts is to merge in the
> "write_inode" branch of Al Viro's vfs tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git) which Al
> has said will not be rebased.  (Both those commits are in that branch.)

Actually, I'd cheerfully rebased that sucker (to e.g. write_inode2); it has
grown a trivial conflict with mainline after one of gfs2 merges and it's
annoying to fix it up after each for-next rebase.

So I'd rather put a rebased variant and switched the for-next to using that,
if people who'd pulled it already are OK with that.
