Return-Path: <linux-kernel-owner+w=401wt.eu-S971732AbXILSQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971732AbXILSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761782AbXILSQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:16:21 -0400
Received: from waste.org ([66.93.16.53]:54230 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761346AbXILSQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:16:20 -0400
Date: Wed, 12 Sep 2007 13:15:12 -0500
From: Matt Mackall <mpm@selenic.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       kgdb-bugreport@lists.sourceforge.net, amitkale@linsyssoft.com,
       jason.wessel@windriver.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] 2.6.23-rc4-mm1: kgdboe link errors
Message-ID: <20070912181512.GQ4219@waste.org>
References: <46E7B1EA.2040009@gmail.com> <20070912101537.129d10c7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912101537.129d10c7.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 10:15:37AM -0700, Randy Dunlap wrote:
> On Wed, 12 Sep 2007 11:31:22 +0200 Jiri Slaby wrote:
> 
> > randconfig [1] causes this link errors:
> > ERROR: "netpoll_cleanup" [drivers/net/kgdboe.ko] undefined!
> > ERROR: "netpoll_setup" [drivers/net/kgdboe.ko] undefined!
> > ERROR: "netpoll_parse_options" [drivers/net/kgdboe.ko] undefined!
> > ERROR: "netpoll_poll" [drivers/net/kgdboe.ko] undefined!
> > ERROR: "netpoll_send_udp" [drivers/net/kgdboe.ko] undefined!
> > ERROR: "netpoll_set_trap" [drivers/net/kgdboe.ko] undefined!
> > make[2]: *** [__modpost] Error 1
> > make[1]: *** [modules] Error 2
> > make: *** [all] Error 2
> > 
> > [1] http://www.fi.muni.cz/~xslaby/sklad/1.config
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kgdb build problems:
>   Building modules, stage 2.
> ERROR: "netpoll_cleanup" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_setup" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_parse_options" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_poll" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_send_udp" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_set_trap" [drivers/net/kgdboe.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> 
> Add 'select' for net-poll/console related config symbols, but
> make KGDBOE 'depend on' NET.  We don't want to 'select' CONFIG_NET,
> but if it is already enabled, the 'select's will enable the rest
> of the needed interfaces.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  lib/Kconfig.kgdb |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.23-rc4-mm1.orig/lib/Kconfig.kgdb
> +++ linux-2.6.23-rc4-mm1/lib/Kconfig.kgdb
> @@ -174,9 +174,11 @@ endchoice
>  
>  config KGDBOE
>  	tristate "KGDB: On ethernet" if !KGDBOE_NOMODULE
> -	depends on m && KGDB
> +	depends on m && KGDB && NET
> +	select NETCONSOLE

NETCONSOLE shouldn't be necessary. Otherwise this looks ok to my
kconfig-addled brain.

>  	select NETPOLL
>  	select NETPOLL_TRAP
> +	select NET_POLL_CONTROLLER
>  	help
>  	  Uses the NETPOLL API to communicate with the host GDB via UDP.
>  	  In order for this to work, the ethernet interface specified must

-- 
Mathematics is the supreme nostalgia of our time.
