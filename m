Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYL2Myo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYL2Myo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYL2Myf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:54:35 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:48824 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYL2Myf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:54:35 -0500
Date: Mon, 29 Dec 2008 13:56:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] linux/uio.h: cleanup for userspace
Message-ID: <20081229125609.GB1852@uranus.ravnborg.org>
References: <1230360582-6657-1-git-send-email-vapier@gentoo.org> <1230553217-985-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230553217-985-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 07:20:17AM -0500, Mike Frysinger wrote:
> Hide iov_shorten() behind __KERNEL__ since it's a prototype only.  Use the
> __inline__ form for iov_length() since it's usable by userspace.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> v2
> 	- drop inline conversion stuff
> 
>  include/linux/uio.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index b7fe138..bd1661b 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -52,6 +52,8 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
>  	return ret;
>  }
>  
> +#ifdef __KERNEL__
>  unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
> +#endif
>  
>  #endif

Could we rearrange stuff in this file so we only get one #ifdef __KERNEL__ / endif
pair?

	Sam
