Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZB1MCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZB1MCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 07:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbZB1MCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 07:02:10 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:42201 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZB1MCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 07:02:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A92783.1010709@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 13:01:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Alex Riesen <raa.lkml@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, trivial@kernel.org
Subject: Re: [PATCH] Use a format string for linux_banner
References: <81b0412b0902250104q53f38343o303e980c1446ed3e@mail.gmail.com>
In-Reply-To: <81b0412b0902250104q53f38343o303e980c1446ed3e@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Riesen wrote:
> There is no format specifiers left in the linux_banner,
> and gcc complains seeing the printk.
> 
> Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
> ---
>  init/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

[+ application/octet-stream attachment, base64 encoded]

Please send patches as inline text or at least as plaintext attachment
in ascii encoding.  linux/Documentation/email-clients.txt has help.

> --- a/init/main.c
> +++ b/init/main.c
> @@ -554,7 +554,7 @@ asmlinkage void __init start_kernel(void)
>  	boot_cpu_init();
>  	page_address_init();
>  	printk(KERN_NOTICE);
> -	printk(linux_banner);
> +	printk("%s", linux_banner);
>  	setup_arch(&command_line);
>  	mm_init_owner(&init_mm, &init_task);
>  	setup_command_line(command_line);

Better than that:

-	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk(KERN_NOTICE "%s", linux_banner);

-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
