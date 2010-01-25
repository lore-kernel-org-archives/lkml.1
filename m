Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388Ab0AYROl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0AYROl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 12:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333Ab0AYROk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 12:14:40 -0500
Received: from mail09.linbit.com ([212.69.161.110]:47421 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0AYROk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 12:14:40 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: drbd-dev@lists.linbit.com
Subject: Re: [Drbd-dev] [patch] drbd: null dereference bug
Date: Mon, 25 Jan 2010 18:14:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <20100123124522.GA3061@bicker>
In-Reply-To: <20100123124522.GA3061@bicker>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001251814.37009.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 23. Januar 2010 13:45:22 schrieb Dan Carpenter:
> epoch is always NULL here.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> This patch has only been compile tested.  Sorry.  :/
> 
> --- orig/drivers/block/drbd/drbd_receiver.c	2010-01-23 10:53:13.000000000
>  +0300 +++ devel/drivers/block/drbd/drbd_receiver.c	2010-01-23
>  10:54:19.000000000 +0300 @@ -1224,7 +1224,7 @@ static int
>  receive_Barrier(struct drbd_c
>  	epoch = kmalloc(sizeof(struct drbd_epoch), GFP_NOIO);
>  	if (!epoch) {
>  		dev_warn(DEV, "Allocation of an epoch failed, slowing down\n");
> -		issue_flush = !test_and_set_bit(DE_BARRIER_IN_NEXT_EPOCH_ISSUED, &epoch->flags);
> +		issue_flush = !test_and_set_bit(DE_BARRIER_IN_NEXT_EPOCH_ISSUED, &mdev->current_epoch->flags);
>  		drbd_wait_ee_list_empty(mdev, &mdev->active_ee);
>  		if (issue_flush) {
>  			rv = drbd_flush_after_epoch(mdev, mdev->current_epoch);
>

The patch is correct. It is going upstream though the DRBD tree.
See:
http://git.drbd.org/?p=linux-2.6-drbd.git;a=commit;h=d3db7b485ad7c467a61279d6a8ef51a3c83352df

-Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
