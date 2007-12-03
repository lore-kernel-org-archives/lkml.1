Return-Path: <linux-kernel-owner+w=401wt.eu-S1752574AbXLCW5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbXLCW5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXLCW5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:57:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbXLCW5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:57:19 -0500
Date: Mon, 03 Dec 2007 17:55:44 -0500 (EST)
Message-Id: <20071203.175544.13775421.k-ueda@ct.jp.nec.com>
To: Geert.Uytterhoeven@sonycom.com
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com, linuxppc-dev@ozlabs.org,
       k-ueda@ct.jp.nec.com
Subject: Re: [PATCH 09/28] blk_end_request: changing ps3disk (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <Pine.LNX.4.64.0712021032490.29349@anakin>
References: <20071130.182810.98558485.k-ueda@ct.jp.nec.com>
	<Pine.LNX.4.64.0712021032490.29349@anakin>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Sun, 2 Dec 2007 10:34:56 +0100 (CET), Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> On Fri, 30 Nov 2007, Kiyoshi Ueda wrote:
> > This patch converts ps3disk to use blk_end_request().
>                                      ^^^^^^^^^^^^^^^
> Patch subject and description are inconsistent with actual change.
> 
> > Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> > Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> > ---
> >  drivers/block/ps3disk.c |    6 +-----
> >  1 files changed, 1 insertion(+), 5 deletions(-)
> > 
> > Index: 2.6.24-rc3-mm2/drivers/block/ps3disk.c
> > ===================================================================
> > --- 2.6.24-rc3-mm2.orig/drivers/block/ps3disk.c
> > +++ 2.6.24-rc3-mm2/drivers/block/ps3disk.c
> > @@ -280,11 +280,7 @@ static irqreturn_t ps3disk_interrupt(int
> >  	}
> >  
> >  	spin_lock(&priv->lock);
> > -	if (!end_that_request_first(req, uptodate, num_sectors)) {
> > -		add_disk_randomness(req->rq_disk);
> > -		blkdev_dequeue_request(req);
> > -		end_that_request_last(req, uptodate);
> > -	}
> > +	__blk_end_request(req, uptodate, num_sectors << 9);
>       ^^^^^^^^^^^^^^^^^

Thank you for the comment.
The description meant the blk_end_request family, not actual function,
blk_end_request().  But as you pointed out, it is misleading.
I'll change the description of all related patches.

Thanks,
Kiyoshi Ueda
