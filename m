Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbZBJUYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbZBJUYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838AbZBJUYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:24:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50599 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbZBJUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:24:24 -0500
Date: Tue, 10 Feb 2009 21:24:05 +0100
From: Pavel Machek <pavel@suse.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Floris Kraak <randakar@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
Message-ID: <20090210202405.GB1382@ucw.cz>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com> <20090204221451.GA27254@uranus.ravnborg.org> <adavdrplty2.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adavdrplty2.fsf@cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-02-04 14:26:45, Roland Dreier wrote:
>  > Before judging on this patch could you please post what warning it
>  > triggers and one or a few patches to fix some of them.
> 
> The warnings are things like:
> 
>     init/main.c: In function 'start_kernel':
>     init/main.c:557: warning: format not a string literal and no format arguments
> 

Would it be possible to declare linux_banner const or something?

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

Actually 
	 printk(KERN_NOTICE "%s", linux_banner);

is a better fix that will save some code, too.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
