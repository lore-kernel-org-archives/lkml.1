Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbXLBJfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbXLBJfw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 04:35:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbXLBJfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 04:35:40 -0500
Received: from yergi.telenet-ops.be ([195.130.132.36]:44920 "EHLO
	yergi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbXLBJfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 04:35:38 -0500
Date: Sun, 2 Dec 2007 10:34:56 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
cc: jens.axboe@oracle.com, bharrosh@panasas.com,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 09/28] blk_end_request: changing ps3disk (take 3)
In-Reply-To: <20071130.182810.98558485.k-ueda@ct.jp.nec.com>
Message-ID: <Pine.LNX.4.64.0712021032490.29349@anakin>
References: <20071130.182810.98558485.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808512-250639608-1196588096=:29349"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808512-250639608-1196588096=:29349
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 30 Nov 2007, Kiyoshi Ueda wrote:
> This patch converts ps3disk to use blk_end_request().
                                     ^^^^^^^^^^^^^^^
Patch subject and description are inconsistent with actual change.

> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  drivers/block/ps3disk.c |    6 +-----
>  1 files changed, 1 insertion(+), 5 deletions(-)
> 
> Index: 2.6.24-rc3-mm2/drivers/block/ps3disk.c
> ===================================================================
> --- 2.6.24-rc3-mm2.orig/drivers/block/ps3disk.c
> +++ 2.6.24-rc3-mm2/drivers/block/ps3disk.c
> @@ -280,11 +280,7 @@ static irqreturn_t ps3disk_interrupt(int
>  	}
>  
>  	spin_lock(&priv->lock);
> -	if (!end_that_request_first(req, uptodate, num_sectors)) {
> -		add_disk_randomness(req->rq_disk);
> -		blkdev_dequeue_request(req);
> -		end_that_request_last(req, uptodate);
> -	}
> +	__blk_end_request(req, uptodate, num_sectors << 9);
        ^^^^^^^^^^^^^^^^^

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---1463808512-250639608-1196588096=:29349--
