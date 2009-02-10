Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZBJUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZBJUq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZBJUqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:46:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754472AbZBJUqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:46:50 -0500
Date: Tue, 10 Feb 2009 12:46:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] check bh->b_blocknr only if BH_Mapped is set
Message-Id: <20090210124640.81d25a27.akpm@linux-foundation.org>
In-Reply-To: <200902091748.12545.knikanth@suse.de>
References: <200902091748.12545.knikanth@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 17:48:11 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> check bh->b_blocknr only if BH_Mapped is set

Why?

> diff --git a/fs/buffer.c b/fs/buffer.c
> index 665d446..782c365 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -344,13 +344,13 @@ __find_get_block_slow(struct block_device *bdev, 
> sector_t block)
>  	head = page_buffers(page);
>  	bh = head;
>  	do {
> -		if (bh->b_blocknr == block) {
> +		if (!buffer_mapped(bh))
> +			all_mapped = 0;
> +		else if (bh->b_blocknr == block) {
>  			ret = bh;
>  			get_bh(bh);
>  			goto out_unlock;
>  		}
> -		if (!buffer_mapped(bh))
> -			all_mapped = 0;
>  		bh = bh->b_this_page;
>  	} while (bh != head);

Does this fix some user-visible misbehaviour?  If so, what was that
behaviour?

Please write good changelogs.  This is not some pointless book-keeping
exercise.  People will make decisions about which kernel versions
patches should be merged into, and they will want to know if a
particular patch addresses a particular problem which they are
experiencing.  For this, they need information.

Thanks.
