Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbYFIT7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbYFIT7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbYFIT7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:59:16 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:43651 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbYFIT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:59:16 -0400
Date: Mon, 9 Jun 2008 14:59:15 -0500
From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
To: scameron@beardog.cca.cpqcorp.net
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [patch] cciss: Fix regression that no device nodes are created if no logical drives are configured.
Message-ID: <20080609195915.GA12866@beardog.cca.cpqcorp.net>
References: <20080609184649.GV8065@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609184649.GV8065@beardog.cca.cpqcorp.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 01:46:49PM -0500, scameron@beardog.cca.cpqcorp.net wrote:
> 
> 
> Fix regression in cciss driver that if no logical drives are configured,
> no device nodes at all get created.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>
Acked-by: Mike Miller <mike.miller@hp.com>
> 
> ---
> 
>  drivers/block/cciss.c |    4 ++++
>  1 files changed, 4 insertions(+)
> 
> diff -puN drivers/block/cciss.c~cciss_fix_cxd0_missing_if_no_drives drivers/block/cciss.c
> --- linux-2.6.26rc5/drivers/block/cciss.c~cciss_fix_cxd0_missing_if_no_drives	2008-06-09 09:27:37.000000000 -0500
> +++ linux-2.6.26rc5-root/drivers/block/cciss.c	2008-06-09 12:33:07.000000000 -0500
> @@ -3535,6 +3535,10 @@ static int __devinit cciss_init_one(stru
>  	for (j = 0; j <= hba[i]->highest_lun; j++)
>  		add_disk(hba[i]->gendisk[j]);
>  
> +	/* we must register the controller even if no disks exist */
> +	if (hba[i]->highest_lun == -1)
> +		add_disk(hba[i]->gendisk[0]);
> +
>  	return 1;
>  
>        clean4:
> _
