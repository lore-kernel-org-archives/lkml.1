Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZF2Tj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZF2Tj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbZF2TjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:39:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbZF2TjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:39:19 -0400
Date: Mon, 29 Jun 2009 12:38:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, swetland@google.com
Subject: Re: Framebuffer support for HTC Dream
Message-Id: <20090629123840.1e20f17d.akpm@linux-foundation.org>
In-Reply-To: <20090629111029.GA15514@elf.ucw.cz>
References: <20090629111029.GA15514@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 13:10:30 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> I cleaned up dead code, a lot of debugging infastructure and horrific
> logo code. I had to remove earlysuspend support, because neccessary
> headers are not in mainline. The driver still works :-).

So you didn't wrote the code?

> I'd like to see it applied, working framebuffer is quite important for
> debugging / getting other drivers into working state.
> 
> 								Pavel
> 
> ---
> 
> This adds support for framebuffer on HTC Dream smartphone (aka
> T-Mobile G1, aka ADP1).
> 
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Cc: Brian Swetland <swetland@google.com>

Someone did.  Are the signoffs and attributions correct and
appropriate?  Should we at least mention the driver's history in the
changelog?

Will it have a maintainer?

> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index fb19803..4a7873b 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -2119,6 +2119,14 @@ config FB_PRE_INIT_FB
>  	  Select this option if display contents should be inherited as set by
>  	  the bootloader.
>  
> +config FB_MSM
> +	tristate
> +	depends on FB && ARCH_MSM
> +	select FB_CFB_FILLRECT
> +	select FB_CFB_COPYAREA
> +	select FB_CFB_IMAGEBLIT
> +	default y

I'm seeing gpio calls in there.  Do we need a gpio dependency, or did
ARCH_MSM give us gpio anyway?

