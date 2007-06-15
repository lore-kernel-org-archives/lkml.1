Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbXFOXlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbXFOXlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbXFOXlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:41:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38953 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbXFOXlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:41:31 -0400
Subject: Re: [PATCH] ext4:fix unexpected error from ext4_reserve_global
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
In-Reply-To: <20070614152927.GC6517@localhost.sw.ru>
References: <20070614152927.GC6517@localhost.sw.ru>
Content-Type: text/plain
Organization: IBM LTC
Date: Fri, 15 Jun 2007 16:41:24 -0700
Message-Id: <1181950884.3808.16.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-06-14 at 19:29 +0400, Dmitriy Monakhov wrote:
> I just cant belive my eyes then i saw this at the first time...
> simple test: strace dd if=/dev/zero of=/mnt/file
> 
Thanks for reporting it. 

> open("/dev/zero", O_RDONLY)             = 0
> close(1)                                = 0
> open("/mnt/test/file", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 1
> read(0, "\0\0\0\0\0\0\0\0\0"..., 512) = 512
> write(1, "\0\0\0\0\0\0\0\0"..., 512) = 512
> read(0, "\0\0\0\0\0\0\0\0\0"..., 512) = 512
> write(1, "\0\0\0\0\0\0\0\0"..., 512) = -1 ENOENT (No such fil
> e or directory)
> 
> This strange error returned from ext4_reserve_global().
> It's just typo because:
> a) In fact this is 100% ENOSPC situation
> b) simular function ext4_reserve_local() returns -ENOSPC
> 
I agree.

Patch is put in ext4 patch queue. Alex if you can Ack, that would be
great.


Thanks,

Mingming
> Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
> ---
>  fs/ext4/balloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 4d7bfd2..43ae8f8 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -1920,7 +1920,7 @@ int ext4_reserve_global(struct super_block *sb, int blocks)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
>  	struct ext4_reservation_slot *rs;
> -	int i, rc = -ENOENT;
> +	int i, rc = -ENOSPC;
>  	__u64 free = 0;
> 
>  	rs = sbi->s_reservation_slots;

