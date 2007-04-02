Return-Path: <linux-kernel-owner+w=401wt.eu-S965774AbXDCMn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965774AbXDCMn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 08:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965775AbXDCMn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 08:43:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4216 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965774AbXDCMnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 08:43:25 -0400
Date: Mon, 2 Apr 2007 18:59:59 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 10/16] show-partitions-on-mount-error.diff
Message-ID: <20070402185958.GB4628@ucw.cz>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012008590.12316@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704012008590.12316@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  block/genhd.c         |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/genhd.h |    1 
>  init/do_mounts.c      |    7 +++++-
>  3 files changed, 61 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.21-rc5/block/genhd.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/block/genhd.c
> +++ linux-2.6.21-rc5/block/genhd.c
> @@ -215,6 +215,60 @@ struct gendisk *get_gendisk(dev_t dev, i
>  	return  kobj ? to_disk(kobj) : NULL;
>  }
>  
> +/*
> + * printk a full list of all partitions - intended for
> + * places where the root filesystem can't be mounted and thus
> + * to give the victim some idea of what went wrong
> + */
> +void printk_all_partitions(void)
> +{
> +	int n;
> +        struct gendisk* sgp;
> +	mutex_lock(&block_subsys_lock);

tabs-vs-spaces problem.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
