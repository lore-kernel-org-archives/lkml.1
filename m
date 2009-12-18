Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZLRO0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZLRO0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZLRO0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:26:54 -0500
Received: from cantor.suse.de ([195.135.220.2]:57800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZLRO0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:26:53 -0500
Date: Fri, 18 Dec 2009 15:26:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Anders Larsen <al@alarsen.net>
Cc: Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] fs/qnx4: decrement sizeof size in strncmp
In-Reply-To: <20091112220836.GA3893@alarsen.net>
Message-ID: <alpine.LNX.2.00.0912181526160.3755@pobox.suse.cz>
References: <20091112220836.GA3893@alarsen.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009, Anders Larsen wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> As an identical match is wanted in this case, strcmp can be used instead.
> 
> The semantic match that lead to detecting this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression foo;
> constant char *abc;
> @@
> 
> *strncmp(foo, abc, sizeof(abc))
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> Signed-off-by: Anders Larsen <al@alarsen.net>
> 
> ---
>  fs/qnx4/inode.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/qnx4/inode.c b/fs/qnx4/inode.c
> index 449f5a6..150f4af 100644
> --- a/fs/qnx4/inode.c
> +++ b/fs/qnx4/inode.c
> @@ -221,7 +221,8 @@ static const char *qnx4_checkroot(struct super_block *sb)
>  				rootdir = (struct qnx4_inode_entry *) (bh->b_data + i * QNX4_DIR_ENTRY_SIZE);
>  				if (rootdir->di_fname != NULL) {
>  					QNX4DEBUG((KERN_INFO "rootdir entry found : [%s]\n", rootdir->di_fname));
> -					if (!strncmp(rootdir->di_fname, QNX4_BMNAME, sizeof QNX4_BMNAME)) {
> +					if (!strcmp(rootdir->di_fname,
> +						    QNX4_BMNAME)) {
>  						found = 1;
>  						qnx4_sb(sb)->BitMap = kmalloc( sizeof( struct qnx4_inode_entry ), GFP_KERNEL );
>  						if (!qnx4_sb(sb)->BitMap) {

Doesn't seem to be present in 2.6.33-rc1.

Applied to my queue, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
