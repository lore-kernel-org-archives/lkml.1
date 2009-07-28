Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621AbZG1Tye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbZG1Tye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbZG1Tyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:54:33 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58542 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZG1Tyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:54:32 -0400
Date: Tue, 28 Jul 2009 21:54:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] UIO: mark uio.h functions __KERNEL__ only
Message-ID: <20090728195431.GA20914@merkur.ravnborg.org>
References: <20090728193139.GA11468@infradead.org> <1248810094-30094-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248810094-30094-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:41:34PM +0200, Jiri Slaby wrote:
> To avoid userspace build failures such as:
> .../linux/uio.h:37: error: expected ???=???, ???,???, ???;???, ???asm??? or ???__attribute__??? before ???iov_length???
> .../linux/uio.h:47: error: expected declaration specifiers or ???...??? before ???size_t???
> move uio functions inside a __KERNEL__ block.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  include/linux/uio.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index b7fe138..693c149 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -35,6 +35,7 @@ struct kvec {
>  #define UIO_FASTIOV	8
>  #define UIO_MAXIOV	1024
>  
> +#ifdef __KERNEL__
>  /*
>   * Total number of bytes covered by an iovec.
>   *
> @@ -53,5 +54,6 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
>  }
>  
>  unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
> +#endif
>  
>  #endif

Can we get this fixed up so we have a single #ifdef __KERNEL__ block?
It would be prettier, and nothing the in non-kernel part would rely
on the kernel part so you can put the kernel part in the bottom of
the file.

	Sam
