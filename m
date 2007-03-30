Return-Path: <linux-kernel-owner+w=401wt.eu-S933567AbXC3JIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbXC3JIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 05:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933609AbXC3JIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 05:08:51 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:44385 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933567AbXC3JIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 05:08:50 -0400
Date: Fri, 30 Mar 2007 11:07:52 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Ken Chen <kenchen@google.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] remove artificial software max_loop limit
In-Reply-To: <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>
 <b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 30 2007 01:48, Ken Chen wrote:
> On 3/30/07, Ken Chen <kenchen@google.com> wrote:

> @@ -812,7 +811,7 @@ static int loop_set_fd
> lo->lo_queue->queuedata = lo;
> lo->lo_queue->unplug_fn = loop_unplug;
>
> -	set_capacity(disks[lo->lo_number], size);
> +	set_capacity(lo->lo_disk, size);
> bd_set_size(bdev, size << 9);
>
> 	set_blocksize(bdev, lo_blocksize);
> @@ -832,7 +831,7 @@ out_clr:
> lo->lo_device = NULL;
> lo->lo_backing_file = NULL;
> lo->lo_flags = 0;
> -	set_capacity(disks[lo->lo_number], 0);
> +	set_capacity(lo->lo_disk, 0);
> invalidate_bdev(bdev, 0);
> bd_set_size(bdev, 0);
> mapping_set_gfp_mask(mapping, lo->old_gfp_mask);

Welcome to Google Mail, we eat your whitespace :-)

> +	sprintf(disk->disk_name, "loop%d", i);

Let's make this %u, no?

> +static struct kobject *loop_probe(dev_t dev, int *part, void *data)
> +{
> +	unsigned int number = dev & MINORMASK;
> +	struct loop_device *lo;
>
> -	for (i = 0; i < max_loop; i++) {
> -		disks[i] = alloc_disk(1);
> -		if (!disks[i])
> -			goto out_mem3;
> -	}

Could not we use kobject_uevent(), like I did (though perhaps without
the k.oops), to make udev create a node?


Jan
-- 
