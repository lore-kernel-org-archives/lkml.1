Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbYCLDZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbYCLDZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 23:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYCLDZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 23:25:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42563 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYCLDZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 23:25:37 -0400
Message-ID: <47D74D0E.8090308@garzik.org>
Date: Tue, 11 Mar 2008 23:25:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genhd must_check warning fix
References: <20080312001317.D68A526F991@magilla.localdomain>
In-Reply-To: <20080312001317.D68A526F991@magilla.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> Fixes:
> 
> 	block/genhd.c:361: warning: ignoring return value of ‘class_register’, declared with attribute warn_unused_result
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  block/genhd.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index c44527d..00da521 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -360,7 +360,9 @@ static struct kobject *base_probe(dev_t devt, int *part, void *data)
>  
>  static int __init genhd_device_init(void)
>  {
> -	class_register(&block_class);
> +	int error = class_register(&block_class);
> +	if (unlikely(error))
> +		return error;
>  	bdev_map = kobj_map_init(base_probe, &block_class_lock);
>  	blk_dev_init();

ACK

I was silly and simply tuned out this warning, assuming [wrongly] that 
it was difficult to fix like the fs/partitions.c warning.

Shows how "helpful" those warnings are...

	Jeff



