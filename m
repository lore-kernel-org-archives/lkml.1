Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZG1Tbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZG1Tbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZG1Tbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:31:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZG1Tbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:31:41 -0400
Date: Tue, 28 Jul 2009 15:31:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UIO: unbreak uio.h userspace compilation
Message-ID: <20090728193139.GA11468@infradead.org>
References: <1248786877-10571-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248786877-10571-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 03:14:37PM +0200, Jiri Slaby wrote:
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index b7fe138..9b2623c 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -42,16 +42,18 @@ struct kvec {
>   * segment lengths have been validated.  Because the individual lengths can
>   * overflow a size_t when added together.
>   */
> -static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
> +static inline __kernel_size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
>  {
>  	unsigned long seg;
> -	size_t ret = 0;
> +	__kernel_size_t ret = 0;
>  
>  	for (seg = 0; seg < nr_segs; seg++)
>  		ret += iov[seg].iov_len;
>  	return ret;
>  }
>  
> +#ifdef __KERNEL__
>  unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
> +#endif

iov_length is kernel internal and should not be exported to userspace.

