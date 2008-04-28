Return-Path: <linux-kernel-owner+w=401wt.eu-S936520AbYD1Qr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936520AbYD1Qr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936289AbYD1Qre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:47:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:54165 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936275AbYD1Qrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:47:32 -0400
Date: Mon, 28 Apr 2008 18:47:31 +0200
From: Jan Kara <jack@suse.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>, jdike@addtoit.com,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6 patch] fs/udf/partition.c:udf_get_pblock() mustn't be
	inline
Message-ID: <20080428164731.GG17054@duck.suse.cz>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org> <20080426172222.GD17345@elte.hu> <20080428153849.GH2813@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080428153849.GH2813@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-04-08 18:38:49, Adrian Bunk wrote:
> This patch fixes the following build error with UML and gcc 4.3:
> 
> <--  snip  -->
> 
> ...
>   CC      fs/udf/partition.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/udf/partition.c: In function ‘udf_get_pblock_virt15’:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/udf/partition.c:32: sorry, unimplemented: inlining failed in call to ‘udf_get_pblock’: function body not available
> /home/bunk/linux/kernel-2.6/git/linux-2.6/fs/udf/partition.c:102: sorry, unimplemented: called from here
> make[3]: *** [fs/udf/partition.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
  Thanks. Merged into UDF git tree.

										Honza

> ---
> 9739b5f94fdf781f71cbb4c7b2f8f6d9e3d58e55 diff --git a/fs/udf/partition.c b/fs/udf/partition.c
> index 63610f0..96dfd20 100644
> --- a/fs/udf/partition.c
> +++ b/fs/udf/partition.c
> @@ -27,8 +27,8 @@
>  #include <linux/slab.h>
>  #include <linux/buffer_head.h>
>  
> -inline uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
> -			       uint16_t partition, uint32_t offset)
> +uint32_t udf_get_pblock(struct super_block *sb, uint32_t block,
> +			uint16_t partition, uint32_t offset)
>  {
>  	struct udf_sb_info *sbi = UDF_SB(sb);
>  	struct udf_part_map *map;
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
