Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbZBDXtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbZBDXtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:49:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZBDXss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:48:48 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:31675 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbZBDXsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=TwMp6H1STG7PYpmqdrYo0RrECNFSzREl9gLJdp+YAt+MSK86Mw59kQQObPi2nkKw6o
         4UU5Cv9Cw2Gzv8o5ksYraDJMQkP2lHhF1fnkPFGUhDCiHC+06ynDJZzc0mWpqocHNcsQ
         YyVyatFk0Y8CVLHVrbUKoJSXVa7Slgh8dVIXQ=
Message-ID: <498A295A.4090008@gmail.com>
Date: Wed, 04 Feb 2009 17:48:42 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Roland Dreier <rdreier@cisco.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Floris Kraak <randakar@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>	<20090204221451.GA27254@uranus.ravnborg.org> <adavdrplty2.fsf@cisco.com>
In-Reply-To: <adavdrplty2.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Before judging on this patch could you please post what warning it
>  > triggers and one or a few patches to fix some of them.
> 
> The warnings are things like:
> 
>     init/main.c: In function 'start_kernel':
>     init/main.c:557: warning: format not a string literal and no format arguments
> 
> where the patch to fix this would be:
> 
> diff --git a/init/main.c b/init/main.c
> index 8442094..78fc0d8 100644
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
> 
> with the impact:
> 
> add/remove: 0/0 grow/shrink: 1/0 up/down: 7/0 (7)
> function                                     old     new   delta
> start_kernel                                 689     696      +7

Just how many of these warnings are showing up? In the cases you posted 
it's presumably no problem, but if the string could either a) be 
potentially set by a malicious user or b) accidentally contain printk 
format characters then this code has a risk that things could blow up..
