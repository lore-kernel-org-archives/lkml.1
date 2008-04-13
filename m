Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYDMJWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYDMJWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYDMJWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:22:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51693 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754814AbYDMJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:22:05 -0400
Date: Sun, 13 Apr 2008 10:17:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 2/7] omfs: add inode routines
Message-ID: <20080413101743.7d762e58@core>
In-Reply-To: <1208041121-26787-3-git-send-email-me@bobcopeland.com>
References: <1208041121-26787-3-git-send-email-me@bobcopeland.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> + * so we have to walk the tree.  Both inodes and file data are allocated
> + * from the same map.  This array can be big (300k) so we allocate
> + * in units of the blocksize.

sbi->s_num_blocks doesn't appear to be validated at the time of mount ?

> +static int omfs_fill_super(struct super_block *sb, void *data, int silent)
> +{

> +	sbi->s_num_blocks = be64_to_cpu(omfs_sb->s_num_blocks);
> +	sbi->s_blocksize = be32_to_cpu(omfs_sb->s_blocksize);
> +	sbi->s_mirrors = be32_to_cpu(omfs_sb->s_mirrors);
> +	sbi->s_root_ino = be64_to_cpu(omfs_sb->s_root_block);
> +	sbi->s_sys_blocksize = be32_to_cpu(omfs_sb->s_sys_blocksize);

Several of these look like they should be checked before use elsewhere in
the code (eg blocksize is fed into shifts later)

