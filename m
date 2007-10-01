Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbXJASsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbXJASsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXJASsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:48:32 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:32881 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbXJASsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:48:30 -0400
Subject: Re: [PATCH 20/30] IGET: Stop JFS from using iget() and read_inode()
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       JFS Discussion <jfs-discussion@lists.sourceforge.net>
In-Reply-To: <20071001131104.29339.78301.stgit@warthog.procyon.org.uk>
References: <20071001130921.29339.72876.stgit@warthog.procyon.org.uk>
	 <20071001131104.29339.78301.stgit@warthog.procyon.org.uk>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 13:44:23 -0500
Message-Id: <1191264263.6182.20.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 14:11 +0100, David Howells wrote:
> Stop the JFS filesystem from using iget() and read_inode().  Replace
> jfs_read_inode() with jfs_iget(), and call that instead of iget().
> jfs_iget() then uses iget_locked() directly and returns a proper error code
> instead of an inode in the event of an error.
> 
> jfs_fill_super() returns any error incurred when getting the root inode
> instead of EINVAL.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

> ---
> 
>  fs/jfs/inode.c     |   20 ++++++++++++++++----
>  fs/jfs/jfs_inode.h |    2 +-
>  fs/jfs/namei.c     |   34 ++++++++++++++--------------------
>  fs/jfs/super.c     |   15 +++++++++------
>  4 files changed, 40 insertions(+), 31 deletions(-)

-- 
David Kleikamp
IBM Linux Technology Center

