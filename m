Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbZDHK6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbZDHK6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZDHK6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:58:04 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:49148 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZDHK6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:58:02 -0400
Date: Wed, 8 Apr 2009 12:57:01 +0200
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hinko Kocevar <hinko.kocevar@cetrtapot.si>,
       Janez Cufer <janez.cufer@cetrtapot.si>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       dev-etrax <dev-etrax@axis.com>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>
Subject: Re: [PATCH] Fix broken compilation of Cris serial driver
Message-ID: <20090408105701.GH8115@axis.com>
References: <49DC7754.4030404@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DC7754.4030404@evidence.eu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 12:07:16PM +0200, Claudio Scordino wrote:
> Hi,
> 
>     compilation of cris serial driver on 2.6.30-rc1 is broken since 
> commit number 0f043a81ebe84be3576667f04fdda481609e3816 removed the 
> read_proc field from the tty_driver structure.
> 
> The patch in attachment may fix the problem. Please check it very 
> carefully: I don't have hardware to make any test.
> 
> Regards,
> 
>            Claudio

Content-Description: 0001-Fix-remove-read_proc-field-from-cris-serial-driver.patch
> From: Claudio Scordino <claudio@evidence.eu.com>
> 
> Commit number 0f043a81ebe84be3576667f04fdda481609e3816 removed the read_proc
> field from the tty_driver structure.
> 
> This broke cris serial driver compilation.
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> ---
>  drivers/serial/crisv10.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
> index 7ba7d70..a331e40 100644
> --- a/drivers/serial/crisv10.c
> +++ b/drivers/serial/crisv10.c
> @@ -27,6 +27,7 @@ static char *serial_version = "$Revision: 1.25 $";
>  #include <linux/kernel.h>
>  #include <linux/mutex.h>
>  #include <linux/bitops.h>
> +#include <linux/proc_fs.h>
>  
>  #include <asm/io.h>
>  #include <asm/irq.h>
> @@ -4425,7 +4426,6 @@ static const struct tty_operations rs_ops = {
>  	.break_ctl = rs_break,
>  	.send_xchar = rs_send_xchar,
>  	.wait_until_sent = rs_wait_until_sent,
> -	.read_proc = rs_read_proc,
>  	.tiocmget = rs_tiocmget,
>  	.tiocmset = rs_tiocmset
>  };
> @@ -4490,6 +4490,7 @@ rs_init(void)
>  	if (tty_register_driver(driver))
>  		panic("Couldn't register serial driver\n");
>  	/* do some initializing for the separate ports */
> +	driver->proc_entry->read_proc = rs_read_proc;

Is this the recommended way to convert proc handling?
I find no other serial driver that does it this way...

I was looking at using the proc_fops instead, but that is a
much larger change.

I will try to test your patch and if it works I'll push it
through the CRIS tree.

Thanks,

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
