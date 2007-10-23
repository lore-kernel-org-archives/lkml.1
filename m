Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbXJWHSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbXJWHSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXJWHS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:18:27 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38337
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752563AbXJWHS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:18:27 -0400
Date: Tue, 23 Oct 2007 00:18:50 -0700 (PDT)
Message-Id: <20071023.001850.130236174.davem@davemloft.net>
To: jens.axboe@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: IDE crash...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071023070932.GB25962@kernel.dk>
References: <20071022.235010.59469063.davem@davemloft.net>
	<20071023070252.GA25962@kernel.dk>
	<20071023070932.GB25962@kernel.dk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 23 Oct 2007 09:09:33 +0200

> Eh this wont work, it's the wrong entry... Here's a temporary
> work-around.
> 
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index c89f0d3..108202b 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -822,6 +822,7 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
>  		return;
>  
>  	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
> +		sg_init_table(hwif->sg_table, hwif->sg_max_nents);
>  		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
>  	} else {
>  		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);

That's the exact patch I'm about to boot test :-)
