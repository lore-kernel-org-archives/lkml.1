Return-Path: <linux-kernel-owner+w=401wt.eu-S1758705AbYA0Tm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbYA0Tm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbYA0Tmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:42:50 -0500
Received: from ns2.suse.de ([195.135.220.15]:57013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbYA0Tmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:42:49 -0500
Date: Sun, 27 Jan 2008 11:40:53 -0800
From: Greg KH <gregkh@suse.de>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] drivers/base/core.c: fix a compile error
Message-ID: <20080127194053.GA17136@suse.de>
References: <479A4867.9040302@goop.org> <20080125221731.GB15172@suse.de> <20080125150002.09cdacb8.rdunlap@xenotime.net> <20080125231129.GD25074@suse.de> <479A6F9D.8040402@goop.org> <20080126091445.GA20935@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126091445.GA20935@hacking>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 05:14:45PM +0800, WANG Cong wrote:
> On Fri, Jan 25, 2008 at 03:24:13PM -0800, Jeremy Fitzhardinge wrote:
> >Greg KH wrote:
> >>Ah, sorry, I missed that "note" :(
> >>
> >>thanks,
> >>
> >>greg 'time to get that make randconfig system up and working' k-h
> >>  
> >
> >Here's a config that fails.
> >
> 
> Here's one possible fix. Please review.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> ---
> 
> Index: linux-2.6/include/linux/genhd.h
> ===================================================================
> --- linux-2.6.orig/include/linux/genhd.h
> +++ linux-2.6/include/linux/genhd.h
> @@ -12,6 +12,8 @@
>  #include <linux/types.h>
>  #include <linux/kdev_t.h>
>  
> +extern struct device_type part_type;
> +
>  #ifdef CONFIG_BLOCK
>  
>  #define kobj_to_dev(k) container_of(k, struct device, kobj)
> @@ -19,7 +21,6 @@
>  #define dev_to_part(device) container_of(device, struct hd_struct, dev)
>  
>  extern struct device_type disk_type;
> -extern struct device_type part_type;
>  extern struct kobject *block_depr;
>  extern struct class block_class;

No, that will fix the build error, but die when linking :(

I'll work on a real fix for this now...

thanks,

greg k-h
