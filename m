Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYE1FVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYE1FVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYE1FUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:20:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbYE1FUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:20:54 -0400
Date: Tue, 27 May 2008 22:20:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com, Greg KH <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH -next] block: genhd errors when CONFIG_PROC_FS=n
Message-Id: <20080527222036.1141e43a.akpm@linux-foundation.org>
In-Reply-To: <20080523094411.06f173e0.randy.dunlap@oracle.com>
References: <20080523094411.06f173e0.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 09:44:11 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> block/genhd.c has build errors when CONFIG_PROC_FS=n, so omit some of
> its functions in that case.
> 
> /local/linsrc/linux-next-20080523/block/genhd.c: In function 'diskstats_start':
> /local/linsrc/linux-next-20080523/block/genhd.c:555: error: 'find_start' undeclared (first use in this function)
> /local/linsrc/linux-next-20080523/block/genhd.c:555: error: (Each undeclared identifier is reported only once
> /local/linsrc/linux-next-20080523/block/genhd.c:555: error: for each function it appears in.)
> make[2]: *** [block/genhd.o] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  block/genhd.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20080523.orig/block/genhd.c
> +++ linux-next-20080523/block/genhd.c
> @@ -539,6 +539,7 @@ static struct device_type disk_type = {
>  	.release	= disk_release,
>  };
>  
> +#ifdef CONFIG_PROC_FS
>  /*
>   * aggregate disk stat collector.  Uses the same stats that the sysfs
>   * entries do, above, but makes them available through one seq_file.
> @@ -644,6 +645,7 @@ const struct seq_operations diskstats_op
>  	.stop	= diskstats_stop,
>  	.show	= diskstats_show
>  };
> +#endif /* CONFIG_PROC_FS */
>  
>  static void media_change_notify_thread(struct work_struct *work)
>  {

This is a fix against

commit ce8568d9535b4756ea304a97ea803314ce895d3c
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Thu May 22 17:21:08 2008 -0400

    block: make proc files seq_start use the class_find_device()
    
    Use the proper class iterator function instead of mucking around in the
    internals of the class structures.
    
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

