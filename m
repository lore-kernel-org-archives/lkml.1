Return-Path: <linux-kernel-owner+w=401wt.eu-S1756856AbYBQJMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbYBQJMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 04:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYBQJMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 04:12:39 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:65154 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbYBQJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 04:12:37 -0500
Date: Sun, 17 Feb 2008 10:12:33 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] drivers/s390/block/dcssblk.c: Fix Unlikely(x) != y
Message-ID: <20080217091233.GB8030@osiris.ibm.com>
References: <47B70C5A.8070202@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B70C5A.8070202@tiscali.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 05:16:26PM +0100, Roel Kluin wrote:
> The patch below was not yet tested. If it's correct as it is, please comment.
> ---
> Fix Unlikely(x) != y
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> index 3faf053..e6c94db 100644
> --- a/drivers/s390/block/dcssblk.c
> +++ b/drivers/s390/block/dcssblk.c
> @@ -666,7 +666,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
>  		page_addr = (unsigned long)
>  			page_address(bvec->bv_page) + bvec->bv_offset;
>  		source_addr = dev_info->start + (index<<12) + bytes_done;
> -		if (unlikely(page_addr & 4095) != 0 || (bvec->bv_len & 4095) != 0)
> +		if (unlikely((page_addr & 4095) != 0) || (bvec->bv_len & 4095) != 0)
>  			// More paranoia.
>  			goto fail;
>  		if (bio_data_dir(bio) == READ) {

Your patch is correct, thank you! At least it wasn't a real bug. Will be applied.
