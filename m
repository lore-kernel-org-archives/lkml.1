Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZERQdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZERQdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZERQcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:32:55 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61992 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbZERQcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:32:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Mon, 18 May 2009 10:32:21 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 30/32] union mount: ext2 fallthru support
In-reply-to: <1242662968-11684-31-git-send-email-jblunck@suse.de>
To: Jan Blunck <jblunck@suse.de>
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Message-id: <20090518163221.GE3144@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
 <1242662968-11684-31-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 18, 2009  18:09 +0200, Jan Blunck wrote:
> diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
> index bd10826..f6b68ec 100644
> --- a/include/linux/ext2_fs.h
> +++ b/include/linux/ext2_fs.h
> @@ -577,6 +577,7 @@ enum {
>  	EXT2_FT_SOCK,
>  	EXT2_FT_SYMLINK,
>  	EXT2_FT_WHT,
> +	EXT2_FT_FALLTHRU,
>  	EXT2_FT_MAX

The EXT2_FT_WHT is not declared in e2fsprogs::lib/ext2fs/ext2_fs.h
so you risk hitting a conflict here if someone isn't looking at
the "should be left alone" ext2 code.  Secondly, it is somewhat
dangerous to use a straight enum here, because this will reassign
values of later variables if one of the earlier ones is removed.

For enums like this that require specific constant on-disk values
I prefer being safe:

enum {
	EXT2_FT_UNKNOWN  = 0,
	EXT2_FT_REG_FILE = 1,
	EXT2_FT_DIR	 = 2,
	EXT2_FT_CHRDEV   = 3,
	EXT2_FT_BLKDEV   = 4,
	EXT2_FT_FIFO     = 5,
	EXT2_FT_SOCK     = 6,
	EXT2_FT_SYMLINK  = 7,
	EXT2_FT_WHT      = 8,
	EXT2_FT_FALLTHRU = 9,
 	EXT2_FT_MAX


It probably also makes sense to include a patch for ext3/ext4 to ensure
these values are not used by some unrelated feature.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

