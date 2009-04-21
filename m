Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZDUHdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZDUHdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbZDUHch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:32:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48029 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbZDUHcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:32:36 -0400
Date: Tue, 21 Apr 2009 09:32:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, alexb <alexb@vax.1wt.eu>
Subject: Re: [PATCH 1/2] fs/compat_ioctl: fix build when !BLOCK
Message-ID: <20090421073234.GB4593@kernel.dk>
References: <1240215264-8096-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240215264-8096-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20 2009, Alexander Beregalov wrote:
> From: alexb <alexb@localhost.(none)>
> 
> In file included from fs/compat_ioctl.c:61:
> include/linux/loop.h:59: error: field 'lo_bio_list' has incomplete type
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Thanks, applied.

> ---
>  fs/compat_ioctl.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> index 3e87ce4..b83f6bc 100644
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -58,7 +58,6 @@
>  #include <linux/i2c.h>
>  #include <linux/i2c-dev.h>
>  #include <linux/atalk.h>
> -#include <linux/loop.h>
>  
>  #include <net/bluetooth/bluetooth.h>
>  #include <net/bluetooth/hci.h>
> @@ -68,6 +67,7 @@
>  #include <linux/gigaset_dev.h>
>  
>  #ifdef CONFIG_BLOCK
> +#include <linux/loop.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_ioctl.h>
>  #include <scsi/sg.h>
> @@ -2660,6 +2660,8 @@ HANDLE_IOCTL(SONET_GETFRAMING, do_atm_ioctl)
>  HANDLE_IOCTL(SONET_GETFRSENSE, do_atm_ioctl)
>  /* block stuff */
>  #ifdef CONFIG_BLOCK
> +/* loop */
> +IGNORE_IOCTL(LOOP_CLR_FD)
>  /* Raw devices */
>  HANDLE_IOCTL(RAW_SETBIND, raw_ioctl)
>  HANDLE_IOCTL(RAW_GETBIND, raw_ioctl)
> @@ -2728,9 +2730,6 @@ HANDLE_IOCTL(LPSETTIMEOUT, lp_timeout_trans)
>  IGNORE_IOCTL(VFAT_IOCTL_READDIR_BOTH32)
>  IGNORE_IOCTL(VFAT_IOCTL_READDIR_SHORT32)
>  
> -/* loop */
> -IGNORE_IOCTL(LOOP_CLR_FD)
> -
>  #ifdef CONFIG_SPARC
>  /* Sparc framebuffers, handled in sbusfb_compat_ioctl() */
>  IGNORE_IOCTL(FBIOGTYPE)
> -- 
> 1.6.2.3
> 

-- 
Jens Axboe

