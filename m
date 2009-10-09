Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbZJISbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbZJISbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761286AbZJISbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:31:43 -0400
Received: from kroah.org ([198.145.64.141]:35322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761266AbZJISbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:31:42 -0400
Date: Fri, 9 Oct 2009 10:30:40 -0700
From: Greg KH <greg@kroah.com>
To: tom.leiming@gmail.com
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] init/do_mounts.c: replace polling for root device
 with devtmpfs_wait_for_dev v1
Message-ID: <20091009173040.GA5718@kroah.com>
References: <1249551642-13182-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249551642-13182-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 05:40:42PM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch removes the polling for root device if rootwait parameter is
> passed to kernel and CONFIG_DEVTMPFS is enabled. This way can lead to
> a faster boot, especially booting from some asynchronous block device
> (such as usb mass storage, mmc card, ...)
> 
> The patch has been verified in beagle board(mmc card as root device).
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  init/do_mounts.c |   16 ++++++++++++++++
>  1 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/init/do_mounts.c b/init/do_mounts.c
> index aa56007..46f0248 100644
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -364,6 +364,7 @@ void __init mount_root(void)
>  void __init prepare_namespace(void)
>  {
>  	int is_floppy;
> +	int ret;
>  
>  	if (root_delay) {
>  		printk(KERN_INFO "Waiting %dsec before mounting root device...\n",
> @@ -371,6 +372,7 @@ void __init prepare_namespace(void)
>  		ssleep(root_delay);
>  	}
>  
> +#ifndef CONFIG_DEVTMPFS
>  	/*
>  	 * wait for the known devices to complete their probing
>  	 *
> @@ -379,6 +381,7 @@ void __init prepare_namespace(void)
>  	 * for the touchpad of a laptop to initialize.
>  	 */
>  	wait_for_device_probe();
> +#endif

Any way to do this without the #ifdef mess in the file?  That's pretty
ugly, and hard to maintain.

thanks,

greg k-h
