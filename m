Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbYCFGzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbYCFGzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYCFGy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:54:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYCFGyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:54:55 -0500
Date: Wed, 5 Mar 2008 22:54:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: spock@gentoo.org, linux-fbdev-devel@lists.sourceforge.net
Cc: Michal Januszewski <spock@gentoo.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-fbdev-devel] [PATCH] uvesafb: don't treat valid modes
 returned by fb_find_mode() as errors
Message-Id: <20080305225412.ad1d3bb5.akpm@linux-foundation.org>
In-Reply-To: <20080127113456.GA17976@spock.one.pl>
References: <20080127113456.GA17976@spock.one.pl>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 12:34:56 +0100 Michal Januszewski <spock@gentoo.org> wrote:

> From: Michal Januszewski <spock@gentoo.org>
> 
> Don't treat valid modes returned by fb_find_mode() (best-fit modes,
> default modes or the first valid mode) as errors.
> 

This changelog is too brief.

> ---
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> index a14ef89..fc68b3e 100644
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
> @@ -885,7 +885,7 @@ static int __devinit uvesafb_vbe_init_mode(struct fb_info *info)
>  	}
>  
>  	/* fb_find_mode() failed */
> -	if (i == 0 || i >= 3) {
> +	if (i == 0) {
>  		info->var.xres = 640;
>  		info->var.yres = 480;
>  		mode = (struct fb_videomode *)
> 

Because I cannot tell what are the consequences of the bug which you're
fixing, hence I cannot tell whether we need this fix in 2.6.25 or even
2.6.24.

