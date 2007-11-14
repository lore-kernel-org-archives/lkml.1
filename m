Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbXKNF0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbXKNF0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXKNF0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:26:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45475 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750893AbXKNF0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:26:10 -0500
Date: Tue, 13 Nov 2007 21:25:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk,
       apw@shadowen.org
Subject: Re: [PATCH] 2.6.24-rc2-mm1 - Build Fail - fs/bfs/inode.c
Message-Id: <20071113212547.495f24dd.akpm@linux-foundation.org>
In-Reply-To: <20071114050054.GB12453@linux.vnet.ibm.com>
References: <20071114050054.GB12453@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2007 10:30:54 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The kernel build fails, with following error
> 
> fs/bfs/inode.c: In function ‘bfs_iget’:
> fs/bfs/inode.c:37: error: ‘ino’ redeclared as different kind of symbol
> fs/bfs/inode.c:35: error: previous definition of ‘ino’ was here
> fs/bfs/inode.c:37: error: ‘inode’ undeclared (first use in this function)
> fs/bfs/inode.c:37: error: (Each undeclared identifier is reported onlyonce
> fs/bfs/inode.c:37: error: for each function it appears in.)
> make[2]: *** [fs/bfs/inode.o] Error 1
> make[1]: *** [fs/bfs] Error 2
> make: *** [fs] Error 2
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
> --- linux-2.6.24-rc2/fs/bfs/inode.c	2007-11-14 09:53:41.000000000 +0530
> +++ linux-2.6.24-rc2/fs/bfs/~inode.c	2007-11-14 10:21:06.000000000 +0530
> @@ -34,7 +34,6 @@ void dump_imap(const char *prefix, struc
>  
>  struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
>  {
> -	unsigned long ino = inode->i_ino;
>  	struct bfs_inode *di;
>  	struct inode *inode;
>  	struct buffer_head *bh;
> 

bah.  That's what happens when I apply patches and fix rejects after doing
all my compile-coverage testing.

Thanks.  I put your two fixes into the hot-fixes/ directory.
