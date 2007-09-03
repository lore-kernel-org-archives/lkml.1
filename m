Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbXICTpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbXICTpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 15:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXICTpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 15:45:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55944 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbXICTpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 15:45:42 -0400
Date: Tue, 4 Sep 2007 01:28:52 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: bug in 2.6.22.6, net/sunrpc/svcsock.c
In-Reply-To: <200709031848.46005.wolfgang.walter@studentenwerk.mhn.de>
Message-ID: <alpine.LFD.0.999.0709040118120.7514@enigma.security.iitk.ac.in>
References: <200709031848.46005.wolfgang.walter@studentenwerk.mhn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfgang,


On Mon, 3 Sep 2007, Wolfgang Walter wrote:
> 
> in 2.6.22.6, net/sunrpc/svcsock.c
> 
> random characters are printed by svc_tcp_accept:
> 
> 	lockd: last TCP connect from <some random chars>
> [...]
> 
> --- linux-2.6.22.6/net/sunrpc/svcsock.c	2007-08-27 18:10:14.000000000 +0200
> +++ linux-2.6.22.6w/net/sunrpc/svcsock.c	2007-09-03 18:27:30.000000000 +0200
> @@ -1090,7 +1090,7 @@
>  						   serv->sv_name);
>  				printk(KERN_NOTICE
>  				       "%s: last TCP connect from %s\n",
> -				       serv->sv_name, buf);
> +				       serv->sv_name, __svc_print_addr(sin, buf, sizeof(buf)));
>  			}
>  			/*
>  			 * Always select the oldest socket. It's not fair,

Your patch is correct, but please read patch submission instructions at:

http://lxr.linux.no/source/Documentation/SubmittingPatches
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt
http://lkml.org/lkml/2005/4/7/183

At a minimum, you need to: (1) provide Signed-off-by: line on top of the
patch, (2) cc: netdev[at]vger.kernel.org (or other maintainer(s)) in your
mail, and, (3) give a useful "[patch] sunrpc: fix printk argument" kind of
Subject: line.


Satyam
