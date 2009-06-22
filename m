Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbZFVVzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbZFVVzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFVVzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:55:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbZFVVzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:55:42 -0400
Date: Mon, 22 Jun 2009 14:54:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH 2/2] serial: bfin_5xx: fix building as module when early
 printk is enabled
Message-Id: <20090622145421.3ff2f332.akpm@linux-foundation.org>
In-Reply-To: <1244854093-2156-2-git-send-email-vapier@gentoo.org>
References: <1244854093-2156-1-git-send-email-vapier@gentoo.org>
	<1244854093-2156-2-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 20:48:13 -0400
Mike Frysinger <vapier@gentoo.org> wrote:

> Since early printk only makes sense/works when the serial driver is built
> into the kernel, disable the option for this driver when it is going to be
> built as a module.  Otherwise we get build failures due to the ifdef
> handling.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/serial/bfin_5xx.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index d7fcca1..b4a7650 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -38,6 +38,10 @@
>  #include <asm/cacheflush.h>
>  #endif
>  
> +#ifdef CONFIG_SERIAL_BFIN_MODULE
> +# undef CONFIG_EARLY_PRINTK
> +#endif
> +
>  /* UART name and device definitions */
>  #define BFIN_SERIAL_NAME	"ttyBF"
>  #define BFIN_SERIAL_MAJOR	204

And that _does_ look like -stable material.

Alan, I queued both these as to-be-merged-by-you.  So if you want me to
stfu and merge them, please let me know.

