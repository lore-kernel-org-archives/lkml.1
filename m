Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbXHAN5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbXHAN5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932092AbXHAN5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:57:12 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:47150 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932066AbXHAN5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:57:11 -0400
Subject: Re: [PATCH] FRV: Make BSG declarations dependent on CONFIG_BLOCK
From: James Bottomley <James.Bottomley@SteelEye.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070801091353.10608.32356.stgit@warthog.cambridge.redhat.com>
References: <20070801091353.10608.32356.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 08:57:09 -0500
Message-Id: <1185976630.3468.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-01 at 10:13 +0100, David Howells wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Make BSG function declarations dependent on CONFIG_BLOCK as they are not
> compilable if the block layer is compiled out.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/bsg.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/bsg.h b/include/linux/bsg.h
> index 102dc09..e917c41 100644
> --- a/include/linux/bsg.h
> +++ b/include/linux/bsg.h
> @@ -47,6 +47,7 @@ struct sg_io_v4 {
>  };
>  
>  #ifdef __KERNEL__
> +#ifdef CONFIG_BLOCK
>  
>  #if defined(CONFIG_BLK_DEV_BSG)
>  struct bsg_class_device {
> @@ -68,6 +69,7 @@ static inline void bsg_unregister_queue(struct request_queue *rq)
>  }
>  #endif
>  
> +#endif /* CONFIG_BLOCK */
>  #endif /* __KERNEL__ */

Are you sure you're testing with git head?  CONFIG_BLK_DEV_BSG cannot be
set unless CONFIG_BLOCK is (which was a bug in previous releases now
fixed in git head ... unless the fix has gone wrong?).

James


