Return-Path: <linux-kernel-owner+w=401wt.eu-S1759920AbYCZLBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920AbYCZLBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 07:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbYCZLB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 07:01:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27414 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbYCZLB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 07:01:28 -0400
Date: Wed, 26 Mar 2008 12:01:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] set relay file can not be read by pread(2)
Message-ID: <20080326110121.GA15355@kernel.dk>
References: <47E9FEF5.4080606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E9FEF5.4080606@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26 2008, Lai Jiangshan wrote:
> Hi:
> 	I found that relay files can be read by pread(2). I fix it,
> for relay files are not capable of seeking.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> --- linux-2.6.24/kernel/relay.c.org	2008-01-25 06:58:37.000000000 +0800
> +++ linux-2.6.24/kernel/relay.c	2008-03-17 23:53:14.000000000 +0800
> @@ -741,7 +741,7 @@ static int relay_file_open(struct inode 
>  	kref_get(&buf->kref);
>  	filp->private_data = buf;
>  
> -	return 0;
> +	return nonseekable_open(inode, filp);
>  }
>  
>  /**

Good catch. I'll add it for 2.6.25.

-- 
Jens Axboe

