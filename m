Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYL2NEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYL2NEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:04:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbYL2NDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:03:54 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbYL2NDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:03:54 -0500
Date: Mon, 29 Dec 2008 08:03:53 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] linux/uio.h: cleanup for userspace
Message-ID: <20081229130353.GA10167@infradead.org>
References: <20081229125609.GB1852@uranus.ravnborg.org> <1230555599-23568-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230555599-23568-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 07:59:59AM -0500, Mike Frysinger wrote:
> Hide iov_shorten() behind __KERNEL__ since it's a prototype only.  Use the
> __inline__ form for iov_length() since it's usable by userspace.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> v3
> 	- keep all __KERNEL__ stuff in one place
> v2
> 	- drop inline conversion stuff
> 
>  include/linux/uio.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index b7fe138..3debd89 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -26,6 +26,8 @@ struct kvec {
>  	size_t iov_len;
>  };
>  
> +unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
> +
>  #endif
>  
>  /*
> @@ -52,6 +54,4 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
>  	return ret;
>  }
>  
> -unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
> -
>  #endif

Umm, iov_length is another kernel-only thing and should not be left
user-visible.  And struct kvec is in another __KERNEL__ block.

Just move UIO_FASTIOV and UIO_MAXIOV up and have a single __KERNEL__
block for the rest.

