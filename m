Return-Path: <linux-kernel-owner+w=401wt.eu-S934246AbYBHKHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934246AbYBHKHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 05:07:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932675AbYBHKGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 05:06:53 -0500
Received: from brick.kernel.dk ([87.55.233.238]:19710 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932727AbYBHKGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 05:06:52 -0500
Date: Fri, 8 Feb 2008 11:06:49 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Ed L. Cashin" <ecashin@coraid.com>
Subject: Re: [Patch 1/6] Enhanced partition statistics: core statistics
Message-ID: <20080208100649.GH15220@kernel.dk>
References: <47A36174.7040600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A36174.7040600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01 2008, Jerome Marchand wrote:
> This patch contain the core infrastructure of enhanced partition
> statistics. It adds to struct hd_struct the same stats data as struct
> gendisk and define basics function to manipulate them.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  include/linux/genhd.h |  132 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 131 insertions(+), 1 deletion(-)
> diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6.orig/include/linux/genhd.h linux-2.6/include/linux/genhd.h
> --- linux-2.6.orig/include/linux/genhd.h	2008-01-31 16:43:28.000000000 +0100
> +++ linux-2.6/include/linux/genhd.h	2008-01-31 16:47:12.000000000 +0100
> @@ -101,6 +101,13 @@ struct hd_struct {
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>  	int make_it_fail;
>  #endif
> +	unsigned long stamp;
> +	int in_flight;
> +#ifdef	CONFIG_SMP
> +	struct disk_stats *dkstats;
> +#else
> +	struct disk_stats dkstats;
> +#endif
>  };

This wont work on !CONFIG_SMP, since the disk_stats structure definition
is below that point. I moved it up.

Committed 1-6, thanks. But please remember to test UP configs too :)

-- 
Jens Axboe

