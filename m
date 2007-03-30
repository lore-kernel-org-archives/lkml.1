Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXC3XKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXC3XKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 19:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933085AbXC3XKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 19:10:13 -0400
Received: from smtp005.mail.ukl.yahoo.com ([217.12.11.36]:21826 "HELO
	smtp005.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933057AbXC3XKJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 19:10:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=trUgugEc1jlSSQyhzpgCK/XcPbG0cfGn1VRCzSXwS8CzO/B8R5Va0JfC+KzAzmnqVXE+HeiWHCLg7rGi1+7pHB1Y+fyadZcn9pBDDI2vWGyhCqIJS6KVYTYVJNkf39+sqsMmsjEx8MkfR4+K3dAeJ9t3lsMGq/OHsRYReXxxQIY=  ;
X-YMail-OSG: mMHABxMVM1nnzKmWsXcfeRpDvfDf2tBsCV0XYPSjnSkgLWwlNebidgBP4O5Qre1a1uWYQI9ee8sQrExd4..IpsthG3lrEXZZRICaRv3.ZZ1pPMjbA31pMlTJBn41PrHr6S8-
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 1/2] UML - Fix umid in xterm titles
Date: Sat, 31 Mar 2007 01:10:03 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       Davide Brini <davide.brini@unibo.it>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070330145255.GA5466@c2.user-mode-linux.org>
In-Reply-To: <20070330145255.GA5466@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703310110.03985.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On venerdì 30 marzo 2007, Jeff Dike wrote:
> From: Davide Brini <davide.brini@unibo.it>
>
> Calls lines_init() *after* xterm_title is modified to include umid.
>
> Signed-off-by: Davide Brini <davide.brini@unibo.it>
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>

Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

> --
>  arch/um/drivers/ssl.c           |    4 ++--
>  arch/um/drivers/stdio_console.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> Index: linux-2.6.21-mm/arch/um/drivers/ssl.c
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/drivers/ssl.c	2007-03-30
> 10:11:01.000000000 -0400 +++
> linux-2.6.21-mm/arch/um/drivers/ssl.c	2007-03-30 10:28:51.000000000 -0400
> @@ -191,12 +191,12 @@ static int ssl_init(void)
>  	ssl_driver = register_lines(&driver, &ssl_ops, serial_lines,
>  				    ARRAY_SIZE(serial_lines));
>
> -	lines_init(serial_lines, ARRAY_SIZE(serial_lines), &opts);
> -
>  	new_title = add_xterm_umid(opts.xterm_title);
>  	if (new_title != NULL)
>  		opts.xterm_title = new_title;
>
> +	lines_init(serial_lines, ARRAY_SIZE(serial_lines), &opts);
> +
>  	ssl_init_done = 1;
>  	register_console(&ssl_cons);
>  	return 0;
> Index: linux-2.6.21-mm/arch/um/drivers/stdio_console.c
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/drivers/stdio_console.c	2007-03-30
> 10:11:01.000000000 -0400 +++
> linux-2.6.21-mm/arch/um/drivers/stdio_console.c	2007-03-30
> 10:28:51.000000000 -0400 @@ -166,12 +166,12 @@ int stdio_init(void)
>  		return -1;
>  	printk(KERN_INFO "Initialized stdio console driver\n");
>
> -	lines_init(vts, ARRAY_SIZE(vts), &opts);
> -
>  	new_title = add_xterm_umid(opts.xterm_title);
>  	if(new_title != NULL)
>  		opts.xterm_title = new_title;
>
> +	lines_init(vts, ARRAY_SIZE(vts), &opts);
> +
>  	con_init_done = 1;
>  	register_console(&stdiocons);
>  	return 0;
>
> -------------------------------------------------------------------------
> Take Surveys. Earn Cash. Influence the Future of IT
> Join SourceForge.net's Techsay panel and you'll get the chance to share
> your opinions on IT & business topics through brief surveys-and earn cash
> http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
> _______________________________________________
> User-mode-linux-devel mailing list
> User-mode-linux-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel



-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
