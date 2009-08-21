Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbZHUAEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbZHUAEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZHUAEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:04:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbZHUAEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:04:24 -0400
Date: Thu, 20 Aug 2009 17:03:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk,
       jens.axboe@oracle.com
Subject: Re: [PATCH 1/4] direct-io: unify argument passing by adding a
 dio_args structure
Message-Id: <20090820170306.93388637.akpm@linux-foundation.org>
In-Reply-To: <1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com>
	<1250763466-24282-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 12:17:36 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> The O_DIRECT IO path is a mess of arguments. Clean that up by passing
> those arguments in a dedicated dio_args structure.
> 
> This is in preparation for changing the internal implementation to be
> page based instead of using iovecs.
> 
> ...
>
> +/*
> + * Arguments passwed to aops->direct_IO()

cnat tpye

> + */
> +struct dio_args {
> +	int rw;
> +	const struct iovec *iov;
> +	unsigned long length;
> +	loff_t offset;
> +	unsigned long nr_segs;
> +};

It would be nice to have some documentation.  Especially for that
pestiferous `rw' thing.

nr_segs is associated with the iovec and might as well be contiguous
with it in the struct.


