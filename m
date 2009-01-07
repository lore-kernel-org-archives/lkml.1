Return-Path: <linux-kernel-owner+w=401wt.eu-S1759697AbZAGSAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759697AbZAGSAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 13:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZAGSAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 13:00:32 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:64004 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751020AbZAGSAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 13:00:31 -0500
Date: Wed, 7 Jan 2009 19:00:24 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tim Bird <tim.bird@am.sony.com>, sfr@canb.auug.org.au,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH V3 01/17] Squashfs: inode operations
In-Reply-To: <E1LJnJn-0002L2-GZ@dylan.lougher.demon.co.uk>
Message-ID: <Pine.LNX.4.64.0901071854210.32034@vixen.sonytel.be>
References: <E1LJnJn-0002L2-GZ@dylan.lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Phillip Lougher wrote:
> diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
> new file mode 100644
> index 0000000..7a63398
> --- /dev/null
> +++ b/fs/squashfs/inode.c
> @@ -0,0 +1,346 @@

> +int squashfs_read_inode(struct inode *inode, long long ino)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	struct squashfs_sb_info *msblk = sb->s_fs_info;
> +	u64 block = SQUASHFS_INODE_BLK(ino) + msblk->inode_table;
        ^^^

> +		TRACE("File inode %x:%x, start_block %llx, block_list_start "
                                                     ^^^^
> +			"%llx, offset %x\n", SQUASHFS_INODE_BLK(ino),
                         ^^^^
> +			offset, squashfs_i(inode)->start, block, offset);

Note that I get lots of

| warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'

on ppc64, since you switched from `unsigned long long' to 'u64', as `u64' is
(still -- this is being changed) `unsigned long' on pp64.

I guess no action has to be taken, for now?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
