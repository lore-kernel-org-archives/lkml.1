Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbYLPU2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbYLPU2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbYLPU17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:27:59 -0500
Received: from brick.kernel.dk ([93.163.65.50]:1190 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758393AbYLPU16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:27:58 -0500
Date: Tue, 16 Dec 2008 21:27:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mikem@roadking.cca.cpqcorp.net
Subject: Re: [patch] cciss: Fix problem that deleting multiple logical drives could cause a panic
Message-ID: <20081216202730.GZ32491@kernel.dk>
References: <20081216201703.GL1126@beardog.cca.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216201703.GL1126@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16 2008, scameron@beardog.cca.cpqcorp.net wrote:
> 
> Fix problem that deleting multiple logical drives could cause a panic.

This looks like a 2.6.28 candidate, correct?

> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
> ---
> 
>  drivers/block/cciss.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff -puN drivers/block/cciss.c~fix_rebuild_lun_table_bug drivers/block/cciss.c
> --- linux-2.6.28-rc8/drivers/block/cciss.c~fix_rebuild_lun_table_bug	2008-12-16 14:00:52.000000000 -0600
> +++ linux-2.6.28-rc8-root/drivers/block/cciss.c	2008-12-16 14:00:52.000000000 -0600
> @@ -1693,6 +1693,11 @@ static int rebuild_lun_table(ctlr_info_t
>  	for (i = 0; i <= h->highest_lun; i++) {
>  		int j;
>  		drv_found = 0;
> +
> +		/* skip holes in the array from already deleted drives */
> +		if (h->drv[i].raid_level == -1)
> +			continue;
> +
>  		for (j = 0; j < num_luns; j++) {
>  			memcpy(&lunid, &ld_buff->LUN[j][0], 4);
>  			lunid = le32_to_cpu(lunid);
> _

-- 
Jens Axboe

